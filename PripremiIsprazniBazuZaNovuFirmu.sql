--USE EC200901Prazna

--	Baza za novu firmu
--1. Restore EC200901 -> EC200901Prazna
/*
--2. Rucno
DELETE FROM [Firma]
WHERE fID <> 1

DELETE FROM [FirmaBaza]
WHERE fID <> 1
--ecLicenca
--9223372036854774783 - FIN.
--9223372036854774015 - NO FIN.

DELETE FROM [Host]
WHERE ID NOT IN (1)

DELETE FROM [Magacin]
WHERE mID NOT IN (1,2)

DELETE FROM [Objekat]
WHERE oID NOT IN (1,2)


*/
--3. Pusti ovaj script

--Drop tables for sync
if exists (select * from dbo.sysobjects where id = object_id(N'[BarCodeKasaSinhro]') and OBJECTPROPERTY(id, N'IsUserTable') = 1) drop table [BarCodeKasaSinhro]
if exists (select * from dbo.sysobjects where id = object_id(N'[BarCodeUISinhro]') and OBJECTPROPERTY(id, N'IsUserTable') = 1) drop table [BarCodeUISinhro]
if exists (select * from dbo.sysobjects where id = object_id(N'[BarCodSinhro]') and OBJECTPROPERTY(id, N'IsUserTable') = 1) drop table [BarCodSinhro]
if exists (select * from dbo.sysobjects where id = object_id(N'[DokTipACC]') and OBJECTPROPERTY(id, N'IsUserTable') = 1) drop table [DokTipACC]
if exists (select * from dbo.sysobjects where id = object_id(N'[FormulaACC]') and OBJECTPROPERTY(id, N'IsUserTable') = 1) drop table [FormulaACC]
if exists (select * from dbo.sysobjects where id = object_id(N'[GKSinhro]') and OBJECTPROPERTY(id, N'IsUserTable') = 1) drop table [GKSinhro]
if exists (select * from dbo.sysobjects where id = object_id(N'[KontoACC]') and OBJECTPROPERTY(id, N'IsUserTable') = 1) drop table [KontoACC]
if exists (select * from dbo.sysobjects where id = object_id(N'[LAGER]') and OBJECTPROPERTY(id, N'IsUserTable') = 1) drop table [LAGER]
if exists (select * from dbo.sysobjects where id = object_id(N'[PLB]') and OBJECTPROPERTY(id, N'IsUserTable') = 1) drop table [PLB]
if exists (select * from dbo.sysobjects where id = object_id(N'[ProSinhro]') and OBJECTPROPERTY(id, N'IsUserTable') = 1) drop table [ProSinhro]
if exists (select * from dbo.sysobjects where id = object_id(N'[RegSifACC]') and OBJECTPROPERTY(id, N'IsUserTable') = 1) drop table [RegSifACC]
if exists (select * from dbo.sysobjects where id = object_id(N'[RegSinhro]') and OBJECTPROPERTY(id, N'IsUserTable') = 1) drop table [RegSinhro]
if exists (select * from dbo.sysobjects where id = object_id(N'[TipoviTroskovaACC]') and OBJECTPROPERTY(id, N'IsUserTable') = 1) drop table [TipoviTroskovaACC]
if exists (select * from dbo.sysobjects where id = object_id(N'[UlazIzlazDetaljSinhro]') and OBJECTPROPERTY(id, N'IsUserTable') = 1) drop table [UlazIzlazDetaljSinhro]
if exists (select * from dbo.sysobjects where id = object_id(N'[UlazIzlazSinhro]') and OBJECTPROPERTY(id, N'IsUserTable') = 1) drop table [UlazIzlazSinhro]
if exists (select * from dbo.sysobjects where id = object_id(N'[UlazIzlazSummSinhro]') and OBJECTPROPERTY(id, N'IsUserTable') = 1) drop table [UlazIzlazSummSinhro]
if exists (select * from dbo.sysobjects where id = object_id(N'[UlazTrosakSinhro]') and OBJECTPROPERTY(id, N'IsUserTable') = 1) drop table [UlazTrosakSinhro]
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[KasaSummPoNP_OLD]') and OBJECTPROPERTY(id, N'IsView') = 1) drop view [dbo].[KasaSummPoNP_OLD]
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[OLD_ecRobnoZaGK]') and OBJECTPROPERTY(id, N'IsView') = 1) drop view [dbo].[OLD_ecRobnoZaGK]
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[OLD_UIDSumm]') and OBJECTPROPERTY(id, N'IsView') = 1) drop view [dbo].[OLD_UIDSumm]
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[OLD_UIDSummSimple]') and OBJECTPROPERTY(id, N'IsView') = 1) drop view [dbo].[OLD_UIDSummSimple]
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[OLD_vCarinskoIzlazi]') and OBJECTPROPERTY(id, N'IsView') = 1) drop view [dbo].[OLD_vCarinskoIzlazi]
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[OLD_vCarinskoIzlaziDetalj]') and OBJECTPROPERTY(id, N'IsView') = 1) drop view [dbo].[OLD_vCarinskoIzlaziDetalj]
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[OLD_vCarinskoUlaziIzlazi]') and OBJECTPROPERTY(id, N'IsView') = 1) drop view [dbo].[OLD_vCarinskoUlaziIzlazi]
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[OLD_vCarinskoVratiTabelu]') and OBJECTPROPERTY(id, N'IsView') = 1) drop view [dbo].[OLD_vCarinskoVratiTabelu]
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[OLD_vCarKolicine]') and OBJECTPROPERTY(id, N'IsView') = 1) drop view [dbo].[OLD_vCarKolicine]
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[OLD_vCarStanje]') and OBJECTPROPERTY(id, N'IsView') = 1) drop view [dbo].[OLD_vCarStanje]
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[OLD_vGlavnaKnjiga]') and OBJECTPROPERTY(id, N'IsView') = 1) drop view [dbo].[OLD_vGlavnaKnjiga]
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[OLD_VTrgKartice]') and OBJECTPROPERTY(id, N'IsView') = 1) drop view [dbo].[OLD_VTrgKartice]
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[vTrgPorezNew_OLD]') and OBJECTPROPERTY(id, N'IsView') = 1) drop view [dbo].[vTrgPorezNew_OLD]
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ecIzvLagerAdvancedOLD]') and OBJECTPROPERTY(id, N'IsProcedure') = 1) drop procedure [dbo].[ecIzvLagerAdvancedOLD]
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[OLD_ArhivirajKasu]') and OBJECTPROPERTY(id, N'IsProcedure') = 1) drop procedure [dbo].[OLD_ArhivirajKasu]
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[OLD_ArhivirajKasuROLLBACK]') and OBJECTPROPERTY(id, N'IsProcedure') = 1) drop procedure [dbo].[OLD_ArhivirajKasuROLLBACK]
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[OLD_BrisiKasaRacun]') and OBJECTPROPERTY(id, N'IsProcedure') = 1) drop procedure [dbo].[OLD_BrisiKasaRacun]
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[OLD_CopyReport]') and OBJECTPROPERTY(id, N'IsProcedure') = 1) drop procedure [dbo].[OLD_CopyReport]
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[OLD_ecAzurirajFinDok]') and OBJECTPROPERTY(id, N'IsProcedure') = 1) drop procedure [dbo].[OLD_ecAzurirajFinDok]
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[OLD_ecAzurirajRobnoDok]') and OBJECTPROPERTY(id, N'IsProcedure') = 1) drop procedure [dbo].[OLD_ecAzurirajRobnoDok]
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[OLD_ecBarCodeUI]') and OBJECTPROPERTY(id, N'IsProcedure') = 1) drop procedure [dbo].[OLD_ecBarCodeUI]
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[OLD_ecKarticaProvjeraodvID]') and OBJECTPROPERTY(id, N'IsProcedure') = 1) drop procedure [dbo].[OLD_ecKarticaProvjeraodvID]
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[OLD_ecParUpd]') and OBJECTPROPERTY(id, N'IsProcedure') = 1) drop procedure [dbo].[OLD_ecParUpd]
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[OLD_ecPreAzurirajFinDok]') and OBJECTPROPERTY(id, N'IsProcedure') = 1) drop procedure [dbo].[OLD_ecPreAzurirajFinDok]
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[OLD_ecPreracunajRealne]') and OBJECTPROPERTY(id, N'IsProcedure') = 1) drop procedure [dbo].[OLD_ecPreracunajRealne]
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[OLD_ecSrediPSandPro]') and OBJECTPROPERTY(id, N'IsProcedure') = 1) drop procedure [dbo].[OLD_ecSrediPSandPro]
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[OLD_ecZakljucivanjeKase]') and OBJECTPROPERTY(id, N'IsProcedure') = 1) drop procedure [dbo].[OLD_ecZakljucivanjeKase]
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[OLD_GetCurrentDatabase]') and OBJECTPROPERTY(id, N'IsProcedure') = 1) drop procedure [dbo].[OLD_GetCurrentDatabase]
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[OLD_GetECDatabases]') and OBJECTPROPERTY(id, N'IsProcedure') = 1) drop procedure [dbo].[OLD_GetECDatabases]
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[OLD_GetFDatabases]') and OBJECTPROPERTY(id, N'IsProcedure') = 1) drop procedure [dbo].[OLD_GetFDatabases]
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[OLD_KopirajRealneVPPrenosniceMP]') and OBJECTPROPERTY(id, N'IsProcedure') = 1) drop procedure [dbo].[OLD_KopirajRealneVPPrenosniceMP]
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[OLD_MakeTablesForSinhroMain]') and OBJECTPROPERTY(id, N'IsProcedure') = 1) drop procedure [dbo].[OLD_MakeTablesForSinhroMain]
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[OLD_NextVidKasa]') and OBJECTPROPERTY(id, N'IsProcedure') = 1) drop procedure [dbo].[OLD_NextVidKasa]
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[OLD_NoviKasaRacun]') and OBJECTPROPERTY(id, N'IsProcedure') = 1) drop procedure [dbo].[OLD_NoviKasaRacun]
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[OLD_PripremiBaze]') and OBJECTPROPERTY(id, N'IsProcedure') = 1) drop procedure [dbo].[OLD_PripremiBaze]
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[OLD_PripremiKase]') and OBJECTPROPERTY(id, N'IsProcedure') = 1) drop procedure [dbo].[OLD_PripremiKase]
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[OLD_PripremiKasuZaHostID]') and OBJECTPROPERTY(id, N'IsProcedure') = 1) drop procedure [dbo].[OLD_PripremiKasuZaHostID]
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[OLD_PripremiNoviMagacin]') and OBJECTPROPERTY(id, N'IsProcedure') = 1) drop procedure [dbo].[OLD_PripremiNoviMagacin]
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[OLD_ProknjiziUFinansije]') and OBJECTPROPERTY(id, N'IsProcedure') = 1) drop procedure [dbo].[OLD_ProknjiziUFinansije]
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[OLD_ReturnObjectsByDependencies]') and OBJECTPROPERTY(id, N'IsProcedure') = 1) drop procedure [dbo].[OLD_ReturnObjectsByDependencies]
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[OLD_spSrediDetaljCarina]') and OBJECTPROPERTY(id, N'IsProcedure') = 1) drop procedure [dbo].[OLD_spSrediDetaljCarina]
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[OLD_SrediTotale]') and OBJECTPROPERTY(id, N'IsProcedure') = 1) drop procedure [dbo].[OLD_SrediTotale]
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[OLD_SrediTotaleVID]') and OBJECTPROPERTY(id, N'IsProcedure') = 1) drop procedure [dbo].[OLD_SrediTotaleVID]
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[OLD_ZakljucivanjeKase]') and OBJECTPROPERTY(id, N'IsProcedure') = 1) drop procedure [dbo].[OLD_ZakljucivanjeKase]
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[OLD2_ecZakljucivanjeKase]') and OBJECTPROPERTY(id, N'IsProcedure') = 1) drop procedure [dbo].[OLD2_ecZakljucivanjeKase]
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[VratiTabeluRealnih_OLD]') and OBJECTPROPERTY(id, N'IsProcedure') = 1) drop procedure [dbo].[VratiTabeluRealnih_OLD]
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[VratiTabeluRealnihOLD_NEBRISI]') and OBJECTPROPERTY(id, N'IsProcedure') = 1) drop procedure [dbo].[VratiTabeluRealnihOLD_NEBRISI]
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ecMarkice_OLD]') and xtype in (N'FN', N'IF', N'TF')) drop function [dbo].[ecMarkice_OLD]
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ecNextVID_OLD]') and xtype in (N'FN', N'IF', N'TF')) drop function [dbo].[ecNextVID_OLD]
GO

--Sredi kasu, samo jedna

if exists (select * from dbo.sysobjects where id = object_id(N'[KasaG0]') and OBJECTPROPERTY(id, N'IsUserTable') = 1) drop table [KasaG0]
if exists (select * from dbo.sysobjects where id = object_id(N'[KasaG2]') and OBJECTPROPERTY(id, N'IsUserTable') = 1) drop table [KasaG2]
if exists (select * from dbo.sysobjects where id = object_id(N'[KasaG3]') and OBJECTPROPERTY(id, N'IsUserTable') = 1) drop table [KasaG3]
if exists (select * from dbo.sysobjects where id = object_id(N'[KasaS0]') and OBJECTPROPERTY(id, N'IsUserTable') = 1) drop table [KasaS0]
if exists (select * from dbo.sysobjects where id = object_id(N'[KasaS2]') and OBJECTPROPERTY(id, N'IsUserTable') = 1) drop table [KasaS2]
if exists (select * from dbo.sysobjects where id = object_id(N'[KasaS3]') and OBJECTPROPERTY(id, N'IsUserTable') = 1) drop table [KasaS3]
if exists (select * from dbo.sysobjects where id = object_id(N'[KasaGArhiva]') and OBJECTPROPERTY(id, N'IsUserTable') = 1) drop table [KasaGArhiva]
if exists (select * from dbo.sysobjects where id = object_id(N'[KasaGSinhro]') and OBJECTPROPERTY(id, N'IsUserTable') = 1) drop table [KasaGSinhro]
if exists (select * from dbo.sysobjects where id = object_id(N'[KasaGStruct]') and OBJECTPROPERTY(id, N'IsUserTable') = 1) drop table [KasaGStruct]
if exists (select * from dbo.sysobjects where id = object_id(N'[KasaSArhiva]') and OBJECTPROPERTY(id, N'IsUserTable') = 1) drop table [KasaSArhiva]
if exists (select * from dbo.sysobjects where id = object_id(N'[KasaSSinhro]') and OBJECTPROPERTY(id, N'IsUserTable') = 1) drop table [KasaSSinhro]
if exists (select * from dbo.sysobjects where id = object_id(N'[KasaSStruct]') and OBJECTPROPERTY(id, N'IsUserTable') = 1) drop table [KasaSStruct]
GO

ALTER     view KasaG

AS

SELECT * FROM KasaG1

GO

ALTER     view KasaG

AS

SELECT * FROM KasaG1

GO

ALTER   view KasaS

AS

SELECT * FROM dbo.KasaS1

GO


ALTER    TRIGGER tr_KasaGUpd ON KasaG 
INSTEAD OF UPDATE
AS
BEGIN 
		UPDATE KasaG1 
		SET 
			KasaG1.RAS = i.RAS, 
			KasaG1.Broj = i.Broj, 
			KasaG1.ParID = i.ParID,
			KasaG1.Placanje = i.Placanje, 
			KasaG1.Sto = i.Sto

			,KasaG1.Gotovina = i.Gotovina
			,KasaG1.Kartica = i.Kartica
			,KasaG1.Cek = i.Cek
			,KasaG1.Virman = i.Virman
			,KasaG1.ReklRacBr = i.ReklRacBr
			,KasaG1.ReklamiraoIme = i.ReklamiraoIme
			,KasaG1.ReklamiraoJMBG = i.ReklamiraoJMBG

		FROM inserted i 
		WHERE i.[Klijent] = 'cane' and i.vID = KasaG1.vID

END

GO

ALTER     TRIGGER tr_KasaGIns ON KasaG 
INSTEAD OF INSERT 
AS 
SET NOCOUNT ON 
BEGIN  
			INSERT KasaG1(mID, vID, Klijent, RAS, Datum, Broj, ParID, UserName, Placanje, Sto /**/, Gotovina, Kartica, Cek, Virman, ReklRacBr, ReklamiraoIme, ReklamiraoJMBG /**/)
			SELECT mID, vID, Klijent, RAS, Datum, Broj, ParID, UserName, Placanje, Sto, Gotovina, Kartica, Cek, Virman, ReklRacBr, ReklamiraoIme, ReklamiraoJMBG
			FROM inserted i 
			WHERE i.[Klijent] = 'cane' and i.vID not in (SELECT DISTINCT vID FROM KasaG)

END

GO

ALTER   TRIGGER tr_KasaGDel ON KasaG 
INSTEAD OF DELETE
AS 
SET NOCOUNT ON 
BEGIN  
		DELETE FROM KasaG1 
		WHERE KasaG1.vID in (SELECT vID FROM deleted)		
		DELETE FROM KasaS1 
		WHERE KasaS1.vID in (SELECT vID FROM deleted)

END
GO

--Isprazni tabele
TRUNCATE TABLE dbo.BarCod
TRUNCATE TABLE dbo.BarCodeKasa
TRUNCATE TABLE dbo.BarCodePopis
TRUNCATE TABLE dbo.BarCodeUI
TRUNCATE TABLE dbo.Cjenovnik
TRUNCATE TABLE dbo.DemiFirmeLager
TRUNCATE TABLE dbo.DemiNarudzba
TRUNCATE TABLE dbo.DemiNarudzbaDetalj
TRUNCATE TABLE dbo.ecOpsirnaAnaliza
TRUNCATE TABLE dbo.ecTemp
TRUNCATE TABLE dbo.GK
TRUNCATE TABLE dbo.GKIOS
TRUNCATE TABLE dbo.IOSFin
TRUNCATE TABLE dbo.JCI
TRUNCATE TABLE dbo.KasaG1
TRUNCATE TABLE dbo.KasaS1
TRUNCATE TABLE dbo.LogTabela
TRUNCATE TABLE dbo.NalogG
TRUNCATE TABLE dbo.NalogS
TRUNCATE TABLE dbo.Normativ
TRUNCATE TABLE dbo.ObrIzdaci
TRUNCATE TABLE dbo.ObrPeriod
TRUNCATE TABLE dbo.ObrPlata
TRUNCATE TABLE dbo.OSObracun
TRUNCATE TABLE dbo.OSPromet
TRUNCATE TABLE dbo.OSredstva
TRUNCATE TABLE dbo.Pro
TRUNCATE TABLE dbo.Radnik
TRUNCATE TABLE dbo.RadnikDjeca
TRUNCATE TABLE dbo.Reg
TRUNCATE TABLE dbo.RegAkcija
TRUNCATE TABLE dbo.RegExtra
TRUNCATE TABLE dbo.RegExtraRab
TRUNCATE TABLE dbo.RegSezona
TRUNCATE TABLE dbo.RtfText
TRUNCATE TABLE dbo.Serijski
TRUNCATE TABLE dbo.Setovi
TRUNCATE TABLE dbo.TempDup
TRUNCATE TABLE dbo.TempTrig
TRUNCATE TABLE dbo.UITable
TRUNCATE TABLE dbo.UlazIzlaz
TRUNCATE TABLE dbo.UlazIzlazDetalj
TRUNCATE TABLE dbo.UlazIzlazSumm
TRUNCATE TABLE dbo.UlazTrosak
TRUNCATE TABLE dbo.Uplatnica
TRUNCATE TABLE dbo.Vozilo
TRUNCATE TABLE dbo.VoziloPar
TRUNCATE TABLE dbo.VoziloReg

DELETE FROM [Par] WHERE ParID > 0
DELETE FROM [Users] WHERE UserName NOT IN ('a','kasa')


















































