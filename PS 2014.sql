/* 
		PROCEDURA ZA POCETNO STANJE 2014 - Prokontik13 -> Prokontik14
		D:\Prokontik(\DATA)
*/


USE [Prokontik13]
go


/* --Provjera razlika
SELECT [mID]
      ,SUM([RazlikaBezPoreza]) BP
      ,SUM([RazlikaSaPorezom]) SP
FROM [Prokontik13].[dbo].[RazlikaTrgILagerPoPro]
GROUP BY mID

SELECT [mID]
      ,[ProID]
      ,[RazlikaBezPoreza]
      ,[RazlikaSaPorezom]
FROM [Prokontik13].[dbo].[RazlikaTrgILagerPoPro]
ORDER BY mID, ProID
*/
-- PripremiNivelacijuOdRazlika 
------------------------------------------------------------------
/* BACKUP [Prokontik13] */
print 'backup'
BACKUP DATABASE [Prokontik13] TO  DISK = N'D:\Prokontik\Prokontik13.bak' WITH  INIT ,  NOUNLOAD ,  NAME = N'Prokontik13 backup',  NOSKIP ,  STATS = 10,  NOFORMAT 
go
/* RESTORE [Prokontik14] */
	-- NAPOMENA: Obrisi bazu Prokontik14 ako postoji
print 'restore nove baze'
RESTORE DATABASE [Prokontik14] FROM  DISK = N'D:\Prokontik\Prokontik13.bak' WITH  FILE = 1, REPLACE,  NOUNLOAD ,  STATS = 10,  RECOVERY ,  MOVE N'F001G040101M001_Data' TO N'D:\Prokontik\DATA\Prokontik14.mdf',  MOVE N'F001G040101M001_Log' TO N'D:\Prokontik\DATA\Prokontik14_log.ldf'
go

print 'brisem nove dokumente u staroj godini'
IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'Prokontik14')
	DELETE FROM [Prokontik13].[dbo].[UlazIzlaz] WHERE DATEPART(year,Datum) <> 2013
	DELETE FROM [Prokontik13].[dbo].[UlazIzlazDetalj] WHERE vID NOT IN (SELECT vID FROM [Prokontik13].[dbo].UlazIzlaz)
	DELETE FROM [Prokontik13].[dbo].[UlazIzlazSumm] WHERE vID NOT IN (SELECT vID FROM [Prokontik13].[dbo].UlazIzlaz)
	DELETE FROM [Prokontik13].[dbo].[UlazTrosak] WHERE vID NOT IN (SELECT vID FROM [Prokontik13].[dbo].UlazIzlaz)
	DELETE FROM [Prokontik13].[dbo].[Serijski] WHERE vID NOT IN (SELECT vID FROM [Prokontik13].[dbo].UlazIzlaz)
	DELETE FROM [Prokontik13].[dbo].[BarCodePopis] WHERE vID NOT IN (SELECT vID FROM [Prokontik13].[dbo].UlazIzlaz)
	DELETE FROM [Prokontik13].[dbo].[BarCodeUI] WHERE vID NOT IN (SELECT vID FROM [Prokontik13].[dbo].UlazIzlaz)
	DELETE FROM [Prokontik13].[dbo].[PazarZaKif] WHERE DATEPART(year,Datum) <> 2013
	DELETE FROM [Prokontik13].[dbo].[SerijaUI] WHERE vID NOT IN (SELECT vID FROM [Prokontik13].[dbo].UlazIzlaz)
	DELETE FROM [Prokontik13].[dbo].[table_vKIF] WHERE DATEPART(year,Datum) <> 2013--WHERE vID NOT IN (SELECT vID FROM [Prokontik13].[dbo].UlazIzlaz)
	DELETE FROM [Prokontik13].[dbo].[table_vKUF] WHERE DATEPART(year,Datum) <> 2013--WHERE vID NOT IN (SELECT vID FROM [Prokontik13].[dbo].UlazIzlaz)
	DELETE FROM [Prokontik13].[dbo].[UIDD] WHERE DATEPART(year,Datum) <> 2013
	DELETE FROM [Prokontik13].[dbo].[UlazIzlazExtra] WHERE vID NOT IN (SELECT vID FROM [Prokontik13].[dbo].UlazIzlaz)
	DELETE FROM [Prokontik13].[dbo].[UlazIzlazRadnik] WHERE vID NOT IN (SELECT vID FROM [Prokontik13].[dbo].UlazIzlaz)
	DELETE FROM [Prokontik13].[dbo].[UlazIzlazTrackChanges] WHERE vID NOT IN (SELECT vID FROM [Prokontik13].[dbo].UlazIzlaz)
	DELETE FROM [Prokontik13].[dbo].[RTFText] WHERE ISNUMERIC(Naziv)=1 AND Naziv NOT IN (SELECT vID FROM [Prokontik13].[dbo].UlazIzlaz)
	DELETE FROM [Prokontik13].[dbo].[ecOpsirnaAnaliza]
	DELETE FROM [Prokontik13].[dbo].[ecTemp] WHERE vIDI NOT IN (SELECT vID FROM [Prokontik13].[dbo].UlazIzlaz) or vIDU NOT IN (SELECT vID FROM [Prokontik13].[dbo].UlazIzlaz)
	DELETE FROM [Prokontik13].[dbo].[FIFO] WHERE vID NOT IN (SELECT vID FROM [Prokontik13].[dbo].UlazIzlaz)
	DELETE FROM [Prokontik13].[dbo].[KompenzacijaG] WHERE DATEPART(year,Datum) <> 2013
	DELETE FROM [Prokontik13].[dbo].[KompenzacijaS] WHERE vID NOT IN (SELECT vID FROM KompenzacijaG)
	DELETE FROM [Prokontik13].[dbo].[table_KUFEvidencija] WHERE DATEPART(year,Datum) <> 2013
	DELETE FROM [Prokontik13].[dbo].[UINotes] WHERE vID NOT IN (SELECT vID FROM [Prokontik13].[dbo].UlazIzlaz)
	DELETE FROM [Prokontik13].[dbo].[UlazIzlazRNalog] WHERE vID NOT IN (SELECT vID FROM [Prokontik13].[dbo].UlazIzlaz)
	DELETE FROM [Prokontik13].[dbo].[UlazIzlazUtovar] WHERE vID NOT IN (SELECT vID FROM [Prokontik13].[dbo].UlazIzlaz)
	DELETE FROM [Prokontik13].[dbo].[UredjajiUI] WHERE UIDaID NOT IN (SELECT AutoID FROM [Prokontik13].[dbo].UlazIzlazDetalj)
	DELETE FROM [Prokontik13].[dbo].[PazarZaKIF] WHERE vID NOT IN (SELECT vID FROM [Prokontik13].[dbo].KasaG WHERE DATEPART(year, Datum) = 2013)
go

/* -- SrediProReg -- */
print 'sredjujem kolicine u pro za sve magacine'
DECLARE @mID int
DECLARE crsM CURSOR
READ_ONLY
FOR SELECT mID FROM [Prokontik13].dbo.Magacin
OPEN crsM
FETCH NEXT FROM crsM INTO @mID
WHILE (@@fetch_status <> -1)
BEGIN
	IF (@@fetch_status <> -2)
	BEGIN
		EXEC [Prokontik13].[dbo].[ecSrediProReg] @mID, 0, 0
	END
	FETCH NEXT FROM crsM INTO @mID
END
CLOSE crsM
DEALLOCATE crsM
go



-- 2014
USE [Prokontik14]
go

/* DODAJ NABAVNU CIJENU NA DOKUMENT POCETNO STANJE
UPDATE [Prokontik14].[dbo].[DokTip] SET [FieldSeq]=N'StaraKol;FC;NabC;Marza;VPC', [LockFieldSeq]=N'NabC;StaraKol', [DetFieldSeq]=N'StaraKol;FC;NabC;Marza;VPC', [DetTotalSeq]=N'FakVr;NabVr;RUC;VPVr' WHERE [dtID]=cast(N'30001' COLLATE Slovenian_CI_AS as varchar(5))
UPDATE [Prokontik14].[dbo].[DokTip] SET [FieldSeq]=N'StaraKol;FC;NabC;Marza;VPC;Tarifa;MPC', [LockFieldSeq]=N'NabC;StaraKol', [DetFieldSeq]=N'StaraKol;FC;NabC;Marza;VPC;Tarifa;MPC', [DetTotalSeq]=N'FakVr;NabVr;RUC;VPVr;PorTrgVr;MPVr' WHERE [dtID]=cast(N'40001' COLLATE Slovenian_CI_AS as varchar(5))
*/

print 'brisem stare dokumente iz nove baze'
DELETE FROM [Prokontik14].[dbo].[UlazIzlaz] WHERE DATEPART(year,Datum) <> 2014
go
DELETE FROM [Prokontik14].[dbo].[UlazIzlazDetalj] WHERE vID NOT IN (SELECT vID FROM [Prokontik14].dbo.UlazIzlaz)
DELETE FROM [Prokontik14].[dbo].[UlazIzlazSumm] WHERE vID NOT IN (SELECT vID FROM [Prokontik14].dbo.UlazIzlaz)
DELETE FROM [Prokontik14].[dbo].[UlazTrosak] WHERE vID NOT IN (SELECT vID FROM [Prokontik14].dbo.UlazIzlaz)
DELETE FROM [Prokontik14].[dbo].[Serijski] WHERE vID NOT IN (SELECT vID FROM [Prokontik14].dbo.UlazIzlaz)
DELETE FROM [Prokontik14].[dbo].[BarCodePopis] WHERE vID NOT IN (SELECT vID FROM [Prokontik14].[dbo].UlazIzlaz)
DELETE FROM [Prokontik14].[dbo].[BarCodeUI] WHERE vID NOT IN (SELECT vID FROM [Prokontik14].[dbo].UlazIzlaz)
DELETE FROM [Prokontik14].[dbo].[PazarZaKif] WHERE DATEPART(year,Datum) <> 2014
DELETE FROM [Prokontik14].[dbo].[SerijaUI] WHERE vID NOT IN (SELECT vID FROM [Prokontik14].[dbo].UlazIzlaz)
--DELETE FROM [Prokontik14].[dbo].[table_vKIF] WHERE vID NOT IN (SELECT vID FROM [Prokontik14].[dbo].UlazIzlaz)
--DELETE FROM [Prokontik14].[dbo].[table_vKUF] WHERE vID NOT IN (SELECT vID FROM [Prokontik14].[dbo].UlazIzlaz)
DELETE FROM [Prokontik14].[dbo].[UIDD] WHERE DATEPART(year,Datum) <> 2014
DELETE FROM [Prokontik14].[dbo].[UlazIzlazExtra] WHERE vID NOT IN (SELECT vID FROM [Prokontik14].[dbo].UlazIzlaz)
DELETE FROM [Prokontik14].[dbo].[UlazIzlazRadnik] WHERE vID NOT IN (SELECT vID FROM [Prokontik14].[dbo].UlazIzlaz)
DELETE FROM [Prokontik14].[dbo].[UlazIzlazTrackChanges] WHERE vID NOT IN (SELECT vID FROM [Prokontik14].[dbo].UlazIzlaz)
DELETE FROM [Prokontik14].[dbo].[RTFText] WHERE ISNUMERIC(Naziv)=1 AND Naziv NOT IN (SELECT vID FROM [Prokontik14].[dbo].UlazIzlaz)
DELETE FROM [Prokontik14].[dbo].[ecOpsirnaAnaliza]
DELETE FROM [Prokontik14].[dbo].[ecTemp] WHERE vIDI NOT IN (SELECT vID FROM [Prokontik14].[dbo].UlazIzlaz) or vIDU NOT IN (SELECT vID FROM [Prokontik14].[dbo].UlazIzlaz)
DELETE FROM [Prokontik14].[dbo].[FIFO] WHERE vID NOT IN (SELECT vID FROM [Prokontik14].[dbo].UlazIzlaz)
DELETE FROM [Prokontik14].[dbo].[KompenzacijaG] WHERE DATEPART(year,Datum) <> 2014
DELETE FROM [Prokontik14].[dbo].[KompenzacijaS] WHERE vID NOT IN (SELECT vID FROM KompenzacijaG)
DELETE FROM [Prokontik14].[dbo].[table_KUFEvidencija] WHERE DATEPART(year,Datum) <> 2014
DELETE FROM [Prokontik14].[dbo].[table_vKIF] WHERE DATEPART(year,Datum) <> 2014
DELETE FROM [Prokontik14].[dbo].[table_vKUF] WHERE DATEPART(year,Datum) <> 2014
DELETE FROM [Prokontik14].[dbo].[table_ecKarticeZaProvjeru]
DELETE FROM [Prokontik14].[dbo].[UINotes] WHERE vID NOT IN (SELECT vID FROM [Prokontik14].[dbo].UlazIzlaz)
DELETE FROM [Prokontik14].[dbo].[UlazIzlazRNalog] WHERE vID NOT IN (SELECT vID FROM [Prokontik14].[dbo].UlazIzlaz)
DELETE FROM [Prokontik14].[dbo].[UlazIzlazUtovar] WHERE vID NOT IN (SELECT vID FROM [Prokontik14].[dbo].UlazIzlaz)
DELETE FROM [Prokontik14].[dbo].[UredjajiUI] WHERE UIDaID NOT IN (SELECT AutoID FROM [Prokontik14].[dbo].UlazIzlazDetalj)
go

/* GK */
print 'pocetno stanje stare GK'
-- delete from gk	
DELETE FROM [Prokontik14].[dbo].[GK] WHERE DATEPART(year, Datum) <> 2014
DELETE FROM [Prokontik13].[dbo].[GK] WHERE DATEPART(year, Datum) <> 2013
-- PS GK
/*
INSERT INTO [Prokontik14].[dbo].GK(
	[RedniBr], [BankaID], [Klijent], [MagID], [TipDokumentaID], [BrojDokumenta], [Datum], 
	[DKT_ID], [ParID], [TrosakID], [IznosD], [IznosP], [Saldo], [Opis], [Vreme], 
	[FaktorE], [ZapID], [Komercijalista], [Valuta], [Sync], [vID])
SELECT 0,0,HOST_NAME(),1,CASE [DKT_ID] WHEN 2 THEN 8 ELSE 7 END AS TipDok, '', '2014-01-01',
	[DKT_ID], GKView.[ParID], 0,
	CASE [DKT_ID] WHEN 2 THEN SUM(GKView.IznosD)-SUM(GKView.IznosP) ELSE 0 END AS SaldoD, 
	CASE [DKT_ID] WHEN 1 THEN SUM(GKView.IznosP)-SUM(GKView.IznosD) ELSE 0 END AS SaldoP, 
	0,'PS', GETDATE(),1.95583,USER_NAME(),0,'2014-01-01',1,-1
FROM [Prokontik13].[dbo].GKView GKView
LEFT JOIN [Prokontik13].[dbo].Par Par On GKView.ParID=Par.ParID
LEFT JOIN [Prokontik13].[dbo].RegSif RS ON Par.PostBr=RS.ID AND RS.dtID='10402'
WHERE  (GKView.DKT_ID=1 or GKView.DKT_ID=2) and DATEPART(year, GKView.Datum) <> 2014
group by GKView.ParID, GKView.DKT_ID

go
*/

print 'pocetno stanje nove finansije'

-- ** --PS FINANSIJE, nakon zavrsnog obracuna
/*

--SELECT [AutoID]
--      ,[vID]
--      ,[Broj]
--      ,[Nalog]
--      ,[Datum]
--      ,[ecBit]
--      ,[Proknjizen]
--      ,[PS]
--      ,[NalogIDknj]
--      ,[NalogID]
--      ,[Opis]
--      ,[mID]
--      ,[Magacin]
--      ,[RBr]
--      ,[dtID]
--      ,[Dokument]
--      ,[Prefix]
--      ,[DokBroj]
--      ,[Sufix]
--      ,[DokDatum]
--      ,[Mjesec]
--      ,[DokValuta]
--      ,[ParID]
--      ,[Partner]
--      ,[Grad]
--      ,[Adresa]
--      ,[PostBr]
--      ,[GradNaziv]
--      ,[KontaktOsoba]
--      ,[Telefon]
--      ,[Mobilni]
--      ,[Fax]
--      ,[IsPravno]
--      ,[GrupaPar]
--      ,[GrupaParNaziv]
--      ,[Parent]
--      ,[ParentNaziv]
--      ,[Komercijalist]
--      ,[KomercNaziv]
--      ,[ParDokBroj]
--      ,[BankaID]
--      ,[Banka]
--      ,[Konto]
--      ,[KontoOrig]
--      ,[NazivKonta]
--      ,[Klasa]
--      ,[KlasaNaziv]
--      ,[Grupa]
--      ,[GrupaNaziv]
--      ,[Sintetika]
--      ,[SintetikaNaziv]
--      ,[Duguje]
--      ,[Potrazuje]
--      ,[DugujePS]
--      ,[PotrazujePS]
--      ,[DugujePromet]
--      ,[PotrazujePromet]
--      ,[ecBitStavka]
--      ,[PDVNeOdbi]
--      ,[Oznaka]
--      ,[IOSZatvoren]
--      ,[IOSNezatvoren]
--      ,[IOSKompZatvoren]
--      ,[MjestoTroskaID]
--      ,[MjestoTroska]
--      ,[AnalitikaPar]
--      ,[AnalitikaRadnik]
--      ,[KUF]
--      ,[DokVID]
--      ,[IsDobavljac]
--      ,[IsKupac]
--INTO [Prokontik14].[dbo].[vNalogAll_13]
--FROM [Prokontik13].[dbo].[vNalogAll]
----!!!TODO!!! ALTER VIEW [dbo].[vNalogAll_AllYears]
--GO


DELETE FROM [Prokontik13].[dbo].[NalogS] WHERE DATEPART(YEAR, DokDatum)<>2013
DELETE FROM [Prokontik14].[dbo].[NalogS] WHERE DATEPART(YEAR, DokDatum)<>2014
DELETE FROM [Prokontik13].[dbo].[NalogG] WHERE vID not in (SELECT vID  FROM [Prokontik13].[dbo].[NalogS])
DELETE FROM [Prokontik14].[dbo].[NalogG] WHERE vID not in (SELECT vID  FROM [Prokontik14].[dbo].[NalogS])
go

  INSERT INTO [Prokontik14].[dbo].[NalogG]([Broj], [Nalog], [Datum], [ecBit], [Napomena])
  VALUES(0, 'POCETNO STANJE', '2014-01-01', 2, 'Pocetno stanje')
  go
  DECLARE @vIDf as int
  SELECT @vIDf = MAX(vID) FROM [Prokontik14].[dbo].NalogG
  
  INSERT INTO [Prokontik14].[dbo].[NalogS](
  	[vID], [RBr], [mID], [dtID], [DokVID], [DokBroj], [DokDatum], [DokValuta], 
  	[ParID], [Opis], [Konto], [Duguje], [Potrazuje], [AK])
  
  --stari nacin
  SELECT @vIDf, 999, 1, '30001', 0, '', '2014-01-01', '2014-01-01', 
  	 [ParID], 'Pocetno stanje', KontoOrig, 
  	CASE WHEN SUM([Duguje]) - SUM([Potrazuje]) > 0 THEN SUM([Duguje]) - SUM([Potrazuje]) ELSE 0 END, 
  	CASE WHEN SUM([Duguje]) - SUM([Potrazuje]) < 0 THEN SUM([Potrazuje]) - SUM([Duguje]) ELSE 0 END,0
  FROM [Prokontik13].dbo.[vNalogAll]
  WHERE --Proknjizen = 1 and --?????
  		parID > 0 and
  		KontoOrig LIKE '2010%' OR KontoOrig LIKE '2020%' OR KontoOrig LIKE '4320%' OR KontoOrig LIKE '4330%' --KontoOrig IN ('2010', '2020', '4320', '4330')
  GROUP BY KontoOrig, ParID, Partner
  HAVING SUM([Duguje]) - SUM([Potrazuje])<>0
  
  ----ILI
  
  ----novi nacin PS po IOS_u
  ----zatvori ios-e?
	--SELECT @vIDf, 999, 1, 
	--	dtID, DokVID, DokBroj, '2014-01-01', '2014-01-01', 
	-- 		[ParID], 'Pocetno stanje', KontoOrig, 
	--case Duguje when 0 then 0 else (abs(Duguje)-[IOSZatvoren])*case when Duguje<0 then -1 else 1 end end,
	--case Potrazuje when 0 then 0 else (abs(Potrazuje)-[IOSZatvoren])*case when Potrazuje<0 then -1 else 1 end end,
	--0
	--FROM [vNalogAll]
	--WHERE ( (KontoOrig LIKE '2010%' OR KontoOrig LIKE '2020%' OR KontoOrig LIKE '4320%' OR KontoOrig LIKE '4330%') ) and [IOSNeZatvoren] <> 0  --and DATEDIFF(DAY, DokDatum, 41617) >= 0  
	--ORDER BY ParID, DokDatum
  
  EXEC [Prokontik14].[dbo].[ecSrediRBrNalogStavke] @vIDf
  go
  DELETE FROM [Prokontik14].[dbo].[IOSFin] --WHERE vIDDok IN (SELECT vID FROM UlazIzlaz WHERE DATEPART(year, Knjizenje) <> 2013)

 -- END --PS FINANSIJE, nakon zavrsnog obracuna
*/

--
/* PRIPREMI ISPRAZNI BAZU */
print 'pripremi isprazni novu bazu'

UPDATE [Prokontik14].[dbo].[FirmaBaza] SET [Godina]=2014, [BazaSys]='Prokontik14'
UPDATE [Prokontik14].[dbo].[Magacin] SET [Godina]=2014, [Baza]='Prokontik14'

DELETE FROM [Prokontik14].[dbo].[Cjenovnik]
DELETE FROM [Prokontik14].[dbo].[DemiFirmeLager]
DELETE FROM [Prokontik14].[dbo].[DemiNarudzba]
DELETE FROM [Prokontik14].[dbo].[DemiNarudzbaDetalj]

-- DELETE FROM [[Prokontik14]].[dbo].[JCI]
DELETE FROM [Prokontik14].[dbo].[GKIOS]
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[UITable]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DELETE FROM [Prokontik14].[dbo].[UITable]
delete  FROM [Prokontik14].[dbo].[TempTrig]

print 'brisem kasa racune'
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[KasaG1]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [Prokontik14].[dbo].[KasaG1] WHERE DATEPART(year, Datum) <> 2014
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[KasaG2]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [Prokontik14].[dbo].[KasaG2] WHERE DATEPART(year, Datum) <> 2014
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[KasaG3]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [Prokontik14].[dbo].[KasaG3] WHERE DATEPART(year, Datum) <> 2014
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[KasaG4]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [Prokontik14].[dbo].[KasaG4] WHERE DATEPART(year, Datum) <> 2014
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[KasaG5]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [Prokontik14].[dbo].[KasaG5] WHERE DATEPART(year, Datum) <> 2014
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[KasaG6]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [Prokontik14].[dbo].[KasaG6] WHERE DATEPART(year, Datum) <> 2014
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[KasaG7]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [Prokontik14].[dbo].[KasaG7] WHERE DATEPART(year, Datum) <> 2014
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[KasaG8]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [Prokontik14].[dbo].[KasaG8] WHERE DATEPART(year, Datum) <> 2014
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[KasaG9]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [Prokontik14].[dbo].[KasaG9] WHERE DATEPART(year, Datum) <> 2014
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[KasaG10]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [Prokontik14].[dbo].[KasaG10] WHERE DATEPART(year, Datum) <> 2014
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[KasaG11]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [Prokontik14].[dbo].[KasaG11] WHERE DATEPART(year, Datum) <> 2014
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[KasaG12]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [Prokontik14].[dbo].[KasaG12] WHERE DATEPART(year, Datum) <> 2014
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[KasaG13]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [Prokontik14].[dbo].[KasaG13] WHERE DATEPART(year, Datum) <> 2014
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[KasaG14]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [Prokontik14].[dbo].[KasaG14] WHERE DATEPART(year, Datum) <> 2014
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[KasaG15]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [Prokontik14].[dbo].[KasaG15] WHERE DATEPART(year, Datum) <> 2014
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[KasaG16]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [Prokontik14].[dbo].[KasaG16] WHERE DATEPART(year, Datum) <> 2014
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[KasaG17]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [Prokontik14].[dbo].[KasaG17] WHERE DATEPART(year, Datum) <> 2014
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[KasaG18]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [Prokontik14].[dbo].[KasaG18] WHERE DATEPART(year, Datum) <> 2014
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[KasaG19]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [Prokontik14].[dbo].[KasaG19] WHERE DATEPART(year, Datum) <> 2014
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[KasaG20]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [Prokontik14].[dbo].[KasaG20] WHERE DATEPART(year, Datum) <> 2014
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[KasaG21]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [Prokontik14].[dbo].[KasaG21] WHERE DATEPART(year, Datum) <> 2014
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[KasaG22]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [Prokontik14].[dbo].[KasaG22] WHERE DATEPART(year, Datum) <> 2014
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[KasaG23]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [Prokontik14].[dbo].[KasaG23] WHERE DATEPART(year, Datum) <> 2014
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[KasaG24]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [Prokontik14].[dbo].[KasaG24] WHERE DATEPART(year, Datum) <> 2014
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[KasaG25]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [Prokontik14].[dbo].[KasaG25] WHERE DATEPART(year, Datum) <> 2014
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[KasaG26]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [Prokontik14].[dbo].[KasaG26] WHERE DATEPART(year, Datum) <> 2014
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[KasaG27]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [Prokontik14].[dbo].[KasaG27] WHERE DATEPART(year, Datum) <> 2014
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[KasaG28]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [Prokontik14].[dbo].[KasaG28] WHERE DATEPART(year, Datum) <> 2014
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[KasaG29]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [Prokontik14].[dbo].[KasaG29] WHERE DATEPART(year, Datum) <> 2014
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[KasaG30]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [Prokontik14].[dbo].[KasaG30] WHERE DATEPART(year, Datum) <> 2014

if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[KasaStavka]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [Prokontik14].[dbo].[KasaStavka] WHERE vID NOT IN (SELECT vID FROM [Prokontik14].[dbo].KasaGlava WHERE DATEPART(year, Datum) = 2014)
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[KasaGlava]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [Prokontik14].[dbo].[KasaGlava] WHERE DATEPART(year, Datum) <> 2014

if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[KasaS1]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [Prokontik14].[dbo].[KasaS1] WHERE vID NOT IN (SELECT vID FROM [Prokontik14].[dbo].KasaG1 WHERE DATEPART(year, Datum) = 2014)
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[KasaS2]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [Prokontik14].[dbo].[KasaS2] WHERE vID NOT IN (SELECT vID FROM [Prokontik14].[dbo].KasaG2 WHERE DATEPART(year, Datum) = 2014)
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[KasaS3]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [Prokontik14].[dbo].[KasaS3] WHERE vID NOT IN (SELECT vID FROM [Prokontik14].[dbo].KasaG3 WHERE DATEPART(year, Datum) = 2014)
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[KasaS4]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [Prokontik14].[dbo].[KasaS4] WHERE vID NOT IN (SELECT vID FROM [Prokontik14].[dbo].KasaG4 WHERE DATEPART(year, Datum) = 2014)
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[KasaS5]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [Prokontik14].[dbo].[KasaS5] WHERE vID NOT IN (SELECT vID FROM [Prokontik14].[dbo].KasaG5 WHERE DATEPART(year, Datum) = 2014)
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[KasaS6]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [Prokontik14].[dbo].[KasaS6] WHERE vID NOT IN (SELECT vID FROM [Prokontik14].[dbo].KasaG6 WHERE DATEPART(year, Datum) = 2014)
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[KasaS7]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [Prokontik14].[dbo].[KasaS7] WHERE vID NOT IN (SELECT vID FROM [Prokontik14].[dbo].KasaG7 WHERE DATEPART(year, Datum) = 2014)
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[KasaS8]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [Prokontik14].[dbo].[KasaS8] WHERE vID NOT IN (SELECT vID FROM [Prokontik14].[dbo].KasaG8 WHERE DATEPART(year, Datum) = 2014)
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[KasaS9]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [Prokontik14].[dbo].[KasaS9] WHERE vID NOT IN (SELECT vID FROM [Prokontik14].[dbo].KasaG9 WHERE DATEPART(year, Datum) = 2014)
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[KasaS10]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [Prokontik14].[dbo].[KasaS10] WHERE vID NOT IN (SELECT vID FROM [Prokontik14].[dbo].KasaG10 WHERE DATEPART(year, Datum) = 2014)
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[KasaS11]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [Prokontik14].[dbo].[KasaS11] WHERE vID NOT IN (SELECT vID FROM [Prokontik14].[dbo].KasaG11 WHERE DATEPART(year, Datum) = 2014)
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[KasaS12]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [Prokontik14].[dbo].[KasaS12] WHERE vID NOT IN (SELECT vID FROM [Prokontik14].[dbo].KasaG12 WHERE DATEPART(year, Datum) = 2014)
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[KasaS13]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [Prokontik14].[dbo].[KasaS13] WHERE vID NOT IN (SELECT vID FROM [Prokontik14].[dbo].KasaG13 WHERE DATEPART(year, Datum) = 2014)
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[KasaS14]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [Prokontik14].[dbo].[KasaS14] WHERE vID NOT IN (SELECT vID FROM [Prokontik14].[dbo].KasaG14 WHERE DATEPART(year, Datum) = 2014)
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[KasaS15]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [Prokontik14].[dbo].[KasaS15] WHERE vID NOT IN (SELECT vID FROM [Prokontik14].[dbo].KasaG15 WHERE DATEPART(year, Datum) = 2014)
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[KasaS16]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [Prokontik14].[dbo].[KasaS16] WHERE vID NOT IN (SELECT vID FROM [Prokontik14].[dbo].KasaG16 WHERE DATEPART(year, Datum) = 2014)
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[KasaS17]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [Prokontik14].[dbo].[KasaS17] WHERE vID NOT IN (SELECT vID FROM [Prokontik14].[dbo].KasaG17 WHERE DATEPART(year, Datum) = 2014)
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[KasaS18]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [Prokontik14].[dbo].[KasaS18] WHERE vID NOT IN (SELECT vID FROM [Prokontik14].[dbo].KasaG18 WHERE DATEPART(year, Datum) = 2014)
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[KasaS19]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [Prokontik14].[dbo].[KasaS19] WHERE vID NOT IN (SELECT vID FROM [Prokontik14].[dbo].KasaG19 WHERE DATEPART(year, Datum) = 2014)
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[KasaS20]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [Prokontik14].[dbo].[KasaS20] WHERE vID NOT IN (SELECT vID FROM [Prokontik14].[dbo].KasaG20 WHERE DATEPART(year, Datum) = 2014)
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[KasaS21]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [Prokontik14].[dbo].[KasaS21] WHERE vID NOT IN (SELECT vID FROM [Prokontik14].[dbo].KasaG21 WHERE DATEPART(year, Datum) = 2014)
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[KasaS22]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [Prokontik14].[dbo].[KasaS22] WHERE vID NOT IN (SELECT vID FROM [Prokontik14].[dbo].KasaG22 WHERE DATEPART(year, Datum) = 2014)
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[KasaS23]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [Prokontik14].[dbo].[KasaS23] WHERE vID NOT IN (SELECT vID FROM [Prokontik14].[dbo].KasaG23 WHERE DATEPART(year, Datum) = 2014)
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[KasaS24]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [Prokontik14].[dbo].[KasaS24] WHERE vID NOT IN (SELECT vID FROM [Prokontik14].[dbo].KasaG24 WHERE DATEPART(year, Datum) = 2014)
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[KasaS25]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [Prokontik14].[dbo].[KasaS25] WHERE vID NOT IN (SELECT vID FROM [Prokontik14].[dbo].KasaG25 WHERE DATEPART(year, Datum) = 2014)
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[KasaS26]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [Prokontik14].[dbo].[KasaS26] WHERE vID NOT IN (SELECT vID FROM [Prokontik14].[dbo].KasaG26 WHERE DATEPART(year, Datum) = 2014)
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[KasaS27]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [Prokontik14].[dbo].[KasaS27] WHERE vID NOT IN (SELECT vID FROM [Prokontik14].[dbo].KasaG27 WHERE DATEPART(year, Datum) = 2014)
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[KasaS28]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [Prokontik14].[dbo].[KasaS28] WHERE vID NOT IN (SELECT vID FROM [Prokontik14].[dbo].KasaG28 WHERE DATEPART(year, Datum) = 2014)
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[KasaS29]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [Prokontik14].[dbo].[KasaS29] WHERE vID NOT IN (SELECT vID FROM [Prokontik14].[dbo].KasaG29 WHERE DATEPART(year, Datum) = 2014)
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[KasaS30]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DELETE FROM [Prokontik14].[dbo].[KasaS30] WHERE vID NOT IN (SELECT vID FROM [Prokontik14].[dbo].KasaG30 WHERE DATEPART(year, Datum) = 2014)

DELETE FROM [Prokontik14].[dbo].[BarCodeKasa] WHERE vID NOT IN (SELECT vID FROM [Prokontik14].[dbo].KasaG WHERE DATEPART(year, Datum) = 2014)
DELETE FROM [Prokontik14].[dbo].[PazarZaKIF] WHERE vID NOT IN (SELECT vID FROM [Prokontik14].[dbo].KasaG WHERE DATEPART(year, Datum) = 2014)

print 'drop nepotrebne tabele'
--if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[KasaGArhiva]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
--drop table [Prokontik14].[dbo].[KasaGArhiva]
--if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[KasaSArhiva]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
--drop table [Prokontik14].[dbo].[KasaSArhiva]

if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[BarCodeKasaSinhro]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [Prokontik14].dbo.[BarCodeKasaSinhro]
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[BarCodeUISinhro]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [Prokontik14].dbo.[BarCodeUISinhro]
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[BarCodSinhro]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [Prokontik14].dbo.[BarCodSinhro]
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[DokTipACC]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [Prokontik14].dbo.[DokTipACC]
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[FormulaACC]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [Prokontik14].dbo.[FormulaACC]
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[GKSinhro]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [Prokontik14].dbo.[GKSinhro]
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[GlavnaKnjigaOLD]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [Prokontik14].dbo.[GlavnaKnjigaOLD]
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[KasaGSinhro]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [Prokontik14].dbo.[KasaGSinhro]
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[KasaSSinhro]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [Prokontik14].dbo.[KasaSSinhro]
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[KontoACC]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [Prokontik14].dbo.[KontoACC]
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[ParSinhro]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [Prokontik14].dbo.[ParSinhro]
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[ProSinhro]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [Prokontik14].dbo.[ProSinhro]
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[RegSifACC]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [Prokontik14].dbo.[RegSifACC]
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[RegSinhro]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [Prokontik14].dbo.[RegSinhro]
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[TipoviTroskovaACC]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [Prokontik14].dbo.[TipoviTroskovaACC]
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[UlazIzlazDetaljSinhro]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [Prokontik14].dbo.[UlazIzlazDetaljSinhro]
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[UlazIzlazSinhro]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [Prokontik14].dbo.[UlazIzlazSinhro]
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[UlazIzlazSummSinhro]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [Prokontik14].dbo.[UlazIzlazSummSinhro]
if exists (select * from [Prokontik14].dbo.sysobjects where id = object_id(N'[UlazTrosakSinhro]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [Prokontik14].dbo.[UlazTrosakSinhro]


/* PS */
print 'pocetno stanje, robno, za sve magacine'
DECLARE @mID int
DECLARE @vIDPS as int
DECLARE crsM CURSOR
READ_ONLY
FOR SELECT mID FROM [Prokontik14].[dbo].Magacin WHERE (VrstaMag <> 6) --and (VrstaMag <> 5 and PodvrstaMag <> 1)  --osim carine i proizvodnje --VrstaMag+PodvrstaMag<>6
OPEN crsM
FETCH NEXT FROM crsM INTO @mID
WHILE (@@fetch_status <> -1)
BEGIN
	IF (@@fetch_status <> -2)
	BEGIN
		SELECT @vIDPS = [Prokontik14].[dbo].[ecNextVID](@mID)
		INSERT INTO [Prokontik14].[dbo].[UlazIzlaz](
			[vID], [mID], [RAS], [Datum], [Knjizenje], [Broj], [ParID], [dtID], [Predznak], 
			[Vreme], [Pristup], [DPO], [Valuta], [Klijent], [UserName], [Paritet], [Placanje], 
			[Napomena], [Otprema], [Vozilo], [Vozac], [vIDStorno], [vIDNiv], [ParDokBroj], 
			[Avans], [FaktSaRabatIznos], [Isporuka], [DatumDok], [Moneta], [Komercijalist], 
			[vIDPrenos], [Naplata], [JCI], [KursnaLista], [Kurs], [PredBroj], [PostBroj], [Izdao])
		SELECT @vIDPS, @mID, 1, '2014-01-01 00:00:11', '2014-01-01 00:00:11', 1, -2, 
			CASE VrstaMag 
				WHEN 3 THEN '30001' 
				WHEN 4 THEN '40001' 
				WHEN 5 THEN CASE PodvrstaMag WHEN 1 THEN '51115'/*1 Proizvodnja*/ ELSE '52001'/*52110 primka 2 Repromaterijal*/ END 
			ELSE '0' END, 1,
			GetDate(), GetDate(), GetDate(), 0, Host_Name(), 'sa', 0,0,
			'Automatsko pocetno stanje', 0,0,0,0,0,0,0,0,0,GetDate(), 1,0,0,0,0,0,0,'','',0
		FROM [Prokontik14].[dbo].Magacin WHERE mID = @mID

		INSERT INTO [Prokontik14].[dbo].[UlazIzlazDetalj](
			[vID], [RedBr], [ProID], [Kol], [Cena], [CSaPor], [Rabat], [Porez], [Tarifa], 
			[Koef], [Realna], [Fakturna], [RabatFak], [Akciza], [Carina], [Naziv], [StaraCena], 
			[StaraCenaSaPor], [StaraKol], [Trosak], [StvarnaKol])

		SELECT @vIDPS,999,[ProID], Kol, /*case when [Kol]>0 then Kol else 0 end,*/ [Cena], [CSaPor],0,0.17,0.17,
			1,[Realna],[Realna], 0,0,0,'',[Cena], [CSaPor],kol,0,kol
		FROM [Prokontik13].[dbo].[Pro] WHERE mID = @mID and Cena + Realna > 0

		-- OBAVEZAN BAR CODE
		INSERT INTO [Prokontik14].[dbo].[BarCodeUI]([vID], [ProID], [BarCode], [Kol])
		SELECT @vIDPS, [ProID], [BarCode], [Kol] 
		FROM [Prokontik13].[dbo].[vBarCodeUIStanje]
		WHERE mID = @mID

		DELETE FROM [Prokontik14].[dbo].[Pro] WHERE mID = @mID and ProID IN (SELECT ProID FROM Reg WHERE TipArtikla<>4)

		EXEC [Prokontik14].[dbo].[ecSredjivanjeRednogBroja] @vIDPS
		EXEC [Prokontik14].[dbo].[ecSrediProReg] @mID, 0, 0
		
		--ZAKLJUCAJ RAD NA KASI U STAROJ GODINI
		--NEWecBIT3Magacin = ecBit.BitSet(NEWecBIT3Magacin, ecEnum.ecBit3Magacin.KasaLock, cbKasaLock.Checked)
		UPDATE Prokontik13.dbo.Magacin SET ecBit3 = Prokontik13.dbo.ecBitSet(ecBit3,5,1) WHERE mID = @mID
	END
	FETCH NEXT FROM crsM INTO @mID
END
CLOSE crsM
DEALLOCATE crsM
go

DBCC shrinkdatabase(N'Prokontik14',  TRUNCATEONLY )
go
use [Prokontik14] DBCC SHRINKFILE (N'F001G040101M001_Log')
go


/*
USE [Prokontik14]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [dbo].[vNalogAll_AllYears]

AS

SELECT [AutoID]
	,[vID]
	,[Broj]
	,[Nalog]
	,[Datum]
	,[ecBit]
	,[Proknjizen]
	,[PS]
	,[NalogIDknj]
	,[NalogID]
	,[Opis]
	,[mID]
	,[Magacin]
	,[RBr]
	,[dtID]
	,[Dokument]
	,[Prefix]
	,[DokBroj]
	,[Sufix]
	,[DokDatum]
	,[Mjesec]
	,[DokValuta]
	,[ParID]
	,[Partner]
	,[Grad]
	,[Adresa]
	,[PostBr]
	,[GradNaziv]
	,[KontaktOsoba]
	,[Telefon]
	,[Mobilni]
	,[Fax]
	,[IsPravno]
	,[GrupaPar]
	,[GrupaParNaziv]
	,[Parent]
	,[ParentNaziv]
	,[Komercijalist]
	,[KomercNaziv]
	,[ParDokBroj]
	,[BankaID]
	,[Banka]
	,[Konto]
	,[KontoOrig]
	,[NazivKonta]
	,[Klasa]
	,[KlasaNaziv]
	,[Grupa]
	,[GrupaNaziv]
	,[Sintetika]
	,[SintetikaNaziv]
	,[Duguje]
	,[Potrazuje]
	,[DugujePS]
	,[PotrazujePS]
	,[DugujePromet]
	,[PotrazujePromet]
	,[ecBitStavka]
	,[PDVNeOdbi]
	,[Oznaka]
	,[IOSZatvoren]
	,[IOSNezatvoren]
	,[IOSKompZatvoren]
	,[MjestoTroskaID]
	,[MjestoTroska]
	,[AnalitikaPar]
	,[AnalitikaRadnik]
	,[KUF]
	,[DokVID]
	,[IsDobavljac]
	,[IsKupac]
FROM [Prokontik13].[dbo].[vNalogAll_AllYears]

UNION ALL

SELECT [AutoID]
	,[vID]
	,[Broj]
	,[Nalog]
	,[Datum]
	,[ecBit]
	,[Proknjizen]
	,[PS]
	,[NalogIDknj]
	,[NalogID]
	,[Opis]
	,[mID]
	,[Magacin]
	,[RBr]
	,[dtID]
	,[Dokument]
	,[Prefix]
	,[DokBroj]
	,[Sufix]
	,[DokDatum]
	,[Mjesec]
	,[DokValuta]
	,[ParID]
	,[Partner]
	,[Grad]
	,[Adresa]
	,[PostBr]
	,[GradNaziv]
	,[KontaktOsoba]
	,[Telefon]
	,[Mobilni]
	,[Fax]
	,[IsPravno]
	,[GrupaPar]
	,[GrupaParNaziv]
	,[Parent]
	,[ParentNaziv]
	,[Komercijalist]
	,[KomercNaziv]
	,[ParDokBroj]
	,[BankaID]
	,[Banka]
	,[Konto]
	,[KontoOrig]
	,[NazivKonta]
	,[Klasa]
	,[KlasaNaziv]
	,[Grupa]
	,[GrupaNaziv]
	,[Sintetika]
	,[SintetikaNaziv]
	,[Duguje]
	,[Potrazuje]
	,[DugujePS]
	,[PotrazujePS]
	,[DugujePromet]
	,[PotrazujePromet]
	,[ecBitStavka]
	,[PDVNeOdbi]
	,[Oznaka]
	,[IOSZatvoren]
	,[IOSNezatvoren]
	,[IOSKompZatvoren]
	,[MjestoTroskaID]
	,[MjestoTroska]
	,[AnalitikaPar]
	,[AnalitikaRadnik]
	,[KUF]
	,[DokVID]
	,[IsDobavljac]
	,[IsKupac]
FROM [dbo].[vNalogAll]
WHERE PS = 0
GO
*/

/*
--REZERVACIJE

--SELECT  UI.[dtID], dt.Naziv, ui.mid, COUNT(vid) c
--  FROM [Prokontik13].[dbo].[UlazIzlaz] UI
--  LEFT JOIN [Prokontik13].[dbo].doktip dt ON ui.dtid=dt.dtID
--  where UI.RAS & 256 = 256 --and UI.RAS & 1 <> 1 --and ui.dtID in (30210,40210)
--  GROUP BY UI.[dtID], dt.Naziv, ui.mid

INSERT INTO [Prokontik14].[dbo].[UlazIzlaz]
           ([vID]
           ,[mID]
           ,[RAS]
           ,[Datum]
           ,[Knjizenje]
           ,[Broj]
           ,[ParID]
           ,[dtID]
           ,[Predznak]
           ,[Vreme]
           ,[Pristup]
           ,[DPO]
           ,[Valuta]
           ,[Klijent]
           ,[UserName]
           ,[Paritet]
           ,[Placanje]
           ,[Napomena]
           ,[Otprema]
           ,[Vozilo]
           ,[Vozac]
           ,[vIDStorno]
           ,[vIDNiv]
           ,[ParDokBroj]
           ,[Avans]
           ,[FaktSaRabatIznos]
           ,[Isporuka]
           ,[DatumDok]
           ,[Moneta]
           ,[Komercijalist]
           ,[vIDPrenos]
           ,[Naplata]
           ,[JCI]
           ,[KursnaLista]
           ,[Kurs]
           ,[PredBroj]
           ,[PostBroj]
           ,[Izdao],StanjeID)
   
SELECT UI.[vID]
      ,UI.[mID]
      ,UI.[RAS]
      ,'2014-01-01'
      ,'2014-01-01'
      ,UI.[Broj]
      ,UI.[ParID]
      ,UI.[dtID]--, dt.Naziv
      ,UI.[Predznak]
      ,UI.[Vreme]
      ,UI.[Pristup]
      ,UI.[DPO]
      ,UI.[Valuta]
      ,UI.[Klijent]
      ,UI.[UserName]
      ,UI.[Paritet]
      ,UI.[Placanje]
      ,UI.[Napomena]
      ,UI.[Otprema]
      ,UI.[Vozilo]
      ,UI.[Vozac]
      ,UI.[vIDStorno]
      ,UI.[vIDNiv]
      ,UI.[ParDokBroj]
      ,UI.[Avans]
      ,UI.[FaktSaRabatIznos]
      ,UI.[Isporuka]
      ,UI.[DatumDok]
      ,UI.[Moneta]
      ,UI.[Komercijalist]
      ,UI.[vIDPrenos]
      ,UI.[Naplata]
      ,UI.[JCI]
      ,UI.[KursnaLista]
      ,UI.[Kurs]
      ,UI.[PredBroj]
      ,UI.[PostBroj]
      ,UI.[Izdao],UI.StanjeID
  --FROM [Prokontik13].[dbo].[UlazIzlaz] UI
  --where UI.RAS & 256 = 256 and UI.RAS & 1 <> 1 and ui.dtID in (30210,40210)
  ----where UI.RAS & 256 = 256 and ui.dtID not in (30211, 30210,30500,40210,40211)
FROM [Prokontik13].[dbo].[UlazIzlaz] UI
LEFT JOIN [Prokontik13].[dbo].vDokumenti dt ON ui.dtid=dt.dtID
where ((UI.RAS & 1 <> 1) OR (UI.RAS & 256 = 256 AND dt.Kartice = 0 )) 
	AND (ui.dtid+mid<>30512) and ui.dtID not in ('',52225) AND (ui.dtid+mid<>30212) AND (ui.dtid+mid<>30213) AND (ui.dtid+mid<>40211)






INSERT INTO [Prokontik14].[dbo].[UlazIzlazDetalj]
           ([vID]
           ,[RedBr]
           ,[ProID]
           ,[Kol]
           ,[Cena]
           ,[CSaPor]
           ,[Rabat]
           ,[Porez]
           ,[Tarifa]
           ,[Koef]
           ,[Realna]
           ,[Fakturna]
           ,[RabatFak]
           ,[Akciza]
           ,[Carina]
           ,[Naziv]
           ,[StaraCena]
           ,[StaraCenaSaPor]
           ,[StaraKol]
           ,[Trosak]
           ,[StvarnaKol]
           ,[CProdPrenos]
           ,[CProdPrenosBPor]
           ,[PDV]
           ,[ecBit]
           ,[PredznakParcijalneNiv]
           ,[PrenosRabat]
           ,[vPrenos]
           ,[MarzaPrenos]
           ,[Bruto]
           ,[Neto]
           ,[vJCI])
SELECT [vID]
      ,[RedBr]
      ,[ProID]
      ,[Kol]
      ,[Cena]
      ,[CSaPor]
      ,[Rabat]
      ,[Porez]
      ,[Tarifa]
      ,[Koef]
      ,[Realna]
      ,[Fakturna]
      ,[RabatFak]
      ,[Akciza]
      ,[Carina]
      ,[Naziv]
      ,[StaraCena]
      ,[StaraCenaSaPor]
      ,[StaraKol]
      ,[Trosak]
      ,[StvarnaKol]
      ,[CProdPrenos]
      ,[CProdPrenosBPor]
      ,[PDV]
      ,[ecBit]
      ,[PredznakParcijalneNiv]
      ,[PrenosRabat]
      ,[vPrenos]
      ,[MarzaPrenos]
      ,[Bruto]
      ,[Neto]
      ,[vJCI]
  FROM [Prokontik13].[dbo].[UlazIzlazDetalj]
where vID in (
  SELECT UI.[vID]
--  FROM [Prokontik13].[dbo].[UlazIzlaz] UI
----  where UI.RAS & 256 = 256 and ui.dtID not in (30211, 30210,30500,40210,40211)
--  where UI.RAS & 256 = 256 and UI.RAS & 1 <> 1 and ui.dtID in (30210,40210)
FROM [Prokontik13].[dbo].[UlazIzlaz] UI
LEFT JOIN [Prokontik13].[dbo].vDokumenti dt ON ui.dtid=dt.dtID
where ((UI.RAS & 1 <> 1) OR (UI.RAS & 256 = 256 AND dt.Kartice = 0 )) 
	AND (ui.dtid+mid<>30512) and ui.dtID not in ('',52225) AND (ui.dtid+mid<>30212) AND (ui.dtid+mid<>30213) AND (ui.dtid+mid<>40211)
)
--REZERVACIJE END
*/

/*--PLATE
DELETE FROM [Prokontik13].[dbo].[ObrIzdaci] WHERE ... <> 2013
DELETE FROM [Prokontik14].[dbo].[ObrIzdaci] WHERE ... <> 2014
--INSERT INTO [Prokontik14].[dbo].[ObrIzdaci]([ObrPeriod], [RadID], [Vrsta], [Osnovica], [Stopa], [Iznos], [ecBit])
--SELECT [ObrPeriod], [RadID], [Vrsta], [Osnovica], [Stopa], [Iznos], [ecBit] 
--FROM [Prokontik13].[dbo].[ObrIzdaci]

DELETE FROM [Prokontik13].[dbo].[ObrPeriod] WHERE ... <> 2013
DELETE FROM [Prokontik14].[dbo].[ObrPeriod] WHERE ... <> 2014
--INSERT INTO [Prokontik14].[dbo].[ObrPeriod]([Naziv], [Oznaka], [DatumOd], [DatumDo], [BrojSati], [ecBit], [DatumIsplate], [DatumObracuna], [MinPlata], [BodVr], [StopaGot], [StopaZR], [IznosGot], [IznosZR])
--SELECT [Naziv], [Oznaka], [DatumOd], [DatumDo], [BrojSati], [ecBit], [DatumIsplate], [DatumObracuna], [MinPlata], [BodVr], [StopaGot], [StopaZR], [IznosGot], [IznosZR] 
--FROM [Prokontik13].[dbo].[ObrPeriod]

DELETE FROM [Prokontik13].[dbo].[ObrPlata] ... <> 2013
DELETE FROM [Prokontik14].[dbo].[ObrPlata] ... <> 2014
--INSERT INTO [Prokontik14].[dbo].[ObrPlata]([ObrPeriod], [RadID], [VrstaRada], [ProsPoSatu], [Stopa], [Sati], [BodPoSat], [BodZaRad], [Iznos], [ecBit])
--SELECT [ObrPeriod], [RadID], [VrstaRada], [ProsPoSatu], [Stopa], [Sati], [BodPoSat], [BodZaRad], [Iznos], [ecBit] 
--FROM [Prokontik13].[dbo].[ObrPlata]
-- --PLATE END */

/*
--** Pocetno stanje Carinsko **--
-- Kreiranje prijemnica sa preostalim kolicinama, proknjiziti rucno zbog sredjivanja kolicina po JCI
-- Zaglavlje

DECLARE @mID as int
SELECT TOP 1 @mID = mID FROM [Prokontik14].[dbo].Magacin WHERE VrstaMag = 6

INSERT INTO [Prokontik14].[dbo].[UlazIzlaz](
	[vID], [mID], [RAS], [Datum], [Knjizenje], [Broj], [ParID], [dtID], [Predznak], 
	[Vreme], [Pristup], [DPO], [Valuta], [Klijent], [UserName], [Paritet], [Placanje], 
	[Napomena], [Otprema], [Vozilo], [Vozac], [vIDStorno], [vIDNiv], [ParDokBroj], [Avans], 
	[FaktSaRabatIznos], [Isporuka], [DatumDok], [Moneta], [Komercijalist], [vIDPrenos], [Naplata], 
	[JCI], [KursnaLista], [Kurs],StanjeID)
SELECT [vID], [mID], 8, '2014-01-01 00:00:11', '2014-01-01 00:00:11', [Broj], [ParID], [dtID], [Predznak], 
	[Vreme], [Pristup], [DPO], [Valuta], 
	[Klijent], [UserName], [Paritet], [Placanje], [Napomena], [Otprema], [Vozilo], [Vozac], 
	[vIDStorno], [vIDNiv], [ParDokBroj], [Avans], [FaktSaRabatIznos], [Isporuka], [Datum], 
	[Moneta], [Komercijalist], [vIDPrenos], [Naplata], [JCI], [KursnaLista], [Kurs],StanjeID 
FROM [Prokontik13].[dbo].[UlazIzlaz]
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
		FROM [Prokontik13].[dbo].UID uid
		LEFT JOIN [Prokontik13].[dbo].UlazIzlaz as UI ON UI.vID = UID.vID 
		LEFT JOIN [Prokontik13].[dbo].DokTip D ON d.DtID = UI.DTID
		LEFT JOIN [Prokontik13].[dbo].Registar R ON UID.ProID = R.ProID and R.mID = UI.mID
		LEFT JOIN [Prokontik13].[dbo].ecMagacin M ON M.mID = UI.mID
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

INSERT INTO [Prokontik14].[dbo].[UlazIzlazDetalj](
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
	FROM [Prokontik13].[dbo].UID uid
	LEFT JOIN [Prokontik13].[dbo].UlazIzlaz as UI ON UI.vID = UID.vID 
	LEFT JOIN [Prokontik13].[dbo].DokTip D ON d.DtID = UI.DTID
	LEFT JOIN [Prokontik13].[dbo].Registar R ON UID.ProID = R.ProID and R.mID = UI.mID
	LEFT JOIN [Prokontik13].[dbo].ecMagacin M ON M.mID = UI.mID
	WHERE UI.RAS & 1 = 1 
		and UI.RAS & 16 = 0
		and UI.Predznak <> 0
		and D.ecBit & 32 = 32 
		and UI.dtID between '60000' and '69999'
	GROUP BY UID.[ProID], R.Naziv, R.InvBr, R.TarBr, R.CarinskoNaziv, R.TipArtikla, M.ecBit2, R.JM, UI.[JCI], UID.[FCSaRab] 
	HAVING SUM(UID.[Kol] * UI.[Predznak]) <> 0
) JCI 
left join [Prokontik13].[dbo].Pro P on jci.proid = p.proid and p.mid = @mID
left join [Prokontik13].[dbo].reg r on p.proid = r.proid
left join [Prokontik13].[dbo].ulazizlaz UI on UI.jci = jci.jci and ui.dtid = '60111'

GO
*/