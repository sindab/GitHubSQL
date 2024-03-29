/*
Script created by SQL Data Compare version 5.0.0.2092 from Red Gate Software Ltd at 25/03/11 12:10:08

Run this script on PROGRAMERI\EC2009.EC201101T

This script will make changes to PROGRAMERI\EC2009.EC201101T to make it the same as PROGRAMERI\EC2009.EC201101

Note that this script will carry out all DELETE commands for all tables first, then all the UPDATES and then all the INSERTS
It will disable foreign key constraints at the beginning of the script, and re-enable them at the end
*/
SET NUMERIC_ROUNDABORT OFF
GO
SET XACT_ABORT, ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS, NOCOUNT ON
GO
-- Pointer used for text / image updates. This might not be needed, but is declared here just in case
DECLARE @pv binary(16)

BEGIN TRANSACTION

-- Drop constraints from [dbo].[EC_ReportBand]
ALTER TABLE [dbo].[EC_ReportBand] DROP CONSTRAINT [FK_ReportBand_Band]
ALTER TABLE [dbo].[EC_ReportBand] DROP CONSTRAINT [FK_ReportBand_Report]

-- Update 2 rows in [dbo].[UIDFields]
UPDATE [dbo].[UIDFields] SET [Caption]=N'Pros. nab.', [CaptionVr]=N'Prosječna nabavna vr.' WHERE [ID]=14
UPDATE [dbo].[UIDFields] SET [Caption]=N'Prosječna nabavna vr.' WHERE [ID]=59

-- Update 4 rows in [dbo].[ReportQuery]
UPDATE [dbo].[ReportQuery] SET [SQLText]=N'SELECT  
		UI.Napomena,
		RS.Vrijednost as MonVr,
		RS.Naziv as MonNaziv,
		UI.UserName,
		UI.DPO,
        UID.vID,
        UID.AutoID,
        UID.RedBr,
        UID.ProID,
        UID.Naziv,
        UID.JM,
        UID.Kol,
		UIDD.Kol as KolBezPredznaka,
		UI.ParDokBroj,
		UID.FC,
		UID.FCSaRab,
        --UID.RabatFak,
        UID.Realna,
        UID.Rabat,
        --UID.Tarifa,
        UID.Porez,
        --UID.StaraKol,
        --UID.StvarnaKol,
        --UID.FC,
        --UID.FCSaRab,
        --UID.NabC,
        UID.VPC as Cena,
        UID.VPCSRab,
        UID.VPCSRabPor,
        UID.MPC,
        UID.MPCSRab,
		UID.MpVr,
		UID.Tarifa,
		--UID.JCI,
        --UID.MPCSRabBPor,
        --UID.StaraC,
        --UID.CProdPrenos,
        --UID.FakVr,
        --UID.FSRabVr,
        --UID.NabVr,
        --UID.FRabVr,
        --UID.Trosak,
        UID.VPVr,
        --UID.RUC,
        --UID.Marza,
        --UID.MPVr,
        UID.VPRabVr,
        UID.VPRabPorVr,
		ROUND((VPRabPorVr - VPRabVr),2) AS PDVVr,
        UID.VPRab,
        UID.VPPor,
		-- Prenos
		UID.CProdPrenos,
		UID.CProdPrenosBPor,
		UID.CProdPrenosSRab,
		UID.MarzaPrenos,
		UID.PrenosVr,
		UID.CProdPrenosBPorVr,
		UID.CProdPrenosSRabVr,
		UID.CProdPrenosSRabBPorVr,


		-- Nivelacija
		UID.StaraC,
		UID.EfektNiv,
		UID.EfektNivSPor,
        --UID.MPRabPorVr,
        --UID.MPSRabBPorVr,
        UID.MPRab,
        --UID.MPPor,
        --UID.PorTrgVr,
        --UID.EfektNiv,
        --UID.Predznak,
        --UI.vID,
        --UI.RAS,
        UI.Broj,
        UI.Datum,
		UI.Broj+''/''+Right(YEAR(UI.Datum),2) as DatumBroj,
        UI.ParID,
        UI.Partner,
        UI.Adresa,
        UI.PostBr,
        UI.Grad,
        UI.Drzava,
        UI.Iznos,
		UI.ParDokBroj,
        --UI.Knjizenje,
        --UI.dtID,
        --UI.Dokument,
        --UI.Predznak,
        --UI.AutoID,
        --UI.Vreme,
        --UI.Pristup,
        --UI.DPO,
        UI.Valuta,
        UI.DatumValute,
        --UI.Klijent,
        --UI.UserName,
        --UI.Paritet,
        UI.ParitetNaziv,
        --UI.Placanje,
        UI.PlacanjeNaziv,
        --UI.Napomena,
        --UI.Otprema, 
        UI.Isporuka,
        UI.OtpremaNaziv,
        UI.Vozilo,
        UI.Vozac,
        --UI.vIDStorno,
        --UI.ParDokBroj,
        --UI.Avans,
        --UI.FaktSaRabatIznos,
        --UI.TrosakOnlyIznos, 
        --UI.CarinaIznos,
        --UI.AkcizaIznos,
        --UIDSumm.vID,
        --UIDSumm.TotFakVr,
        --UIDSumm.TotFSRabVr,
        --UIDSumm.TotNabVr,
        --UIDSumm.TotFRabVr,
        --UIDSumm.TotTrosak,
        UIDSumm.TotVPVr,
        --UIDSumm.TotRUC,
        --UIDSumm.TotMarza,
        --UIDSumm.TotMPVr,
        UIDSumm.TotVPRabVr,
        UIDSumm.TotVPRabPorVr,
        UIDSumm.TotVPRab,
        UIDSumm.TotVPPor
        --UIDSumm.TotMPRabPorVr,
        --UIDSumm.TotMPSRabBPorVr,
        --UIDSumm.TotMPRab,
        --UIDSumm.TotMPPor
        --UIDSumm.TotPorTrgVr,
        --UIDSumm.TotEfektNiv
FROM UID
LEFT JOIN UI On UID.vID=UI.vID
LEFT JOIN UIDSummSimple as UIDSumm On UID.vID = UIDSumm.vID
Left JOIN UlazIzlazDetalj UIDD on UID.AutoID=UIDD.AutoID
LEFT JOIN @fSys.dbo.RegSif RS on RS.ID=UI.Moneta AND RS.dtid=10404
WHERE UID.vID=:vID 
Order By UID.RedBr
' WHERE [QueryName]=N'Izdatnica(Trošak)_A'
UPDATE [dbo].[ReportQuery] SET [SQLText]=N'SELECT 
	ProID, 
	Naziv, 
	JM, 
	Kol, 
	Nabavna, 
	Realna,
	getdate() as Datum
FROM RegSimple 
###' WHERE [QueryName]=N'LagerBezGrupa'
UPDATE [dbo].[ReportQuery] SET [SQLText]=N'SELECT  
		CASE ISNULL(N:Naslov,'''') WHEN '''' THEN Dokument ELSE N:Naslov END as Naslov,
		UI.Napomena,
		RS.Vrijednost as MonVr,
		RS.Naziv as MonNaziv,
		UI.UserName,
		UI.DPO,
        UID.vID,
        UID.AutoID,
        UID.RedBr,
        UID.ProID,
        UID.Naziv,
        UID.JM,
        UID.Kol,
		UIDD.Kol as KolBezPredznaka,
		UI.ParDokBroj,
		UID.FC,
		UID.FCSaRab,
        --UID.RabatFak,
        UID.Realna,
        UID.Rabat,
        --UID.Tarifa,
        UID.Porez,
        --UID.StaraKol,
        --UID.StvarnaKol,
        --UID.FC,
        --UID.FCSaRab,
        --UID.NabC,
        UID.VPC as Cena,
        UID.VPCSRab,
        UID.VPCSRabPor,
        UID.MPC,
        UID.MPCSRab,
		UID.MpVr,
		UID.Tarifa,
		--UID.JCI,
        --UID.MPCSRabBPor,
        --UID.StaraC,
        --UID.CProdPrenos,
        --UID.FakVr,
        --UID.FSRabVr,
        --UID.NabVr,
        --UID.FRabVr,
        --UID.Trosak,
        UID.VPVr,
        --UID.RUC,
        --UID.Marza,
        --UID.MPVr,
        UID.VPRabVr,
        UID.VPRabPorVr,
		ROUND((VPRabPorVr - VPRabVr),2) AS PDVVr,
        UID.VPRab,
        UID.VPPor,
		-- Prenos
		UID.CProdPrenos,
		UID.CProdPrenosBPor,
		UID.CProdPrenosSRab,
		UID.MarzaPrenos,
		UID.PrenosVr,
		UID.CProdPrenosBPorVr,
		UID.CProdPrenosSRabVr,
		UID.CProdPrenosSRabBPorVr,


		-- Nivelacija
		UID.StaraC,
		UID.EfektNiv,
		UID.EfektNivSPor,
        --UID.MPRabPorVr,
        --UID.MPSRabBPorVr,
        UID.MPRab,
        --UID.MPPor,
        --UID.PorTrgVr,
        --UID.EfektNiv,
        --UID.Predznak,
        --UI.vID,
        --UI.RAS,
        UI.Broj,
        UI.Datum,
		UI.Broj+''/''+Right(YEAR(UI.Datum),2) as DatumBroj,
        UI.ParID,
        UI.Partner,
        UI.Adresa,
        UI.PostBr,
        UI.Grad,
        UI.Drzava,
        UI.Iznos,
		UI.ParDokBroj,
        --UI.Knjizenje,
        --UI.dtID,
        --UI.Dokument,
        --UI.Predznak,
        --UI.AutoID,
        --UI.Vreme,
        --UI.Pristup,
        --UI.DPO,
        UI.Valuta,
        UI.DatumValute,
        --UI.Klijent,
        --UI.UserName,
        --UI.Paritet,
        UI.ParitetNaziv,
        --UI.Placanje,
        UI.PlacanjeNaziv,
        --UI.Napomena,
        --UI.Otprema, 
        UI.Isporuka,
        UI.OtpremaNaziv,
        UI.Vozilo,
        UI.Vozac,
        --UI.vIDStorno,
        --UI.ParDokBroj,
        --UI.Avans,
        --UI.FaktSaRabatIznos,
        --UI.TrosakOnlyIznos, 
        --UI.CarinaIznos,
        --UI.AkcizaIznos,
        --UIDSumm.vID,
        --UIDSumm.TotFakVr,
        --UIDSumm.TotFSRabVr,
        --UIDSumm.TotNabVr,
        --UIDSumm.TotFRabVr,
        --UIDSumm.TotTrosak,
        UIDSumm.TotVPVr,
        --UIDSumm.TotRUC,
        --UIDSumm.TotMarza,
        --UIDSumm.TotMPVr,
        UIDSumm.TotVPRabVr,
        UIDSumm.TotVPRabPorVr,
        UIDSumm.TotVPRab,
        UIDSumm.TotVPPor
        --UIDSumm.TotMPRabPorVr,
        --UIDSumm.TotMPSRabBPorVr,
        --UIDSumm.TotMPRab,
        --UIDSumm.TotMPPor
        --UIDSumm.TotPorTrgVr,
        --UIDSumm.TotEfektNiv
FROM UID
LEFT JOIN UI On UID.vID=UI.vID
LEFT JOIN UIDSummSimple as UIDSumm On UID.vID = UIDSumm.vID
Left JOIN UlazIzlazDetalj UIDD on UID.AutoID=UIDD.AutoID
LEFT JOIN @fSys.dbo.RegSif RS on RS.ID=UI.Moneta AND RS.dtid=10404
WHERE UID.vID=:vID 
Order By UID.RedBr
' WHERE [QueryName]=N'Rashod,kalo,lom'
UPDATE [dbo].[ReportQuery] SET [SQLText]=N'SELECT 
    CASE ISNULL(N:Naslov, '''') WHEN '''' THEN UI.Dokument ELSE N:Naslov END as Naslov,
        UID.vID,
        UI.Broj,
        UID.RedBr,
        UID.Naziv,
        UID.JM,
        UID.ProID,
        UID.Tarifa,
        UID.Kol,
        UID.RabatFak,
        UID.FC,
		UI.Broj+''/''+Right(YEAR(UI.Datum),2) as DatumBroj,
        UID.FakVr,
        UID.Trosak,
        UID.RUC,
		UID.FCSaRab, 
		UID.FSRabVr, 
		UID.NabC,
		UID.NabVr,
		UID.TrosakVr,
		UID.Rabat,
		UID.MPCSrabBPor,
		UID.MPC,
		UID.VPC,
		UI.JCI,
		UI.DPO, 
		UID.Realna,
        --UID.MPCSRabbPor,
        --UID.MPSRabBPorVr,
		UID.CProdPrenosBPor,
		UID.VPCSRab,
        UID.MPCSRab,
        UID.MPvr,
        UID.VPvr,
        UID.StaraCSPor,
        UID.StaraKol,
		UID.Marza as Marza,
        UI.Datum,
        UI.DatumValute,
        UI.Partner,
        UI.Adresa,
        UI.PostBr,
        UI.Grad,
		UI.ParDokBroj,
		UID.MPSrabBPorVr,
        UIDSumm.TotFakVr,
        UIDSumm.TotFRabVr,
        UIDSumm.TotFSRabVr,
        UIDSumm.TotTrosakVr,
        UIDSumm.TotNabVr,
        UIDSumm.TotRUC,
        UIDSumm.TotMPVr,
		UIDSumm.TotMPSRabBPorVr,
		UIDSumm.TotMPPor
FROM UID
LEFT JOIN UI ON UID.vID=UI.vID
LEFT JOIN UIDSummSimple as UIDSumm ON UID.vID=UIDSumm.vID
--WHERE UIDSumm.vID=131
WHERE UIDSumm.vID=:vID Order By CAST(UID.RedBr as numeric)
' WHERE [QueryName]=N'Ulazmaterijala'

-- Update 7 rows in [dbo].[EC_Report]
UPDATE [dbo].[EC_Report] SET [DateModified]='20110324 17:42:00.000' WHERE [ReportName]=N'Izdatnica(Trošak)_A'
UPDATE [dbo].[EC_Report] SET [Naziv]=N'Štampa dokumenta', [DateModified]='20110324 17:17:00.000' WHERE [ReportName]=N'Izdatnicamaterijala'
UPDATE [dbo].[EC_Report] SET [dtID]=N'52225;52226', [Naziv]=N'Štampa dokumenta', [DateModified]='20110316 13:21:00.000' WHERE [ReportName]=N'Medjuskladišnicaulazna_A'
UPDATE [dbo].[EC_Report] SET [DateModified]='20110324 17:21:00.000' WHERE [ReportName]=N'MedjusklIzlazMat'
UPDATE [dbo].[EC_Report] SET [DateModified]='20110324 15:54:00.000' WHERE [ReportName]=N'PopisRepro'
UPDATE [dbo].[EC_Report] SET [dtID]=N'52260;52240;52250', [Naziv]=N'Štampa dokumenta', [DateModified]='20110324 17:50:00.000' WHERE [ReportName]=N'Rashod,kalo,lom'
UPDATE [dbo].[EC_Report] SET [dtID]=N'52110', [DateModified]='20110325 09:48:00.000' WHERE [ReportName]=N'Ulazmaterijala'

-- Update 100 rows in [dbo].[EC_BandField]
UPDATE [dbo].[EC_BandField] SET [Width]=3296 WHERE [BandName]=N'Detail19081836' AND [Name]=N'02NazivD'
UPDATE [dbo].[EC_BandField] SET [Left]=4319 WHERE [BandName]=N'Detail19081836' AND [Name]=N'03JMD'
UPDATE [dbo].[EC_BandField] SET [Left]=4711 WHERE [BandName]=N'Detail19081836' AND [Name]=N'04StaraKolD'
UPDATE [dbo].[EC_BandField] SET [Left]=5488 WHERE [BandName]=N'Detail19081836' AND [Name]=N'05StvarnaKolD'
UPDATE [dbo].[EC_BandField] SET [Left]=6265 WHERE [BandName]=N'Detail19081836' AND [Name]=N'05StvarnaKolD1'
UPDATE [dbo].[EC_BandField] SET [Left]=9565, [Text]=N'NabC', [Width]=704 WHERE [BandName]=N'Detail19081836' AND [Name]=N'05StvarnaKolD3'
UPDATE [dbo].[EC_BandField] SET [Left]=10269, [Text]=N'NabC*Kol', [Width]=731 WHERE [BandName]=N'Detail19081836' AND [Name]=N'05StvarnaKolD6'
UPDATE [dbo].[EC_BandField] SET [Text]=N'Ukupna pros.nab. vrijednost:' WHERE [BandName]=N'Footer162865' AND [Name]=N'NovoPolje6'
UPDATE [dbo].[EC_BandField] SET [Text]=N'Ukupna pros.nab. vrijednost:' WHERE [BandName]=N'Footer1628655887' AND [Name]=N'NovoPolje6'
UPDATE [dbo].[EC_BandField] SET [Text]=N'Pros.nab. vrijednost:' WHERE [BandName]=N'Footer2380' AND [Name]=N'NovoPolje20x'
UPDATE [dbo].[EC_BandField] SET [Text]=N'Pros.nab. vrijednost:' WHERE [BandName]=N'Footer56' AND [Name]=N'NovoPolje6x1'
UPDATE [dbo].[EC_BandField] SET [Text]=N'Pros.nab. vrijednost:' WHERE [BandName]=N'Footer565969' AND [Name]=N'NovoPolje6x1'
UPDATE [dbo].[EC_BandField] SET [Text]=N'SUM(NabC*Kol)' WHERE [BandName]=N'Footer962684' AND [Name]=N'NovoPolje8'
UPDATE [dbo].[EC_BandField] SET [Text]=N'Pros.nab. vrijednost:' WHERE [BandName]=N'GFLagerPoSezoniStSve0' AND [Name]=N'NovoPolje6x'
UPDATE [dbo].[EC_BandField] SET [Text]=N'Pros.nab. vrijednost:' WHERE [BandName]=N'GFMagacinNaziv' AND [Name]=N'NovoPolje20x1'
UPDATE [dbo].[EC_BandField] SET [Text]=N'Pros.nab.' WHERE [BandName]=N'Header7551465' AND [Name]=N'02VPCH1'
UPDATE [dbo].[EC_BandField] SET [Width]=6488 WHERE [BandName]=N'Izdatnica(Trošak)_ADetail439' AND [Name]=N'Detail02_Copy_Copy'
UPDATE [dbo].[EC_BandField] SET [Left]=7340 WHERE [BandName]=N'Izdatnica(Trošak)_ADetail439' AND [Name]=N'Detail03_Copy_Copy'
UPDATE [dbo].[EC_BandField] SET [Left]=7683 WHERE [BandName]=N'Izdatnica(Trošak)_ADetail439' AND [Name]=N'Detail04_Copy_Copy'
UPDATE [dbo].[EC_BandField] SET [Left]=8042, [Text]=N'FC', [Width]=697 WHERE [BandName]=N'Izdatnica(Trošak)_ADetail439' AND [Name]=N'Detail05_Copy_Copy'
UPDATE [dbo].[EC_BandField] SET [Format]=N'#,##0.00', [Left]=9330, [Text]=N'Cena', [Width]=441 WHERE [BandName]=N'Izdatnica(Trošak)_ADetail439' AND [Name]=N'Detail08_Copy_Copy'
UPDATE [dbo].[EC_BandField] SET [Left]=9771, [Text]=N'Realna*Kol', [Width]=779 WHERE [BandName]=N'Izdatnica(Trošak)_ADetail439' AND [Name]=N'Detail09_Copy_Copy'
UPDATE [dbo].[EC_BandField] SET [Left]=8739, [Text]=N'Realna', [Width]=591 WHERE [BandName]=N'Izdatnica(Trošak)_ADetail439' AND [Name]=N'NovoPolje4_Copy_Copy'
UPDATE [dbo].[EC_BandField] SET [Width]=6488 WHERE [BandName]=N'Izdatnica(Trošak)_APageHeader1165' AND [Name]=N'Header02_Copy_Copy'
UPDATE [dbo].[EC_BandField] SET [Left]=7340 WHERE [BandName]=N'Izdatnica(Trošak)_APageHeader1165' AND [Name]=N'Header03_Copy_Copy'
UPDATE [dbo].[EC_BandField] SET [Left]=7683 WHERE [BandName]=N'Izdatnica(Trošak)_APageHeader1165' AND [Name]=N'Header04_Copy_Copy'
UPDATE [dbo].[EC_BandField] SET [Left]=8042, [Text]=N'Fakturna', [Width]=697 WHERE [BandName]=N'Izdatnica(Trošak)_APageHeader1165' AND [Name]=N'Header05_Copy_Copy'
UPDATE [dbo].[EC_BandField] SET [Left]=9330, [Text]=N'VPC', [Width]=441 WHERE [BandName]=N'Izdatnica(Trošak)_APageHeader1165' AND [Name]=N'Header08_Copy_Copy'
UPDATE [dbo].[EC_BandField] SET [Left]=9771, [Text]=N'Pros. nab. vr.', [Width]=779 WHERE [BandName]=N'Izdatnica(Trošak)_APageHeader1165' AND [Name]=N'Header09_Copy_Copy'
UPDATE [dbo].[EC_BandField] SET [Left]=8739, [Text]=N'Pros. nab.', [Width]=591 WHERE [BandName]=N'Izdatnica(Trošak)_APageHeader1165' AND [Name]=N'NovoPolje2_Copy_Copy'
UPDATE [dbo].[EC_BandField] SET [Text]=N'Pros.nab.' WHERE [BandName]=N'KarticeIzlazaHeader0' AND [Name]=N'02VPCH1'
UPDATE [dbo].[EC_BandField] SET [Text]=N'Pros.nab./
prosječna' WHERE [BandName]=N'KarticePageHeader34022947541435' AND [Name]=N'03RazduzenjeBezPorezaH10'
UPDATE [dbo].[EC_BandField] SET [Width]=530 WHERE [BandName]=N'Medjuskladišnicaulazna_ADetail' AND [Name]=N'Detail01_Copy'
UPDATE [dbo].[EC_BandField] SET [Left]=1005, [Width]=4996 WHERE [BandName]=N'Medjuskladišnicaulazna_ADetail' AND [Name]=N'Detail02_Copy'
UPDATE [dbo].[EC_BandField] SET [Left]=6001, [Width]=392 WHERE [BandName]=N'Medjuskladišnicaulazna_ADetail' AND [Name]=N'Detail03_Copy'
UPDATE [dbo].[EC_BandField] SET [Left]=6393, [Width]=804 WHERE [BandName]=N'Medjuskladišnicaulazna_ADetail' AND [Name]=N'Detail04_Copy'
UPDATE [dbo].[EC_BandField] SET [Width]=530 WHERE [BandName]=N'Medjuskladišnicaulazna_APageHeader' AND [Name]=N'Header01_Copy'
UPDATE [dbo].[EC_BandField] SET [Left]=1005, [Width]=4996 WHERE [BandName]=N'Medjuskladišnicaulazna_APageHeader' AND [Name]=N'Header02_Copy'
UPDATE [dbo].[EC_BandField] SET [Left]=6001, [Width]=392 WHERE [BandName]=N'Medjuskladišnicaulazna_APageHeader' AND [Name]=N'Header03_Copy'
UPDATE [dbo].[EC_BandField] SET [Left]=6393, [Width]=804 WHERE [BandName]=N'Medjuskladišnicaulazna_APageHeader' AND [Name]=N'Header04_Copy'
UPDATE [dbo].[EC_BandField] SET [Text]=N'Naslov + " br.: "+DatumBroj' WHERE [BandName]=N'Medjuskladišnicaulazna_ARepHeader' AND [Name]=N'FakturaRacunOtpremnica_Copy'
UPDATE [dbo].[EC_BandField] SET [Text]=N'Pros.nab. vrijednost' WHERE [BandName]=N'PageHeader1836410801' AND [Name]=N'KolLbl4'
UPDATE [dbo].[EC_BandField] SET [Text]=N'Pros.nab. cijena' WHERE [BandName]=N'PageHeader1836410801' AND [Name]=N'ProIDLbl7'
UPDATE [dbo].[EC_BandField] SET [Text]=N'Pros.nab.
vrijednost' WHERE [BandName]=N'PageHeader21282' AND [Name]=N'UkVrBezPorezaLbl1'
UPDATE [dbo].[EC_BandField] SET [Text]=N'Pros.nab.
vrijednost' WHERE [BandName]=N'PageHeader21282218' AND [Name]=N'UkVrBezPorezaLbl1'
UPDATE [dbo].[EC_BandField] SET [Text]=N'Pros.nab.
vrijednost' WHERE [BandName]=N'PageHeader212822181130' AND [Name]=N'UkVrBezPorezaLbl1'
UPDATE [dbo].[EC_BandField] SET [Text]=N'Pros.nab. vr
vrijednost' WHERE [BandName]=N'PageHeader21282218113027060' AND [Name]=N'UkVrBezPorezaLbl1'
UPDATE [dbo].[EC_BandField] SET [Text]=N'Pros.nab.' WHERE [BandName]=N'PageHeader21282218113027060' AND [Name]=N'UkVrBezPorezaLbl5'
UPDATE [dbo].[EC_BandField] SET [Text]=N'Pros.nab.' WHERE [BandName]=N'PageHeader2128221811302706031439' AND [Name]=N'PlacanjeNazivLbl1'
UPDATE [dbo].[EC_BandField] SET [Text]=N'Pros.nab. vr
vrijednost' WHERE [BandName]=N'PageHeader2128221811302706031439' AND [Name]=N'UkVrBezPorezaLbl1'
UPDATE [dbo].[EC_BandField] SET [Text]=N'Pros.nab.
vrijednost' WHERE [BandName]=N'PageHeader2128221811304755' AND [Name]=N'UkVrBezPorezaLbl1'
UPDATE [dbo].[EC_BandField] SET [Text]=N'Pros.nab.
vrijednost' WHERE [BandName]=N'PageHeader2128221811304755758' AND [Name]=N'UkVrBezPorezaLbl1'
UPDATE [dbo].[EC_BandField] SET [Text]=N'Pros.nab.
vrijednost' WHERE [BandName]=N'PageHeader212822181314' AND [Name]=N'UkVrBezPorezaLbl1'
UPDATE [dbo].[EC_BandField] SET [Text]=N'Pros.nab.
vrijednost' WHERE [BandName]=N'PageHeader25985' AND [Name]=N'NabavnaLbl2'
UPDATE [dbo].[EC_BandField] SET [Text]=N'Pros.nab.' WHERE [BandName]=N'PageHeader25985' AND [Name]=N'RealnaLbl'
UPDATE [dbo].[EC_BandField] SET [Text]=N'Pros.nab.
vrijednost' WHERE [BandName]=N'PageHeader259857166' AND [Name]=N'NabavnaLbl2'
UPDATE [dbo].[EC_BandField] SET [Text]=N'Pros.nab.' WHERE [BandName]=N'PageHeader259857166' AND [Name]=N'RealnaLbl'
UPDATE [dbo].[EC_BandField] SET [Text]=N'Pros.nab.' WHERE [BandName]=N'PageHeader427' AND [Name]=N'NovoPolje12'
UPDATE [dbo].[EC_BandField] SET [Text]=N'Pros.nab.
vrijednost' WHERE [BandName]=N'PageHeader427' AND [Name]=N'NovoPolje17'
UPDATE [dbo].[EC_BandField] SET [Left]=4319 WHERE [BandName]=N'PageHeader471389' AND [Name]=N'JMLbl'
UPDATE [dbo].[EC_BandField] SET [Width]=3296 WHERE [BandName]=N'PageHeader471389' AND [Name]=N'NazivLbl'
UPDATE [dbo].[EC_BandField] SET [Left]=4711 WHERE [BandName]=N'PageHeader471389' AND [Name]=N'StaraKolLbl'
UPDATE [dbo].[EC_BandField] SET [Left]=5488 WHERE [BandName]=N'PageHeader471389' AND [Name]=N'StvarnaKolLbl'
UPDATE [dbo].[EC_BandField] SET [Left]=6265 WHERE [BandName]=N'PageHeader471389' AND [Name]=N'StvarnaKolLbl1'
UPDATE [dbo].[EC_BandField] SET [Left]=9565, [Text]=N'Nabavna', [Width]=704 WHERE [BandName]=N'PageHeader471389' AND [Name]=N'StvarnaKolLbl3'
UPDATE [dbo].[EC_BandField] SET [Left]=10269, [Width]=731 WHERE [BandName]=N'PageHeader471389' AND [Name]=N'StvarnaKolLbl6'
UPDATE [dbo].[EC_BandField] SET [Width]=441 WHERE [BandName]=N'Rashod,kalo,lomDetail439' AND [Name]=N'Detail01_Copy'
UPDATE [dbo].[EC_BandField] SET [Left]=852, [Width]=3913 WHERE [BandName]=N'Rashod,kalo,lomDetail439' AND [Name]=N'Detail02_Copy'
UPDATE [dbo].[EC_BandField] SET [Left]=4765, [Width]=343 WHERE [BandName]=N'Rashod,kalo,lomDetail439' AND [Name]=N'Detail03_Copy'
UPDATE [dbo].[EC_BandField] SET [Left]=5108, [Width]=359 WHERE [BandName]=N'Rashod,kalo,lomDetail439' AND [Name]=N'Detail04_Copy'
UPDATE [dbo].[EC_BandField] SET [Left]=8692 WHERE [BandName]=N'Rashod,kalo,lomDetail439' AND [Name]=N'Detail05_Copy'
UPDATE [dbo].[EC_BandField] SET [Text]=N'Realna*Kol' WHERE [BandName]=N'Rashod,kalo,lomDetail439' AND [Name]=N'Detail09_Copy'
UPDATE [dbo].[EC_BandField] SET [Text]=N'Realna' WHERE [BandName]=N'Rashod,kalo,lomDetail439' AND [Name]=N'NovoPolje5_Copy'
UPDATE [dbo].[EC_BandField] SET [Width]=441 WHERE [BandName]=N'Rashod,kalo,lomPageHeader1165' AND [Name]=N'Header01_Copy'
UPDATE [dbo].[EC_BandField] SET [Left]=852, [Width]=3913 WHERE [BandName]=N'Rashod,kalo,lomPageHeader1165' AND [Name]=N'Header02_Copy'
UPDATE [dbo].[EC_BandField] SET [Left]=4765, [Width]=343 WHERE [BandName]=N'Rashod,kalo,lomPageHeader1165' AND [Name]=N'Header03_Copy'
UPDATE [dbo].[EC_BandField] SET [Left]=5108, [Width]=359 WHERE [BandName]=N'Rashod,kalo,lomPageHeader1165' AND [Name]=N'Header04_Copy'
UPDATE [dbo].[EC_BandField] SET [Left]=8692 WHERE [BandName]=N'Rashod,kalo,lomPageHeader1165' AND [Name]=N'Header05_Copy'
UPDATE [dbo].[EC_BandField] SET [Text]=N'Pros. nab. vr.' WHERE [BandName]=N'Rashod,kalo,lomPageHeader1165' AND [Name]=N'Header09_Copy'
UPDATE [dbo].[EC_BandField] SET [Text]=N'Pros. nab.' WHERE [BandName]=N'Rashod,kalo,lomPageHeader1165' AND [Name]=N'NovoPolje3_Copy'
UPDATE [dbo].[EC_BandField] SET [Visible]=0 WHERE [BandName]=N'Rashod,kalo,lomRepFooter484' AND [Name]=N'subRekapitulacija_Copy'
UPDATE [dbo].[EC_BandField] SET [Text]=N'Naslov + " BR: "+DatumBroj' WHERE [BandName]=N'Rashod,kalo,lomRepHeader1260' AND [Name]=N'FakturaRacunOtpremnica_Copy'
UPDATE [dbo].[EC_BandField] SET [Visible]=0 WHERE [BandName]=N'UlazmaterijalaGF1' AND [Name]=N'lblSub2_Copy'
UPDATE [dbo].[EC_BandField] SET [Text]=N'Kol*Realna' WHERE [BandName]=N'VPFakturaDetail2025' AND [Name]=N'Detail09'
UPDATE [dbo].[EC_BandField] SET [Text]=N'Realna' WHERE [BandName]=N'VPFakturaDetail2025' AND [Name]=N'NovoPolje4'
UPDATE [dbo].[EC_BandField] SET [Text]=N'SUM(Kol*Realna)' WHERE [BandName]=N'VPFakturaRepFooter3922' AND [Name]=N'lblTotal1'
UPDATE [dbo].[EC_BandField] SET [Text]=N'Naslov & " br.: " & DatumBroj & " od " & Datum' WHERE [BandName]=N'VPFakturaRepHeader3811' AND [Name]=N'FakturaRacunOtpremnica'
UPDATE [dbo].[EC_BandField] SET [Width]=3610 WHERE [BandName]=N'VPMedjIzlDetail316' AND [Name]=N'Detail02'
UPDATE [dbo].[EC_BandField] SET [Left]=5890 WHERE [BandName]=N'VPMedjIzlDetail316' AND [Name]=N'Detail03'
UPDATE [dbo].[EC_BandField] SET [Left]=6432 WHERE [BandName]=N'VPMedjIzlDetail316' AND [Name]=N'Detail04'
UPDATE [dbo].[EC_BandField] SET [Left]=8395, [Width]=550 WHERE [BandName]=N'VPMedjIzlDetail316' AND [Name]=N'Detail05'
UPDATE [dbo].[EC_BandField] SET [Left]=7461, [Width]=409 WHERE [BandName]=N'VPMedjIzlDetail316' AND [Name]=N'Detail06'
UPDATE [dbo].[EC_BandField] SET [Text]=N'VPC' WHERE [BandName]=N'VPMedjIzlDetail316' AND [Name]=N'Detail1'
UPDATE [dbo].[EC_BandField] SET [Width]=3160 WHERE [BandName]=N'VPMedjIzlPageHeader1155' AND [Name]=N'Header02'
UPDATE [dbo].[EC_BandField] SET [Left]=5890 WHERE [BandName]=N'VPMedjIzlPageHeader1155' AND [Name]=N'Header03'
UPDATE [dbo].[EC_BandField] SET [Left]=6432 WHERE [BandName]=N'VPMedjIzlPageHeader1155' AND [Name]=N'Header04'
UPDATE [dbo].[EC_BandField] SET [Left]=8470, [Width]=475 WHERE [BandName]=N'VPMedjIzlPageHeader1155' AND [Name]=N'Header05'
UPDATE [dbo].[EC_BandField] SET [Left]=7461 WHERE [BandName]=N'VPMedjIzlPageHeader1155' AND [Name]=N'Header06'
UPDATE [dbo].[EC_BandField] SET [Text]=N'VP
cijena' WHERE [BandName]=N'VPMedjIzlPageHeader1155' AND [Name]=N'Header1'
UPDATE [dbo].[EC_BandField] SET [Text]=N'Pros.nab. vrijednost:' WHERE [BandName]=N'VPPrenosUMPFooter105116750' AND [Name]=N'Detail8'

-- Update 1 row in [dbo].[EC_Band]
UPDATE [dbo].[EC_Band] SET [Height]=225 WHERE [Name]=N'VPMedjIzlDetail316'

-- Update 11 rows in [dbo].[DokTip]
UPDATE [dbo].[DokTip] SET [FieldSeq]=N'FC;NabC;VPC;StaraKol;StvarnaKol', [LockFieldSeq]=N'NabC;StaraKol', [DetFieldSeq]=N'FC;NabC;VPC;StaraKol;StvarnaKol', [DetTotalSeq]=N'FakVr;NabVr;VPVr', [DetFinSeq]=N'FakVr;NabVr;VPVr;VPPor' WHERE [dtID]=N'52000'
UPDATE [dbo].[DokTip] SET [ecBit]=229, [Seq]=3, [DetTotalSeq]=N'FakVr;FRabVr;FSRabVr;TrosakVr;NabVr;VPVr', [DetFinSeq]=N'FakVr;FRabVr;FSRabVr;TrosakVr;NabVr;RealnaVr;RUCVr;VPVr;TrosakVr;UlazniPDVVr;UlazniPDVNeOdbiVr;UlazniTrosakNezavisniVr;UlazniTrosakZavisniVr;UlazniTrosakSpedVr;UlazniTrosakCarinaVr;UlazniTrosakAkcizaVr' WHERE [dtID]=N'52110'
UPDATE [dbo].[DokTip] SET [ecBit]=9223372036854710233 WHERE [dtID]=N'52150'
UPDATE [dbo].[DokTip] SET [ecBit]=65764, [FieldSeq]=N'Realna;VPC;Rabat;VPCSRab;Porez;VPCSRabPor', [LockFieldSeq]=N'Realna', [DetFieldSeq]=N'Realna;VPC;Rabat;VPCSRab;Porez;VPCSRabPor', [DetFinSeq]=N'RealnaVr;VPVr;VPRab;VPRabVr;VPPor;VPRabPorVr' WHERE [dtID]=N'52210'
UPDATE [dbo].[DokTip] SET [ecBit]=2724, [FieldSeq]=N'FC;Realna;VPC', [LockFieldSeq]=N'Realna;VPC', [DetFieldSeq]=N'FC;NabC;Realna;VPC', [DetTotalSeq]=N'FakVr;NabVr;RealnaVr;VPVr', [DetFinSeq]=N'FakVr;NabVr;RealnaVr;VPVr' WHERE [dtID]=N'52220'
UPDATE [dbo].[DokTip] SET [ecBit]=4780, [FieldSeq]=N'FC;RabatFak;FCSaRab;Realna;VPC;MarzaPrenos;CProdPrenos', [LockFieldSeq]=N'Realna;VPC', [DetFieldSeq]=N'Realna;VPC;MarzaPrenos;CProdPrenos', [DetTotalSeq]=N'RealnaVr;VPVr;VPRucPrenosVr;CProdPrenosBPorVr;PrenosPDVVr;PrenosVr', [DetFinSeq]=N'FakVr;FSRabVr;TrosakVr;NabVr;RealnaVr;RUCVr;VPVr;VPRab;VPRabVr;VPRucPrenosVr;MPRucPrenosVr;CProdPrenosBPorVr;PrenosRabat;CProdPrenosSRabVr;CProdPrenosSRabBPorVr;PrenosPDVVr;PrenosVr' WHERE [dtID]=N'52221'
UPDATE [dbo].[DokTip] SET [ecBit]=526373, [FieldSeq]=N'FC;RabatFak;FCSaRab;NabC;VPC', [LockFieldSeq]=N'NabC;VPC', [DetFieldSeq]=N'FC;RabatFak;FCSaRab;NabC;VPC', [DetTotalSeq]=N'FakVr;FRabVr;FSRabVr;NabVr;VPVr', [DetFinSeq]=N'FakVr;FSRabVr;NabVr;RealnaVr;RUCVr;VPVr', [Prefix]=N'', [Sufix]=N'', [DefaultNapomena]=N'0' WHERE [dtID]=N'52225'
UPDATE [dbo].[DokTip] SET [ecBit]=4132, [DetFinSeq]=N'FakVr;FSRabVr;TrosakVr;NabVr;RealnaVr;RUCVr;VPVr;VPRab;VPRabVr' WHERE [dtID]=N'52226'
UPDATE [dbo].[DokTip] SET [ecBit]=4194468, [FieldSeq]=N'Realna;VPC', [LockFieldSeq]=N'Realna;VPC', [DetFieldSeq]=N'Realna;VPC', [DetTotalSeq]=N'RealnaVr;VPVr', [DetFinSeq]=N'FakVr;NabVr;RealnaVr;VPVr' WHERE [dtID]=N'52260'
UPDATE [dbo].[DokTip] SET [ecBit]=4194340, [FieldSeq]=N'FC;Realna;VPC', [LockFieldSeq]=N'Realna;VPC', [DetFieldSeq]=N'FC;Realna;VPC', [DetTotalSeq]=N'FakVr;RealnaVr;VPVr', [DetFinSeq]=N'FakVr;RealnaVr;VPVr' WHERE [dtID]=N'52270'
UPDATE [dbo].[DokTip] SET [ecBit]=65700, [FieldSeq]=N'FC;RabatFak;FCSaRab;Realna;VPC', [LockFieldSeq]=N'Realna', [DetFieldSeq]=N'FC;RabatFak;FCSaRab;Realna;VPC', [DetTotalSeq]=N'FakVr;FRabVr;FSRabVr;RealnaVr;VPVr', [DetFinSeq]=N'FakVr;FSRabVr;NabVr;RealnaVr;VPVr' WHERE [dtID]=N'52280'

-- Add 5 rows to [dbo].[DokTip]
INSERT INTO [dbo].[DokTip] ([dtID], [Naziv], [Opis], [Predznak], [ecBit], [ecFields], [ecFieldsEdit], [dgID], [Seq], [RightID], [FieldSeq], [LockFieldSeq], [DetFieldSeq], [DetTotalSeq], [GKTip], [DefaultNacinPlacanja], [DetFinSeq], [Grupa], [DrugiNaziv], [DrugiBroj], [Prefix], [Sufix], [DefaultNapomena]) VALUES (N'52001', N'Početno stanje', N'Pocetno stanje', 1, 16777645, 131196, 9223372036854775804, 6, 2, 6, N'FC;NabC;VPC', N'NabC', N'FC;NabC;VPC', N'FakVr;NabVr;VPVr', 0, N'13', N'FakVr;NabVr;RealnaVr;VPVr', 0, NULL, NULL, NULL, NULL, NULL)
INSERT INTO [dbo].[DokTip] ([dtID], [Naziv], [Opis], [Predznak], [ecBit], [ecFields], [ecFieldsEdit], [dgID], [Seq], [RightID], [FieldSeq], [LockFieldSeq], [DetFieldSeq], [DetTotalSeq], [GKTip], [DefaultNacinPlacanja], [DetFinSeq], [Grupa], [DrugiNaziv], [DrugiBroj], [Prefix], [Sufix], [DefaultNapomena]) VALUES (N'52111', N'Primka uvozna', N'Nabavka materijala iz uvoza', 1, 237, 68719865919, 9223372036854775804, 1, 4, 12, N'FC;RabatFak;FCSaRab;NabC;VPC', N'NabC', N'FC;RabatFak;FCSaRab;NabC;Koef;Trosak;Carina;Akciza;VPC', N'FakVr;FRabVr;FSRabVr;TrosakVr;NabVr;VPVr', 257, N'13', N'FakVr;FRabVr;FSRabVr;TrosakVr;NabVr;RealnaVr;RUCVr;VPVr;TrosakVr;UlazniPDVVr;UlazniPDVNeOdbiVr;UlazniTrosakNezavisniVr;UlazniTrosakZavisniVr;UlazniTrosakSpedVr;UlazniTrosakCarinaVr;UlazniTrosakAkcizaVr', 0, NULL, NULL, NULL, NULL, NULL)
INSERT INTO [dbo].[DokTip] ([dtID], [Naziv], [Opis], [Predznak], [ecBit], [ecFields], [ecFieldsEdit], [dgID], [Seq], [RightID], [FieldSeq], [LockFieldSeq], [DetFieldSeq], [DetTotalSeq], [GKTip], [DefaultNacinPlacanja], [DetFinSeq], [Grupa], [DrugiNaziv], [DrugiBroj], [Prefix], [Sufix], [DefaultNapomena]) VALUES (N'52140', N'Višak', N'Evidentiranje viska robe u veleprodaji', 1, 16777644, 131196, 9223372036854775804, 6, 5, 6, N'FC;NabC;VPC', N'NabC', N'FC;NabC;VPC', N'FakVr;NabVr;VPVr', 0, N'13', N'FakVr;NabVr;RealnaVr;VPVr', 0, NULL, NULL, NULL, NULL, NULL)
INSERT INTO [dbo].[DokTip] ([dtID], [Naziv], [Opis], [Predznak], [ecBit], [ecFields], [ecFieldsEdit], [dgID], [Seq], [RightID], [FieldSeq], [LockFieldSeq], [DetFieldSeq], [DetTotalSeq], [GKTip], [DefaultNacinPlacanja], [DetFinSeq], [Grupa], [DrugiNaziv], [DrugiBroj], [Prefix], [Sufix], [DefaultNapomena]) VALUES (N'52240', N'Manjak', N'Evidentiranje manjka robe u veleprodaji', -1, 4194340, 548012156, 9223372036854775804, 7, 50, 6, N'Realna;VPC', N'Realna;VPC', N'Realna;VPC', N'RealnaVr;VPVr', 0, N'13', N'FakVr;NabVr;RealnaVr;VPVr', 0, NULL, NULL, NULL, NULL, NULL)
INSERT INTO [dbo].[DokTip] ([dtID], [Naziv], [Opis], [Predznak], [ecBit], [ecFields], [ecFieldsEdit], [dgID], [Seq], [RightID], [FieldSeq], [LockFieldSeq], [DetFieldSeq], [DetTotalSeq], [GKTip], [DefaultNacinPlacanja], [DetFinSeq], [Grupa], [DrugiNaziv], [DrugiBroj], [Prefix], [Sufix], [DefaultNapomena]) VALUES (N'52250', N'Otpis', N'Otpis', -1, 4194340, 548012156, 9223372036854775804, 7, 55, 6, N'Realna;VPC', N'Realna;VPC', N'Realna;VPC', N'RealnaVr;VPVr', 0, N'13', N'FakVr;NabVr;RealnaVr;VPVr', 0, NULL, NULL, NULL, NULL, NULL)

-- Add 17 rows to [dbo].[EC_Band]
INSERT INTO [dbo].[EC_Band] ([Name], [Type], [BackColor], [CanGrow], [CanShrink], [Height], [OnPrint], [GroupBy], [Sort], [KeepTogether], [OnFormat]) VALUES (N'Detail1908183614631', 0, -1, 1, 0, 210, N'', N'', 0, 1, N'')
INSERT INTO [dbo].[EC_Band] ([Name], [Type], [BackColor], [CanGrow], [CanShrink], [Height], [OnPrint], [GroupBy], [Sort], [KeepTogether], [OnFormat]) VALUES (N'Footer96268429387', 2, -1, 1, 0, 840, N'', N'', 0, 1, N'')
INSERT INTO [dbo].[EC_Band] ([Name], [Type], [BackColor], [CanGrow], [CanShrink], [Height], [OnPrint], [GroupBy], [Sort], [KeepTogether], [OnFormat]) VALUES (N'Header26875246317', 1, 16777215, 1, 0, 825, N'', N'', 0, 1, N'if dtid <> 40000 then
lblRazlikaPDV.Visible = False
lblDRazlikaPDV.Visible = False
lblRazlikaSaPDV.Visible = False
lblDRazlikaSaPDV.Visible = False
endif')
INSERT INTO [dbo].[EC_Band] ([Name], [Type], [BackColor], [CanGrow], [CanShrink], [Height], [OnPrint], [GroupBy], [Sort], [KeepTogether], [OnFormat]) VALUES (N'PageFooter2606193911165', 4, -1, 1, 0, 210, N'', N'', 0, 1, N'')
INSERT INTO [dbo].[EC_Band] ([Name], [Type], [BackColor], [CanGrow], [CanShrink], [Height], [OnPrint], [GroupBy], [Sort], [KeepTogether], [OnFormat]) VALUES (N'PageHeader47138928208', 3, -1, 1, 0, 435, N'', N'', 0, 1, N'')
INSERT INTO [dbo].[EC_Band] ([Name], [Type], [BackColor], [CanGrow], [CanShrink], [Height], [OnPrint], [GroupBy], [Sort], [KeepTogether], [OnFormat]) VALUES (N'UlazmaterijalaDetail902', 0, -1, 1, 0, 220, N'', N'', 0, 1, N'')
INSERT INTO [dbo].[EC_Band] ([Name], [Type], [BackColor], [CanGrow], [CanShrink], [Height], [OnPrint], [GroupBy], [Sort], [KeepTogether], [OnFormat]) VALUES (N'UlazmaterijalaFooter9031', 2, -1, 0, 0, 20, N'', N'', 0, 1, N'')
INSERT INTO [dbo].[EC_Band] ([Name], [Type], [BackColor], [CanGrow], [CanShrink], [Height], [OnPrint], [GroupBy], [Sort], [KeepTogether], [OnFormat]) VALUES (N'UlazmaterijalaGF113603', 6, -1, 0, 0, 1545, N'', N'', 0, 1, N'')
INSERT INTO [dbo].[EC_Band] ([Name], [Type], [BackColor], [CanGrow], [CanShrink], [Height], [OnPrint], [GroupBy], [Sort], [KeepTogether], [OnFormat]) VALUES (N'UlazmaterijalaGH115743', 5, -1, 1, 0, 3350, N'', N'vID', 1, 1, N'')
INSERT INTO [dbo].[EC_Band] ([Name], [Type], [BackColor], [CanGrow], [CanShrink], [Height], [OnPrint], [GroupBy], [Sort], [KeepTogether], [OnFormat]) VALUES (N'UlazmaterijalaHeader28675', 1, -1, 0, 0, 360, N'', N'', 0, 1, N'')
INSERT INTO [dbo].[EC_Band] ([Name], [Type], [BackColor], [CanGrow], [CanShrink], [Height], [OnPrint], [GroupBy], [Sort], [KeepTogether], [OnFormat]) VALUES (N'UlazmaterijalaPageFooter15252', 4, -1, 1, 0, 255, N'', N'', 0, 1, N'')
INSERT INTO [dbo].[EC_Band] ([Name], [Type], [BackColor], [CanGrow], [CanShrink], [Height], [OnPrint], [GroupBy], [Sort], [KeepTogether], [OnFormat]) VALUES (N'UlazmaterijalaPageHeader27857', 3, -1, 1, 0, 0, N'', N'', 0, 1, N'')
INSERT INTO [dbo].[EC_Band] ([Name], [Type], [BackColor], [CanGrow], [CanShrink], [Height], [OnPrint], [GroupBy], [Sort], [KeepTogether], [OnFormat]) VALUES (N'VisakDetail9904', 0, -1, 1, 0, 220, N'', N'', 0, 1, N'')
INSERT INTO [dbo].[EC_Band] ([Name], [Type], [BackColor], [CanGrow], [CanShrink], [Height], [OnPrint], [GroupBy], [Sort], [KeepTogether], [OnFormat]) VALUES (N'VisakFooter19013', 2, -1, 1, 0, 2385, N'', N'', 0, 1, N'')
INSERT INTO [dbo].[EC_Band] ([Name], [Type], [BackColor], [CanGrow], [CanShrink], [Height], [OnPrint], [GroupBy], [Sort], [KeepTogether], [OnFormat]) VALUES (N'VisakPageFooter15578', 4, -1, 1, 0, 240, N'', N'', 0, 1, N'')
INSERT INTO [dbo].[EC_Band] ([Name], [Type], [BackColor], [CanGrow], [CanShrink], [Height], [OnPrint], [GroupBy], [Sort], [KeepTogether], [OnFormat]) VALUES (N'VisakPageHeader13508', 3, -1, 1, 0, 420, N'', N'', 0, 1, N'')
INSERT INTO [dbo].[EC_Band] ([Name], [Type], [BackColor], [CanGrow], [CanShrink], [Height], [OnPrint], [GroupBy], [Sort], [KeepTogether], [OnFormat]) VALUES (N'VisakRepHeader3679', 1, -1, 1, 0, 820, N'', N'', 0, 1, N'')

-- Add 101 rows to [dbo].[EC_BandField]
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'Detail1908183614631', N'00RedBrD', 10, 6, 0, 16777215, 0, 6, -16777216, 1, 0, 0, 0, N'Arial', 0, 8, 0, -16777216, N'', 185, 0, 0, 0, 0, 0, N'', 11, 1, 0, N'', N'RedBr', 0, 1, N'', 493, 1, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'Detail1908183614631', N'01ProIDD', 10, 8, 0, 16777215, 0, 6, -16777216, 1, 0, 0, 0, N'Arial', 0, 8, 0, -16777216, N'', 185, 0, 0, 493, 0, 0, N'', 11, 1, 0, N'', N'ProID', 0, 1, N'', 530, 1, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'Detail1908183614631', N'02NazivD', 10, 6, 0, 16777215, 0, 6, -16777216, 1, 1, 0, 0, N'Arial', 0, 8, 0, -16777216, N'', 180, 0, 0, 1023, 0, 0, N'', 11, 1, 0, N'', N'Naziv', 0, 1, N'', 5673, 1, N'', N'', N'', 1, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'Detail1908183614631', N'03JMD', 10, 6, 0, 16777215, 0, 6, -16777216, 1, 0, 0, 0, N'Arial', 0, 8, 0, -16777216, N'', 185, 0, 0, 6696, 0, 0, N'', 11, 1, 0, N'', N'JM', 0, 1, N'', 392, 1, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'Detail1908183614631', N'04StaraKolD', 10, 8, 0, 16777215, 0, 6, -16777216, 1, 0, 0, 0, N'Arial', 0, 8, 0, -16777216, N'fKolicina', 185, 0, 0, 7088, 0, 0, N'', 11, 1, 0, N'', N'Kol', 0, 1, N'', 777, 1, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'Detail1908183614631', N'05StvarnaKolD', 10, 8, 0, 16777215, 0, 6, -16777216, 1, 0, 0, 0, N'Arial', 0, 8, 0, -16777216, N'fKolicina', 185, 0, 0, 7865, 0, 0, N'', 11, 1, 0, N'', N'FC', 0, 1, N'', 777, 1, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'Detail1908183614631', N'05StvarnaKolD1', 10, 8, 0, -1, 0, 8, -16777216, 1, 0, 0, 0, N'Arial', 0, 8, 0, -16777216, N'fKolicina', 180, 0, 0, 8642, 0, 0, N'', 11, 1, 0, N'', N'NabC', 0, 1, N'', 777, 1, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'Detail1908183614631', N'05StvarnaKolD3', 10, 8, 0, -1, 0, 6, -16777216, 1, 0, 0, 0, N'Arial', 0, 8, 0, -16777216, N'fCijena', 180, 0, 0, 9419, 0, 0, N'', 11, 1, 0, N'', N'VPCSRab', 0, 1, N'', 850, 1, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'Detail1908183614631', N'05StvarnaKolD6', 10, 8, 0, -1, 0, 8, -16777216, 1, 0, 0, 0, N'Arial', 0, 8, 0, -16777216, N'fCijena', 180, 0, 0, 10269, 0, 0, N'', 11, 1, 0, N'', N'NabC*Kol', 0, 1, N'', 731, 1, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'Detail1908183614631', N'NovoPolje4', 0, 16, 0, 16777215, 0, 1, -16777216, 0, 0, 0, 0, N'Arial', 0, 10, 0, -16777216, N'', 0, 0, 0, 0, 1, 0, N'', 0, 0, 0, N'', N'NovoPolje4', 195, 1, N'', 10975, 1, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'Footer96268429387', N'NovoPolje2', 0, 8, 0, 16777215, 0, 1, -16777216, 0, 0, 0, 0, N'Arial', 0, 8, 0, -16777216, N'', 210, 0, 0, 7290, 0, 0, N'', 0, 0, 0, N'', N'Nabavna vrijednost:', 255, 1, N'', 2040, 1, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'Footer96268429387', N'NovoPolje5', 0, 8, 0, 16777215, 0, 1, -16777216, 1, 0, 0, 0, N'Arial', 0, 8, 0, -16777216, N'fIznos', 210, 0, 0, 9345, 0, 0, N'', 0, 0, 0, N'', N'SUM(NabC*Kol)', 255, 1, N'', 1590, 1, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'Footer96268429387', N'NovoPolje6', 0, 8, 0, 16777215, 0, 1, -16777216, 0, 0, 0, 0, N'Arial', 0, 8, 0, -16777216, N'', 210, 0, 0, 7290, 0, 0, N'', 0, 0, 0, N'', N'Fakturna vrijednost:', 30, 1, N'', 2040, 1, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'Footer96268429387', N'NovoPolje7', 0, 8, 0, 16777215, 0, 1, -16777216, 0, 0, 0, 0, N'Arial', 0, 8, 0, -16777216, N'', 210, 0, 0, 7290, 0, 0, N'', 0, 0, 0, N'', N'VP vrijednost:', 480, 1, N'', 2040, 1, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'Footer96268429387', N'NovoPolje8', 0, 8, 0, 16777215, 0, 1, -16777216, 1, 0, 0, 0, N'Arial', 0, 8, 0, -16777216, N'fIznos', 210, 0, 0, 9345, 0, 0, N'', 0, 0, 0, N'', N'SUM(VPCSRab*Kol)', 480, 1, N'', 1590, 1, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'Footer96268429387', N'NovoPolje9', 0, 8, 0, 16777215, 0, 1, -16777216, 1, 0, 0, 0, N'Arial', 0, 8, 0, -16777216, N'fIznos', 210, 0, 0, 9345, 0, 0, N'', 0, 0, 0, N'', N'SUM(FC*Kol)', 30, 1, N'', 1590, 1, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'Header26875246317', N'NovoPolje3', 0, 16, 0, 16777215, 0, 0, -16777216, 1, 0, 0, 0, N'Arial', 0, 10, 0, -16777216, N'', 255, 0, 0, 0, 0, 0, N'', 0, 0, 0, N'LinijaHeaderPortrait', N'', 0, 1, N'', 10875, 1, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'Header26875246317', N'titleLbl', 0, 7, 0, 16777215, 0, 0, -16777216, 1, 0, 0, 0, N'Arial', 1, 14, 0, -16777216, N'', 345, 0, 0, 0, 0, 0, N'', 0, 0, 0, N'', N'"POČETNO STANJE BR:" & DatumBroj', 405, 1, N'', 10905, 1, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'PageFooter2606193911165', N'ftrRight1', 0, 2, 0, 16777215, 0, 0, -16777216, 1, 0, 0, 0, N'Arial', 0, 7, 0, -16777216, N'', 165, 0, 0, 45, 0, 0, N'', 0, 0, 0, N'', N'"Strana " & [Page] & " od " & [Pages]', 15, 1, N'', 10845, 1, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'PageFooter2606193911165', N'lblLinijaF1', 0, 16, 0, 16777215, 0, 0, -16777216, 1, 0, 0, 0, N'Arial', 0, 10, 0, -16777216, N'', 210, 0, 0, 0, 0, 0, N'', 0, 0, 0, N'Linija0FooterPortrait', N'', 0, 1, N'', 10905, 1, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'PageHeader47138928208', N'JMLbl', 11, 3, 0, 16777215, 0, 1, -16777216, 0, 0, 0, 0, N'Arial', 1, 8, 0, -16777216, N'', 425, 0, 0, 6696, 0, 0, N'', 0, 0, 0, N'', N'JM', 0, 1, N'', 392, 0, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'PageHeader47138928208', N'NazivLbl', 11, 3, 0, 16777215, 0, 1, -16777216, 0, 0, 0, 0, N'Arial', 1, 8, 0, -16777216, N'', 420, 0, 0, 1023, 0, 0, N'', 0, 0, 0, N'', N'Naziv artikla', 0, 1, N'', 5673, 0, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'PageHeader47138928208', N'NovoPolje1', 0, 16, 0, 16777215, 0, 1, -16777216, 0, 0, 0, 0, N'Arial', 0, 10, 0, -16777216, N'', 0, 0, 0, 0, 1, 0, N'', 0, 0, 0, N'', N'NovoPolje4', 435, 1, N'', 10900, 1, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'PageHeader47138928208', N'ProIDLbl', 11, 3, 0, 16777215, 0, 1, -16777216, 0, 0, 0, 0, N'Arial', 1, 8, 0, -16777216, N'', 425, 0, 0, 493, 0, 0, N'', 0, 0, 0, N'', N'Šifra', 0, 1, N'', 530, 0, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'PageHeader47138928208', N'RedBrLbl', 11, 5, 0, 16777215, 0, 1, -16777216, 0, 0, 0, 0, N'Arial', 1, 8, 0, -16777216, N'', 425, 0, 0, 0, 0, 0, N'', 0, 0, 0, N'', N'R.B.', 0, 1, N'', 493, 0, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'PageHeader47138928208', N'StaraKolLbl', 11, 5, 0, 16777215, 0, 1, -16777216, 0, 0, 0, 0, N'Arial', 1, 8, 0, -16777216, N'', 425, 0, 0, 7088, 0, 0, N'', 0, 0, 0, N'', N'Količina', 0, 1, N'', 777, 0, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'PageHeader47138928208', N'StvarnaKolLbl', 11, 5, 0, 16777215, 0, 1, -16777216, 0, 0, 0, 0, N'Arial', 1, 8, 0, -16777216, N'', 425, 0, 0, 7865, 0, 0, N'', 0, 0, 0, N'', N'Fakturna', 0, 1, N'', 777, 0, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'PageHeader47138928208', N'StvarnaKolLbl1', 11, 5, 0, -1, 0, 1, -16777216, 0, 0, 0, 0, N'Arial', 1, 8, 0, -16777216, N'', 420, 0, 0, 8642, 0, 0, N'', 0, 0, 0, N'', N'Nabavna', 0, 1, N'', 777, 0, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'PageHeader47138928208', N'StvarnaKolLbl3', 11, 5, 0, -1, 0, 1, -16777216, 0, 0, 0, 0, N'Arial', 1, 8, 0, -16777216, N'', 420, 0, 0, 9419, 0, 0, N'', 0, 0, 0, N'', N'VPC', 0, 1, N'', 850, 0, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'PageHeader47138928208', N'StvarnaKolLbl6', 11, 5, 0, -1, 0, 1, -16777216, 0, 0, 0, 0, N'Arial', 1, 8, 0, -16777216, N'', 420, 0, 0, 10269, 0, 0, N'', 0, 0, 0, N'', N'Nab. vr.', 0, 1, N'', 731, 0, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'UlazmaterijalaDetail902', N'00RedBrD1_Copy', 10, 8, 0, 16777215, 0, 6, 16777215, 1, 0, 0, 0, N'Arial', 0, 8, 0, -16777216, N'', 195, 0, 0, 0, 0, 8, N'', 11, 1, 0, N'', N'RedBr', 0, 1, N'', 411, 0, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'UlazmaterijalaDetail902', N'01ProIDD1_Copy', 10, 8, 0, 16777215, 0, 6, 16777215, 1, 0, 0, 0, N'Arial', 0, 8, 0, -16777216, N'', 195, 0, 0, 411, 0, 8, N'', 11, 1, 0, N'', N'ProID', 0, 1, N'', 441, 0, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'UlazmaterijalaDetail902', N'02NazivD1_Copy', 10, 6, 0, 16777215, 0, 6, 16777215, 1, 1, 0, 0, N'Arial', 0, 8, 0, -16777216, N'', 195, 0, 0, 852, 0, 8, N'', 11, 1, 0, N'', N'Naziv', 0, 1, N'', 5009, 1, N'', N'', N'', 1, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'UlazmaterijalaDetail902', N'03JMD1_Copy', 10, 6, 0, 16777215, 0, 6, 16777215, 1, 0, 0, 0, N'Arial', 0, 8, 0, -16777216, N'', 195, 0, 0, 5861, 0, 8, N'', 11, 1, 0, N'', N'JM', 0, 1, N'', 343, 0, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'UlazmaterijalaDetail902', N'05KolD1_Copy', 10, 8, 0, 16777215, 0, 6, 16777215, 1, 0, 0, 0, N'Arial', 0, 8, 0, -16777216, N'#,##0.00', 195, 0, 0, 6204, 0, 8, N'', 11, 1, 0, N'', N'Kol', 0, 1, N'', 359, 0, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'UlazmaterijalaDetail902', N'06RabatFakD1_Copy', 10, 8, 0, 16777215, 0, 8, 16777215, 1, 0, 0, 0, N'Arial', 0, 8, 0, -16777216, N'#,##0.00', 195, 0, 0, 9858, 0, 8, N'', 11, 1, 0, N'', N'NabVr', 0, 1, N'', 742, 0, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'UlazmaterijalaDetail902', N'07FCD1_Copy', 10, 8, 0, 16777215, 0, 6, 16777215, 1, 0, 0, 0, N'Arial', 0, 8, 0, -16777216, N'fNabavna', 195, 0, 0, 9154, 0, 8, N'', 11, 1, 0, N'', N'NabC', 0, 1, N'', 704, 0, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'UlazmaterijalaDetail902', N'08FakVrD1_Copy', 10, 8, 0, 16777215, 0, 6, 16777215, 1, 0, 0, 0, N'Arial', 0, 8, 0, -16777216, N'fCijena', 195, 0, 0, 7260, 0, 8, N'', 11, 1, 0, N'', N'FSRabVr', 0, 1, N'', 742, 0, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'UlazmaterijalaDetail902', N'09TrosakD1_Copy', 10, 8, 0, 16777215, 0, 6, 16777215, 1, 0, 0, 0, N'Arial', 0, 8, 0, -16777216, N'#,##0.00', 195, 0, 0, 8002, 0, 8, N'', 11, 1, 0, N'', N'Trosak', 0, 1, N'', 576, 0, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'UlazmaterijalaDetail902', N'09TrosakD1_Copy1', 10, 8, 0, -1, 0, 6, -1, 1, 0, 0, 0, N'Arial', 0, 8, 0, -16777216, N'#,##0.00', 195, 0, 0, 8578, 0, 8, N'', 11, 1, 0, N'', N'TrosakVr', 0, 1, N'', 576, 0, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'UlazmaterijalaDetail902', N'Linija_Copy', 6, 0, 0, -1, 0, 1, -16777216, 0, 0, 0, 0, N'Arial', 0, 8, 0, -16777216, N'', 0, 0, 0, 0, 1, 10, N'', 0, 0, 0, N'', N'', 205, 1, N'', 10620, 0, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'UlazmaterijalaDetail902', N'Novo polje1_Copy', 10, 8, 0, 16777215, 0, 6, 16777215, 1, 0, 0, 0, N'Arial', 0, 8, 0, -16777216, N'fNabavna', 195, 0, 0, 6563, 0, 8, N'', 11, 1, 0, N'', N'FCSaRab', 0, 1, N'', 697, 1, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'UlazmaterijalaGF113603', N'18MPKalkKontrol2_Copy', 0, 7, 0, -1, 0, 0, -1, 0, 0, 0, 0, N'Arial', 0, 8, 0, -16777216, N'', 210, 0, 0, 4470, 0, 0, N'', 0, 0, 0, N'', N'M.P.', 870, 1, N'', 1500, 0, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'UlazmaterijalaGF113603', N'19MPKalkKontrol2_Copy', 6, 0, 0, -1, 0, 1, -16777216, 0, 0, 0, 0, N'Arial', 0, 8, 0, -16777216, N'', 0, 0, 0, 4470, 1, 0, N'', 0, 0, 0, N'', N'', 1365, 1, N'', 1500, 0, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'UlazmaterijalaGF113603', N'20MPKalkRobuPri2_Copy', 0, 7, 0, -1, 0, 0, -1, 0, 0, 0, 0, N'Arial', 0, 8, 0, -16777216, N'', 210, 0, 0, 9000, 0, 0, N'', 0, 0, 0, N'', N'Kontrolisao:', 885, 1, N'', 1500, 0, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'UlazmaterijalaGF113603', N'20MPKalkRobuPri2_Copy1', 0, 7, 0, -1, 0, 0, -1, 0, 0, 0, 0, N'Arial', 0, 8, 0, -16777216, N'', 210, 0, 0, 45, 0, 0, N'', 0, 0, 0, N'', N'Robu primio:', 915, 1, N'', 1500, 0, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'UlazmaterijalaGF113603', N'21MPKalkRobuPri2_Copy', 6, 0, 0, -1, 0, 1, -16777216, 0, 0, 0, 0, N'Arial', 0, 8, 0, -16777216, N'', 0, 0, 0, 9000, 1, 0, N'', 0, 0, 0, N'', N'', 1380, 1, N'', 1500, 0, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'UlazmaterijalaGF113603', N'21MPKalkRobuPri2_Copy1', 6, 0, 0, -1, 0, 1, -16777216, 0, 0, 0, 0, N'Arial', 0, 8, 0, -16777216, N'', 0, 0, 0, 45, 1, 0, N'', 0, 0, 0, N'', N'', 1410, 1, N'', 1500, 0, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'UlazmaterijalaGF113603', N'lblSub2_Copy', 0, 16, 0, 16777215, 0, 0, -16777216, 0, 1, 0, 0, N'Arial', 0, 10, 0, -16777216, N'', 450, 0, 0, 2565, 0, 0, N'', 0, 0, 0, N'UlazniPDVSaFakturnom', N'', 165, 0, N'', 2415, 1, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'UlazmaterijalaGF113603', N'lblTotal_Copy', 0, 16, 0, 16777215, 0, 0, -16777216, 0, 1, 0, 0, N'Arial', 0, 10, 0, -16777216, N'', 270, 0, 0, 5325, 0, 0, N'', 0, 0, 0, N'LabelTotal', N'', 165, 1, N'', 4335, 1, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'UlazmaterijalaGF113603', N'NovoPolje223_Copy', 0, 16, 0, 16777215, 0, 0, -16777216, 0, 0, 0, 0, N'Microsoft Sans Serif', 0, 10, 0, -16777216, N'', 90, 0, 0, 165, 0, 0, N'', 0, 0, 0, N'', N'', 705, 1, N'', 10230, 1, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'UlazmaterijalaGF113603', N'subTroskovi_Copy', 0, 16, 0, 16777215, 0, 0, -16777216, 1, 1, 0, 0, N'Arial', 0, 10, 0, -16777216, N'', 450, 0, 0, 75, 0, 0, N'', 0, 0, 0, N'RekapTroskovi', N'', 165, 1, N'', 2280, 1, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'UlazmaterijalaGH115743', N'00RedBrDZ1_Copy', 11, 7, 0, 16777215, 0, 1, -16777216, 0, 0, 0, 0, N'Arial Narrow', 0, 8, 0, -16777216, N'', 800, 0, 0, 0, 0, 15, N'', 11, 1, 0, N'', N'R.b.', 2535, 1, N'', 411, 0, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'UlazmaterijalaGH115743', N'01ProIDDz1_Copy', 11, 7, 0, 16777215, 0, 1, -16777216, 0, 0, 0, 0, N'Arial Narrow', 0, 8, 0, -16777216, N'', 800, 0, 0, 411, 0, 15, N'', 11, 1, 0, N'', N'Šifra', 2535, 1, N'', 441, 0, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'UlazmaterijalaGH115743', N'02NazivDz1_Copy', 11, 7, 0, 16777215, 0, 1, -16777216, 0, 0, 0, 0, N'Arial Narrow', 0, 8, 0, -16777216, N'', 795, 0, 0, 852, 0, 15, N'', 11, 1, 0, N'', N'Naziv artikla', 2535, 1, N'', 5009, 0, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'UlazmaterijalaGH115743', N'03JMDz1_Copy', 11, 7, 0, 16777215, 0, 1, -16777216, 0, 0, 0, 0, N'Arial Narrow', 0, 8, 0, -16777216, N'', 795, 0, 0, 5861, 0, 15, N'', 11, 1, 0, N'', N'JM  ', 2535, 1, N'', 343, 0, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'UlazmaterijalaGH115743', N'05KolDz1_Copy', 11, 7, 0, 16777215, 0, 1, -16777216, 0, 0, 0, 0, N'Arial Narrow', 0, 8, 0, -16777216, N'', 800, 0, 0, 6204, 0, 15, N'', 11, 1, 0, N'', N'Kol', 2535, 1, N'', 359, 0, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'UlazmaterijalaGH115743', N'06RabatFakDz1_Copy', 11, 7, 0, 16777215, 0, 1, -16777216, 0, 0, 0, 0, N'Arial Narrow', 0, 8, 0, -16777216, N'', 795, 0, 0, 9858, 0, 15, N'', 11, 1, 0, N'', N'Nabavna
vrijednost', 2535, 1, N'', 742, 0, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'UlazmaterijalaGH115743', N'07FCDz1_Copy', 11, 7, 0, 16777215, 0, 1, -16777216, 0, 0, 0, 0, N'Arial Narrow', 0, 8, 0, -16777216, N'', 800, 0, 0, 9154, 0, 15, N'', 11, 1, 0, N'', N'Nabavna
cijena', 2535, 1, N'', 704, 0, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'UlazmaterijalaGH115743', N'08FakVrDz1_Copy', 11, 7, 0, 16777215, 0, 1, -16777216, 0, 0, 0, 0, N'Arial Narrow', 0, 8, 0, -16777216, N'', 800, 0, 0, 7260, 0, 15, N'', 11, 1, 0, N'', N'Fakturna
vrijednost', 2535, 1, N'', 742, 0, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'UlazmaterijalaGH115743', N'09TrosakDz1_Copy', 11, 7, 0, 16777215, 0, 1, -16777216, 0, 0, 0, 0, N'Arial Narrow', 0, 8, 0, -16777216, N'', 800, 0, 0, 8002, 0, 15, N'', 11, 1, 0, N'', N'Trošak
po JM', 2535, 1, N'', 576, 0, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'UlazmaterijalaGH115743', N'09TrosakDz1_Copy1', 11, 7, 0, -1, 0, 1, -16777216, 0, 0, 0, 0, N'Arial Narrow', 0, 8, 0, -16777216, N'', 795, 0, 0, 8578, 0, 15, N'', 11, 1, 0, N'', N'Trošak', 2535, 1, N'', 576, 0, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'UlazmaterijalaGH115743', N'lblBrojRacD1_Copy', 0, 6, 0, -1, 0, 0, -16777216, 1, 1, 0, 0, N'Arial', 0, 10, 0, -16777216, N'', 210, 0, 0, 2205, 0, 0, N'', 0, 0, 0, N'', N'ParDokBroj & " od " & DPO', 1755, 1, N'', 2730, 1, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'UlazmaterijalaGH115743', N'lblBrRac1_Copy', 0, 6, 0, -1, 0, 0, -16777216, 0, 0, 0, 0, N'Arial', 0, 10, 0, -16777216, N'', 210, 0, 0, 75, 0, 0, N'', 0, 0, 0, N'', N'Br računa dobavljača:', 1755, 1, N'', 2130, 1, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'UlazmaterijalaGH115743', N'lblGrad1_Copy', 0, 16, 0, -1, 0, 0, -16777216, 1, 1, 0, 0, N'Arial', 0, 10, 0, -16777216, N'', 270, 0, 0, 8070, 0, 0, N'', 0, 0, 0, N'vIDGrad', N'', 195, 1, N'', 2190, 1, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'UlazmaterijalaGH115743', N'MPKalkFakturaBroj_Copy', 0, 7, 0, -1, 0, 0, -1, 1, 0, 0, 0, N'Arial', 1, 14, 0, -16777216, N'', 465, 0, 0, 30, 0, 0, N'', 0, 0, 0, N'', N'"Primka materijala uvoz br.: " + DatumBroj', 2025, 1, N'', 10440, 0, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'UlazmaterijalaGH115743', N'Novo polje2z1_Copy', 11, 7, 0, 16777215, 0, 1, -16777216, 0, 0, 0, 0, N'Arial Narrow', 0, 8, 0, -16777216, N'', 800, 0, 0, 6563, 0, 15, N'', 11, 1, 0, N'', N'Fakturna
cijena', 2535, 1, N'', 697, 1, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'UlazmaterijalaGH115743', N'NovoPolje3_Copy', 0, 16, 0, 16777215, 0, 0, -16777216, 1, 1, 0, 0, N'Microsoft Sans Serif', 0, 8, 0, -16777216, N'', 1755, 0, 0, 75, 0, 0, N'', 0, 0, 0, N'VPPartneri', N'', 0, 1, N'', 4935, 1, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'UlazmaterijalaGH115743', N'ZaglavljeFaktureVP1_Copy', 0, 16, 0, -1, 0, 0, -16777216, 1, 1, 0, 0, N'Arial', 0, 10, 0, -16777216, N'', 1200, 0, 0, 7080, 0, 0, N'', 0, 0, 0, N'ZaglavljeKalkVP', N'', 405, 1, N'', 3420, 1, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'UlazmaterijalaHeader28675', N'NovoPolje2_Copy', 0, 16, 0, 16777215, 0, 1, -16777216, 1, 0, 0, 0, N'Microsoft Sans Serif', 0, 8, 0, -16777216, N'', 345, 0, 0, 0, 0, 0, N'', 0, 0, 0, N'LinijaHeader', N'', 0, 1, N'', 10515, 1, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'UlazmaterijalaPageFooter15252', N'NovoPolje1_Copy', 0, 16, 0, 16777215, 0, 1, -16777216, 1, 0, 0, 0, N'Arial', 0, 6, 0, -16777216, N'', 210, 0, 0, 0, 0, 0, N'', 0, 0, 0, N'Linija0Footer', N'', 30, 1, N'', 10560, 1, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'UlazmaterijalaPageFooter15252', N'NovoPolje133_Copy', 0, 8, 0, 16777215, 0, 0, -16777216, 1, 0, 0, 0, N'Arial', 0, 6, 0, -16777216, N'', 210, 0, 0, 5850, 0, 0, N'', 0, 0, 0, N'', N'" Strana " + Page +" od " + Pages', 30, 1, N'', 4710, 1, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'VisakDetail9904', N'Detail00', 10, 8, 0, -1, 0, 8, -1, 1, 0, 0, 0, N'Arial', 0, 8, 0, -16777216, N'', 195, 0, 0, 0, 0, 15, N'', 11, 1, 0, N'', N'RedBr', 0, 1, N'', 475, 0, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'VisakDetail9904', N'Detail01', 10, 8, 0, -1, 0, 7, -1, 1, 0, 0, 0, N'Arial', 0, 8, 0, -16777216, N'', 195, 0, 0, 475, 0, 15, N'', 11, 1, 0, N'', N'ProID', 0, 1, N'', 530, 0, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'VisakDetail9904', N'Detail02', 10, 6, 0, -1, 0, 7, -1, 1, 1, 1, 0, N'Arial', 0, 8, 0, -16777216, N'', 195, 0, 0, 1005, 0, 15, N'', 11, 1, 0, N'', N'Naziv', 0, 1, N'', 4349, 1, N'', N'', N'', 1, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'VisakDetail9904', N'Detail03', 10, 6, 0, -1, 0, 7, -1, 1, 0, 0, 0, N'Arial', 0, 8, 0, -16777216, N'', 195, 0, 0, 5354, 0, 15, N'', 11, 1, 0, N'', N'JM', 0, 1, N'', 392, 0, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'VisakDetail9904', N'Detail04', 10, 8, 0, -1, 0, 7, -1, 1, 0, 0, 0, N'Arial', 0, 8, 0, -16777216, N'#,##0.00', 195, 0, 0, 5746, 0, 15, N'', 11, 1, 0, N'', N'Kol', 0, 1, N'', 804, 0, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'VisakDetail9904', N'Detail05', 10, 8, 0, -1, 0, 7, -1, 1, 1, 0, 0, N'Arial', 0, 8, 0, -16777216, N'fCijena', 195, 0, 0, 6550, 0, 15, N'', 11, 1, 0, N'', N'FC', 0, 1, N'', 727, 1, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'VisakDetail9904', N'Detail06', 10, 8, 0, -1, 0, 7, -1, 1, 0, 0, 0, N'Arial', 0, 8, 0, -16777216, N'#,##0.00', 195, 0, 0, 7277, 0, 15, N'', 11, 1, 0, N'', N'NabC', 0, 1, N'', 621, 0, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'VisakDetail9904', N'Detail07', 10, 8, 0, -1, 0, 7, -1, 1, 1, 0, 0, N'Arial', 0, 8, 0, -16777216, N'fCijena', 195, 0, 0, 7898, 0, 15, N'', 11, 1, 0, N'', N'Cena', 0, 1, N'', 727, 0, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'VisakDetail9904', N'Detail09', 10, 8, 0, -1, 0, 7, -1, 1, 0, 0, 0, N'Arial', 0, 8, 0, -16777216, N'#,##0.00', 195, 0, 0, 9237, 0, 15, N'', 11, 1, 0, N'', N'NabC*Kol', 0, 1, N'', 813, 0, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'VisakDetail9904', N'lineh', 0, 16, 1, 16777215, 0, 1, -16777216, 0, 0, 0, 0, N'Microsoft Sans Serif', 0, 8, 0, -16777216, N'', 15, 0, 0, 0, 1, 15, N'', 0, 0, 0, N'', N'NovoPolje1', 205, 1, N'', 10065, 1, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'VisakFooter19013', N'fldRobuPreuzeoFakturisao', 0, 16, 1, 16777215, 0, 0, -16777216, 1, 0, 0, 0, N'Arial', 0, 10, 0, -16777216, N'', 660, 0, 0, 285, 0, 0, N'', 0, 0, 0, N'RobuPreuzeoFakturisao', N'', 1425, 1, N'', 9555, 1, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'VisakFooter19013', N'OtpremapoleVPFakPolje1', 0, 16, 0, -1, 0, 0, -16777216, 1, 1, 0, 0, N'Arial', 0, 10, 0, -16777216, N'', 225, 0, 0, 105, 0, 0, N'', 0, 0, 0, N'Napomena', N'', 1200, 1, N'', 9780, 1, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'VisakFooter19013', N'subRekapitulacija', 0, 16, 0, 16777215, 0, 0, -16777216, 1, 1, 0, 0, N'Microsoft Sans Serif', 0, 8, 0, -16777216, N'', 1000, 0, 0, 105, 0, 0, N'', 0, 0, 0, N'Rekapitulacija', N'', 50, 0, N'', 4230, 1, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'VisakFooter19013', N'subTotal1', 0, 16, 0, -1, 0, 0, -16777216, 1, 1, 0, 0, N'Microsoft Sans Serif', 0, 8, 0, -16777216, N'', 1000, 0, 0, 4605, 0, 0, N'', 0, 0, 0, N'LabelTotal', N'', 50, 1, N'', 4320, 1, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'VisakPageFooter15578', N'NovoPolje1', 0, 8, 0, 16777215, 0, 0, 16777215, 1, 0, 0, 0, N'Arial', 0, 6, 0, -16777216, N'', 180, 0, 0, 4680, 0, 0, N'', 0, 0, 0, N'', N'" Strana " + Page +" od " + Pages', 0, 1, N'', 5295, 1, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'VisakPageFooter15578', N'VPFakturaFooter', 8, 16, 0, 16777215, 0, 1, -16777216, 1, 1, 0, 0, N'Arial', 0, 10, 0, -16777216, N'', 165, 0, 0, 15, 0, 0, N'', 0, 0, 0, N'Linija0FooterPortrait', N'', 15, 1, N'', 9990, 1, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'VisakPageHeader13508', N'Header00', 11, 7, 0, -1, 0, 1, -16777216, 0, 0, 0, 0, N'Arial', 1, 8, 0, -16777216, N'', 405, 0, 0, 0, 0, 0, N'', 0, 0, 0, N'', N'R.b.', 0, 1, N'', 475, 0, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'VisakPageHeader13508', N'Header01', 11, 7, 0, -1, 0, 1, -16777216, 0, 0, 0, 0, N'Arial', 1, 8, 0, -16777216, N'', 405, 0, 0, 475, 0, 0, N'', 0, 0, 0, N'', N'Šifra', 0, 1, N'', 530, 0, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'VisakPageHeader13508', N'Header02', 11, 7, 0, -1, 0, 1, -16777216, 0, 0, 0, 0, N'Arial', 1, 8, 0, -16777216, N'', 405, 0, 0, 1005, 0, 0, N'', 0, 0, 0, N'', N'NAZIV ARTIKLA', 0, 1, N'', 4349, 0, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'VisakPageHeader13508', N'Header03', 11, 7, 0, -1, 0, 1, -16777216, 0, 0, 0, 0, N'Arial', 1, 8, 0, -16777216, N'', 405, 0, 0, 5354, 0, 0, N'', 0, 0, 0, N'', N'JM  ', 0, 1, N'', 392, 0, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'VisakPageHeader13508', N'Header04', 11, 7, 0, -1, 0, 1, -16777216, 0, 0, 0, 0, N'Arial', 1, 8, 0, -16777216, N'', 405, 0, 0, 5746, 0, 0, N'', 0, 0, 0, N'', N'Količina', 0, 1, N'', 804, 0, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'VisakPageHeader13508', N'Header05', 11, 7, 0, -1, 0, 1, -16777216, 0, 0, 0, 0, N'Arial', 1, 8, 0, -16777216, N'', 405, 0, 0, 6550, 0, 0, N'', 0, 0, 0, N'', N'Fakturna', 0, 1, N'', 727, 0, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'VisakPageHeader13508', N'Header06', 11, 7, 0, -1, 0, 1, -16777216, 0, 0, 0, 0, N'Arial', 1, 8, 0, -16777216, N'', 405, 0, 0, 7277, 0, 0, N'', 0, 0, 0, N'', N'Nabavna', 0, 1, N'', 621, 0, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'VisakPageHeader13508', N'Header07', 11, 7, 0, -1, 0, 1, -16777216, 0, 0, 0, 0, N'Arial', 1, 8, 0, -16777216, N'', 405, 0, 0, 7898, 0, 0, N'', 0, 0, 0, N'', N'VPC', 0, 1, N'', 727, 0, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'VisakPageHeader13508', N'Header09', 11, 7, 0, -1, 0, 1, -16777216, 0, 0, 0, 0, N'Arial', 1, 8, 0, -16777216, N'', 405, 0, 0, 9237, 0, 0, N'', 0, 0, 0, N'', N'Nab.vr.', 0, 1, N'', 813, 0, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'VisakRepHeader3679', N'FakturaRacunOtpremnica', 0, 7, 0, 16777215, 0, 0, -16777216, 1, 0, 0, 0, N'Arial', 1, 14, 0, -16777216, N'', 360, 0, 0, 60, 0, 10, N'', 0, 0, 0, N'', N'"VIŠAK REPROMATERIJALA BR: "+DatumBroj', 405, 1, N'', 10005, 0, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'VisakRepHeader3679', N'SubPartneri1', 0, 16, 0, -1, 0, 0, -16777216, 1, 1, 0, 0, N'Microsoft Sans Serif', 0, 8, 0, -16777216, N'', 360, 0, 0, 0, 0, 0, N'', 0, 0, 0, N'LinijaHeader', N'', 15, 1, N'', 9975, 1, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'VPMedjIzlDetail316', N'Detail2', 10, 8, 0, 16777215, 0, 7, -1, 1, 0, 0, 0, N'Arial', 0, 9, 0, -16777216, N'fCijena', 195, 0, 0, 9165, 0, 8, N'', 11, 1, 0, N'', N'Realna', 0, 1, N'', 405, 0, N'', N'', N'', 0, 0)
INSERT INTO [dbo].[EC_BandField] ([BandName], [Name], [Type], [Align], [Anchor], [BackColor], [BarCode], [BorderStyle], [BorderColor], [Calculated], [CanGrow], [CanShrink], [CheckBox], [FontName], [FontStyle], [FontSize], [ForcePageBreak], [ForeColor], [Format], [Height], [HideDuplicates], [KeepTogether], [Left], [LineSlant], [LineWidth], [Picture], [PictureAlign], [PictureScale], [RunningSum], [SubReport], [Text], [Top], [Visible], [VisibleFormula], [Width], [WordWrap], [Caption], [DataX], [DataY], [FieldMark], [Rtf]) VALUES (N'VPMedjIzlPageHeader1155', N'Header2', 11, 7, 0, -1, 0, 1, -16777216, 0, 0, 0, 0, N'Arial', 1, 8, 0, -16777216, N'', 525, 0, 0, 9090, 0, 15, N'', 0, 0, 0, N'', N'Pros.nab.
cijena', 0, 1, N'', 480, 0, N'', N'', N'', 0, 0)

-- Add 3 rows to [dbo].[EC_Report]
INSERT INTO [dbo].[EC_Report] ([ReportName], [QueryName], [Orientation], [PaperSize], [FontName], [FontSize], [FontBold], [FontItalic], [FontUnder], [Filter], [CustomHeight], [CustomWidth], [ColumnLayout], [Columns], [Picture], [PictureScale], [dtID], [Naziv], [Sequence], [EndGroup], [Tip], [LeftMargin], [RightMargin], [TopMargin], [BottomMargin], [OnOpen], [ecBit], [DateModified]) VALUES (N'PrimkaMatUvoz', N'Ulazmaterijala', 1, 9, N'Microsoft Sans Serif', 8, 0, 0, 0, N'', 0, 0, 0, 1, N'', 0, N'52111', N'Štampa dokumenta', 1, 1, 2, 700, 700, 300, 300, N'', 0, '20110324 16:49:00.000')
INSERT INTO [dbo].[EC_Report] ([ReportName], [QueryName], [Orientation], [PaperSize], [FontName], [FontSize], [FontBold], [FontItalic], [FontUnder], [Filter], [CustomHeight], [CustomWidth], [ColumnLayout], [Columns], [Picture], [PictureScale], [dtID], [Naziv], [Sequence], [EndGroup], [Tip], [LeftMargin], [RightMargin], [TopMargin], [BottomMargin], [OnOpen], [ecBit], [DateModified]) VALUES (N'PSRepro', N'Popis', 1, 0, N'Times New Roman', 9, 0, 0, 0, N'', 0, 0, 0, 1, N'', 0, N'52001', N'Štampa dokumenta', 1, 1, 2, 500, 500, 500, 500, N'', 0, '20110324 16:40:00.000')
INSERT INTO [dbo].[EC_Report] ([ReportName], [QueryName], [Orientation], [PaperSize], [FontName], [FontSize], [FontBold], [FontItalic], [FontUnder], [Filter], [CustomHeight], [CustomWidth], [ColumnLayout], [Columns], [Picture], [PictureScale], [dtID], [Naziv], [Sequence], [EndGroup], [Tip], [LeftMargin], [RightMargin], [TopMargin], [BottomMargin], [OnOpen], [ecBit], [DateModified]) VALUES (N'VisakRepro', N'FakturaVP', 1, 9, N'Microsoft Sans Serif', 8, 0, 0, 0, N'', 0, 0, 0, 1, N'', 0, N'52140', N'Štampa dokumenta', 1, 1, 2, 1300, 650, 300, 300, N'', 0, '20110324 17:00:00.000')

-- Add 17 rows to [dbo].[EC_ReportBand]
INSERT INTO [dbo].[EC_ReportBand] ([ReportName], [BandName], [Visible]) VALUES (N'PrimkaMatUvoz', N'UlazmaterijalaDetail902', 1)
INSERT INTO [dbo].[EC_ReportBand] ([ReportName], [BandName], [Visible]) VALUES (N'PrimkaMatUvoz', N'UlazmaterijalaFooter9031', 1)
INSERT INTO [dbo].[EC_ReportBand] ([ReportName], [BandName], [Visible]) VALUES (N'PrimkaMatUvoz', N'UlazmaterijalaGF113603', 1)
INSERT INTO [dbo].[EC_ReportBand] ([ReportName], [BandName], [Visible]) VALUES (N'PrimkaMatUvoz', N'UlazmaterijalaGH115743', 1)
INSERT INTO [dbo].[EC_ReportBand] ([ReportName], [BandName], [Visible]) VALUES (N'PrimkaMatUvoz', N'UlazmaterijalaHeader28675', 1)
INSERT INTO [dbo].[EC_ReportBand] ([ReportName], [BandName], [Visible]) VALUES (N'PrimkaMatUvoz', N'UlazmaterijalaPageFooter15252', 1)
INSERT INTO [dbo].[EC_ReportBand] ([ReportName], [BandName], [Visible]) VALUES (N'PrimkaMatUvoz', N'UlazmaterijalaPageHeader27857', 1)
INSERT INTO [dbo].[EC_ReportBand] ([ReportName], [BandName], [Visible]) VALUES (N'PSRepro', N'Detail1908183614631', 1)
INSERT INTO [dbo].[EC_ReportBand] ([ReportName], [BandName], [Visible]) VALUES (N'PSRepro', N'Footer96268429387', 1)
INSERT INTO [dbo].[EC_ReportBand] ([ReportName], [BandName], [Visible]) VALUES (N'PSRepro', N'Header26875246317', 1)
INSERT INTO [dbo].[EC_ReportBand] ([ReportName], [BandName], [Visible]) VALUES (N'PSRepro', N'PageFooter2606193911165', 1)
INSERT INTO [dbo].[EC_ReportBand] ([ReportName], [BandName], [Visible]) VALUES (N'PSRepro', N'PageHeader47138928208', 1)
INSERT INTO [dbo].[EC_ReportBand] ([ReportName], [BandName], [Visible]) VALUES (N'VisakRepro', N'VisakDetail9904', 1)
INSERT INTO [dbo].[EC_ReportBand] ([ReportName], [BandName], [Visible]) VALUES (N'VisakRepro', N'VisakFooter19013', 1)
INSERT INTO [dbo].[EC_ReportBand] ([ReportName], [BandName], [Visible]) VALUES (N'VisakRepro', N'VisakPageFooter15578', 1)
INSERT INTO [dbo].[EC_ReportBand] ([ReportName], [BandName], [Visible]) VALUES (N'VisakRepro', N'VisakPageHeader13508', 1)
INSERT INTO [dbo].[EC_ReportBand] ([ReportName], [BandName], [Visible]) VALUES (N'VisakRepro', N'VisakRepHeader3679', 1)

-- Add constraints to [dbo].[EC_ReportBand]
ALTER TABLE [dbo].[EC_ReportBand] WITH NOCHECK ADD CONSTRAINT [FK_ReportBand_Band] FOREIGN KEY ([BandName]) REFERENCES [dbo].[EC_Band] ([Name]) ON UPDATE CASCADE
ALTER TABLE [dbo].[EC_ReportBand] WITH NOCHECK ADD CONSTRAINT [FK_ReportBand_Report] FOREIGN KEY ([ReportName]) REFERENCES [dbo].[EC_Report] ([ReportName]) ON UPDATE CASCADE

COMMIT TRANSACTION
