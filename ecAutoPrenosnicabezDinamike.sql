SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


ALTER  PROCEDURE ecAutoPrenosnicabezDinamike(
	@magSource as int,
	@vID as int
)

AS

/*----DEBUG---------------
DECLARE @magSource int
DECLARE @vID varchar(50)
SET @magSource = 1
SET @vID = 15
-------------------------*/

-- print 'ecAutoPrenosnicabezDinamike PRM:'
-- print @magSource
-- print @vID

DECLARE @magDest int --VPMag od source magacina
DECLARE @tipSource as int
DECLARE @tipDest as int
DECLARE @Formatdecimala as varchar(15)
DECLARE @BrojDecimala as int
DECLARE @bit as BIGINT --za provjeru bitova: 8 - PrenosIzVPPrijeKnjMPFakture i 10 - dozvoli rabat u mp
DECLARE @datum as smalldatetime
SELECT @datum = Knjizenje FROM UlazIzlaz WHERE vID = @vID

SELECT @magDest = VPMag, @tipSource = Tip, @bit = ecBit, @FormatDecimala = fCijena
FROM Magacin
WHERE mID = @magSource

SELECT @tipDest = Tip
FROM Magacin
WHERE mID = @magDest

SET @BrojDecimala = LEN(@FormatDecimala) - CHARINDEX('.',@FormatDecimala,0)

IF @BrojDECIMALA = LEN(@FormatDecimala)
BEGIN
	SET @BrojDECIMALA = 0
END

--DECLARE @sql as varchar(8000)

--BEGIN TRANSACTION

IF @magDest > 0 and @tipSource = 1 and @tipDest = 0 and dbo.ecBitTest(@bit, 8) = 1
BEGIN
	
--	ALTER TABLE UlazIzlazDetalj DISABLE TRIGGER trigSetSumm

	SELECT ProSource.Kol
	FROM  UID
	LEFT JOIN dbo.fnRegistar(@magSource,0) ProSource ON ProSource.ProID = UID.ProID --AND ProSource.mID = @magSource
	LEFT JOIN dbo.fnRegistar(@magDest,0) ProDest on ProDest.ProId = UID.ProID --AND ProDest.mID = @magDest
	WHERE ProSource.tipartikla in(1,2,3) and UID.VID = @Vid 
		and UID.Kol > ProSource.Kol + ProDEST.Kol 
		AND UID.mID = @magSource

	DECLARE @c as int
	SET @c = @@ROWCOUNT
	IF @c > 0 
	BEGIN
		DECLARE @msg as varchar(2000)
		SET @msg = 'Postoje minusi - nema ni u Veleprodaji' + char(10) + char(13) + cast(@c as varchar(3)) + ' artikala ne zadovoljava kolicinu.'
		raiserror (@msg, 16,-1)
		RETURN 25
	END

	if dbo.ecBitTest(@bit, 10) = 1  -- nema rabata u maloprodaji
	BEGIN
		UPDATE UlazIzlazDetalj 
		SET CSaPor=ROUND(CSaPor*(1-Rabat),@BrojDecimala)
		FROM UlazIzlaz UI
		WHERE UlazIzlazDetalj.vID=@vID AND UI.mID = @magSource AND UI.vID = UlazIzlazDetalj.vID
	
		UPDATE UlazIzlazDetalj 
		SET Cena = ROUND(CSaPor/(1+Tarifa),9), Rabat=0
		FROM UlazIzlaz UI
		WHERE UlazIzlazDetalj.vID=@vID AND UI.mID = @magSource AND UI.vID = UlazIzlazDetalj.vID
	
--		EXEC [dbo].[trigSum] @vID --EXEC [SrediTotaleVID] @vID
	END
	

	DECLARE  @ZaPrenos  TABLE (
		AutoID int IDENTITY(1,1) NOT NULL  PRIMARY KEY, 
                	ProID nvarchar(50) NULL,
		Kol numeric(18,9) NULL,
		MPC numeric(18,9) NULL, 
		VPC numeric(18,9) NULL, 
		PrenosMPC numeric(18,9)  NULL, 
		PrenosVPC numeric(18,9) NULL, 
		PrenosRabat numeric(18,9)  NULL
	)

	INSERT INTO @ZaPrenos (ProID ,Kol, MPC, VPC, PrenosMPC, PrenosVPC, PrenosRabat)
	SELECT 
		UID.ProID,
		(UID.Kol - ProSource.Kol) As PotrebnaKol,  
		ROUND(UID.MPC ,9) As MPC, 
		ROUND(UID.VPC, 9) As VPC,
		CASE 
			WHEN ROUND(ProDEST.CSaPor,@BrojDECIMALA) < ROUND(UID.MPC ,@BrojDECIMALA)
			      THEN ROUND(UID.VPC*(1+UID.Tarifa) ,9)
			WHEN ROUND(ProDEST.CSaPor,@BrojDECIMALA) >= ROUND(UID.MPC ,@BrojDECIMALA)
			      THEN ROUND(ProDEST.Cena*(1+UID.Tarifa),9) 
		END As PrenosMPC,
		CASE
			WHEN ROUND(ProDEST.CSaPor,@BrojDECIMALA) < ROUND(UID.MPC ,@BrojDECIMALA)
			      THEN ROUND(UID.VPC ,9)
			WHEN ROUND(ProDEST.CSaPor,@BrojDECIMALA) >= ROUND(UID.MPC ,@BrojDECIMALA)
			      THEN ROUND(ProDEST.Cena,9) 
		END As PrenosVPC,
		CASE
			WHEN ROUND(ProDEST.CSaPor,@BrojDECIMALA) <= ROUND(UID.MPC ,@BrojDECIMALA)
			     THEN 0
			WHEN ROUND(ProDEST.CSaPor,@BrojDECIMALA) > ROUND(UID.MPC ,@BrojDECIMALA)
			      THEN 
				      CASE 
			      		WHEN ROUND(ProDEST.CSaPor ,@BrojDECIMALA)<>0
					THEN 1 - ROUND(UID.MPC,@BrojDECIMALA) / ROUND(ProDEST.CSaPor ,@BrojDECIMALA)
					ELSE
					0
					END
		END As DestPrenosRabat
	FROM UID
	LEFT JOIN dbo.fnRegistar(@magSource,0) ProSource ON ProSource.ProID = UID.ProID --AND ProSource.mID = @magSource
	LEFT JOIN dbo.fnRegistar(@magDest,0) ProDest on ProDest.ProId = ProSource.ProID --AND ProDest.mID = @magDest
	WHERE UID.VID = @Vid and ProSource.Kol- UID.Kol < 0 AND ProSource.tipartikla in(1,2,3) and  UID.mID = @magSource

	DECLARE @Count int
	SELECT @Count = COUNT(AutoID) FROM @ZaPrenos
	
	IF  @Count  > 0 -- potrebna prenosnica
	BEGIN
		DECLARE @brojac int
		SET @Brojac = 1
		DECLARE @ProID nvarchar(50)
		DECLARE @Kol numeric(18,9)
		DECLARE @MPC numeric(18,9) 
		DECLARE @VPC numeric(18,9)
		DECLARE @PrenosMPC numeric(18,9)
		DECLARE @PrenosVPC numeric(18,9)
		DECLARE @PrenosRabat numeric(18,9)

		WHILE @brojac <= @Count
		BEGIN
			SELECT @ProID =p.ProID ,@Kol = p.kol, @MPC = p.MPC, @VPC=p.VPC, @PrenosMPC=p.PrenosMPC, @PrenosVPC =p.PrenosVPC, @PrenosRabat=P.PrenosRabat 
			FROM @ZaPrenos P WHERE P.AutoID = @Brojac
		
			-- da li postoji prenosnica sa ovim proizvodom
			DECLARE @vIDDest int -- ako ima koji updatejtujem
			DECLARE @vIDSource int 
			DECLARE  @KnjizenjeS datetime
			DECLARE  @KnjizenjeD datetime
		
			SET @vIDDest=0
			SET @vIDSource=0
		
			SELECT	@vIDDest = ISNULL(UID.vID, 0), 
				@KnjizenjeD = UI.Knjizenje 
			FROM UID
			LEFT JOIN UlazIzlaz UI ON UI.vid = UID.vid
			WHERE 
				UI.dtID = '30221'   
				and UI.RAS & 4096 = 4096 --PRINT Power(2,12)
				and DateDIFF(day,UI.Datum,@datum)=0
				and UI.vidPrenos <> 0
				and ProID = @ProID 
				and ROUND(UID.VPC,@BrojDecimala) = ROUND(@PrenosVPC,@BrojDecimala) 
				and ROUND(UID.Rabat,6) = ROUND(@PrenosRabat,6) 
				and ROUND(UID.CProdPrenos,@BrojDecimala) = ROUND(@MPC,@BrojDecimala)
				AND UI.mID = @magDest
	
			IF @vidDest <> 0 -- postoji
			BEGIN 
				--print @proid + 'postoji '
				SELECT @vIDSource = ISNULL(UI.vID, 0), @KnjizenjeS = UI.Knjizenje
				FROM UlazIzlaz UI
				WHERE UI.vIDPrenos = @vIDDest AND UI.mID = @magSource
			
				UPDATE UlazIzlazDetalj SET Kol = Kol+@kol WHERE vID = @vidDest and ProId = @ProID
			        	UPDATE UlazIzlazDetalj SET Kol = Kol+@kol WHERE vID = @vidSource and ProId = @ProId
				UPDATE UlazIzlazDetalj SET vPrenos = @vidSource  WHERE vID = @vid and ProId = @ProId
			
				--EXEC ecSrediNivelacije @KnjizenjeD, @vidDest 
				--EXEC ecSrediProOdVeze @vidDest
				--EXEC [dbo].[ecSrediProReg] @magDest, 0, @vIDDest --
				--EXEC [dbo].[trigSum] @vIDDest --EXEC [SrediTotaleVID] @vidDest
			
				--EXEC ecSrediNivelacije @KnjizenjeS, @viDsource   
				--EXEC ecSrediProOdVeze @viDsource 
				--EXEC [dbo].[ecSrediProReg] @magSource, 0, @vIDSource --
				--EXEC [dbo].[trigSum] @vIDsource --EXEC [SrediTotaleVID] @viDsource
	
			END ELSE BEGIN -- ne postoji - mozda teba kreirati novu ili dodati u postojecu
				SELECT @vIDDest = MAX(UID.vID) 
				FROM UID 
				LEFT JOIN UlazIzlaz UI ON UI.vid = UID.vid 
				WHERE UI.dtID = '30221' 
				and UI.RAS & Power(2,12) =Power(2,12)
				and DateDIFF(day,UI.Datum,@datum)=0
				and UI.vidPrenos <> 0
				AND UI.mID = @magDest
				and ui.vid NOT IN 
					(SELECT ui1.VID 
					FROM ULazIzlazdetalj UID1 
					LEFT JOIN ULazIzlaz UI1 ON UI1.vid = UID1.vid 
					WHERE UI1.dtID = '30221'   
						and UI1.RAS & Power(2,12) =Power(2,12)
						and DateDIFF(day,UI1.Datum,@datum)=0
						and UI1.vidPrenos <> 0
						and UID1.ProID = @ProID
						AND UI1.mID = @magDest
					)
				GROUP BY UI.VID

				SET @viddest = ISNULL(@viddest,0)

				if @vIDDest <> 0 -- postoji neka bez proizvoda
				BEGIN
					SELECT @KnjizenjeD = UI.Knjizenje 
					FROM UlazIzlaz UI  
					WHERE vid = @viddest AND mID = @magDest
		
					--Print @Proid +'postoji neka bez proizvoda'
					SELECT @vIDSource = ISNULL(UI.vID, 0), @KnjizenjeS = UI.Knjizenje
					FROM UlazIzlaz UI 
					WHERE UI.vIDPrenos = @vIDDest AND UI.mID = @magSource
		
					INSERT INTO [UlazIzlazDetalj]( 
						[vID], [RedBr], [ProID], [Kol], [Cena], [CSaPor], 
						[Rabat], [Porez], [Tarifa], [Koef], [Realna], 
						[Fakturna], [RabatFak],	[Akciza], [Carina], 
						[Naziv], [StaraCena], [StaraCenaSaPor], [StaraKol], 	
						[Trosak], [StvarnaKol], [CProdPrenos], [CProdPrenosBPor], 
						[PDV], [ecBit], [PredznakParcijalneNiv], [PrenosRabat], [vPrenos])
					SELECT 
						@vidDEST, '30000', @ProID, @kol, 
						Round(@PrenosVPC,@BrojDECIMALA), @PrenosMPC,
						@PrenosRabat, Reg.Tarifa, Reg.Tarifa,
						Reg.Koef, Reg.Realna,
						CASE WHEN reg.Koef<>0 THEN 
							CASE Reg.NAbavna/Reg.Koef WHEN 0 THEN Reg.Realna ELSE Reg.NAbavna/Reg.Koef END
						ELSE 
							CASE reg.Nabavna WHEN 0 THEN Reg.Realna ELSE reg.Nabavna END
						END,
						0, 0, 0,
						rEG.nAZIV, reg.cena, reg.CSapor, reg.Kol,
						0, Reg.Kol, Round(@MPC,@BrojDECIMALA),
						@VPC, 0, 0, 0, 0, 0
					FROM dbo.fnRegistar(@magDest,0) Reg 
					WHERE ProId = @ProID --AND mID = @magDest
		
					INSERT INTO [UlazIzlazDetalj](
						[vID], [RedBr], [ProID], [Kol], [Cena], [CSaPor], 
						[Rabat], [Porez], [Tarifa], [Koef], [Realna], 
						[Fakturna], [RabatFak], [Akciza], [Carina], 
						[Naziv], [StaraCena], [StaraCenaSaPor], [StaraKol], 
						[Trosak], [StvarnaKol], [CProdPrenos], [CProdPrenosBPor], 
						[PDV], [ecBit], [PredznakParcijalneNiv], [PrenosRabat], [vPrenos])
					SELECT 
						@vidSource, '30000', @ProID, @kol, @VPC,
						Round(@MPC,@BrojDECIMALA), 0, Reg.Tarifa, Reg.Tarifa, P.Koef, P.Realna, -- Reg.Koef, Reg.Realna,
						CASE WHEN P.Koef<>0 THEN P.NAbavna/P.Koef ELSE P.Nabavna END, -- STARA VARIJANTA CASE WHEN reg.Koef<>0 THEN Reg.NAbavna/Reg.Koef ELSE reg.Nabavna END,
						0, 0, 0, Reg.Naziv, reg.cena, reg.CSapor, reg.Kol,
						0, Reg.Kol, @PrenosMPC, Round(@PrenosVPC,@BrojDECIMALA),
						0, 0, 0, @PrenosRabat, 0
					FROM dbo.fnRegistar(@magSource,0) Reg
					LEFT JOIN Pro P ON Reg.ProID = P.ProID --DODAO ZBOG NABAVNE I FAKTURNE
					WHERE Reg.ProId = @ProID AND P.mID = @magDest --AND Reg.mID = @magSource 

					--Dodavanje realne i fakturne u fakturi
					UPDATE 	UlazIzlazDetalj
					SET Koef = P.Koef, Realna = P.Realna, Fakturna = CASE WHEN P.Koef<>0 THEN P.NAbavna/P.Koef ELSE P.Nabavna END
					FROM Pro P 
					CROSS JOIN UlazIzlaz UI --ON UI.vID = UlazIzlazDetalj.vID
					WHERE UlazIzlazDetalj.vID = @vID AND UlazIzlazDetalj.ProID = P.ProID 
						AND P.mID = @magDest AND UI.mID = @magSource AND UI.vID = UlazIzlazDetalj.vID
	
					--EXEC ecSrediNivelacije @KnjizenjeD, @vidDest 
					--EXEC [dbo].[ecSrediProReg] @magDest, 0, @vIDDest --EXEC ecSrediProOdVeze @vidDest
			
					--EXEC [ecSredjivanjeRednogBroja] @VIDSOURCE
					--EXEC ecSrediNivelacije @KnjizenjeS, @viDsource   
					--EXEC [dbo].[ecSrediProReg] @magSource, 0, @vIDSource --EXEC ecSrediProOdVeze @viDsource 
		
					--EXEC [dbo].[trigSum] @vIDDest --EXEC [SrediTotaleVID] @vidDest
					--EXEC [dbo].[trigSum] @vIDsource --EXEC [SrediTotaleVID] @viDsource
				END ELSE BEGIN -- ne postoji ili postoji sa drugim uslovima - treba kreirati nove prenosnice i upuniti proizvode
					--Print @Proid + 'ne postoji ili postoji sa drugim uslovima - treba kreirati nove prenosnice i upuniti proizvode'     
		                        		set @KnjizenjeD=@datum
					set @KnjizenjeS=@datum
					--SELECT [EC201101].[dbo].[ecNextBroj](<@mID, int, >, <@dtID, varchar(5), >, <@godina, int, >, <@proknjizeni, int, >)
					DECLARE @brojnovidest INT 	
					SELECT @brojnovidest = dbo.[ecNextBroj](@magDest, '30221', DATEPART(year, @datum), 1)-- ISNULL(MAX(CAST(broj AS int)), 0)+1 
-- 					FROM  UlazIzlaz 
-- 					WHERE DTID = '30221' AND mID = @magDest

					SELECT @vIDDest = dbo.ecNextVID(@magDest) --IsNull(MAX(vID), 100000000 * @magDest) + 1 FROM UlazIzlaz WHERE vID BETWEEN 100000000 * @magDest AND 100000000 * @magDest + 99999999

					INSERT INTO UlazIzlaz (
						mID, vID, RAS,Datum, Knjizenje, Broj, ParID, dtID, Predznak, Vreme,Pristup, DPO,Valuta,Klijent,UserName,DatumDok
					)
					SELECT @magDest, @vIdDest, 4099, @Datum,@Datum , @brojnovidest , @MagSource, 
						'30221',-1,getdate(),getdate(),getdate(),0,HOST_NAME(),USER_NAME(),getdate()
					
					DECLARE @brojnovisource int 	
					SELECT @brojnovisource = dbo.[ecNextBroj](@magSource, '40226', DATEPART(year, @datum), 1)--ISNULL(max(CAST(broj as int)), 0) + 1 
-- 					FROM UlazIzlaz 
-- 					WHERE DTID = '40226' AND mID = @magSource

					SELECT @vIDSource = dbo.ecNextVID(@magSource) --IsNull(MAX(vID), 100000000 * @magSource) + 1 FROM UlazIzlaz WHERE vID BETWEEN 100000000 * @magSource AND 100000000 * @magSource + 99999999

					INSERT INTO UlazIzlaz (
						mID, vID, RAS,Datum, Knjizenje, Broj, ParID, dtID, Predznak, Vreme,Pristup, DPO,Valuta,Klijent,UserName,DatumDok,vidprenos)
					SELECT @magSource, @vIdsource, 4099, @Datum,@Datum ,  @brojnovisource , @Magdest, 
						'40226',1,getdate(),getdate(),getdate(),0,HOST_NAME(),USER_NAME(),getdate(),@vidDest

				        	UPDATE UlazIzlaz  
					SET vidPrenos = @vidSource 
					WHERE UlazIzlaz.vid = @vidDest 		
					INSERT INTO [UlazIzlazDetalj](
						[vID], [RedBr], [ProID], [Kol], [Cena], [CSaPor], 
						[Rabat], [Porez], [Tarifa], [Koef], [Realna], [Fakturna], 
						[RabatFak], [Akciza], [Carina], [Naziv], 
						[StaraCena], [StaraCenaSaPor], [StaraKol], [Trosak], 
						[StvarnaKol], [CProdPrenos], [CProdPrenosBPor], [PDV], 
						[ecBit], [PredznakParcijalneNiv], [PrenosRabat], [vPrenos])
					SELECT 
						@vidDEST, '30000', @ProID, @kol, Round(@PrenosVPC, @BrojDECIMALA),
						@PrenosMPC, @PrenosRabat, Reg.Tarifa, Reg.Tarifa, Reg.Koef, Reg.Realna,
						CASE WHEN reg.Koef<>0 THEN 
							CASE Reg.NAbavna/Reg.Koef WHEN 0 THEN Reg.Realna ELSE Reg.NAbavna/Reg.Koef END
						ELSE 
							CASE reg.Nabavna WHEN 0 THEN Reg.Realna ELSE reg.Nabavna END
						END,
						--OLD CASE WHEN reg.Koef<>0 THEN Reg.Nabavna/Reg.Koef ELSE reg.Nabavna END,
						0, 0, 0, rEG.nAZIV, reg.cena, reg.CSapor, reg.Kol,
						0, Reg.Kol, round(@MPC, @BrojDECIMALA), @VPC, 0, 0, 0, 0, 0
					FROM dbo.fnRegistar(@magDest,0) Reg 
					WHERE ProId = @ProID --AND mID = @magDest

					INSERT INTO [UlazIzlazDetalj](
						[vID], [RedBr], [ProID], [Kol], [Cena], [CSaPor], 
						[Rabat], [Porez], [Tarifa], [Koef], [Realna], [Fakturna], 
						[RabatFak], [Akciza], [Carina], [Naziv], 
						[StaraCena], [StaraCenaSaPor], [StaraKol], [Trosak], 
						[StvarnaKol], [CProdPrenos], [CProdPrenosBPor], [PDV], 
						[ecBit], [PredznakParcijalneNiv], [PrenosRabat], [vPrenos])
					SELECT 
						@vidSource, '30000', @ProID, @kol, @VPC,
						round(@MPC,@BrojDECIMALA), 0, Reg.Tarifa, Reg.Tarifa,
						P.Koef, P.Realna, --Reg.Koef, Reg.Realna, 
						CASE WHEN P.Koef<>0 THEN P.NAbavna/P.Koef ELSE P.Nabavna END, -- STARA VARIJANTA CASE WHEN reg.Koef<>0 THEN Reg.NAbavna/Reg.Koef ELSE reg.Nabavna END,
						0, 0, 0, Reg.Naziv, reg.cena, reg.CSapor, reg.Kol,
						0, Reg.Kol, @PrenosMPC, round(@PrenosVPC,@BrojDECIMALA),
						0, 0, 0, @PrenosRabat, 0
					FROM dbo.fnRegistar(@magSource,0) Reg 
					LEFT JOIN Pro P ON Reg.ProID = P.ProID --DODAO ZBOG NABAVNE I FAKTURNE
					WHERE Reg.ProId = @ProID AND P.mID = @magDest --AND Reg.mID = @magSource

					--Dodavanje realne i fakturne u fakturi
					--UPDATE UlazIzlazDetalj 
					--SET Koef = P.Koef, Realna = P.Realna, Fakturna = CASE WHEN P.Koef<>0 THEN P.NAbavna/P.Koef ELSE P.Nabavna END
					--FROM Pro P 
					--WHERE vID = @vID AND UlazIzlazDetalj.ProID = P.ProID AND P.mID = @magDest
		
					--EXEC [ecSredjivanjeRednogBroja] @VIDDEST
					--EXEC ecSrediNivelacije @KnjizenjeD, @vidDest 
					--EXEC [dbo].[ecSrediProReg] @magDest, 0, @vIDDest --EXEC ecSrediProOdVeze @vidDest
			
					--EXEC [ecSredjivanjeRednogBroja] @VIDSOURCE
					--EXEC ecSrediNivelacije @KnjizenjeS, @viDsource   
					--EXEC [dbo].[ecSrediProReg] @magSource, 0, @vIDSource --EXEC ecSrediProOdVeze @viDsource 
		
					--EXEC [dbo].[trigSum] @vIDDest --EXEC [SrediTotaleVID] @vidDest
					--EXEC [dbo].[trigSum] @vIDSource --EXEC [SrediTotaleVID] @viDsource
				END
			END
			SET @Brojac = @Brojac+1
			CONTINUE
		END
	END

--	ALTER TABLE UlazIzlazDetalj ENABLE TRIGGER trigSetSumm



/* sve prenosnice iz vp */

DECLARE curUI CURSOR
LOCAL
FAST_FORWARD
READ_ONLY
FOR SELECT UI.Vid, UI.Knjizenje
FROM UlazIzlaz as UI 
WHERE UI.RAS & 1 = 1 and  UI.dtid = '30221' and  UI.ParID = @magSource and UI.mID = @magDest and DateDiff(day, Datum,getdate()) = 0
ORDER BY Knjizenje


Declare @VezaDest int
DECLARE @KnjizDest datetime

OPEN curUI
	FETCH NEXT FROM curUI INTO @VezaDest, @KnjizDest
	WHILE (@@fetch_status <> -1)
	BEGIN
		IF (@@fetch_status <> -2)
		BEGIN
			EXEC [ecSredjivanjeRednogBroja] @VezaDest
			EXEC ecSrediNivelacije @KnjizDest, @VezaDest
			EXEC [dbo].[ecSrediProReg] @magDest, 0, @VezaDest
		--	EXEC [dbo].[trigSum] @VezaDest
		FETCH NEXT FROM curUI INTO @VezaDest, @KnjizDest
		END
	END

CLOSE curUI
DEALLOCATE curUI

/* sve prenosnice iz vp end */



/* sve prenosnice iz MP */ 
DECLARE curUI CURSOR
LOCAL
FAST_FORWARD
READ_ONLY

FOR SELECT UI.Vid, UI.Knjizenje
FROM UlazIzlaz as UI 
WHERE UI.RAS & 1 = 1 and  UI.dtid = '40226' and UI.mID = @magSource and DateDiff(day, Datum,getdate()) = 0
ORDER BY Knjizenje

Declare @VezaSource int
DECLARE @KnjizSource datetime

OPEN curUI
	FETCH NEXT FROM curUI INTO @VezaSource, @KnjizSource
	WHILE (@@fetch_status <> -1)
	BEGIN
		IF (@@fetch_status <> -2)
		BEGIN
			EXEC [ecSredjivanjeRednogBroja] @VezaSource
			EXEC ecSrediNivelacije  @KnjizSource, @VezaSource
			EXEC [dbo].[ecSrediProReg] @magSource, 0, @VezaSource
	--		EXEC [dbo].[trigSum] @VezaSource
		FETCH NEXT FROM curUI INTO @VezaSource, @KnjizSource
		END
	END

CLOSE curUI
DEALLOCATE curUI

/* sve prenosnice iz MP end */ 

END

--COMMIT TRANSACTION


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

