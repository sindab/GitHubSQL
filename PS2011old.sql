/* PROCEDURA ZA POCETNO STANJE 2011 


DATA DIREKTORIJ = D:\EASTCODE\DATA\
AKO NEMA D: RENAME D:\EASTCODE\DATA\ WITH C:\EASTCODE\DATA\
*/

--2010

USE [EC201001]
go

IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'EC201101')
	DROP DATABASE [EC201101]
go

DECLARE @mID int
DECLARE crsM CURSOR
READ_ONLY
FOR SELECT mID FROM [EC201001].dbo.Magacin
OPEN crsM
FETCH NEXT FROM crsM INTO @mID
WHILE (@@fetch_status <> -1)
BEGIN
	IF (@@fetch_status <> -2)
	BEGIN
		EXEC [EC201001].[dbo].[ecSrediProReg] @mID, 0, 0
	END
	FETCH NEXT FROM crsM INTO @mID
END
CLOSE crsM
DEALLOCATE crsM
go


/* BACKUP */
BACKUP DATABASE [EC201001] TO  DISK = N'C:\EC201001.bak' WITH  INIT ,  NOUNLOAD ,  NAME = N'EC201001 backup',  NOSKIP ,  STATS = 10,  NOFORMAT 
go

/* RESTORE */
RESTORE DATABASE [EC201101] FROM  DISK = N'C:\EC201001.bak' WITH  FILE = 1,  NOUNLOAD ,  STATS = 10,  RECOVERY ,  MOVE N'F001G040101M001_Data' TO N'D:\EASTCODE\DATA\EC201101.mdf',  MOVE N'F001G040101M001_Log' TO N'D:\EASTCODE\DATA\EC201101_log.ldf'
go



-- 2011
USE [EC201101]
go

/* GK */
-- delete from gk	
DELETE FROM [EC201101].[dbo].[GK] WHERE DATEPART(year, Datum) <> 2011
-- PS GK
INSERT INTO [EC201101].[dbo].GK(
	[RedniBr], [BankaID], [Klijent], [MagID], [TipDokumentaID], [BrojDokumenta], [Datum], 
	[DKT_ID], [ParID], [TrosakID], [IznosD], [IznosP], [Saldo], [Opis], [Vreme], 
	[FaktorE], [ZapID], [Komercijalista], [Valuta], [Sync], [vID])
SELECT 0,0,HOST_NAME(),1,CASE [DKT_ID] WHEN 2 THEN 8 ELSE 7 END AS TipDok, '', '2011-01-01',
	[DKT_ID], GKView.[ParID], 0,
	CASE [DKT_ID] WHEN 2 THEN SUM(GKView.IznosD)-SUM(GKView.IznosP) ELSE 0 END AS SaldoD, 
	CASE [DKT_ID] WHEN 1 THEN SUM(GKView.IznosP)-SUM(GKView.IznosD) ELSE 0 END AS SaldoP, 
	0,'PS', GETDATE(),1.95583,USER_NAME(),0,'2011-01-01',1,-1
FROM [EC201001].[dbo].GKView GKView
LEFT JOIN [EC201001].[dbo].Par Par On GKView.ParID=Par.ParID
LEFT JOIN [EC201001].[dbo].RegSif RS ON Par.PostBr=RS.ID AND RS.dtID='10402'
WHERE  (GKView.DKT_ID=1 or GKView.DKT_ID=2) and DATEPART(year, GKView.Datum) <> 2011
group by GKView.ParID, GKView.DKT_ID

go

-- --PS FINANSIJE, nakon zavrsnog obracuna
-- 
-- DELETE FROM [EC201101].[dbo].[NalogG] WHERE DATEPART(year, Datum) <> 2011
-- go
-- DELETE FROM [EC201101].[dbo].[NalogS] WHERE vID NOT IN (SELECT vID FROM [EC201101].[dbo].[NalogG])
-- go
-- INSERT INTO [EC201101].[dbo].[NalogG]([Broj], [Nalog], [Datum], [ecBit], [Napomena])
-- VALUES(0, 'POCETNO STANJE', '2011-01-01', 2, 'Pocetno stanje')
-- DECLARE @vIDf as int
-- SELECT @vIDf = MAX(vID) FROM [EC201101].[dbo].NalogG
-- INSERT INTO [EC201101].[dbo].[NalogS](
-- 	[vID], [RBr], [mID], [dtID], [DokVID], [DokBroj], [DokDatum], [DokValuta], 
-- 	[ParID], [Opis], [Konto], [Duguje], [Potrazuje], [AK])
-- SELECT @vIDf, 999, 1, '30001', 0, '', '2011-01-01', '2011-01-01', 
-- 	 [ParID], 'Pocetno stanje', KontoOrig, 
-- 	CASE WHEN SUM([Duguje]) - SUM([Potrazuje]) > 0 THEN SUM([Duguje]) - SUM([Potrazuje]) ELSE 0 END, 
-- 	CASE WHEN SUM([Duguje]) - SUM([Potrazuje]) < 0 THEN SUM([Potrazuje]) - SUM([Duguje]) ELSE 0 END,0
-- FROM [EC201001].dbo.[vNalogAll]
-- WHERE --Proknjizen = 1 and --?????
-- 		parID > 0 and
-- 		KontoOrig IN ('2010', '4320', '4330')
-- GROUP BY KontoOrig, ParID, Partner
-- HAVING SUM([Duguje]) - SUM([Potrazuje])<>0
-- 
-- EXEC [EC201101].[dbo].[ecSrediRBrNalogStavke] @vIDf
-- go
-- DELETE FROM [EC201101].[dbo].[IOSFin] --WHERE vIDDok IN (SELECT vID FROM UlazIzlaz WHERE DATEPART(year, Knjizenje) <> 2011)

--
/* PRIPREMI ISPRAZNI BAZU */
UPDATE [EC201101].[dbo].[FirmaBaza] SET [Godina]=2011, [BazaSys]='EC201101'
UPDATE [EC201101].[dbo].[Magacin] SET [Godina]=2011, [Baza]='EC201101'

DELETE FROM [EC201101].[dbo].[Cjenovnik]
DELETE FROM [EC201101].[dbo].[DemiFirmeLager]
DELETE FROM [EC201101].[dbo].[DemiNarudzba]
DELETE FROM [EC201101].[dbo].[DemiNarudzbaDetalj]

-- DELETE FROM [EC201101].[dbo].[JCI]
DELETE FROM [EC201101].[dbo].[GKIOS]
DELETE FROM [EC201101].[dbo].[UITable] WHERE DATEPART(year, Knjizenje) <> 2011 and mID not in (SELECT mID FROM [EC201101].[dbo].Magacin WHERE VrstaMag = 6)
DELETE FROM [EC201101].[dbo].[UlazIzlaz] WHERE DATEPART(year, Knjizenje) <> 2011 and mID not in (SELECT mID FROM [EC201101].[dbo].Magacin WHERE VrstaMag = 6)
DELETE FROM [EC201101].[dbo].[BarCodePopis] WHERE vID NOT IN (SELECT vID FROM [EC201101].[dbo].UlazIzlaz WHERE DATEPART(year, Knjizenje) = 2011 and mID not in (SELECT mID FROM [EC201101].[dbo].Magacin WHERE VrstaMag = 6))
DELETE FROM [EC201101].[dbo].[BarCodeUI] WHERE vID NOT IN (SELECT vID FROM [EC201101].[dbo].UlazIzlaz WHERE DATEPART(year, Knjizenje) = 2011 and mID not in (SELECT mID FROM [EC201101].[dbo].Magacin WHERE VrstaMag = 6))
DELETE FROM [EC201101].[dbo].[Serijski] WHERE vID NOT IN (SELECT vID FROM [EC201101].[dbo].UlazIzlaz WHERE DATEPART(year, Knjizenje) = 2011 and mID not in (SELECT mID FROM [EC201101].[dbo].Magacin WHERE VrstaMag = 6))
DELETE FROM [EC201101].[dbo].[UlazIzlazDetalj] WHERE vID NOT IN (SELECT vID FROM [EC201101].[dbo].UlazIzlaz WHERE DATEPART(year, Knjizenje) = 2011 and mID not in (SELECT mID FROM [EC201101].[dbo].Magacin WHERE VrstaMag = 6))
DELETE FROM [EC201101].[dbo].[UlazIzlazSumm] WHERE vID NOT IN (SELECT vID FROM [EC201101].[dbo].UlazIzlaz WHERE DATEPART(year, Knjizenje) = 2011 and mID not in (SELECT mID FROM [EC201101].[dbo].Magacin WHERE VrstaMag = 6))
DELETE FROM [EC201101].[dbo].[UlazTrosak] WHERE vID NOT IN (SELECT vID FROM [EC201101].[dbo].UlazIzlaz WHERE DATEPART(year, Knjizenje) = 2011 and mID not in (SELECT mID FROM [EC201101].[dbo].Magacin WHERE VrstaMag = 6))

DELETE FROM [EC201101].[dbo].[KasaG] WHERE DATEPART(year, Datum) <> 2011
if exists (select * from [EC201101].dbo.sysobjects where id = object_id(N'[KasaS1]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [EC201101].[dbo].[KasaS1] WHERE vID NOT IN (SELECT vID FROM [EC201101].[dbo].KasaG WHERE DATEPART(year, Datum) = 2011)
if exists (select * from [EC201101].dbo.sysobjects where id = object_id(N'[KasaS2]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [EC201101].[dbo].[KasaS2] WHERE vID NOT IN (SELECT vID FROM [EC201101].[dbo].KasaG WHERE DATEPART(year, Datum) = 2011)
if exists (select * from [EC201101].dbo.sysobjects where id = object_id(N'[KasaS3]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [EC201101].[dbo].[KasaS3] WHERE vID NOT IN (SELECT vID FROM [EC201101].[dbo].KasaG WHERE DATEPART(year, Datum) = 2011)
if exists (select * from [EC201101].dbo.sysobjects where id = object_id(N'[KasaS4]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [EC201101].[dbo].[KasaS4] WHERE vID NOT IN (SELECT vID FROM [EC201101].[dbo].KasaG WHERE DATEPART(year, Datum) = 2011)
if exists (select * from [EC201101].dbo.sysobjects where id = object_id(N'[KasaS5]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [EC201101].[dbo].[KasaS5] WHERE vID NOT IN (SELECT vID FROM [EC201101].[dbo].KasaG WHERE DATEPART(year, Datum) = 2011)
if exists (select * from [EC201101].dbo.sysobjects where id = object_id(N'[KasaS6]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [EC201101].[dbo].[KasaS6] WHERE vID NOT IN (SELECT vID FROM [EC201101].[dbo].KasaG WHERE DATEPART(year, Datum) = 2011)
if exists (select * from [EC201101].dbo.sysobjects where id = object_id(N'[KasaS7]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [EC201101].[dbo].[KasaS7] WHERE vID NOT IN (SELECT vID FROM [EC201101].[dbo].KasaG WHERE DATEPART(year, Datum) = 2011)
if exists (select * from [EC201101].dbo.sysobjects where id = object_id(N'[KasaS8]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [EC201101].[dbo].[KasaS8] WHERE vID NOT IN (SELECT vID FROM [EC201101].[dbo].KasaG WHERE DATEPART(year, Datum) = 2011)
if exists (select * from [EC201101].dbo.sysobjects where id = object_id(N'[KasaS9]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [EC201101].[dbo].[KasaS9] WHERE vID NOT IN (SELECT vID FROM [EC201101].[dbo].KasaG WHERE DATEPART(year, Datum) = 2011)
if exists (select * from [EC201101].dbo.sysobjects where id = object_id(N'[KasaS10]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [EC201101].[dbo].[KasaS10] WHERE vID NOT IN (SELECT vID FROM [EC201101].[dbo].KasaG WHERE DATEPART(year, Datum) = 2011)
if exists (select * from [EC201101].dbo.sysobjects where id = object_id(N'[KasaS11]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [EC201101].[dbo].[KasaS11] WHERE vID NOT IN (SELECT vID FROM [EC201101].[dbo].KasaG WHERE DATEPART(year, Datum) = 2011)
if exists (select * from [EC201101].dbo.sysobjects where id = object_id(N'[KasaS12]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [EC201101].[dbo].[KasaS12] WHERE vID NOT IN (SELECT vID FROM [EC201101].[dbo].KasaG WHERE DATEPART(year, Datum) = 2011)
if exists (select * from [EC201101].dbo.sysobjects where id = object_id(N'[KasaS13]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [EC201101].[dbo].[KasaS13] WHERE vID NOT IN (SELECT vID FROM [EC201101].[dbo].KasaG WHERE DATEPART(year, Datum) = 2011)
if exists (select * from [EC201101].dbo.sysobjects where id = object_id(N'[KasaS14]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [EC201101].[dbo].[KasaS14] WHERE vID NOT IN (SELECT vID FROM [EC201101].[dbo].KasaG WHERE DATEPART(year, Datum) = 2011)
if exists (select * from [EC201101].dbo.sysobjects where id = object_id(N'[KasaS15]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [EC201101].[dbo].[KasaS15] WHERE vID NOT IN (SELECT vID FROM [EC201101].[dbo].KasaG WHERE DATEPART(year, Datum) = 2011)

if exists (select * from [EC201101].dbo.sysobjects where id = object_id(N'[KasaGArhiva]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [EC201101].[dbo].[KasaGArhiva]
if exists (select * from [EC201101].dbo.sysobjects where id = object_id(N'[KasaSArhiva]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [EC201101].[dbo].[KasaSArhiva]
print 'drop ostale arhivske tabele za kasu'

DELETE FROM [EC201101].[dbo].[BarCodeKasa] WHERE vID NOT IN (SELECT vID FROM [EC201101].[dbo].KasaG WHERE DATEPART(year, Datum) = 2011)


if exists (select * from [EC201101].dbo.sysobjects where id = object_id(N'[BarCodeKasaSinhro]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [EC201101].dbo.[BarCodeKasaSinhro]
if exists (select * from [EC201101].dbo.sysobjects where id = object_id(N'[BarCodeUISinhro]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [EC201101].dbo.[BarCodeUISinhro]
if exists (select * from [EC201101].dbo.sysobjects where id = object_id(N'[BarCodSinhro]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [EC201101].dbo.[BarCodSinhro]
if exists (select * from [EC201101].dbo.sysobjects where id = object_id(N'[DokTipACC]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [EC201101].dbo.[DokTipACC]
if exists (select * from [EC201101].dbo.sysobjects where id = object_id(N'[FormulaACC]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [EC201101].dbo.[FormulaACC]
if exists (select * from [EC201101].dbo.sysobjects where id = object_id(N'[GKSinhro]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [EC201101].dbo.[GKSinhro]
if exists (select * from [EC201101].dbo.sysobjects where id = object_id(N'[GlavnaKnjigaOLD]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [EC201101].dbo.[GlavnaKnjigaOLD]
if exists (select * from [EC201101].dbo.sysobjects where id = object_id(N'[KasaGSinhro]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [EC201101].dbo.[KasaGSinhro]
if exists (select * from [EC201101].dbo.sysobjects where id = object_id(N'[KasaSSinhro]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [EC201101].dbo.[KasaSSinhro]
if exists (select * from [EC201101].dbo.sysobjects where id = object_id(N'[KontoACC]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [EC201101].dbo.[KontoACC]
if exists (select * from [EC201101].dbo.sysobjects where id = object_id(N'[ParSinhro]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [EC201101].dbo.[ParSinhro]
if exists (select * from [EC201101].dbo.sysobjects where id = object_id(N'[ProSinhro]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [EC201101].dbo.[ProSinhro]
if exists (select * from [EC201101].dbo.sysobjects where id = object_id(N'[RegSifACC]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [EC201101].dbo.[RegSifACC]
if exists (select * from [EC201101].dbo.sysobjects where id = object_id(N'[RegSinhro]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [EC201101].dbo.[RegSinhro]
if exists (select * from [EC201101].dbo.sysobjects where id = object_id(N'[TipoviTroskovaACC]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [EC201101].dbo.[TipoviTroskovaACC]
if exists (select * from [EC201101].dbo.sysobjects where id = object_id(N'[UlazIzlazDetaljSinhro]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [EC201101].dbo.[UlazIzlazDetaljSinhro]
if exists (select * from [EC201101].dbo.sysobjects where id = object_id(N'[UlazIzlazSinhro]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [EC201101].dbo.[UlazIzlazSinhro]
if exists (select * from [EC201101].dbo.sysobjects where id = object_id(N'[UlazIzlazSummSinhro]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [EC201101].dbo.[UlazIzlazSummSinhro]
if exists (select * from [EC201101].dbo.sysobjects where id = object_id(N'[UlazTrosakSinhro]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [EC201101].dbo.[UlazTrosakSinhro]


/* PS */
DECLARE @mID int
DECLARE @vIDPS as int
DECLARE crsM CURSOR
READ_ONLY
FOR SELECT mID FROM [EC201101].[dbo].Magacin WHERE VrstaMag <> 6
OPEN crsM
FETCH NEXT FROM crsM INTO @mID
WHILE (@@fetch_status <> -1)
BEGIN
	IF (@@fetch_status <> -2)
	BEGIN
		SELECT @vIDPS = [EC201101].[dbo].[ecNextVID](@mID)
		INSERT INTO [EC201101].[dbo].[UlazIzlaz](
		[vID], [mID], [RAS], [Datum], [Knjizenje], [Broj], [ParID], [dtID], [Predznak], 
		[Vreme], [Pristup], [DPO], [Valuta], [Klijent], [UserName], [Paritet], [Placanje], 
		[Napomena], [Otprema], [Vozilo], [Vozac], [vIDStorno], [vIDNiv], [ParDokBroj], 
		[Avans], [FaktSaRabatIznos], [Isporuka], [DatumDok], [Moneta], [Komercijalist], 
		[vIDPrenos], [Naplata], [JCI], [KursnaLista], [Kurs], [PredBroj], [PostBroj], [Izdao])
		SELECT @vIDPS, @mID, 1, '2011-01-01', '2011-01-01', 0, -2, 
		CASE VrstaMag 
			WHEN 3 THEN '30110' 
			WHEN 4 THEN '40110' 
			WHEN 5 THEN CASE PodvrstaMag WHEN 1 THEN '51115'/*1 Proizvodnja*/ ELSE '52110'/*2 Repromaterijal*/ END 
		ELSE '0' END, 1,
		GetDate(), GetDate(), GetDate(), 0, Host_Name(), 'sa', 0,0,
		'Automatsko pocetno stanje', 0,0,0,0,0,0,0,0,0,GetDate(), 1,0,0,0,0,0,0,'','',0
		FROM [EC201101].[dbo].Magacin WHERE mID = @mID

		INSERT INTO [EC201101].[dbo].[UlazIzlazDetalj](
		[vID], [RedBr], [ProID], [Kol], [Cena], [CSaPor], [Rabat], [Porez], [Tarifa], 
		[Koef], [Realna], [Fakturna], [RabatFak], [Akciza], [Carina], [Naziv], [StaraCena], 
		[StaraCenaSaPor], [StaraKol], [Trosak], [StvarnaKol])

		SELECT @vIDPS,999,[ProID], [Kol], [Cena], [CSaPor],0,0.17,0.17,
		1,[Nabavna],[Nabavna], 0,0,0,'',[Cena], [CSaPor],kol,0,kol
		FROM [EC201001].[dbo].[Pro] WHERE mID = @mID and Cena > 0

		DELETE FROM [EC201101].[dbo].[Pro] WHERE mID = @mID

		EXEC [EC201101].[dbo].[ecSredjivanjeRednogBroja] @vIDPS
		EXEC [EC201101].[dbo].[ecSrediProReg] @mID, 0, 0
	END
	FETCH NEXT FROM crsM INTO @mID
END
CLOSE crsM
DEALLOCATE crsM
go

if exists (select * from [EC201101].[dbo].sysobjects where id = object_id(N'[GKPS]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [GKPS]
GO

DBCC shrinkdatabase(N'EC201101',  TRUNCATEONLY )
go
use [EC201101] DBCC SHRINKFILE (N'F001G040101M001_Log')
go
