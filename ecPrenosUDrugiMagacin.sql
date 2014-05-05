USE [Prokontik]
GO
/****** Object:  StoredProcedure [dbo].[ecPrenosUDrugiMagacin]    Script Date: 10/16/2012 09:44:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[ecPrenosUDrugiMagacin](
	@magSource as int,
	@magDest as int,
	@vID as int
)

AS

/*DECLARE @magSource int
DECLARE @magDest int
DECLARE @vID varchar(50)
SET @magSource = 1
SET @magDest = 4
SET @vID = '40000'*/

DECLARE @vrstaSource as int
DECLARE @vrstaDest as int
DECLARE @fmtCijena as int
DECLARE @tipSourceMag as int
DECLARE @tipDestMag as int

SELECT @tipSourceMag = Tip, @vrstaSource = VrstaMag 
FROM Magacin
WHERE mID = @magSource

SELECT @fmtCijena = LEN(fCijena) - CHARINDEX('.',fCijena), @tipDestMag = Tip, @vrstaDest = VrstaMag 
FROM Magacin 
WHERE mID = @magDest

DECLARE @IsPrenos as int -- 0 = medjuskladisnica ili 1, -1 = Prenos
SET @IsPrenos = @vrstaDest - @vrstaSource 

DECLARE @sql as varchar(8000)

IF ABS(@IsPrenos) IN (0, 1, 2) --0 = medjuskladisnica , 1 = Prenos, 2 = repro -> veleprodaja
BEGIN
	SET @sql = 
		'
		DECLARE @vidDest as int
		SELECT @vidDest = dbo.ecNextVID(' + CAST(@magDest AS VARCHAR(5)) + ') 
		INSERT INTO [UlazIzlazDetalj]
		(
			[vID], [RedBr], [ProID], [Kol], [Cena], [Rabat], [Porez], [Tarifa], [Koef], 
			[Realna], [Fakturna], [RabatFak], [Akciza], [Carina], [Naziv], [StaraCena], 
			[StaraKol], [Trosak], [StvarnaKol], [CSaPor], [CProdPrenos], [CProdPrenosBPor], [PDV], [ecBit], [vJCI]
		)'

	IF ABS(@IsPrenos) = 2 OR ((@vrstaSource = 3 AND @vrstaDest = 3) OR (@vrstaSource = 6 AND @vrstaDest = 5))  -- VP -> Repro OR Carina -> Repro
	BEGIN
		SET @sql = @sql + '
			SELECT 
				@vidDest,[RedBr], UID.[ProID], UID.[Kol], 
				UID.[Cena],UID.[Rabat],UID.[Porez], UID.[Tarifa], 1,
				UID.[Realna], UID.[Realna], 0, 0, 0, Reg.[Naziv], Reg.Nabavna, 
				Reg.Kol, 0, Reg.Kol, UID.[CSaPor],UID.[CSaPor],UID.[Cena],0, 0, [vJCI]
			FROM [UlazIzlazDetalj] UID
			LEFT JOIN dbo.fnRegistar(' + CASE  WHEN @IsPrenos IN (0,1) THEN CAST(@magSource AS VARCHAR(5)) ELSE CAST(@magDest AS VARCHAR(5)) END + ',0) Reg ON Reg.ProID = UID.ProID 
			WHERE vID = ' + CAST(@vID as varchar(10)) 
	END ELSE BEGIN
		SET @sql = @sql + '
			SELECT @vidDest, [RedBr], UID.[ProID], UID.[Kol], ' 
				+ CASE @IsPrenos WHEN 0 THEN  'UID.[Cena],' ELSE 'UID.[CProdPrenosBPor],' END + '
				'+ CASE @IsPrenos WHEN 0 THEN 'UID.[Rabat],' ELSE 'UID.[PrenosRabat],' END + ' 
				UID.[Porez], UID.[Tarifa], 1, --CASE WHEN UID.Fakturna <> 0 THEN Reg.Koef ELSE 1 END, --Reg.[Koef], 
				Reg.[Realna], Reg.Nabavna, --CASE WHEN Reg.Koef <> 0 THEN Reg.Nabavna / Reg.Koef ELSE 0 END, 
				0, 0, 0, Reg.[Naziv], Reg.Cena, 
				Reg.Kol, 0, Reg.Kol, ' 
				+ CASE @IsPrenos WHEN 0 THEN  'UID.[CSaPor],' ELSE 'UID.[CProdPrenos],' END + '
				'+ CASE @IsPrenos WHEN 0 THEN 'UID.[CProdPrenos],' ELSE 'UID.[CSaPor],' END + '
				'+ CASE @IsPrenos WHEN 0 THEN 'UID.[CProdPrenosBPor],' ELSE 'UID.[Cena],' END + '
				0, 0, [vJCI]
			FROM [UlazIzlazDetalj] UID
			LEFT JOIN dbo.fnRegistar(' + CAST(@magSource AS VARCHAR(5)) + ',0) Reg ON Reg.ProID = UID.ProID 
			WHERE vID = ' + CAST(@vID as varchar(10)) 
	END

	SET @sql = @sql + '
		DECLARE @i as int
		SET @i = ' + CAST(@IsPrenos as varchar(5)) + '
		DECLARE @NEWdtID as varchar(5)
		SELECT @NEWdtID = CAST((@i * 10000) + CAST(dtID as int) + 5 as Varchar(10))
		FROM [UlazIzlaz] 
		WHERE vID = ' + CAST(@vID as varchar(10)) + '
		IF @NEWdtID = ''31225'' BEGIN SET @NEWdtID = ''30225'' END
		IF @NEWdtID = ''32225'' BEGIN SET @NEWdtID = ''30225'' END
		IF @NEWdtID = ''50225'' OR @NEWdtID = ''51225'' BEGIN SET @NEWdtID = ''52225'' END
		IF @NEWdtID = ''50226'' BEGIN SET @NEWdtID = ''52226'' END
		IF @NEWdtID = ''41225'' BEGIN SET @NEWdtID = ''40226'' END
		IF @NEWdtID = ''42226'' BEGIN SET @NEWdtID = ''40226'' END
		IF @NEWdtID = ''31233'' BEGIN SET @NEWdtID = ''30233'' END
		IF @NEWdtID = ''50232'' BEGIN SET @NEWdtID = ''52225'' END --carina u repro
		'

	SET @sql = @sql + '
		INSERT INTO [UlazIzlaz](
			mID, [vID], [RAS], [Datum], [Knjizenje], [Broj], [ParID], [dtID], [Predznak], 
			[Vreme], [Pristup], [DPO], [Valuta], [Klijent], [UserName], [Paritet], 
			[Placanje], [Napomena], [Otprema], [Vozilo], [Vozac], [vIDStorno], [vIDNiv], 
			[ParDokBroj], [Avans], [FaktSaRabatIznos], [vIDPrenos], Moneta, JCI
			)
		SELECT ' + CAST(@magDest AS VARCHAR(5)) + ', @vidDest, 
			8, Datum, Datum, 
			dbo.[ecNextBroj](' + CAST(@magDest AS VARCHAR(5)) + ', @NEWdtID, DATEPART(year, Datum), 1)
			, ' + CAST(@magSource as varchar(10)) + ', @NEWdtID, 1, 
			GetDate(), GetDate(), [DPO], [Valuta], HOST_NAME(), USER_NAME(), [Paritet], 
			[Placanje], [Napomena], [Otprema], [Vozilo], [Vozac], ' + CAST(@vID as varchar(10)) + ', 0, 
			[Broj], [Avans], [FaktSaRabatIznos], ' + CAST(@vID as varchar(10)) + ', 1, JCI
		FROM [UlazIzlaz]
		WHERE vID = '  + CAST(@vID as varchar(10)) + '
		IF @NEWdtID = ''30229'' 
		BEGIN
			UPDATE UlazIzlazDetalj SET Cena = ROUND(Cena * (1-Rabat), ' + CAST(@fmtCijena AS varchar(10)) + '), CSaPor = CSaPor * (1-Rabat) WHERE vID = @vidDest
			UPDATE UlazIzlazDetalj SET Rabat = 0 WHERE vID = @vidDest
		END
		EXEC ecSredjivanjeRednogBroja @vidDest
		
		UPDATE UlazIzlaz SET vIDPrenos = @vidDest WHERE vID = '  + CAST(@vID as varchar(10)) + '

		INSERT INTO [BarCodeUI]([vID], [ProID], [BarCode], [Kol])
		SELECT @vidDest, BCS.[ProID], BCS.BarCode, BCS.[Kol]
		FROM [BarCodeUI] BCS
		WHERE vID = ' + CAST(@vID as varchar(10)) 
END 

-------------------------------------------------------------------------

IF ABS(@IsPrenos) IN (3) --PRENOS CARINSKO(6) <-> VP(3)
BEGIN 
	SET @sql = 
		'
		DECLARE @newVID as int
		SELECT @newVID = dbo.ecNextVID(' + CAST(@magDest AS VARCHAR(5)) + ') 

		INSERT INTO [UlazIzlazDetalj](
			[vID], 
			[RedBr], 
			[ProID], 
			[Kol], 
			[Cena], 
			[Rabat], 
			[Porez], 
			[Tarifa], 
			[Koef], 
			[Realna], 
			[Fakturna], 
			[RabatFak], 
			[Akciza], 
			[Carina], 
			[Naziv], 
			[StaraCena], 
			[StaraKol], 
			[Trosak], 
			[StvarnaKol], 
			[CSaPor], 
			[CProdPrenos], 
			[CProdPrenosBPor], [vJCI]
			)
		SELECT 
			@newVID, 
			[RedBr], 
			UID.[ProID], 
			UID.[Kol], 
			UID.[CProdPrenosBPor],' 
			+ CASE @IsPrenos WHEN -3 THEN  '0,' ELSE 'UID.[Rabat], ' END + ' 
			UID.[Tarifa], 
			UID.[Tarifa], 
			UID.Koef, 
			RegS.[Realna],  
			UID.Fakturna,
			UID.RabatFak, 
			UID.Akciza, 
			UID.Carina, 
			Reg.[Naziv], 
			Reg.Cena, 
			Reg.Kol, 
			Trosak, 
			Reg.Kol, 
			UID.[CProdPrenos], 
			UID.[CSaPor], 
			UID.[Cena], [vJCI]
		FROM [UlazIzlazDetalj] UID
		LEFT JOIN dbo.fnRegistar(' + CAST(@magDest AS VARCHAR(5)) + ',0) Reg ON Reg.ProID = UID.ProID --AND Reg.mID = ' + CAST(@magDest AS VARCHAR(5)) + '
		LEFT JOIN dbo.fnRegistar(' + CAST(@magSource AS VARCHAR(5)) + ',0) RegS ON RegS.ProID = UID.ProID --AND RegS.mID = ' + CAST(@magSource AS VARCHAR(5)) + '
		WHERE vID = ' + CAST(@vID as varchar(10))

	---bit 14 magacin, kreiraj kalkulaciju uvoznu(0) ili ulaz iz carinskog(1)
	DECLARE @kreirajUlaz as bit
	SELECT @kreirajUlaz = ecBit & Power(2, 14)
	FROM Magacin
	WHERE mID = @magSource

	SET @sql = @sql + '
		DECLARE @i as int
		SET @i = ' + CAST(@IsPrenos as varchar(5)) + '
		DECLARE @NEWdtID as varchar(5)
		DECLARE @parID as int'

	IF @kreirajUlaz = 1
	BEGIN
		SET @sql = @sql + '
			SELECT @NEWdtID = ''30227'' 
				,@parID = ' + CAST(@magSource as varchar(10)) + '
			FROM [UlazIzlaz] 
			WHERE vID = ' + CAST(@vID as varchar(10)) 
	END ELSE BEGIN
		SET @sql = @sql + '
			SELECT TOP 1 @NEWdtID = ''30111''
				,@parID = ParID
			FROM [UlazIzlaz] 
			WHERE dtID = ''60111'' and JCI = (SELECT JCI FROM [UlazIzlaz] WHERE vID  = ' + CAST(@vID as varchar(10)) + ' and RAS <> 16)'
	END

	SET @sql = @sql + '
		INSERT INTO [UlazIzlaz](
			mID, [vID], [RAS], [Datum], [Knjizenje], [Broj], [ParID], [dtID], [Predznak], 
			[Vreme], [Pristup], [DPO], [Valuta], [Klijent], [UserName], [Paritet], 
			[Placanje], [Napomena], [Otprema], [Vozilo], [Vozac], [vIDStorno], [vIDNiv], 
			[ParDokBroj], [Avans], [FaktSaRabatIznos], [vIDPrenos], Moneta, JCI
			)
		SELECT ' + CAST(@magDest AS VARCHAR(5)) + ', @newVID, 
			8, [Datum], [Knjizenje], 
			dbo.[ecNextBroj](' + CAST(@magDest AS VARCHAR(5)) + ', @NEWdtID, DATEPART(year, Datum), 1)
			, @parID, @NEWdtID, 1, 
			GetDate(), GetDate(), [DPO], [Valuta], HOST_NAME(), USER_NAME(), [Paritet], 
			[Placanje], [Napomena], [Otprema], [Vozilo], [Vozac], 0, 0, 
			''Iz CS br. '' + CAST([Broj] as varchar(50)), [Avans], 
			(SELECT TotFSRabVr FROM [UIDSumm] WHERE vID = @newVID), 
			' + CAST(@vID as varchar(10)) + ', 1, JCI
		FROM [UlazIzlaz]
		WHERE vID = '  + CAST(@vID as varchar(10))  + '
		
		UPDATE UlazIzlaz SET vIDPrenos = @newVID WHERE vID = '  + CAST(@vID as varchar(10))  + '

		EXEC ecSredjivanjeRednogBroja @newVID' 

	SET @sql = @sql + '
			INSERT INTO [UlazTrosak](
			[vID], [tID], [ParID], [Iznos], [Porez], [CSaPor]
			)
		SELECT @newVID, [tID], [ParID], [Iznos], [Porez], [CSaPor]
		FROM [UlazTrosak]
		WHERE vID = '  + CAST(@vID as varchar(10)) 

END

--------------------------------------------------------------------------------

EXEC (@sql)
--PRINT (@sql)
