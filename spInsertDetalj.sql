SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[spInsertDetalj](
	@MODE as int, --1 insert, 2 update, 3 delete, 4 import XML(insert sa provjerom Reg)
	@AutoID bigint,
	@vID int, 
	@RedBr int, 
	@ProID nvarchar(50),
	@Kol numeric(18,9),
	@Cena numeric(18,9),
	@Rabat numeric(18,9),
	@Porez numeric(18,9),
	@Tarifa numeric(18,9),
	@Koef numeric(18,9),
	@Realna numeric(18,9),
	@Fakturna numeric(18,9),
	@RabatFak numeric(18,9),
	@Akciza numeric(18,9),
	@Carina numeric(18,9),
	@Naziv nvarchar(2000),
	@StaraCena numeric(18,9),
	@StaraCenaSaPor numeric(18,9),
	@StaraKol numeric(18,9),
	@Trosak numeric(18,9),
	@StvarnaKol numeric(18,9),
	@CSaPor numeric(18,9),
	@CProdPrenos numeric(18,9),
	@CProdPrenosBPor numeric(18,9),
	@PDV numeric(18,9),
	@ecBit tinyint,
	@PredznakParcijalneNiv smallint,
	@PrenosRabat numeric(18,9),
	@RazlikaTipova smallint = 0,     -- da li je u prenosnici ili medjuskladisnici razlicit tip magacina (0 nije, 1 jeste zbog ROUND CprodPrenos i CprodprenosBbor
	@Bruto numeric(18,9)=0,
	@Neto numeric(18,9)=0,
	@vJCI varchar(255)='',
	@BC varchar(50)='',
	@obavBC int=0,
	@cenaUMoneti numeric(18,9)=0
)

AS

IF @Koef = 0
BEGIN
	SET @Koef = 1
END

DECLARE @jmZaokruziKol as int
SELECT @jmZaokruziKol = [dbo].[ecBitTest](ecBit, 0) FROM RegSif WHERE dtID = '10428' and ID = (SELECT JM FROM Reg WHERE ProID = @ProID)
SET @Kol = CASE ISNULL(@jmZaokruziKol, 0) WHEN 0 THEN @Kol ELSE convert(int, @Kol) END

--IF @MODE <> 3
--BEGIN
	DECLARE @Formatdecimala as varchar(15)
	DECLARE @BrojDecimala as int
	DECLARE @BrojDecimalaBPor as int
	DECLARE @BrojDecimalaSPor as int
	DECLARE @BrojDecimalaPrenosBPor as int
	DECLARE @BrojDecimalaPrenosSPor as int
	DECLARE @CCSaPor as numeric(18,9)
	DECLARE @CCProdPrenosBPor as numeric(18,9)
	DECLARE @CCena as numeric(18,9)
	DECLARE @CCProdPrenos as numeric(18,9)

	DECLARE @mID as int
	DECLARE @TIPMag as int
	DECLARE @VrstaMag as int
	DECLARE @ecBit2 as int
	
	DECLARE @dtID as varchar(5)
	SELECT @dtID = dtID, @mID = mID FROM UlazIzlaz WHERE vID = @vID
	
	SELECT @TipMag = Tip, @VrstaMag = VrstaMag, @FormatDecimala = fCijena, @ecBit2 = ecBit2
	FROM ecMagacin 
	WHERE mID = @mID
	
	SET @BrojDecimala= LEN(@FormatDecimala)-CHARINDEX('.',@FormatDecimala,0)
	IF @BrojDECIMALA =LEN(@FormatDecimala)
	BEGIN
		SET @BrojDECIMALA =2
	END
	
	if @TipMag = 0  
	BEGIN
		SET @BrojDecimalaBPor  = @BrojDECIMALA
		SET @BrojDecimalaSPor =9
		SET @BrojDecimalaPrenosBPor=9 
		SET @BrojDecimalaPrenosSPor =@BrojDECIMALA
	
		SET @CCena = Round(@Cena, @BrojDECIMALA)
		SET @CCSaPor = @CCena*(1+@Tarifa)
		if  @RazlikaTipova = 0 
		BEGIN
			SET @CCProdPrenosBPor = Round(@CProdPrenosBPor,@BrojDECIMALA)
			SET @CCProdPrenos = @CCProdPrenosBPor*(1+@Tarifa)
		END ELSE BEGIN
			SET @CCProdPrenos = ROUND(@CProdPrenos,@BrojDECIMALA) --ROUND(@CCProdPrenosBPor*(1+@Tarifa), @BrojDECIMALA)
			SET @CCProdPrenosBPor = @CProdPrenos/(1+@Tarifa)--@CProdPrenosBPor
		END
	END ELSE BEGIN
		SET @BrojDecimalaBPor  = 9
		SET @BrojDecimalaSPor =@BrojDECIMALA
		SET @BrojDecimalaPrenosBPor=@BrojDECIMALA
		SET @BrojDecimalaPrenosSPor =9
	
		SET @CCSaPor = Round(@CSaPor,@BrojDECIMALA)
		SET @CCena = @CCSaPor/(1+@Tarifa)
		if  @RazlikaTipova = 0 
		BEGIN
			SET @CCProdPrenos = Round(@CCProdPrenos,@BrojDECIMALA)		
			SET @CCProdPrenosBPor = @CCProdPrenos/(1+@Tarifa)
			
		END ELSE BEGIN
			SET @CCProdPrenosBPor = Round(@CProdPrenosBPor,@BrojDECIMALA)
			SET @CCProdPrenos = @CCProdPrenosBPor*(1+@Tarifa)
		END
	END
--END

--ALTER TABLE UlazIzlazDetalj DISABLE TRIGGER trigSetSumm

--DO INSERT
IF @MODE = 1 OR @MODE = 4
BEGIN
	IF @MODE = 4
	BEGIN
		-- Provjera Reg
		if @ProID = ''
		begin
			SELECT @ProID = ISNULL(ProID, '') FROM BarCod WHERE BarCode = @BC
			if @ProID = ''
			begin
				SELECT @ProID = MAX(CAST(ProID as int)) + 1
				FROM Reg WHERE ISNUMERIC(ProID) = 1
			end
		end
		if not exists (select ProID from Reg where ProID = @ProID)
		begin
			INSERT INTO [Reg]([ProID], [Naziv], [JM], [SifraDob], [TipArtikla], [Aktivan], [Tarifa], [BC])
			VALUES(@ProID, @Naziv, 1, '', 1, 1, 1, @BC)
			if not exists (select BarCode from BarCod where BarCode = @BC)
			begin
				INSERT INTO [BarCod]([ProID], [BarCode])
				VALUES(@ProID, @BC)
			end
		end else begin
			if @cena = 0
			begin
				SELECT @cena = Cena, @csapor = CSaPor FROM Pro WHERE proID = @ProID and mID = @mID
			end
		end
	END
	INSERT INTO UlazIzlazDetalj(
		vID, RedBr, ProID, Kol, Cena, Rabat, Porez, Tarifa, 
		Koef, Realna, Fakturna, RabatFak, Akciza, Carina, Naziv, 
		StaraCena, StaraCenaSaPor, StaraKol, Trosak, StvarnaKol, 
		CSaPor, CProdPrenos,CProdPrenosBPor,PDV,ecBit,PredznakParcijalneNiv,PrenosRabat,Bruto,Neto,vJCI,CenaUMoneti
	)
	SELECT
		@vID, @RedBr, @ProID, @Kol,
		IsNull(Round(@CCena,@BrojDecimalaBPor),0),
		IsNull(@Rabat,0), IsNull(@Porez,0), IsNull(@Tarifa,0), IsNull(@Koef,0), IsNull(@Realna,0),
		IsNull(@Fakturna,0), IsNull(@RabatFak,0), IsNull(@Akciza,0), IsNull(@Carina,0), CASE IsNull(@Naziv,'') WHEN '' THEN Reg.Naziv ELSE @Naziv END,
		IsNull(Round(@StaraCena,@BrojDecimalaBPor),0),
		IsNull(Round(@StaraCenaSaPor,@BrojdecimalaSPor),0),
		IsNull(@StaraKol,0), IsNull(@Trosak,0), 
		IsNull(@StvarnaKol,0),
		IsNull(Round(@CCSaPor,@BrojDecimalaSPor),0),
		IsNull(Round(@CCProdPrenos,@BrojdecimalaPrenosSPor),0),
		IsNull(Round(@CCProdPrenosBPor,@BrojDecimalaPrenosBPor),0),
		IsNull(@PDV,0), IsNull(@ecBit,0), IsNull(@PredznakParcijalneNiv,0), IsNull(@PrenosRabat,0),
		ROUND(Isnull(@Bruto,0),2),ROUND(Isnull(@Neto,0),2),@vJCI, @cenaUMoneti
	FROM Reg 
	-- TODO (Fakturna...) LEFT JOIN Pro ON Pro.mID = @mID and Reg.ProID = Pro.ProID
	WHERE Reg.ProID = @proID
	--BarCodeUI
	if @obavBC > 0
	begin
		EXEC [ecBarCodeUI] @vID, @ProID, @BC
	end
END 
--DO UPDATE
IF @MODE = 2
BEGIN
	UPDATE UlazIzlazDetalj
	SET	vID = @vID, 
		RedBr = @RedBr, 
		ProID = @ProID, 
		Kol = IsNull(@Kol, 0),
		Cena = IsNull(Round(@CCena,@BrojDecimalaBPor),0), 
		Rabat = IsNull(@Rabat,0),
		Porez = IsNull(@Porez,0), 
		Tarifa = IsNull(@Tarifa,0), 
		Koef = IsNull(@Koef,0), 
		Realna = IsNull(@Realna,0), 
		Fakturna = IsNull(@Fakturna,0), 
		RabatFak = IsNull(@RabatFak,0), 
		Akciza = IsNull(@Akciza,0), 
		Carina = IsNull(@Carina,0), 
		Naziv = CASE IsNull(@Naziv,'') WHEN '' THEN Reg.Naziv ELSE @Naziv END, 
		StaraCena = IsNull(Round(@StaraCena,@BrojDecimalaBPor),0), 
		StaraCenaSaPor = IsNull(Round(@StaraCenaSaPor,@BrojDecimalaSPor),0), 
		StaraKol = IsNull(@StaraKol,0), 
		Trosak = IsNull(@Trosak,0), 
		StvarnaKol = IsNull(@StvarnaKol, 0), 
		CSaPor = IsNull(Round(@CCSaPor,@BrojDecimalaSPor),0), 
		CProdPrenos = IsNull(Round(@CCProdPrenos,@BrojDecimalaPrenosSPor),0),
		CProdPrenosBPor = IsNull(Round(@CCProdPrenosBPor,@BrojDecimalaPrenosBPor),0),
		PDV = IsNull(@PDV,0),
		ecBit = IsNull(@ecBit,0),
		PrenosRabat = IsNull(@PrenosRabat,0),
		Bruto=ROUND(Isnull(@Bruto,0),2),
		Neto=ROUND(Isnull(@Neto,0),2),
		vJCI=IsNull(@vJCI,''),
		CenaUMoneti=@cenaUMoneti
	FROM Reg
	WHERE UlazIzlazDetalj.AutoID = @AutoID and UlazIzlazDetalj.ProID = Reg.ProID
	--BarCodeUI
	if @obavBC > 0
	begin
		EXEC [ecBarCodeUI] @vID, @ProID, @BC
	end
END

--DO DELETE
IF @MODE = 3
BEGIN
	SELECT @vID = vID, @ProID = ProID, @RedBr = RedBr FROM UlazIzlazDetalj WHERE AutoID = @AutoID

	DELETE FROM UlazIzlazDetalj
	WHERE AutoID = @AutoID

	IF @dtID = '60214'
	BEGIN
		DELETE FROM [JCI] WHERE vIDIzlaz = @vID AND ProID IN (SELECT ProIDMat FROM Normativ WHERE ProIDPro = @ProID) and RBIzlaz = @RedBr
	END ELSE BEGIN
		DELETE FROM [JCI] WHERE vIDIzlaz = @vID AND ProID = @ProID
	END
	
	DELETE FROM Serijski WHERE vID = @vID and ProID = @ProID
	
	DELETE FROM BarCodeUI WHERE vID = @vID and ProID = @proID

	DELETE FROM BarCodePopis WHERE vID = @vID and ProID = @proID

	DELETE FROM SerijaUI WHERE vID = @vID and ProID = @ProID
END

IF dbo.ecBitTest(@ecBit2, 22) = 1 --Prati ambalazu (magacin)
BEGIN
	DECLARE @dokAmb as int --Prati ambalazu (dokument)
	SELECT @dokAmb = dbo.ecBitTest(ecBit, 15) FROM DokTip WHERE dtID = @dtID
	IF @dokAmb = 1
	BEGIN
		DECLARE @tip as int
		SELECT @tip = TipArtikla FROM Reg WHERE ProID = @ProID
		IF @tip <> 9
		BEGIN
			EXEC dbo.spAmbalaza @vID--, @ProID
		END
	END
END

--EXEC [dbo].[trigSum] @vID
--EXEC [dbo].[ecSredjivanjeRednogBroja] @vID
--ALTER TABLE UlazIzlazDetalj ENABLE TRIGGER trigSetSumm

--	EXEC [SrediTotaleVID] @vID

/*IF @VrstaMag = 6 and @dtID <> '60111' and @dtID <> '60213' and @dtID <> '60226' and @dtID <> '60219'
BEGIN

	EXEC spSrediDetaljCarina @vID

END*/

GO


