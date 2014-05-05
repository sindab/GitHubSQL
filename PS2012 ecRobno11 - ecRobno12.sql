/* 
		PROCEDURA ZA POCETNO STANJE 2012 - EC201101 -> EC201201

DATA DIREKTORIJ = D:\EASTCODE\DATA\
*/

--2011

USE [EC201101]
go

--IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'EC201201')
--	DROP DATABASE [EC201201]
--go

/*
SELECT [mID]
      ,[RazlikaBezPoreza]
      ,[RazlikaSaPorezom]
  FROM [EC201101].[dbo].[RazlikaTrgILager]
GO

SELECT [mID]
      ,[ProID]
      ,[RazlikaBezPoreza]
      ,[RazlikaSaPorezom]
  FROM [EC201101].[dbo].[RazlikaTrgILagerPoPro]
GO
*/

-- PripremiNivelacijuOdRazlika 
DECLARE @mID int
DECLARE @vID as int
DECLARE @vrstaMag as int
DECLARE @razlika as decimal(9,2)
DECLARE crsM CURSOR
READ_ONLY
FOR SELECT mID, VrstaMag FROM [EC201101].dbo.Magacin WHERE VrstaMag IN (3, 4) --SAMO VP i MP
OPEN crsM
FETCH NEXT FROM crsM INTO @mID, @vrstaMag
WHILE (@@fetch_status <> -1)
BEGIN
	IF (@@fetch_status <> -2)
	BEGIN
		SET @razlika = 0
		SELECT @razlika = SUM([RazlikaSaPorezom])
		  FROM [EC201101].[dbo].[RazlikaTrgILagerPoPro]
		  WHERE mID = @mID
		IF @razlika <> 0
		BEGIN
			EXEC [EC201101].[dbo].ecSrediProReg @mID

			SELECT @VID = [EC201101].[dbo].[ecNextVID] (@mID)
			INSERT INTO [EC201101].[dbo].[UlazIzlaz]
			   ([vID],[mID],[RAS],[Datum],[Knjizenje],[Broj],[ParID],[dtID],[Predznak],[Vreme],[Pristup],[DPO]
			   ,[Valuta],[Klijent],[UserName],[Napomena],[DatumDok])
			SELECT @vID,@mID,3073,GETDATE(),GETDATE(), [EC201101].[dbo].[ecNextBroj] (@mID,dtID,2011,1),
			0, dtID, Predznak, GETDATE(), GETDATE(), GETDATE(), 0, HOST_NAME(), USER_NAME(), 'Korekcija za PS', GETDATE()
			FROM [EC201101].[dbo].DokTip
			WHERE dtID = CASE @vrstaMag WHEN 4 THEN '40150' ELSE '30150' END

			INSERT INTO [EC201101].[dbo].UlazIzlazDetalj
			([vID], [RedBr], [ProID], [Kol], [Cena], [CSaPor], [Rabat], [Porez], [Tarifa], 
			 [Koef], [Realna], [Fakturna], [RabatFak], [Akciza], [Carina], [Naziv],
			 [StaraCena], [StaraCenaSaPor], [StaraKol], [Trosak], [StvarnaKol], 
			 [CProdPrenos], [CProdPrenosBPor], [PDV], [ecBit], [PredznakParcijalneNiv], 
			 [PrenosRabat], [vPrenos], [MarzaPrenos], [Bruto], [Neto], [vJCI])
			SELECT @VID, 1, R.ProID, 
				CASE WHEN (R.CSaPor-RTrgPoPro.RazlikaSaPorezom)>0 THEN 1 ELSE 10 END,
				CASE WHEN (R.CSaPor-RTrgPoPro.RazlikaSaPorezom)>0 THEN (R.CSaPor-RTrgPoPro.RazlikaSaPorezom)/1.17 
					ELSE (R.CSaPor-RTrgPoPro.RazlikaSaPorezom/10)/1.17 END,
				CASE WHEN (R.CSaPor-RTrgPoPro.RazlikaSaPorezom)>0 THEN Round((R.CSaPor-RTrgPoPro.RazlikaSaPorezom),2) 
					ELSE ROUND((R.CSaPor-RTrgPoPro.RazlikaSaPorezom/0),2) END,
			0,0.17,0.17,1,0,0,0,0,0,'',r.Cena,R.CSaPor,0,0,0,0,0,0,0,1,0,0,0,0,0,''
			FROM [EC201101].[dbo].RazlikaTrgILagerPoPro RTrgPoPro
			LEFT JOIN [EC201101].[dbo].Registar R ON RTrgPoPro.ProID=R.ProID and R.mID = RTrgPoPro.mID
			WHERE RTrgPoPro.mID = @mID and ABS(RazlikabezPoreza) >= 0.01
			EXEC [EC201101].[dbo].[ecSredjivanjeRednogBroja] @vID
		END
		EXEC [EC201101].[dbo].ecSrediProReg @mID
	END
	FETCH NEXT FROM crsM INTO @mID, @vrstaMag
END
CLOSE crsM
DEALLOCATE crsM
GO


/* BACKUP */
print 'backup'
BACKUP DATABASE [EC201101] TO  DISK = N'D:\EASTCODE\EC201101.bak' WITH  INIT ,  NOUNLOAD ,  NAME = N'EC201101 backup',  NOSKIP ,  STATS = 10,  NOFORMAT 
go

/* RESTORE */
print 'restore nove baze'
RESTORE DATABASE [EC201201] FROM  DISK = N'D:\EASTCODE\EC201101.bak' WITH  FILE = 1, REPLACE,  NOUNLOAD ,  STATS = 10,  RECOVERY ,  MOVE N'F001G040101M001_Data' TO N'D:\EASTCODE\DATA\EC201201.mdf',  MOVE N'F001G040101M001_Log' TO N'D:\EASTCODE\DATA\EC201201_log.ldf'
go

print 'brisem nove dokumente u staroj godini'
IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'EC201201')
	DELETE FROM [EC201101].[dbo].[UlazIzlaz] WHERE DATEPART(year,Datum) <> 2011
go
IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'EC201201')
	DELETE FROM [EC201101].[dbo].[UlazIzlazDetalj] WHERE vID NOT IN (SELECT vID FROM [EC201101].[dbo].UlazIzlaz)
go
IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'EC201201')
	DELETE FROM [EC201101].[dbo].[UlazIzlazSumm] WHERE vID NOT IN (SELECT vID FROM [EC201101].[dbo].UlazIzlaz)
go
IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'EC201201')
	DELETE FROM [EC201101].[dbo].[UlazTrosak] WHERE vID NOT IN (SELECT vID FROM [EC201101].[dbo].UlazIzlaz)
go
IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'EC201201')
	DELETE FROM [EC201101].[dbo].[Serijski] WHERE vID NOT IN (SELECT vID FROM [EC201101].[dbo].UlazIzlaz)
go
IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'EC201201')
	DELETE FROM [EC201101].[dbo].[BarCodePopis] WHERE vID NOT IN (SELECT vID FROM [EC201101].[dbo].UlazIzlaz)
go
IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'EC201201')
	DELETE FROM [EC201101].[dbo].[BarCodeUI] WHERE vID NOT IN (SELECT vID FROM [EC201101].[dbo].UlazIzlaz)
go

/* -- ako nije sredjeno kod - PripremiNivelacijuOdRazlika
print 'sredjujem kolicine u pro za sve magacine'
DECLARE @mID int
DECLARE crsM CURSOR
READ_ONLY
FOR SELECT mID FROM [EC201101].dbo.Magacin
OPEN crsM
FETCH NEXT FROM crsM INTO @mID
WHILE (@@fetch_status <> -1)
BEGIN
	IF (@@fetch_status <> -2)
	BEGIN
		EXEC [EC201101].[dbo].[ecSrediProReg] @mID, 0, 0
	END
	FETCH NEXT FROM crsM INTO @mID
END
CLOSE crsM
DEALLOCATE crsM
go
*/




-- 2012
USE [EC201201]
go

/* PRIPREMI ISPRAZNI BAZU */
print 'pripremi isprazni novu bazu'

print 'brisem stare dokumente iz nove baze'
DELETE FROM [EC201201].[dbo].[UlazIzlaz] WHERE DATEPART(year,Datum) <> 2012
go
DELETE FROM [EC201201].[dbo].[UlazIzlazDetalj] WHERE vID NOT IN (SELECT vID FROM [EC201201].dbo.UlazIzlaz)
go
DELETE FROM [EC201201].[dbo].[UlazIzlazSumm] WHERE vID NOT IN (SELECT vID FROM [EC201201].dbo.UlazIzlaz)
go
DELETE FROM [EC201201].[dbo].[UlazTrosak] WHERE vID NOT IN (SELECT vID FROM [EC201201].dbo.UlazIzlaz)
go
DELETE FROM [EC201201].[dbo].[Serijski] WHERE vID NOT IN (SELECT vID FROM [EC201201].dbo.UlazIzlaz)
go
DELETE FROM [EC201201].[dbo].[BarCodePopis] WHERE vID NOT IN (SELECT vID FROM [EC201201].[dbo].UlazIzlaz)
go
DELETE FROM [EC201201].[dbo].[BarCodeUI] WHERE vID NOT IN (SELECT vID FROM [EC201201].[dbo].UlazIzlaz)
go

/* GK */
print 'pocetno stanje stare GK'
-- delete from gk	
DELETE FROM [EC201201].[dbo].[GK] WHERE DATEPART(year, Datum) <> 2012
DELETE FROM [EC201101].[dbo].[GK] WHERE DATEPART(year, Datum) <> 2011
-- PS GK
/*
INSERT INTO [EC201201].[dbo].GK(
	[RedniBr], [BankaID], [Klijent], [MagID], [TipDokumentaID], [BrojDokumenta], [Datum], 
	[DKT_ID], [ParID], [TrosakID], [IznosD], [IznosP], [Saldo], [Opis], [Vreme], 
	[FaktorE], [ZapID], [Komercijalista], [Valuta], [Sync], [vID])
SELECT 0,0,HOST_NAME(),1,CASE [DKT_ID] WHEN 2 THEN 8 ELSE 7 END AS TipDok, '', '2012-01-01',
	[DKT_ID], GKView.[ParID], 0,
	CASE [DKT_ID] WHEN 2 THEN SUM(GKView.IznosD)-SUM(GKView.IznosP) ELSE 0 END AS SaldoD, 
	CASE [DKT_ID] WHEN 1 THEN SUM(GKView.IznosP)-SUM(GKView.IznosD) ELSE 0 END AS SaldoP, 
	0,'PS', GETDATE(),1.95583,USER_NAME(),0,'2012-01-01',1,-1
FROM [EC201101].[dbo].GKView GKView
LEFT JOIN [EC201101].[dbo].Par Par On GKView.ParID=Par.ParID
LEFT JOIN [EC201101].[dbo].RegSif RS ON Par.PostBr=RS.ID AND RS.dtID='10402'
WHERE  (GKView.DKT_ID=1 or GKView.DKT_ID=2) and DATEPART(year, GKView.Datum) <> 2012
group by GKView.ParID, GKView.DKT_ID

go
*/

UPDATE [EC201201].[dbo].[FirmaBaza] SET [Godina]=2012, [BazaSys]='EC201201'
UPDATE [EC201201].[dbo].[Magacin] SET [Godina]=2012, [Baza]='EC201201'

DELETE FROM [EC201201].[dbo].[Cjenovnik]
DELETE FROM [EC201201].[dbo].[DemiFirmeLager]
DELETE FROM [EC201201].[dbo].[DemiNarudzba]
DELETE FROM [EC201201].[dbo].[DemiNarudzbaDetalj]

-- DELETE FROM [EC201201].[dbo].[JCI]
DELETE FROM [EC201201].[dbo].[GKIOS]
if exists (select * from [EC201201].dbo.sysobjects where id = object_id(N'[UITable]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DELETE FROM [EC201201].[dbo].[UITable] 

print 'brisem kasa racune'
if exists (select * from [EC201201].dbo.sysobjects where id = object_id(N'[KasaG1]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [EC201201].[dbo].[KasaG1] WHERE DATEPART(year, Datum) <> 2012
if exists (select * from [EC201201].dbo.sysobjects where id = object_id(N'[KasaG2]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [EC201201].[dbo].[KasaG2] WHERE DATEPART(year, Datum) <> 2012
if exists (select * from [EC201201].dbo.sysobjects where id = object_id(N'[KasaG3]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [EC201201].[dbo].[KasaG3] WHERE DATEPART(year, Datum) <> 2012
if exists (select * from [EC201201].dbo.sysobjects where id = object_id(N'[KasaG4]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [EC201201].[dbo].[KasaG4] WHERE DATEPART(year, Datum) <> 2012
if exists (select * from [EC201201].dbo.sysobjects where id = object_id(N'[KasaG5]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [EC201201].[dbo].[KasaG5] WHERE DATEPART(year, Datum) <> 2012
if exists (select * from [EC201201].dbo.sysobjects where id = object_id(N'[KasaG6]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [EC201201].[dbo].[KasaG6] WHERE DATEPART(year, Datum) <> 2012
if exists (select * from [EC201201].dbo.sysobjects where id = object_id(N'[KasaG7]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [EC201201].[dbo].[KasaG7] WHERE DATEPART(year, Datum) <> 2012
if exists (select * from [EC201201].dbo.sysobjects where id = object_id(N'[KasaG8]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [EC201201].[dbo].[KasaG8] WHERE DATEPART(year, Datum) <> 2012
if exists (select * from [EC201201].dbo.sysobjects where id = object_id(N'[KasaG9]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [EC201201].[dbo].[KasaG9] WHERE DATEPART(year, Datum) <> 2012
if exists (select * from [EC201201].dbo.sysobjects where id = object_id(N'[KasaG10]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [EC201201].[dbo].[KasaG10] WHERE DATEPART(year, Datum) <> 2012
if exists (select * from [EC201201].dbo.sysobjects where id = object_id(N'[KasaG11]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [EC201201].[dbo].[KasaG11] WHERE DATEPART(year, Datum) <> 2012
if exists (select * from [EC201201].dbo.sysobjects where id = object_id(N'[KasaG12]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [EC201201].[dbo].[KasaG12] WHERE DATEPART(year, Datum) <> 2012

if exists (select * from [EC201201].dbo.sysobjects where id = object_id(N'[KasaStavka]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [EC201201].[dbo].[KasaStavka] WHERE vID NOT IN (SELECT vID FROM [EC201201].[dbo].KasaGlava WHERE DATEPART(year, Datum) = 2012)
if exists (select * from [EC201201].dbo.sysobjects where id = object_id(N'[KasaGlava]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [EC201201].[dbo].[KasaGlava] WHERE DATEPART(year, Datum) <> 2012

if exists (select * from [EC201201].dbo.sysobjects where id = object_id(N'[KasaS1]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [EC201201].[dbo].[KasaS1] WHERE vID NOT IN (SELECT vID FROM [EC201201].[dbo].KasaG1 WHERE DATEPART(year, Datum) = 2012)
if exists (select * from [EC201201].dbo.sysobjects where id = object_id(N'[KasaS2]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [EC201201].[dbo].[KasaS2] WHERE vID NOT IN (SELECT vID FROM [EC201201].[dbo].KasaG2 WHERE DATEPART(year, Datum) = 2012)
if exists (select * from [EC201201].dbo.sysobjects where id = object_id(N'[KasaS3]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [EC201201].[dbo].[KasaS3] WHERE vID NOT IN (SELECT vID FROM [EC201201].[dbo].KasaG3 WHERE DATEPART(year, Datum) = 2012)
if exists (select * from [EC201201].dbo.sysobjects where id = object_id(N'[KasaS4]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [EC201201].[dbo].[KasaS4] WHERE vID NOT IN (SELECT vID FROM [EC201201].[dbo].KasaG4 WHERE DATEPART(year, Datum) = 2012)
if exists (select * from [EC201201].dbo.sysobjects where id = object_id(N'[KasaS5]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [EC201201].[dbo].[KasaS5] WHERE vID NOT IN (SELECT vID FROM [EC201201].[dbo].KasaG5 WHERE DATEPART(year, Datum) = 2012)
if exists (select * from [EC201201].dbo.sysobjects where id = object_id(N'[KasaS6]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [EC201201].[dbo].[KasaS6] WHERE vID NOT IN (SELECT vID FROM [EC201201].[dbo].KasaG6 WHERE DATEPART(year, Datum) = 2012)
if exists (select * from [EC201201].dbo.sysobjects where id = object_id(N'[KasaS7]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [EC201201].[dbo].[KasaS7] WHERE vID NOT IN (SELECT vID FROM [EC201201].[dbo].KasaG7 WHERE DATEPART(year, Datum) = 2012)
if exists (select * from [EC201201].dbo.sysobjects where id = object_id(N'[KasaS8]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [EC201201].[dbo].[KasaS8] WHERE vID NOT IN (SELECT vID FROM [EC201201].[dbo].KasaG8 WHERE DATEPART(year, Datum) = 2012)
if exists (select * from [EC201201].dbo.sysobjects where id = object_id(N'[KasaS9]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [EC201201].[dbo].[KasaS9] WHERE vID NOT IN (SELECT vID FROM [EC201201].[dbo].KasaG9 WHERE DATEPART(year, Datum) = 2012)
if exists (select * from [EC201201].dbo.sysobjects where id = object_id(N'[KasaS10]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [EC201201].[dbo].[KasaS10] WHERE vID NOT IN (SELECT vID FROM [EC201201].[dbo].KasaG10 WHERE DATEPART(year, Datum) = 2012)
if exists (select * from [EC201201].dbo.sysobjects where id = object_id(N'[KasaS11]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [EC201201].[dbo].[KasaS11] WHERE vID NOT IN (SELECT vID FROM [EC201201].[dbo].KasaG11 WHERE DATEPART(year, Datum) = 2012)
if exists (select * from [EC201201].dbo.sysobjects where id = object_id(N'[KasaS12]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [EC201201].[dbo].[KasaS12] WHERE vID NOT IN (SELECT vID FROM [EC201201].[dbo].KasaG12 WHERE DATEPART(year, Datum) = 2012)

DELETE FROM [EC201201].[dbo].[BarCodeKasa] WHERE vID NOT IN (SELECT vID FROM [EC201201].[dbo].KasaG WHERE DATEPART(year, Datum) = 2012)
go

print 'drop nepotrebne tabele'
if exists (select * from [EC201201].dbo.sysobjects where id = object_id(N'[KasaGArhiva]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [EC201201].[dbo].[KasaGArhiva]
if exists (select * from [EC201201].dbo.sysobjects where id = object_id(N'[KasaSArhiva]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [EC201201].[dbo].[KasaSArhiva]

if exists (select * from [EC201201].dbo.sysobjects where id = object_id(N'[BarCodeKasaSinhro]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [EC201201].dbo.[BarCodeKasaSinhro]
if exists (select * from [EC201201].dbo.sysobjects where id = object_id(N'[BarCodeUISinhro]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [EC201201].dbo.[BarCodeUISinhro]
if exists (select * from [EC201201].dbo.sysobjects where id = object_id(N'[BarCodSinhro]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [EC201201].dbo.[BarCodSinhro]
if exists (select * from [EC201201].dbo.sysobjects where id = object_id(N'[DokTipACC]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [EC201201].dbo.[DokTipACC]
if exists (select * from [EC201201].dbo.sysobjects where id = object_id(N'[FormulaACC]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [EC201201].dbo.[FormulaACC]
if exists (select * from [EC201201].dbo.sysobjects where id = object_id(N'[GKSinhro]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [EC201201].dbo.[GKSinhro]
if exists (select * from [EC201201].dbo.sysobjects where id = object_id(N'[GlavnaKnjigaOLD]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [EC201201].dbo.[GlavnaKnjigaOLD]
if exists (select * from [EC201201].dbo.sysobjects where id = object_id(N'[KasaGSinhro]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [EC201201].dbo.[KasaGSinhro]
if exists (select * from [EC201201].dbo.sysobjects where id = object_id(N'[KasaSSinhro]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [EC201201].dbo.[KasaSSinhro]
if exists (select * from [EC201201].dbo.sysobjects where id = object_id(N'[KontoACC]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [EC201201].dbo.[KontoACC]
if exists (select * from [EC201201].dbo.sysobjects where id = object_id(N'[ParSinhro]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [EC201201].dbo.[ParSinhro]
if exists (select * from [EC201201].dbo.sysobjects where id = object_id(N'[ProSinhro]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [EC201201].dbo.[ProSinhro]
if exists (select * from [EC201201].dbo.sysobjects where id = object_id(N'[RegSifACC]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [EC201201].dbo.[RegSifACC]
if exists (select * from [EC201201].dbo.sysobjects where id = object_id(N'[RegSinhro]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [EC201201].dbo.[RegSinhro]
if exists (select * from [EC201201].dbo.sysobjects where id = object_id(N'[TipoviTroskovaACC]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [EC201201].dbo.[TipoviTroskovaACC]
if exists (select * from [EC201201].dbo.sysobjects where id = object_id(N'[UlazIzlazDetaljSinhro]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [EC201201].dbo.[UlazIzlazDetaljSinhro]
if exists (select * from [EC201201].dbo.sysobjects where id = object_id(N'[UlazIzlazSinhro]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [EC201201].dbo.[UlazIzlazSinhro]
if exists (select * from [EC201201].dbo.sysobjects where id = object_id(N'[UlazIzlazSummSinhro]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [EC201201].dbo.[UlazIzlazSummSinhro]
if exists (select * from [EC201201].dbo.sysobjects where id = object_id(N'[UlazTrosakSinhro]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [EC201201].dbo.[UlazTrosakSinhro]

print 'pocetno stanje nove finansije'
/*
DELETE FROM [EC201101].[dbo].[NalogS] WHERE DATEPART(YEAR, DokDatum)<>2011
DELETE FROM [EC201201].[dbo].[NalogS] WHERE DATEPART(YEAR, DokDatum)<>2012
DELETE FROM [EC201101].[dbo].[NalogG] WHERE vID not in (SELECT vID  FROM [EC201101].[dbo].[NalogS])
DELETE FROM [EC201201].[dbo].[NalogG] WHERE vID not in (SELECT vID  FROM [EC201201].[dbo].[NalogS])

-- ** --PS FINANSIJE, nakon zavrsnog obracuna

  INSERT INTO [EC201201].[dbo].[NalogG]([Broj], [Nalog], [Datum], [ecBit], [Napomena])
  VALUES(0, 'POCETNO STANJE', '2012-01-01', 2, 'Pocetno stanje')
  go
  DECLARE @vIDf as int
  SELECT @vIDf = MAX(vID) FROM [EC201201].[dbo].NalogG
  INSERT INTO [EC201201].[dbo].[NalogS](
  	[vID], [RBr], [mID], [dtID], [DokVID], [DokBroj], [DokDatum], [DokValuta], 
  	[ParID], [Opis], [Konto], [Duguje], [Potrazuje], [AK])
  SELECT @vIDf, 999, 1, '30001', 0, '', '2012-01-01', '2012-01-01', 
  	 [ParID], 'Pocetno stanje', KontoOrig, 
  	CASE WHEN SUM([Duguje]) - SUM([Potrazuje]) > 0 THEN SUM([Duguje]) - SUM([Potrazuje]) ELSE 0 END, 
  	CASE WHEN SUM([Duguje]) - SUM([Potrazuje]) < 0 THEN SUM([Potrazuje]) - SUM([Duguje]) ELSE 0 END,0
  FROM [EC201101].dbo.[vNalogAll]
  WHERE --Proknjizen = 1 and --?????
  		parID > 0 and
  		KontoOrig IN ('2010', '2020', '4320', '4330')
  GROUP BY KontoOrig, ParID, Partner
  HAVING SUM([Duguje]) - SUM([Potrazuje])<>0
  
  EXEC [EC201201].[dbo].[ecSrediRBrNalogStavke] @vIDf
  go
  DELETE FROM [EC201201].[dbo].[IOSFin] --WHERE vIDDok IN (SELECT vID FROM UlazIzlaz WHERE DATEPART(year, Knjizenje) <> 2012)

 -- END --PS FINANSIJE, nakon zavrsnog obracuna
*/

print 'pocetno stanje, robno, za sve magacine'
DECLARE @mID int
DECLARE @vIDPS as int
DECLARE crsM CURSOR
READ_ONLY
FOR SELECT mID FROM [EC201201].[dbo].Magacin WHERE VrstaMag <> 6
OPEN crsM
FETCH NEXT FROM crsM INTO @mID
WHILE (@@fetch_status <> -1)
BEGIN
	IF (@@fetch_status <> -2)
	BEGIN
		SELECT @vIDPS = [EC201201].[dbo].[ecNextVID](@mID)
		INSERT INTO [EC201201].[dbo].[UlazIzlaz](
		[vID], [mID], [RAS], [Datum], [Knjizenje], [Broj], [ParID], [dtID], [Predznak], 
		[Vreme], [Pristup], [DPO], [Valuta], [Klijent], [UserName], [Paritet], [Placanje], 
		[Napomena], [Otprema], [Vozilo], [Vozac], [vIDStorno], [vIDNiv], [ParDokBroj], 
		[Avans], [FaktSaRabatIznos], [Isporuka], [DatumDok], [Moneta], [Komercijalist], 
		[vIDPrenos], [Naplata], [JCI], [KursnaLista], [Kurs], [PredBroj], [PostBroj], [Izdao])
		SELECT @vIDPS, @mID, 1 /*8 neproknjizeno*/, '2012-01-01 00:00:11', '2012-01-01 00:00:11', 1, -2, 
		CASE VrstaMag 
			WHEN 3 THEN '30001' 
			WHEN 4 THEN '40001' 
			WHEN 5 THEN CASE PodvrstaMag WHEN 1 THEN '51115'/*1 Proizvodnja*/ ELSE '52110'/*2 Repromaterijal*/ END 
		ELSE '0' END, 1,
		GetDate(), GetDate(), GetDate(), 0, Host_Name(), 'sa', 0,0,
		'Automatsko pocetno stanje', 0,0,0,0,0,0,0,0,0,GetDate(), 1,0,0,0,0,0,0,'','',0
		FROM [EC201201].[dbo].Magacin WHERE mID = @mID

		INSERT INTO [EC201201].[dbo].[UlazIzlazDetalj](
		[vID], [RedBr], [ProID], [Kol], [Cena], [CSaPor], [Rabat], [Porez], [Tarifa], 
		[Koef], [Realna], [Fakturna], [RabatFak], [Akciza], [Carina], [Naziv], [StaraCena], 
		[StaraCenaSaPor], [StaraKol], [Trosak], [StvarnaKol])

		SELECT @vIDPS,999,[ProID], Kol, /*case when [Kol]>0 then Kol else 0 end,*/ [Cena], [CSaPor],0,0.17,0.17,
		1,[Realna],[Realna], 0,0,0,'',[Cena], [CSaPor],kol,0,kol
		FROM [EC201101].[dbo].[Pro] WHERE mID = @mID and Cena + Realna > 0

		-- OBAVEZAN BAR CODE, za euroline
		/*
		INSERT INTO [EC201201].[dbo].[BarCodeUI]([vID], [ProID], [BarCode], [Kol])
		SELECT @vIDPS, [ProID], [BarCode], [Kol] 
		FROM [EC201101].[dbo].[vBarCodeUIStanje]
		WHERE mID = @mID
		*/
		DELETE FROM [EC201201].[dbo].[Pro] WHERE mID = @mID

		EXEC [EC201201].[dbo].[ecSredjivanjeRednogBroja] @vIDPS
		EXEC [EC201201].[dbo].[ecSrediProReg] @mID, 0, 0
	END
	FETCH NEXT FROM crsM INTO @mID
END
CLOSE crsM
DEALLOCATE crsM
go

/*if exists (select * from [EC201201].[dbo].sysobjects where id = object_id(N'[GKPS]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [GKPS]
GO

DBCC shrinkdatabase(N'EC201201',  TRUNCATEONLY )
go
use [EC201201] DBCC SHRINKFILE (N'F001G040101M001_Log')
go
*/

-- Ako ne unose izvode u staru GK
-- DELETE FROM [EC201201].[dbo].[GK]
-- go

/*
--** Pocetno stanje Carinsko **--
-- Kreiranje prijemnica sa preostalim kolicinama, proknjiziti rucno zbog sredjivanja kolicina po JCI
-- Zaglavlje

DECLARE @mID as int
SELECT TOP 1 @mID = mID FROM [EC201201].[dbo].Magacin WHERE VrstaMag = 6

INSERT INTO [EC201201].[dbo].[UlazIzlaz](
	[vID], [mID], [RAS], [Datum], [Knjizenje], [Broj], [ParID], [dtID], [Predznak], 
	[Vreme], [Pristup], [DPO], [Valuta], [Klijent], [UserName], [Paritet], [Placanje], 
	[Napomena], [Otprema], [Vozilo], [Vozac], [vIDStorno], [vIDNiv], [ParDokBroj], [Avans], 
	[FaktSaRabatIznos], [Isporuka], [DatumDok], [Moneta], [Komercijalist], [vIDPrenos], [Naplata], 
	[JCI], [KursnaLista], [Kurs])
SELECT [vID], [mID], 8, '2012-01-01 00:00:11', '2012-01-01 00:00:11', [Broj], [ParID], [dtID], [Predznak], 
	'2012-01-01 00:00:11', '2012-01-01 00:00:11', '2012-01-01 00:00:11', 
	0, [Klijent], [UserName], [Paritet], [Placanje], [Napomena], [Otprema], [Vozilo], [Vozac], 
	[vIDStorno], [vIDNiv], [ParDokBroj], [Avans], [FaktSaRabatIznos], [Isporuka], [Datum], 
	[Moneta], [Komercijalist], [vIDPrenos], [Naplata], [JCI], [KursnaLista], [Kurs] 
FROM [EC201101].[dbo].[UlazIzlaz]
where mid = @mID and dtid = 60111
and jci in (SELECT distinct JCI
	FROM (
		SELECT 
			UID.[ProID], 
			CASE WHEN M.ecBit2 & 64 = 64 THEN 
				(CASE WHEN R.TipArtikla = 4 THEN R.Naziv ELSE R.CarinskoNaziv END)
			ELSE
				(CASE WHEN R.TipArtikla = 4 THEN R.Naziv ELSE R.Naziv END)
			END as Naziv,
			R.JM, SUM(UID.Bruto*UI.[Predznak]) Bruto, SUM(UID.Neto*UI.[Predznak]) Neto, 
			SUM(UID.[Kol]*UI.[Predznak]) Kol, 
			UID.[FCSaRab] as Fakturna, UI.[JCI], R.InvBr as InvBr, R.TarBr as TarBr
		FROM [EC201101].[dbo].UID uid
		LEFT JOIN [EC201101].[dbo].UlazIzlaz as UI ON UI.vID = UID.vID 
		LEFT JOIN [EC201101].[dbo].DokTip D ON d.DtID = UI.DTID
		LEFT JOIN [EC201101].[dbo].Registar R ON UID.ProID = R.ProID and R.mID = UI.mID
		LEFT JOIN [EC201101].[dbo].ecMagacin M ON M.mID = UI.mID
		WHERE UI.RAS & 1 = 1 
			and UI.RAS & 16 = 0
			and UI.Predznak <> 0
			and D.ecBit & 32 = 32 
			and UI.dtID between '60000' and '69999'
		GROUP BY UID.[ProID], R.Naziv,  R.InvBr, R.TarBr, R.CarinskoNaziv, R.TipArtikla, M.ecBit2, R.JM, UI.[JCI], UID.[FCSaRab] 
		HAVING SUM(UID.[Kol] * UI.[Predznak]) <> 0
	) JCI
)

-------------*****************************************---------------------------

-- Stavke

INSERT INTO [EC201201].[dbo].[UlazIzlazDetalj](
	[vID], [RedBr], [ProID], [Kol], [Cena], [CSaPor], [Rabat], [Porez], [Tarifa], 
	[Koef], [Realna], [Fakturna], [RabatFak], [Akciza], [Carina], [Naziv], 
	[StaraCena], [StaraCenaSaPor], [StaraKol], [Trosak], [StvarnaKol], 
	[Bruto], [Neto], [vJCI])
SELECT UI.[vID], 9999, JCI.[ProID], JCI.[Kol], P.[Cena], P.[CSaPor], 0, 0.17, 0.17, 1, 
	JCI.[Fakturna], JCI.[Fakturna], 0, 0, 0, r.naziv, 0, 0, 0, 0, 0, 0, 0, '' 
FROM 
 (
	SELECT UID.[ProID], 
		CASE WHEN M.ecBit2 & 64 = 64 THEN 
			(CASE WHEN R.TipArtikla = 4 THEN R.Naziv ELSE R.CarinskoNaziv END)
		ELSE
			(CASE WHEN R.TipArtikla = 4 THEN R.Naziv ELSE R.Naziv END)
		END as Naziv,
		R.JM, SUM(UID.Bruto * UI.[Predznak]) Bruto, SUM(UID.Neto * UI.[Predznak]) Neto, 
		SUM(UID.[Kol] * UI.[Predznak]) Kol, 
		UID.[FCSaRab] as Fakturna, UI.[JCI], R.InvBr as InvBr, R.TarBr as TarBr
	FROM [EC201101].[dbo].UID uid
	LEFT JOIN [EC201101].[dbo].UlazIzlaz as UI ON UI.vID = UID.vID 
	LEFT JOIN [EC201101].[dbo].DokTip D ON d.DtID = UI.DTID
	LEFT JOIN [EC201101].[dbo].Registar R ON UID.ProID = R.ProID and R.mID = UI.mID
	LEFT JOIN [EC201101].[dbo].ecMagacin M ON M.mID = UI.mID
	WHERE UI.RAS & 1 = 1 
		and UI.RAS & 16 = 0
		and UI.Predznak <> 0
		and D.ecBit & 32 = 32 
		and UI.dtID between '60000' and '69999'
	GROUP BY UID.[ProID], R.Naziv, R.InvBr, R.TarBr, R.CarinskoNaziv, R.TipArtikla, M.ecBit2, R.JM, UI.[JCI], UID.[FCSaRab] 
	HAVING SUM(UID.[Kol] * UI.[Predznak]) <> 0
) JCI 
left join [EC201101].[dbo].Pro P on jci.proid = p.proid and p.mid = @mID
left join [EC201101].[dbo].reg r on p.proid = r.proid
left join [EC201101].[dbo].ulazizlaz UI on UI.jci = jci.jci and ui.dtid = '60111'

GO
*/