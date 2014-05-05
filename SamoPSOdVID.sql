print 'pocetno stanje, robno, za sve magacine'

DECLARE @vIDPS as int
set @vIDPS = ???????????

delete from ulazizlazdetalj where vid=@vIDPS

DECLARE @mID int
DECLARE crsM CURSOR
READ_ONLY
FOR SELECT mID FROM [EC201101].[dbo].Magacin WHERE mid=1 --VrstaMag <> 6
OPEN crsM
FETCH NEXT FROM crsM INTO @mID
WHILE (@@fetch_status <> -1)
BEGIN
	IF (@@fetch_status <> -2)
	BEGIN
		--SELECT @vIDPS = [EC201101].[dbo].[ecNextVID](@mID)
-- 		INSERT INTO [EC201101].[dbo].[UlazIzlaz](
-- 		[vID], [mID], [RAS], [Datum], [Knjizenje], [Broj], [ParID], [dtID], [Predznak], 
-- 		[Vreme], [Pristup], [DPO], [Valuta], [Klijent], [UserName], [Paritet], [Placanje], 
-- 		[Napomena], [Otprema], [Vozilo], [Vozac], [vIDStorno], [vIDNiv], [ParDokBroj], 
-- 		[Avans], [FaktSaRabatIznos], [Isporuka], [DatumDok], [Moneta], [Komercijalist], 
-- 		[vIDPrenos], [Naplata], [JCI], [KursnaLista], [Kurs], [PredBroj], [PostBroj], [Izdao])
-- 		SELECT @vIDPS, @mID, 1, '2011-01-01', '2011-01-01', 1, -2, 
-- 		CASE VrstaMag 
-- 			WHEN 3 THEN '30001' 
-- 			WHEN 4 THEN '40001' 
-- 			WHEN 5 THEN CASE PodvrstaMag WHEN 1 THEN '51115'/*1 Proizvodnja*/ ELSE '52110'/*2 Repromaterijal*/ END 
-- 		ELSE '0' END, 1,
-- 		GetDate(), GetDate(), GetDate(), 0, Host_Name(), 'sa', 0,0,
-- 		'Automatsko pocetno stanje', 0,0,0,0,0,0,0,0,0,GetDate(), 1,0,0,0,0,0,0,'','',0
-- 		FROM [EC201101].[dbo].Magacin WHERE mID = @mID

		INSERT INTO [EC201101].[dbo].[UlazIzlazDetalj](
		[vID], [RedBr], [ProID], [Kol], [Cena], [CSaPor], [Rabat], [Porez], [Tarifa], 
		[Koef], [Realna], [Fakturna], [RabatFak], [Akciza], [Carina], [Naziv], [StaraCena], 
		[StaraCenaSaPor], [StaraKol], [Trosak], [StvarnaKol])

		SELECT @vIDPS,999,[ProID], case when [Kol]>0 then Kol else 0 end, [Cena], [CSaPor],0,0.17,0.17,
		1,[Nabavna],[Nabavna], 0,0,0,'',[Cena], [CSaPor],kol,0,kol
		FROM [EC201001].[dbo].[Pro] WHERE mID = @mID and Cena > 0

-- 		-- OBAVEZAN BAR CODE
-- 		INSERT INTO [EC201101].[dbo].[BarCodeUI]([vID], [ProID], [BarCode], [Kol])
-- 		SELECT @vIDPS, [ProID], [BarCode], [Kol] 
-- 		FROM [EC201001].[dbo].[vBarCodeUIStanje]
-- 		WHERE mID = @mID

		DELETE FROM [EC201101].[dbo].[Pro] WHERE mID = @mID

		EXEC [EC201101].[dbo].[ecSredjivanjeRednogBroja] @vIDPS
		EXEC [EC201101].[dbo].[ecSrediProReg] @mID, 0, 0
	END
	FETCH NEXT FROM crsM INTO @mID
END
CLOSE crsM
DEALLOCATE crsM
go
