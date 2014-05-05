--ISPRAZNI BAZU
DELETE FROM [BarCod]
DELETE FROM [BarCodeKasa]
DELETE FROM [BarCodeUI]
DELETE FROM [Cjenovnik]
DELETE FROM [DemiFirmeLager]
DELETE FROM [DemiNarudzba]
DELETE FROM [DemiNarudzbaDetalj]
DELETE FROM [ecOpsirnaAnaliza]
DELETE FROM [ecTemp]
DELETE FROM [GK]
DELETE FROM [GKIOS]
DELETE FROM [GlavnaKnjiga]
DELETE FROM [Grupa]
DELETE FROM [JCI]
DELETE FROM [KasaG]
DELETE FROM [KasaGArhiva]
DELETE FROM [KasaSArhiva]
DELETE FROM [LogTabela]
DELETE FROM [NalogG]
DELETE FROM [NalogS]
DELETE FROM [Normativ]
DELETE FROM [ObrPeriod]
DELETE FROM [ObrPlata]
DELETE FROM [Par] WHERE ParID > 0
DELETE FROM [Pro]
DELETE FROM [Rabati]
DELETE FROM [Radnik]
DELETE FROM [RadnikDjeca]
DELETE FROM [Reg]
DELETE FROM [RegAkcija]
DELETE FROM [RegExtra]
DELETE FROM [RegExtraRab]
DELETE FROM [RegSezona]
DELETE FROM [Serijski]
DELETE FROM [Setovi]
DELETE FROM [TempTrig]
DELETE FROM [UlazIzlazDetalj]
DELETE FROM [UlazIzlazSumm]
DELETE FROM [UlazTrosak]
DELETE FROM UredjajiUI
DELETE FROM [Uplatnica]
DELETE FROM [Vozilo]
DELETE FROM [VoziloPar]
DELETE FROM [VoziloReg]
DELETE FROM [Firma_Band]
DELETE FROM [Firma_BandField]
DELETE FROM [Firma_Report]
DELETE FROM [Firma_ReportBand]
DELETE FROM Fifo
DELETE FROM UINotes
DELETE FROM SerijaUI
DELETE FROM UlazIzlazRNalog
DELETE FROM UlazIzlazUtovar
DELETE FROM UlazIzlazExtra
DELETE FROM [UlazIzlaz]

DELETE FROM dbo.KompenzacijaG
DELETE FROM dbo.KompenzacijaS
DELETE FROM dbo.OSDok
DELETE FROM dbo.OSDokS
DELETE FROM dbo.PazarZaKIF
DELETE FROM dbo.table_ecKarticeZaProvjeru
DELETE FROM dbo.table_KUFEvidencija
DELETE FROM dbo.table_vKIF
DELETE FROM dbo.table_vKUF
DELETE FROM dbo.UlazIzlazRadnik
DELETE FROM dbo.UlazIzlazTrackChanges
DELETE FROM dbo.Uredjaj


-- --ISPRAZNI OSTALE
-- DELETE FROM [Firma] WHERE fID <> 1
-- DELETE FROM [FirmaBaza] WHERE fID <> 1
-- DELETE FROM [Host] WHERE ID > 1
-- DELETE FROM [Konto]
-- DELETE FROM [Magacin]
-- DELETE FROM [Objekat]
-- DELETE FROM [RegSif]



--RESET AutoID
--BarCodeKasa
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
CREATE TABLE dbo.Tmp_BarCodeKasa
	(
	AutoID int NOT NULL,
	vID int NULL,
	ProID nvarchar(50) NULL,
	BarCode nvarchar(50) NULL,
	Kol numeric(18, 7) NULL
	)  ON [PRIMARY]
GO
IF EXISTS(SELECT * FROM dbo.BarCodeKasa)
	 EXEC('INSERT INTO dbo.Tmp_BarCodeKasa (AutoID, vID, ProID, BarCode, Kol)
		SELECT AutoID, vID, ProID, BarCode, Kol FROM dbo.BarCodeKasa (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.BarCodeKasa
GO
EXECUTE sp_rename N'dbo.Tmp_BarCodeKasa', N'BarCodeKasa', 'OBJECT'
GO
ALTER TABLE dbo.BarCodeKasa ADD CONSTRAINT
	PK_BarCodeKasa PRIMARY KEY CLUSTERED 
	(
	AutoID
	) ON [PRIMARY]

GO
COMMIT


BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
CREATE TABLE dbo.Tmp_BarCodeKasa
	(
	AutoID int NOT NULL IDENTITY (1, 1),
	vID int NULL,
	ProID nvarchar(50) NULL,
	BarCode nvarchar(50) NULL,
	Kol numeric(18, 7) NULL
	)  ON [PRIMARY]
GO
SET IDENTITY_INSERT dbo.Tmp_BarCodeKasa ON
GO
IF EXISTS(SELECT * FROM dbo.BarCodeKasa)
	 EXEC('INSERT INTO dbo.Tmp_BarCodeKasa (AutoID, vID, ProID, BarCode, Kol)
		SELECT AutoID, vID, ProID, BarCode, Kol FROM dbo.BarCodeKasa (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_BarCodeKasa OFF
GO
DROP TABLE dbo.BarCodeKasa
GO
EXECUTE sp_rename N'dbo.Tmp_BarCodeKasa', N'BarCodeKasa', 'OBJECT'
GO
ALTER TABLE dbo.BarCodeKasa ADD CONSTRAINT
	PK_BarCodeKasa PRIMARY KEY CLUSTERED 
	(
	AutoID
	) ON [PRIMARY]

GO
COMMIT

--BarCodeUI
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
CREATE TABLE dbo.Tmp_BarCodeUI
	(
	AutoID int NOT NULL,
	vID int NULL,
	ProID nvarchar(50) NULL,
	BarCode nvarchar(50) NULL,
	Kol numeric(18, 7) NULL
	)  ON [PRIMARY]
GO
IF EXISTS(SELECT * FROM dbo.BarCodeUI)
	 EXEC('INSERT INTO dbo.Tmp_BarCodeUI (AutoID, vID, ProID, BarCode, Kol)
		SELECT AutoID, vID, ProID, BarCode, Kol FROM dbo.BarCodeUI (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.BarCodeUI
GO
EXECUTE sp_rename N'dbo.Tmp_BarCodeUI', N'BarCodeUI', 'OBJECT'
GO
ALTER TABLE dbo.BarCodeUI ADD CONSTRAINT
	PK_BarCodeUI PRIMARY KEY CLUSTERED 
	(
	AutoID
	) ON [PRIMARY]

GO
COMMIT


BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
CREATE TABLE dbo.Tmp_BarCodeUI
	(
	AutoID int NOT NULL IDENTITY (1, 1),
	vID int NULL,
	ProID nvarchar(50) NULL,
	BarCode nvarchar(50) NULL,
	Kol numeric(18, 7) NULL
	)  ON [PRIMARY]
GO
SET IDENTITY_INSERT dbo.Tmp_BarCodeUI ON
GO
IF EXISTS(SELECT * FROM dbo.BarCodeUI)
	 EXEC('INSERT INTO dbo.Tmp_BarCodeUI (AutoID, vID, ProID, BarCode, Kol)
		SELECT AutoID, vID, ProID, BarCode, Kol FROM dbo.BarCodeUI (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_BarCodeUI OFF
GO
DROP TABLE dbo.BarCodeUI
GO
EXECUTE sp_rename N'dbo.Tmp_BarCodeUI', N'BarCodeUI', 'OBJECT'
GO
ALTER TABLE dbo.BarCodeUI ADD CONSTRAINT
	PK_BarCodeUI PRIMARY KEY CLUSTERED 
	(
	AutoID
	) ON [PRIMARY]

GO
COMMIT

--KasaS1
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
CREATE TABLE dbo.Tmp_KasaS1
	(
	vID int NOT NULL,
	ProID nvarchar(50) NOT NULL,
	RedBr int NULL,
	Kol numeric(18, 7) NULL,
	Cena numeric(18, 7) NULL,
	CSaPor numeric(18, 7) NULL,
	Rabat numeric(18, 7) NULL,
	Tarifa numeric(18, 7) NULL,
	AutoID int NOT NULL
	)  ON [PRIMARY]
GO
IF EXISTS(SELECT * FROM dbo.KasaS1)
	 EXEC('INSERT INTO dbo.Tmp_KasaS1 (vID, ProID, RedBr, Kol, Cena, CSaPor, Rabat, Tarifa, AutoID)
		SELECT vID, ProID, RedBr, Kol, Cena, CSaPor, Rabat, Tarifa, AutoID FROM dbo.KasaS1 (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.KasaS1
GO
EXECUTE sp_rename N'dbo.Tmp_KasaS1', N'KasaS1', 'OBJECT'
GO
ALTER TABLE dbo.KasaS1 ADD CONSTRAINT
	PK_KasaS1 PRIMARY KEY CLUSTERED 
	(
	AutoID
	) ON [PRIMARY]

GO
COMMIT

BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
CREATE TABLE dbo.Tmp_KasaS1
	(
	vID int NOT NULL,
	ProID nvarchar(50) NOT NULL,
	RedBr int NULL,
	Kol numeric(18, 7) NULL,
	Cena numeric(18, 7) NULL,
	CSaPor numeric(18, 7) NULL,
	Rabat numeric(18, 7) NULL,
	Tarifa numeric(18, 7) NULL,
	AutoID int NOT NULL IDENTITY (1, 1)
	)  ON [PRIMARY]
GO
SET IDENTITY_INSERT dbo.Tmp_KasaS1 ON
GO
IF EXISTS(SELECT * FROM dbo.KasaS1)
	 EXEC('INSERT INTO dbo.Tmp_KasaS1 (vID, ProID, RedBr, Kol, Cena, CSaPor, Rabat, Tarifa, AutoID)
		SELECT vID, ProID, RedBr, Kol, Cena, CSaPor, Rabat, Tarifa, AutoID FROM dbo.KasaS1 (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_KasaS1 OFF
GO
DROP TABLE dbo.KasaS1
GO
EXECUTE sp_rename N'dbo.Tmp_KasaS1', N'KasaS1', 'OBJECT'
GO
ALTER TABLE dbo.KasaS1 ADD CONSTRAINT
	PK_KasaS1 PRIMARY KEY CLUSTERED 
	(
	AutoID
	) ON [PRIMARY]

GO
COMMIT


--UlazIZlaz
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
ALTER TABLE dbo.UlazIzlaz
	DROP CONSTRAINT DF_UlazIzlaz_mID
GO
ALTER TABLE dbo.UlazIzlaz
	DROP CONSTRAINT DF_UI_RAS
GO
ALTER TABLE dbo.UlazIzlaz
	DROP CONSTRAINT DF_UI_Datum
GO
ALTER TABLE dbo.UlazIzlaz
	DROP CONSTRAINT DF_UI_Knjizenje
GO
ALTER TABLE dbo.UlazIzlaz
	DROP CONSTRAINT DF_UI_Broj
GO
ALTER TABLE dbo.UlazIzlaz
	DROP CONSTRAINT DF_UI_ParID
GO
ALTER TABLE dbo.UlazIzlaz
	DROP CONSTRAINT DF_UI_dtID
GO
ALTER TABLE dbo.UlazIzlaz
	DROP CONSTRAINT DF_UI_Predznak
GO
ALTER TABLE dbo.UlazIzlaz
	DROP CONSTRAINT DF_UlazIzlaz_Vreme
GO
ALTER TABLE dbo.UlazIzlaz
	DROP CONSTRAINT DF_UlazIzlaz_Pristup
GO
ALTER TABLE dbo.UlazIzlaz
	DROP CONSTRAINT DF_UlazIzlaz_DPO
GO
ALTER TABLE dbo.UlazIzlaz
	DROP CONSTRAINT DF_UlazIzlaz_Valuta
GO
ALTER TABLE dbo.UlazIzlaz
	DROP CONSTRAINT DF_UlazIzlaz_KlijentID
GO
ALTER TABLE dbo.UlazIzlaz
	DROP CONSTRAINT DF_UlazIzlaz_UserID
GO
ALTER TABLE dbo.UlazIzlaz
	DROP CONSTRAINT DF_UlazIzlaz_Paritet
GO
ALTER TABLE dbo.UlazIzlaz
	DROP CONSTRAINT DF_UlazIzlaz_Placanje
GO
ALTER TABLE dbo.UlazIzlaz
	DROP CONSTRAINT DF_UlazIzlaz_Napomena
GO
ALTER TABLE dbo.UlazIzlaz
	DROP CONSTRAINT DF_UlazIzlaz_Otprema
GO
ALTER TABLE dbo.UlazIzlaz
	DROP CONSTRAINT DF_UlazIzlaz_Vozilo
GO
ALTER TABLE dbo.UlazIzlaz
	DROP CONSTRAINT DF_UlazIzlaz_Vozac
GO
ALTER TABLE dbo.UlazIzlaz
	DROP CONSTRAINT DF_UlazIzlaz_vIDStorno
GO
ALTER TABLE dbo.UlazIzlaz
	DROP CONSTRAINT DF_UlazIzlaz_vIDNiv
GO
ALTER TABLE dbo.UlazIzlaz
	DROP CONSTRAINT DF_UlazIzlaz_ParDokBroj
GO
ALTER TABLE dbo.UlazIzlaz
	DROP CONSTRAINT DF_UlazIzlaz_Avans
GO
ALTER TABLE dbo.UlazIzlaz
	DROP CONSTRAINT DF_UlazIzlaz_FaktSaRabatIznos
GO
ALTER TABLE dbo.UlazIzlaz
	DROP CONSTRAINT DF_UlazIzlaz_Isporuka
GO
ALTER TABLE dbo.UlazIzlaz
	DROP CONSTRAINT DF_UlazIzlaz_DatumDok
GO
ALTER TABLE dbo.UlazIzlaz
	DROP CONSTRAINT DF_UlazIzlaz_Moneta
GO
ALTER TABLE dbo.UlazIzlaz
	DROP CONSTRAINT DF_UlazIzlaz_Komercijalist
GO
ALTER TABLE dbo.UlazIzlaz
	DROP CONSTRAINT DF_UlazIzlaz_vIDNiv1
GO
ALTER TABLE dbo.UlazIzlaz
	DROP CONSTRAINT DF_UlazIzlaz_Naplata
GO
ALTER TABLE dbo.UlazIzlaz
	DROP CONSTRAINT DF_UlazIzlaz_JCI
GO
ALTER TABLE dbo.UlazIzlaz
	DROP CONSTRAINT DF_UlazIzlaz_KursnaLista
GO
ALTER TABLE dbo.UlazIzlaz
	DROP CONSTRAINT DF_UlazIzlaz_Kurs
GO
CREATE TABLE dbo.Tmp_UlazIzlaz
	(
	vID int NOT NULL,
	mID int NOT NULL,
	RAS bigint NOT NULL,
	Datum datetime NOT NULL,
	Knjizenje datetime NOT NULL,
	Broj varchar(25) NULL,
	ParID int NULL,
	dtID varchar(10) NULL,
	Predznak smallint NULL,
	AutoID int NOT NULL,
	Vreme datetime NULL,
	Pristup datetime NULL,
	DPO datetime NULL,
	Valuta smallint NULL,
	Klijent varchar(50) NULL,
	UserName varchar(50) NULL,
	Paritet varchar(5) NULL,
	Placanje varchar(5) NULL,
	Napomena ntext NULL,
	Otprema varchar(5) NULL,
	Vozilo nvarchar(50) NULL,
	Vozac nvarchar(50) NULL,
	vIDStorno int NULL,
	vIDNiv int NULL,
	ParDokBroj nvarchar(50) NULL,
	Avans numeric(18, 7) NULL,
	FaktSaRabatIznos numeric(18, 7) NULL,
	Isporuka datetime NULL,
	DatumDok datetime NULL,
	Moneta varchar(5) NULL,
	Komercijalist int NULL,
	vIDPrenos int NULL,
	Naplata numeric(18, 7) NULL,
	JCI varchar(50) NULL,
	KursnaLista varchar(5) NULL,
	Kurs numeric(18, 6) NOT NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
DECLARE @v sql_variant 
SET @v = cast(N'2' as tinyint)
EXECUTE sp_addextendedproperty N'MS_DefaultView', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', NULL, NULL
SET @v = NULL
EXECUTE sp_addextendedproperty N'MS_Filter', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', NULL, NULL
SET @v = N'vID'
EXECUTE sp_addextendedproperty N'MS_LinkChildFields', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', NULL, NULL
SET @v = N'vID'
EXECUTE sp_addextendedproperty N'MS_LinkMasterFields', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', NULL, NULL
SET @v = NULL
EXECUTE sp_addextendedproperty N'MS_OrderBy', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', NULL, NULL
SET @v = cast(N'0' as bit)
EXECUTE sp_addextendedproperty N'MS_OrderByOn', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', NULL, NULL
SET @v = cast(N'0' as tinyint)
EXECUTE sp_addextendedproperty N'MS_Orientation', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', NULL, NULL
SET @v = N'dbo.UlazIzlazDetalj'
EXECUTE sp_addextendedproperty N'MS_SubdatasheetName', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', NULL, NULL
SET @v = cast(N'10000' as int)
EXECUTE sp_addextendedproperty N'MS_TableMaxRecords', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', NULL, NULL
GO
DECLARE @v sql_variant 
SET @v = cast(N'0' as bit)
EXECUTE sp_addextendedproperty N'MS_ColumnHidden', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'vID'
SET @v = cast(N'0' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnOrder', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'vID'
SET @v = cast(N'-1' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnWidth', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'vID'
GO
DECLARE @v sql_variant 
SET @v = cast(N'0' as bit)
EXECUTE sp_addextendedproperty N'MS_ColumnHidden', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'RAS'
SET @v = cast(N'0' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnOrder', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'RAS'
SET @v = cast(N'-1' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnWidth', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'RAS'
GO
DECLARE @v sql_variant 
SET @v = cast(N'0' as bit)
EXECUTE sp_addextendedproperty N'MS_ColumnHidden', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Datum'
SET @v = cast(N'0' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnOrder', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Datum'
SET @v = cast(N'-1' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnWidth', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Datum'
GO
DECLARE @v sql_variant 
SET @v = cast(N'0' as bit)
EXECUTE sp_addextendedproperty N'MS_ColumnHidden', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Knjizenje'
SET @v = cast(N'0' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnOrder', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Knjizenje'
SET @v = cast(N'-1' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnWidth', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Knjizenje'
GO
DECLARE @v sql_variant 
SET @v = cast(N'0' as bit)
EXECUTE sp_addextendedproperty N'MS_ColumnHidden', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Broj'
SET @v = cast(N'0' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnOrder', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Broj'
SET @v = cast(N'-1' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnWidth', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Broj'
GO
DECLARE @v sql_variant 
SET @v = cast(N'0' as bit)
EXECUTE sp_addextendedproperty N'MS_ColumnHidden', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'ParID'
SET @v = cast(N'0' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnOrder', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'ParID'
SET @v = cast(N'-1' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnWidth', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'ParID'
GO
DECLARE @v sql_variant 
SET @v = cast(N'0' as bit)
EXECUTE sp_addextendedproperty N'MS_ColumnHidden', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'dtID'
SET @v = cast(N'0' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnOrder', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'dtID'
SET @v = cast(N'-1' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnWidth', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'dtID'
GO
DECLARE @v sql_variant 
SET @v = cast(N'0' as bit)
EXECUTE sp_addextendedproperty N'MS_ColumnHidden', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Predznak'
SET @v = cast(N'0' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnOrder', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Predznak'
SET @v = cast(N'-1' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnWidth', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Predznak'
GO
DECLARE @v sql_variant 
SET @v = cast(N'0' as bit)
EXECUTE sp_addextendedproperty N'MS_ColumnHidden', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'AutoID'
SET @v = cast(N'0' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnOrder', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'AutoID'
SET @v = cast(N'-1' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnWidth', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'AutoID'
GO
DECLARE @v sql_variant 
SET @v = cast(N'0' as bit)
EXECUTE sp_addextendedproperty N'MS_ColumnHidden', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Vreme'
SET @v = cast(N'0' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnOrder', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Vreme'
SET @v = cast(N'-1' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnWidth', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Vreme'
GO
DECLARE @v sql_variant 
SET @v = cast(N'0' as bit)
EXECUTE sp_addextendedproperty N'MS_ColumnHidden', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Pristup'
SET @v = cast(N'0' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnOrder', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Pristup'
SET @v = cast(N'-1' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnWidth', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Pristup'
GO
DECLARE @v sql_variant 
SET @v = cast(N'0' as bit)
EXECUTE sp_addextendedproperty N'MS_ColumnHidden', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'DPO'
SET @v = cast(N'0' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnOrder', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'DPO'
SET @v = cast(N'-1' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnWidth', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'DPO'
GO
DECLARE @v sql_variant 
SET @v = cast(N'0' as bit)
EXECUTE sp_addextendedproperty N'MS_ColumnHidden', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Valuta'
SET @v = cast(N'0' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnOrder', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Valuta'
SET @v = cast(N'-1' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnWidth', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Valuta'
GO
DECLARE @v sql_variant 
SET @v = cast(N'0' as bit)
EXECUTE sp_addextendedproperty N'MS_ColumnHidden', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Klijent'
SET @v = cast(N'0' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnOrder', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Klijent'
SET @v = cast(N'-1' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnWidth', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Klijent'
GO
DECLARE @v sql_variant 
SET @v = cast(N'0' as bit)
EXECUTE sp_addextendedproperty N'MS_ColumnHidden', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'UserName'
SET @v = cast(N'0' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnOrder', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'UserName'
SET @v = cast(N'-1' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnWidth', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'UserName'
GO
DECLARE @v sql_variant 
SET @v = cast(N'0' as bit)
EXECUTE sp_addextendedproperty N'MS_ColumnHidden', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Paritet'
SET @v = cast(N'0' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnOrder', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Paritet'
SET @v = cast(N'-1' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnWidth', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Paritet'
GO
DECLARE @v sql_variant 
SET @v = cast(N'0' as bit)
EXECUTE sp_addextendedproperty N'MS_ColumnHidden', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Placanje'
SET @v = cast(N'0' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnOrder', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Placanje'
SET @v = cast(N'-1' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnWidth', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Placanje'
GO
DECLARE @v sql_variant 
SET @v = cast(N'0' as bit)
EXECUTE sp_addextendedproperty N'MS_ColumnHidden', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Napomena'
SET @v = cast(N'0' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnOrder', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Napomena'
SET @v = cast(N'-1' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnWidth', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Napomena'
GO
DECLARE @v sql_variant 
SET @v = cast(N'0' as bit)
EXECUTE sp_addextendedproperty N'MS_ColumnHidden', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Otprema'
SET @v = cast(N'0' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnOrder', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Otprema'
SET @v = cast(N'-1' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnWidth', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Otprema'
GO
DECLARE @v sql_variant 
SET @v = cast(N'0' as bit)
EXECUTE sp_addextendedproperty N'MS_ColumnHidden', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Vozilo'
SET @v = cast(N'0' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnOrder', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Vozilo'
SET @v = cast(N'-1' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnWidth', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Vozilo'
GO
DECLARE @v sql_variant 
SET @v = cast(N'0' as bit)
EXECUTE sp_addextendedproperty N'MS_ColumnHidden', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Vozac'
SET @v = cast(N'0' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnOrder', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Vozac'
SET @v = cast(N'-1' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnWidth', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Vozac'
GO
DECLARE @v sql_variant 
SET @v = cast(N'0' as bit)
EXECUTE sp_addextendedproperty N'MS_ColumnHidden', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'vIDStorno'
SET @v = cast(N'0' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnOrder', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'vIDStorno'
SET @v = cast(N'-1' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnWidth', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'vIDStorno'
GO
DECLARE @v sql_variant 
SET @v = cast(N'0' as bit)
EXECUTE sp_addextendedproperty N'MS_ColumnHidden', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'vIDNiv'
SET @v = cast(N'0' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnOrder', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'vIDNiv'
SET @v = cast(N'-1' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnWidth', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'vIDNiv'
GO
DECLARE @v sql_variant 
SET @v = cast(N'0' as bit)
EXECUTE sp_addextendedproperty N'MS_ColumnHidden', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'ParDokBroj'
SET @v = cast(N'0' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnOrder', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'ParDokBroj'
SET @v = cast(N'-1' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnWidth', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'ParDokBroj'
GO
DECLARE @v sql_variant 
SET @v = cast(N'0' as bit)
EXECUTE sp_addextendedproperty N'MS_ColumnHidden', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Avans'
SET @v = cast(N'0' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnOrder', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Avans'
SET @v = cast(N'-1' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnWidth', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Avans'
GO
DECLARE @v sql_variant 
SET @v = cast(N'0' as bit)
EXECUTE sp_addextendedproperty N'MS_ColumnHidden', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'FaktSaRabatIznos'
SET @v = cast(N'0' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnOrder', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'FaktSaRabatIznos'
SET @v = cast(N'-1' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnWidth', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'FaktSaRabatIznos'
GO
DECLARE @v sql_variant 
SET @v = cast(N'0' as bit)
EXECUTE sp_addextendedproperty N'MS_ColumnHidden', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Isporuka'
SET @v = cast(N'0' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnOrder', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Isporuka'
SET @v = cast(N'-1' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnWidth', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Isporuka'
GO
DECLARE @v sql_variant 
SET @v = cast(N'0' as bit)
EXECUTE sp_addextendedproperty N'MS_ColumnHidden', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'DatumDok'
SET @v = cast(N'0' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnOrder', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'DatumDok'
SET @v = cast(N'-1' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnWidth', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'DatumDok'
GO
DECLARE @v sql_variant 
SET @v = cast(N'0' as bit)
EXECUTE sp_addextendedproperty N'MS_ColumnHidden', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Moneta'
SET @v = cast(N'0' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnOrder', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Moneta'
SET @v = cast(N'-1' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnWidth', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Moneta'
GO
DECLARE @v sql_variant 
SET @v = cast(N'0' as bit)
EXECUTE sp_addextendedproperty N'MS_ColumnHidden', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Komercijalist'
SET @v = cast(N'0' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnOrder', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Komercijalist'
SET @v = cast(N'-1' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnWidth', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Komercijalist'
GO
DECLARE @v sql_variant 
SET @v = cast(N'0' as bit)
EXECUTE sp_addextendedproperty N'MS_ColumnHidden', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'vIDPrenos'
SET @v = cast(N'0' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnOrder', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'vIDPrenos'
SET @v = cast(N'-1' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnWidth', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'vIDPrenos'
GO
DECLARE @v sql_variant 
SET @v = cast(N'0' as bit)
EXECUTE sp_addextendedproperty N'MS_ColumnHidden', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Naplata'
SET @v = cast(N'0' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnOrder', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Naplata'
SET @v = cast(N'-1' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnWidth', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Naplata'
GO
ALTER TABLE dbo.Tmp_UlazIzlaz ADD CONSTRAINT
	DF_UlazIzlaz_mID DEFAULT (0) FOR mID
GO
ALTER TABLE dbo.Tmp_UlazIzlaz ADD CONSTRAINT
	DF_UI_RAS DEFAULT (0) FOR RAS
GO
ALTER TABLE dbo.Tmp_UlazIzlaz ADD CONSTRAINT
	DF_UI_Datum DEFAULT (getdate()) FOR Datum
GO
ALTER TABLE dbo.Tmp_UlazIzlaz ADD CONSTRAINT
	DF_UI_Knjizenje DEFAULT (getdate()) FOR Knjizenje
GO
ALTER TABLE dbo.Tmp_UlazIzlaz ADD CONSTRAINT
	DF_UI_Broj DEFAULT ('') FOR Broj
GO
ALTER TABLE dbo.Tmp_UlazIzlaz ADD CONSTRAINT
	DF_UI_ParID DEFAULT (0) FOR ParID
GO
ALTER TABLE dbo.Tmp_UlazIzlaz ADD CONSTRAINT
	DF_UI_dtID DEFAULT (0) FOR dtID
GO
ALTER TABLE dbo.Tmp_UlazIzlaz ADD CONSTRAINT
	DF_UI_Predznak DEFAULT (0) FOR Predznak
GO
ALTER TABLE dbo.Tmp_UlazIzlaz ADD CONSTRAINT
	DF_UlazIzlaz_Vreme DEFAULT (0) FOR Vreme
GO
ALTER TABLE dbo.Tmp_UlazIzlaz ADD CONSTRAINT
	DF_UlazIzlaz_Pristup DEFAULT (0) FOR Pristup
GO
ALTER TABLE dbo.Tmp_UlazIzlaz ADD CONSTRAINT
	DF_UlazIzlaz_DPO DEFAULT (0) FOR DPO
GO
ALTER TABLE dbo.Tmp_UlazIzlaz ADD CONSTRAINT
	DF_UlazIzlaz_Valuta DEFAULT (0) FOR Valuta
GO
ALTER TABLE dbo.Tmp_UlazIzlaz ADD CONSTRAINT
	DF_UlazIzlaz_KlijentID DEFAULT (0) FOR Klijent
GO
ALTER TABLE dbo.Tmp_UlazIzlaz ADD CONSTRAINT
	DF_UlazIzlaz_UserID DEFAULT (0) FOR UserName
GO
ALTER TABLE dbo.Tmp_UlazIzlaz ADD CONSTRAINT
	DF_UlazIzlaz_Paritet DEFAULT ('0') FOR Paritet
GO
ALTER TABLE dbo.Tmp_UlazIzlaz ADD CONSTRAINT
	DF_UlazIzlaz_Placanje DEFAULT ('0') FOR Placanje
GO
ALTER TABLE dbo.Tmp_UlazIzlaz ADD CONSTRAINT
	DF_UlazIzlaz_Napomena DEFAULT ('') FOR Napomena
GO
ALTER TABLE dbo.Tmp_UlazIzlaz ADD CONSTRAINT
	DF_UlazIzlaz_Otprema DEFAULT ('0') FOR Otprema
GO
ALTER TABLE dbo.Tmp_UlazIzlaz ADD CONSTRAINT
	DF_UlazIzlaz_Vozilo DEFAULT ('') FOR Vozilo
GO
ALTER TABLE dbo.Tmp_UlazIzlaz ADD CONSTRAINT
	DF_UlazIzlaz_Vozac DEFAULT ('') FOR Vozac
GO
ALTER TABLE dbo.Tmp_UlazIzlaz ADD CONSTRAINT
	DF_UlazIzlaz_vIDStorno DEFAULT (0) FOR vIDStorno
GO
ALTER TABLE dbo.Tmp_UlazIzlaz ADD CONSTRAINT
	DF_UlazIzlaz_vIDNiv DEFAULT (0) FOR vIDNiv
GO
ALTER TABLE dbo.Tmp_UlazIzlaz ADD CONSTRAINT
	DF_UlazIzlaz_ParDokBroj DEFAULT ('') FOR ParDokBroj
GO
ALTER TABLE dbo.Tmp_UlazIzlaz ADD CONSTRAINT
	DF_UlazIzlaz_Avans DEFAULT (0) FOR Avans
GO
ALTER TABLE dbo.Tmp_UlazIzlaz ADD CONSTRAINT
	DF_UlazIzlaz_FaktSaRabatIznos DEFAULT (0) FOR FaktSaRabatIznos
GO
ALTER TABLE dbo.Tmp_UlazIzlaz ADD CONSTRAINT
	DF_UlazIzlaz_Isporuka DEFAULT (0) FOR Isporuka
GO
ALTER TABLE dbo.Tmp_UlazIzlaz ADD CONSTRAINT
	DF_UlazIzlaz_DatumDok DEFAULT (0) FOR DatumDok
GO
ALTER TABLE dbo.Tmp_UlazIzlaz ADD CONSTRAINT
	DF_UlazIzlaz_Moneta DEFAULT ('1') FOR Moneta
GO
ALTER TABLE dbo.Tmp_UlazIzlaz ADD CONSTRAINT
	DF_UlazIzlaz_Komercijalist DEFAULT (0) FOR Komercijalist
GO
ALTER TABLE dbo.Tmp_UlazIzlaz ADD CONSTRAINT
	DF_UlazIzlaz_vIDNiv1 DEFAULT (0) FOR vIDPrenos
GO
ALTER TABLE dbo.Tmp_UlazIzlaz ADD CONSTRAINT
	DF_UlazIzlaz_Naplata DEFAULT (0) FOR Naplata
GO
ALTER TABLE dbo.Tmp_UlazIzlaz ADD CONSTRAINT
	DF_UlazIzlaz_JCI DEFAULT ('') FOR JCI
GO
ALTER TABLE dbo.Tmp_UlazIzlaz ADD CONSTRAINT
	DF_UlazIzlaz_KursnaLista DEFAULT ('') FOR KursnaLista
GO
ALTER TABLE dbo.Tmp_UlazIzlaz ADD CONSTRAINT
	DF_UlazIzlaz_Kurs DEFAULT (1) FOR Kurs
GO
IF EXISTS(SELECT * FROM dbo.UlazIzlaz)
	 EXEC('INSERT INTO dbo.Tmp_UlazIzlaz (vID, mID, RAS, Datum, Knjizenje, Broj, ParID, dtID, Predznak, AutoID, Vreme, Pristup, DPO, Valuta, Klijent, UserName, Paritet, Placanje, Napomena, Otprema, Vozilo, Vozac, vIDStorno, vIDNiv, ParDokBroj, Avans, FaktSaRabatIznos, Isporuka, DatumDok, Moneta, Komercijalist, vIDPrenos, Naplata, JCI, KursnaLista, Kurs)
		SELECT vID, mID, RAS, Datum, Knjizenje, Broj, ParID, dtID, Predznak, AutoID, Vreme, Pristup, DPO, Valuta, Klijent, UserName, Paritet, Placanje, Napomena, Otprema, Vozilo, Vozac, vIDStorno, vIDNiv, ParDokBroj, Avans, FaktSaRabatIznos, Isporuka, DatumDok, Moneta, Komercijalist, vIDPrenos, Naplata, JCI, KursnaLista, Kurs FROM dbo.UlazIzlaz (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.UlazIzlaz
GO
EXECUTE sp_rename N'dbo.Tmp_UlazIzlaz', N'UlazIzlaz', 'OBJECT'
GO
ALTER TABLE dbo.UlazIzlaz ADD CONSTRAINT
	PK_UI PRIMARY KEY CLUSTERED 
	(
	vID
	) WITH FILLFACTOR = 70 ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX IX_UlazIzlaz ON dbo.UlazIzlaz
	(
	Datum
	) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX IX_UlazIzlaz_1 ON dbo.UlazIzlaz
	(
	Knjizenje,
	vID
	) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX IX_UlazIzlaz_2 ON dbo.UlazIzlaz
	(
	RAS
	) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX IX_UI ON dbo.UlazIzlaz
	(
	Knjizenje
	) WITH FILLFACTOR = 70 ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX IX_UlazIzlaz_3 ON dbo.UlazIzlaz
	(
	vID,
	RAS
	) ON [PRIMARY]
GO
CREATE TRIGGER trigSrediPro
ON dbo.UlazIzlaz
AFTER UPDATE

AS 

--SELECT 0[vID], 1[mID], 2[RAS], 3[Datum], 4[Knjizenje], 5[Broj], 6[ParID], 7[dtID], 8[Predznak], 9[AutoID], 10[Vreme], 11[Pristup], 12[DPO], 13[Valuta], 14[Klijent], 15[UserName], 16[Paritet], 17[Placanje], 18[Napomena], 19[Otprema], 20[Vozilo], 21[Vozac], 22[vIDStorno], 23[vIDNiv], 24[ParDokBroj], 25[Avans], 26[FaktSaRabatIznos], 27[Isporuka], 28[DatumDok], 29[Moneta], 30[Komercijalist], 31[vIDPrenos], 32[Naplata], 33[JCI], 34[KursnaLista], 35[Kurs] FROM [UlazIzlaz]
BEGIN

	DECLARE @vID AS INT
	DECLARE @RAS as bigint
	DECLARE @dtID as varchar(5)
	SELECT @vID = vID, @RAS = RAS, @dtID = dtID FROM inserted
	
-- 	IF SUBSTRING(COLUMNS_UPDATED(), 1, 1) & 4 = 4 --RAS
-- 	BEGIN
-- 		IF @RAS & 1 = 1 --OR (@dtID IN ('40222')) --Knjizen u robno OR Faktura gotovinska (za pazar)
--		BEGIN
-- 			--raiserror ('RAS proknjizen' ,16, 1)
-- 			EXEC [ecSrediProOdVeze] @vID
-- 		END
-- 	END

END
GO
CREATE TRIGGER [DelTotal] ON dbo.UlazIzlaz 
FOR DELETE 
AS
DELETE FROM UlazIzlazSumm
WHERE vID IN (Select vID from deleted)
GO
COMMIT

BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
ALTER TABLE dbo.UlazIzlaz
	DROP CONSTRAINT DF_UlazIzlaz_mID
GO
ALTER TABLE dbo.UlazIzlaz
	DROP CONSTRAINT DF_UI_RAS
GO
ALTER TABLE dbo.UlazIzlaz
	DROP CONSTRAINT DF_UI_Datum
GO
ALTER TABLE dbo.UlazIzlaz
	DROP CONSTRAINT DF_UI_Knjizenje
GO
ALTER TABLE dbo.UlazIzlaz
	DROP CONSTRAINT DF_UI_Broj
GO
ALTER TABLE dbo.UlazIzlaz
	DROP CONSTRAINT DF_UI_ParID
GO
ALTER TABLE dbo.UlazIzlaz
	DROP CONSTRAINT DF_UI_dtID
GO
ALTER TABLE dbo.UlazIzlaz
	DROP CONSTRAINT DF_UI_Predznak
GO
ALTER TABLE dbo.UlazIzlaz
	DROP CONSTRAINT DF_UlazIzlaz_Vreme
GO
ALTER TABLE dbo.UlazIzlaz
	DROP CONSTRAINT DF_UlazIzlaz_Pristup
GO
ALTER TABLE dbo.UlazIzlaz
	DROP CONSTRAINT DF_UlazIzlaz_DPO
GO
ALTER TABLE dbo.UlazIzlaz
	DROP CONSTRAINT DF_UlazIzlaz_Valuta
GO
ALTER TABLE dbo.UlazIzlaz
	DROP CONSTRAINT DF_UlazIzlaz_KlijentID
GO
ALTER TABLE dbo.UlazIzlaz
	DROP CONSTRAINT DF_UlazIzlaz_UserID
GO
ALTER TABLE dbo.UlazIzlaz
	DROP CONSTRAINT DF_UlazIzlaz_Paritet
GO
ALTER TABLE dbo.UlazIzlaz
	DROP CONSTRAINT DF_UlazIzlaz_Placanje
GO
ALTER TABLE dbo.UlazIzlaz
	DROP CONSTRAINT DF_UlazIzlaz_Napomena
GO
ALTER TABLE dbo.UlazIzlaz
	DROP CONSTRAINT DF_UlazIzlaz_Otprema
GO
ALTER TABLE dbo.UlazIzlaz
	DROP CONSTRAINT DF_UlazIzlaz_Vozilo
GO
ALTER TABLE dbo.UlazIzlaz
	DROP CONSTRAINT DF_UlazIzlaz_Vozac
GO
ALTER TABLE dbo.UlazIzlaz
	DROP CONSTRAINT DF_UlazIzlaz_vIDStorno
GO
ALTER TABLE dbo.UlazIzlaz
	DROP CONSTRAINT DF_UlazIzlaz_vIDNiv
GO
ALTER TABLE dbo.UlazIzlaz
	DROP CONSTRAINT DF_UlazIzlaz_ParDokBroj
GO
ALTER TABLE dbo.UlazIzlaz
	DROP CONSTRAINT DF_UlazIzlaz_Avans
GO
ALTER TABLE dbo.UlazIzlaz
	DROP CONSTRAINT DF_UlazIzlaz_FaktSaRabatIznos
GO
ALTER TABLE dbo.UlazIzlaz
	DROP CONSTRAINT DF_UlazIzlaz_Isporuka
GO
ALTER TABLE dbo.UlazIzlaz
	DROP CONSTRAINT DF_UlazIzlaz_DatumDok
GO
ALTER TABLE dbo.UlazIzlaz
	DROP CONSTRAINT DF_UlazIzlaz_Moneta
GO
ALTER TABLE dbo.UlazIzlaz
	DROP CONSTRAINT DF_UlazIzlaz_Komercijalist
GO
ALTER TABLE dbo.UlazIzlaz
	DROP CONSTRAINT DF_UlazIzlaz_vIDNiv1
GO
ALTER TABLE dbo.UlazIzlaz
	DROP CONSTRAINT DF_UlazIzlaz_Naplata
GO
ALTER TABLE dbo.UlazIzlaz
	DROP CONSTRAINT DF_UlazIzlaz_JCI
GO
ALTER TABLE dbo.UlazIzlaz
	DROP CONSTRAINT DF_UlazIzlaz_KursnaLista
GO
ALTER TABLE dbo.UlazIzlaz
	DROP CONSTRAINT DF_UlazIzlaz_Kurs
GO
CREATE TABLE dbo.Tmp_UlazIzlaz
	(
	vID int NOT NULL,
	mID int NOT NULL,
	RAS bigint NOT NULL,
	Datum datetime NOT NULL,
	Knjizenje datetime NOT NULL,
	Broj varchar(25) NULL,
	ParID int NULL,
	dtID varchar(10) NULL,
	Predznak smallint NULL,
	AutoID int NOT NULL IDENTITY (1, 1),
	Vreme datetime NULL,
	Pristup datetime NULL,
	DPO datetime NULL,
	Valuta smallint NULL,
	Klijent varchar(50) NULL,
	UserName varchar(50) NULL,
	Paritet varchar(5) NULL,
	Placanje varchar(5) NULL,
	Napomena ntext NULL,
	Otprema varchar(5) NULL,
	Vozilo nvarchar(50) NULL,
	Vozac nvarchar(50) NULL,
	vIDStorno int NULL,
	vIDNiv int NULL,
	ParDokBroj nvarchar(50) NULL,
	Avans numeric(18, 7) NULL,
	FaktSaRabatIznos numeric(18, 7) NULL,
	Isporuka datetime NULL,
	DatumDok datetime NULL,
	Moneta varchar(5) NULL,
	Komercijalist int NULL,
	vIDPrenos int NULL,
	Naplata numeric(18, 7) NULL,
	JCI varchar(50) NULL,
	KursnaLista varchar(5) NULL,
	Kurs numeric(18, 6) NOT NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
DECLARE @v sql_variant 
SET @v = cast(N'2' as tinyint)
EXECUTE sp_addextendedproperty N'MS_DefaultView', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', NULL, NULL
SET @v = NULL
EXECUTE sp_addextendedproperty N'MS_Filter', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', NULL, NULL
SET @v = N'vID'
EXECUTE sp_addextendedproperty N'MS_LinkChildFields', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', NULL, NULL
SET @v = N'vID'
EXECUTE sp_addextendedproperty N'MS_LinkMasterFields', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', NULL, NULL
SET @v = NULL
EXECUTE sp_addextendedproperty N'MS_OrderBy', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', NULL, NULL
SET @v = cast(N'0' as bit)
EXECUTE sp_addextendedproperty N'MS_OrderByOn', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', NULL, NULL
SET @v = cast(N'0' as tinyint)
EXECUTE sp_addextendedproperty N'MS_Orientation', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', NULL, NULL
SET @v = N'dbo.UlazIzlazDetalj'
EXECUTE sp_addextendedproperty N'MS_SubdatasheetName', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', NULL, NULL
SET @v = cast(N'10000' as int)
EXECUTE sp_addextendedproperty N'MS_TableMaxRecords', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', NULL, NULL
GO
DECLARE @v sql_variant 
SET @v = cast(N'0' as bit)
EXECUTE sp_addextendedproperty N'MS_ColumnHidden', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'vID'
SET @v = cast(N'0' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnOrder', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'vID'
SET @v = cast(N'-1' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnWidth', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'vID'
GO
DECLARE @v sql_variant 
SET @v = cast(N'0' as bit)
EXECUTE sp_addextendedproperty N'MS_ColumnHidden', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'RAS'
SET @v = cast(N'0' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnOrder', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'RAS'
SET @v = cast(N'-1' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnWidth', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'RAS'
GO
DECLARE @v sql_variant 
SET @v = cast(N'0' as bit)
EXECUTE sp_addextendedproperty N'MS_ColumnHidden', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Datum'
SET @v = cast(N'0' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnOrder', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Datum'
SET @v = cast(N'-1' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnWidth', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Datum'
GO
DECLARE @v sql_variant 
SET @v = cast(N'0' as bit)
EXECUTE sp_addextendedproperty N'MS_ColumnHidden', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Knjizenje'
SET @v = cast(N'0' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnOrder', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Knjizenje'
SET @v = cast(N'-1' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnWidth', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Knjizenje'
GO
DECLARE @v sql_variant 
SET @v = cast(N'0' as bit)
EXECUTE sp_addextendedproperty N'MS_ColumnHidden', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Broj'
SET @v = cast(N'0' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnOrder', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Broj'
SET @v = cast(N'-1' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnWidth', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Broj'
GO
DECLARE @v sql_variant 
SET @v = cast(N'0' as bit)
EXECUTE sp_addextendedproperty N'MS_ColumnHidden', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'ParID'
SET @v = cast(N'0' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnOrder', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'ParID'
SET @v = cast(N'-1' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnWidth', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'ParID'
GO
DECLARE @v sql_variant 
SET @v = cast(N'0' as bit)
EXECUTE sp_addextendedproperty N'MS_ColumnHidden', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'dtID'
SET @v = cast(N'0' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnOrder', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'dtID'
SET @v = cast(N'-1' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnWidth', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'dtID'
GO
DECLARE @v sql_variant 
SET @v = cast(N'0' as bit)
EXECUTE sp_addextendedproperty N'MS_ColumnHidden', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Predznak'
SET @v = cast(N'0' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnOrder', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Predznak'
SET @v = cast(N'-1' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnWidth', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Predznak'
GO
DECLARE @v sql_variant 
SET @v = cast(N'0' as bit)
EXECUTE sp_addextendedproperty N'MS_ColumnHidden', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'AutoID'
SET @v = cast(N'0' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnOrder', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'AutoID'
SET @v = cast(N'-1' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnWidth', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'AutoID'
GO
DECLARE @v sql_variant 
SET @v = cast(N'0' as bit)
EXECUTE sp_addextendedproperty N'MS_ColumnHidden', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Vreme'
SET @v = cast(N'0' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnOrder', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Vreme'
SET @v = cast(N'-1' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnWidth', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Vreme'
GO
DECLARE @v sql_variant 
SET @v = cast(N'0' as bit)
EXECUTE sp_addextendedproperty N'MS_ColumnHidden', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Pristup'
SET @v = cast(N'0' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnOrder', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Pristup'
SET @v = cast(N'-1' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnWidth', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Pristup'
GO
DECLARE @v sql_variant 
SET @v = cast(N'0' as bit)
EXECUTE sp_addextendedproperty N'MS_ColumnHidden', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'DPO'
SET @v = cast(N'0' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnOrder', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'DPO'
SET @v = cast(N'-1' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnWidth', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'DPO'
GO
DECLARE @v sql_variant 
SET @v = cast(N'0' as bit)
EXECUTE sp_addextendedproperty N'MS_ColumnHidden', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Valuta'
SET @v = cast(N'0' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnOrder', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Valuta'
SET @v = cast(N'-1' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnWidth', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Valuta'
GO
DECLARE @v sql_variant 
SET @v = cast(N'0' as bit)
EXECUTE sp_addextendedproperty N'MS_ColumnHidden', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Klijent'
SET @v = cast(N'0' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnOrder', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Klijent'
SET @v = cast(N'-1' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnWidth', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Klijent'
GO
DECLARE @v sql_variant 
SET @v = cast(N'0' as bit)
EXECUTE sp_addextendedproperty N'MS_ColumnHidden', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'UserName'
SET @v = cast(N'0' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnOrder', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'UserName'
SET @v = cast(N'-1' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnWidth', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'UserName'
GO
DECLARE @v sql_variant 
SET @v = cast(N'0' as bit)
EXECUTE sp_addextendedproperty N'MS_ColumnHidden', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Paritet'
SET @v = cast(N'0' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnOrder', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Paritet'
SET @v = cast(N'-1' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnWidth', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Paritet'
GO
DECLARE @v sql_variant 
SET @v = cast(N'0' as bit)
EXECUTE sp_addextendedproperty N'MS_ColumnHidden', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Placanje'
SET @v = cast(N'0' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnOrder', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Placanje'
SET @v = cast(N'-1' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnWidth', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Placanje'
GO
DECLARE @v sql_variant 
SET @v = cast(N'0' as bit)
EXECUTE sp_addextendedproperty N'MS_ColumnHidden', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Napomena'
SET @v = cast(N'0' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnOrder', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Napomena'
SET @v = cast(N'-1' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnWidth', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Napomena'
GO
DECLARE @v sql_variant 
SET @v = cast(N'0' as bit)
EXECUTE sp_addextendedproperty N'MS_ColumnHidden', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Otprema'
SET @v = cast(N'0' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnOrder', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Otprema'
SET @v = cast(N'-1' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnWidth', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Otprema'
GO
DECLARE @v sql_variant 
SET @v = cast(N'0' as bit)
EXECUTE sp_addextendedproperty N'MS_ColumnHidden', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Vozilo'
SET @v = cast(N'0' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnOrder', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Vozilo'
SET @v = cast(N'-1' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnWidth', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Vozilo'
GO
DECLARE @v sql_variant 
SET @v = cast(N'0' as bit)
EXECUTE sp_addextendedproperty N'MS_ColumnHidden', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Vozac'
SET @v = cast(N'0' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnOrder', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Vozac'
SET @v = cast(N'-1' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnWidth', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Vozac'
GO
DECLARE @v sql_variant 
SET @v = cast(N'0' as bit)
EXECUTE sp_addextendedproperty N'MS_ColumnHidden', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'vIDStorno'
SET @v = cast(N'0' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnOrder', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'vIDStorno'
SET @v = cast(N'-1' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnWidth', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'vIDStorno'
GO
DECLARE @v sql_variant 
SET @v = cast(N'0' as bit)
EXECUTE sp_addextendedproperty N'MS_ColumnHidden', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'vIDNiv'
SET @v = cast(N'0' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnOrder', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'vIDNiv'
SET @v = cast(N'-1' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnWidth', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'vIDNiv'
GO
DECLARE @v sql_variant 
SET @v = cast(N'0' as bit)
EXECUTE sp_addextendedproperty N'MS_ColumnHidden', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'ParDokBroj'
SET @v = cast(N'0' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnOrder', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'ParDokBroj'
SET @v = cast(N'-1' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnWidth', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'ParDokBroj'
GO
DECLARE @v sql_variant 
SET @v = cast(N'0' as bit)
EXECUTE sp_addextendedproperty N'MS_ColumnHidden', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Avans'
SET @v = cast(N'0' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnOrder', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Avans'
SET @v = cast(N'-1' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnWidth', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Avans'
GO
DECLARE @v sql_variant 
SET @v = cast(N'0' as bit)
EXECUTE sp_addextendedproperty N'MS_ColumnHidden', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'FaktSaRabatIznos'
SET @v = cast(N'0' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnOrder', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'FaktSaRabatIznos'
SET @v = cast(N'-1' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnWidth', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'FaktSaRabatIznos'
GO
DECLARE @v sql_variant 
SET @v = cast(N'0' as bit)
EXECUTE sp_addextendedproperty N'MS_ColumnHidden', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Isporuka'
SET @v = cast(N'0' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnOrder', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Isporuka'
SET @v = cast(N'-1' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnWidth', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Isporuka'
GO
DECLARE @v sql_variant 
SET @v = cast(N'0' as bit)
EXECUTE sp_addextendedproperty N'MS_ColumnHidden', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'DatumDok'
SET @v = cast(N'0' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnOrder', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'DatumDok'
SET @v = cast(N'-1' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnWidth', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'DatumDok'
GO
DECLARE @v sql_variant 
SET @v = cast(N'0' as bit)
EXECUTE sp_addextendedproperty N'MS_ColumnHidden', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Moneta'
SET @v = cast(N'0' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnOrder', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Moneta'
SET @v = cast(N'-1' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnWidth', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Moneta'
GO
DECLARE @v sql_variant 
SET @v = cast(N'0' as bit)
EXECUTE sp_addextendedproperty N'MS_ColumnHidden', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Komercijalist'
SET @v = cast(N'0' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnOrder', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Komercijalist'
SET @v = cast(N'-1' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnWidth', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Komercijalist'
GO
DECLARE @v sql_variant 
SET @v = cast(N'0' as bit)
EXECUTE sp_addextendedproperty N'MS_ColumnHidden', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'vIDPrenos'
SET @v = cast(N'0' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnOrder', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'vIDPrenos'
SET @v = cast(N'-1' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnWidth', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'vIDPrenos'
GO
DECLARE @v sql_variant 
SET @v = cast(N'0' as bit)
EXECUTE sp_addextendedproperty N'MS_ColumnHidden', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Naplata'
SET @v = cast(N'0' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnOrder', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Naplata'
SET @v = cast(N'-1' as smallint)
EXECUTE sp_addextendedproperty N'MS_ColumnWidth', @v, N'user', N'dbo', N'table', N'Tmp_UlazIzlaz', N'column', N'Naplata'
GO
ALTER TABLE dbo.Tmp_UlazIzlaz ADD CONSTRAINT
	DF_UlazIzlaz_mID DEFAULT (0) FOR mID
GO
ALTER TABLE dbo.Tmp_UlazIzlaz ADD CONSTRAINT
	DF_UI_RAS DEFAULT (0) FOR RAS
GO
ALTER TABLE dbo.Tmp_UlazIzlaz ADD CONSTRAINT
	DF_UI_Datum DEFAULT (getdate()) FOR Datum
GO
ALTER TABLE dbo.Tmp_UlazIzlaz ADD CONSTRAINT
	DF_UI_Knjizenje DEFAULT (getdate()) FOR Knjizenje
GO
ALTER TABLE dbo.Tmp_UlazIzlaz ADD CONSTRAINT
	DF_UI_Broj DEFAULT ('') FOR Broj
GO
ALTER TABLE dbo.Tmp_UlazIzlaz ADD CONSTRAINT
	DF_UI_ParID DEFAULT (0) FOR ParID
GO
ALTER TABLE dbo.Tmp_UlazIzlaz ADD CONSTRAINT
	DF_UI_dtID DEFAULT (0) FOR dtID
GO
ALTER TABLE dbo.Tmp_UlazIzlaz ADD CONSTRAINT
	DF_UI_Predznak DEFAULT (0) FOR Predznak
GO
ALTER TABLE dbo.Tmp_UlazIzlaz ADD CONSTRAINT
	DF_UlazIzlaz_Vreme DEFAULT (0) FOR Vreme
GO
ALTER TABLE dbo.Tmp_UlazIzlaz ADD CONSTRAINT
	DF_UlazIzlaz_Pristup DEFAULT (0) FOR Pristup
GO
ALTER TABLE dbo.Tmp_UlazIzlaz ADD CONSTRAINT
	DF_UlazIzlaz_DPO DEFAULT (0) FOR DPO
GO
ALTER TABLE dbo.Tmp_UlazIzlaz ADD CONSTRAINT
	DF_UlazIzlaz_Valuta DEFAULT (0) FOR Valuta
GO
ALTER TABLE dbo.Tmp_UlazIzlaz ADD CONSTRAINT
	DF_UlazIzlaz_KlijentID DEFAULT (0) FOR Klijent
GO
ALTER TABLE dbo.Tmp_UlazIzlaz ADD CONSTRAINT
	DF_UlazIzlaz_UserID DEFAULT (0) FOR UserName
GO
ALTER TABLE dbo.Tmp_UlazIzlaz ADD CONSTRAINT
	DF_UlazIzlaz_Paritet DEFAULT ('0') FOR Paritet
GO
ALTER TABLE dbo.Tmp_UlazIzlaz ADD CONSTRAINT
	DF_UlazIzlaz_Placanje DEFAULT ('0') FOR Placanje
GO
ALTER TABLE dbo.Tmp_UlazIzlaz ADD CONSTRAINT
	DF_UlazIzlaz_Napomena DEFAULT ('') FOR Napomena
GO
ALTER TABLE dbo.Tmp_UlazIzlaz ADD CONSTRAINT
	DF_UlazIzlaz_Otprema DEFAULT ('0') FOR Otprema
GO
ALTER TABLE dbo.Tmp_UlazIzlaz ADD CONSTRAINT
	DF_UlazIzlaz_Vozilo DEFAULT ('') FOR Vozilo
GO
ALTER TABLE dbo.Tmp_UlazIzlaz ADD CONSTRAINT
	DF_UlazIzlaz_Vozac DEFAULT ('') FOR Vozac
GO
ALTER TABLE dbo.Tmp_UlazIzlaz ADD CONSTRAINT
	DF_UlazIzlaz_vIDStorno DEFAULT (0) FOR vIDStorno
GO
ALTER TABLE dbo.Tmp_UlazIzlaz ADD CONSTRAINT
	DF_UlazIzlaz_vIDNiv DEFAULT (0) FOR vIDNiv
GO
ALTER TABLE dbo.Tmp_UlazIzlaz ADD CONSTRAINT
	DF_UlazIzlaz_ParDokBroj DEFAULT ('') FOR ParDokBroj
GO
ALTER TABLE dbo.Tmp_UlazIzlaz ADD CONSTRAINT
	DF_UlazIzlaz_Avans DEFAULT (0) FOR Avans
GO
ALTER TABLE dbo.Tmp_UlazIzlaz ADD CONSTRAINT
	DF_UlazIzlaz_FaktSaRabatIznos DEFAULT (0) FOR FaktSaRabatIznos
GO
ALTER TABLE dbo.Tmp_UlazIzlaz ADD CONSTRAINT
	DF_UlazIzlaz_Isporuka DEFAULT (0) FOR Isporuka
GO
ALTER TABLE dbo.Tmp_UlazIzlaz ADD CONSTRAINT
	DF_UlazIzlaz_DatumDok DEFAULT (0) FOR DatumDok
GO
ALTER TABLE dbo.Tmp_UlazIzlaz ADD CONSTRAINT
	DF_UlazIzlaz_Moneta DEFAULT ('1') FOR Moneta
GO
ALTER TABLE dbo.Tmp_UlazIzlaz ADD CONSTRAINT
	DF_UlazIzlaz_Komercijalist DEFAULT (0) FOR Komercijalist
GO
ALTER TABLE dbo.Tmp_UlazIzlaz ADD CONSTRAINT
	DF_UlazIzlaz_vIDNiv1 DEFAULT (0) FOR vIDPrenos
GO
ALTER TABLE dbo.Tmp_UlazIzlaz ADD CONSTRAINT
	DF_UlazIzlaz_Naplata DEFAULT (0) FOR Naplata
GO
ALTER TABLE dbo.Tmp_UlazIzlaz ADD CONSTRAINT
	DF_UlazIzlaz_JCI DEFAULT ('') FOR JCI
GO
ALTER TABLE dbo.Tmp_UlazIzlaz ADD CONSTRAINT
	DF_UlazIzlaz_KursnaLista DEFAULT ('') FOR KursnaLista
GO
ALTER TABLE dbo.Tmp_UlazIzlaz ADD CONSTRAINT
	DF_UlazIzlaz_Kurs DEFAULT (1) FOR Kurs
GO
SET IDENTITY_INSERT dbo.Tmp_UlazIzlaz ON
GO
IF EXISTS(SELECT * FROM dbo.UlazIzlaz)
	 EXEC('INSERT INTO dbo.Tmp_UlazIzlaz (vID, mID, RAS, Datum, Knjizenje, Broj, ParID, dtID, Predznak, AutoID, Vreme, Pristup, DPO, Valuta, Klijent, UserName, Paritet, Placanje, Napomena, Otprema, Vozilo, Vozac, vIDStorno, vIDNiv, ParDokBroj, Avans, FaktSaRabatIznos, Isporuka, DatumDok, Moneta, Komercijalist, vIDPrenos, Naplata, JCI, KursnaLista, Kurs)
		SELECT vID, mID, RAS, Datum, Knjizenje, Broj, ParID, dtID, Predznak, AutoID, Vreme, Pristup, DPO, Valuta, Klijent, UserName, Paritet, Placanje, Napomena, Otprema, Vozilo, Vozac, vIDStorno, vIDNiv, ParDokBroj, Avans, FaktSaRabatIznos, Isporuka, DatumDok, Moneta, Komercijalist, vIDPrenos, Naplata, JCI, KursnaLista, Kurs FROM dbo.UlazIzlaz (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_UlazIzlaz OFF
GO
DROP TABLE dbo.UlazIzlaz
GO
EXECUTE sp_rename N'dbo.Tmp_UlazIzlaz', N'UlazIzlaz', 'OBJECT'
GO
ALTER TABLE dbo.UlazIzlaz ADD CONSTRAINT
	PK_UI PRIMARY KEY CLUSTERED 
	(
	vID
	) WITH FILLFACTOR = 70 ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX IX_UlazIzlaz ON dbo.UlazIzlaz
	(
	Datum
	) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX IX_UlazIzlaz_1 ON dbo.UlazIzlaz
	(
	Knjizenje,
	vID
	) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX IX_UlazIzlaz_2 ON dbo.UlazIzlaz
	(
	RAS
	) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX IX_UI ON dbo.UlazIzlaz
	(
	Knjizenje
	) WITH FILLFACTOR = 70 ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX IX_UlazIzlaz_3 ON dbo.UlazIzlaz
	(
	vID,
	RAS
	) ON [PRIMARY]
GO
CREATE TRIGGER trigSrediPro
ON dbo.UlazIzlaz
AFTER UPDATE

AS 

--SELECT 0[vID], 1[mID], 2[RAS], 3[Datum], 4[Knjizenje], 5[Broj], 6[ParID], 7[dtID], 8[Predznak], 9[AutoID], 10[Vreme], 11[Pristup], 12[DPO], 13[Valuta], 14[Klijent], 15[UserName], 16[Paritet], 17[Placanje], 18[Napomena], 19[Otprema], 20[Vozilo], 21[Vozac], 22[vIDStorno], 23[vIDNiv], 24[ParDokBroj], 25[Avans], 26[FaktSaRabatIznos], 27[Isporuka], 28[DatumDok], 29[Moneta], 30[Komercijalist], 31[vIDPrenos], 32[Naplata], 33[JCI], 34[KursnaLista], 35[Kurs] FROM [UlazIzlaz]
BEGIN

	DECLARE @vID AS INT
	DECLARE @RAS as bigint
	DECLARE @dtID as varchar(5)
	SELECT @vID = vID, @RAS = RAS, @dtID = dtID FROM inserted
	
-- 	IF SUBSTRING(COLUMNS_UPDATED(), 1, 1) & 4 = 4 --RAS
-- 	BEGIN
-- 		IF @RAS & 1 = 1 --OR (@dtID IN ('40222')) --Knjizen u robno OR Faktura gotovinska (za pazar)
--		BEGIN
-- 			--raiserror ('RAS proknjizen' ,16, 1)
-- 			EXEC [ecSrediProOdVeze] @vID
-- 		END
-- 	END

END
GO
CREATE TRIGGER [DelTotal] ON dbo.UlazIzlaz 
FOR DELETE 
AS
DELETE FROM UlazIzlazSumm
WHERE vID IN (Select vID from deleted)
GO
COMMIT


--UlazIzlazDetalj
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
ALTER TABLE dbo.UlazIzlazDetalj
	DROP CONSTRAINT DF_UID_RedBr
GO
ALTER TABLE dbo.UlazIzlazDetalj
	DROP CONSTRAINT DF_UID_Kol
GO
ALTER TABLE dbo.UlazIzlazDetalj
	DROP CONSTRAINT DF_UID_Cena
GO
ALTER TABLE dbo.UlazIzlazDetalj
	DROP CONSTRAINT DF_UlazIzlazDetalj_CSaPor
GO
ALTER TABLE dbo.UlazIzlazDetalj
	DROP CONSTRAINT DF_UID_Rabat
GO
ALTER TABLE dbo.UlazIzlazDetalj
	DROP CONSTRAINT DF_UID_Porez
GO
ALTER TABLE dbo.UlazIzlazDetalj
	DROP CONSTRAINT DF_UID_Tarifa
GO
ALTER TABLE dbo.UlazIzlazDetalj
	DROP CONSTRAINT DF_UID_Koef
GO
ALTER TABLE dbo.UlazIzlazDetalj
	DROP CONSTRAINT DF_UID_Realna
GO
ALTER TABLE dbo.UlazIzlazDetalj
	DROP CONSTRAINT DF_UlazIzlazDetalj_Fakturna
GO
ALTER TABLE dbo.UlazIzlazDetalj
	DROP CONSTRAINT DF_UlazIzlazDetalj_RabatFak
GO
ALTER TABLE dbo.UlazIzlazDetalj
	DROP CONSTRAINT DF_UlazIzlazDetalj_Akciza
GO
ALTER TABLE dbo.UlazIzlazDetalj
	DROP CONSTRAINT DF_UlazIzlazDetalj_Carina
GO
ALTER TABLE dbo.UlazIzlazDetalj
	DROP CONSTRAINT DF_UlazIzlazDetalj_Naziv
GO
ALTER TABLE dbo.UlazIzlazDetalj
	DROP CONSTRAINT DF_UlazIzlazDetalj_StaraCena
GO
ALTER TABLE dbo.UlazIzlazDetalj
	DROP CONSTRAINT DF_UlazIzlazDetalj_StaraCena1
GO
ALTER TABLE dbo.UlazIzlazDetalj
	DROP CONSTRAINT DF_UlazIzlazDetalj_StaraKol
GO
ALTER TABLE dbo.UlazIzlazDetalj
	DROP CONSTRAINT DF_UlazIzlazDetalj_Trosak
GO
ALTER TABLE dbo.UlazIzlazDetalj
	DROP CONSTRAINT DF_UlazIzlazDetalj_StvarnaKol
GO
ALTER TABLE dbo.UlazIzlazDetalj
	DROP CONSTRAINT DF_UlazIzlazDetalj_CProdPrenos
GO
ALTER TABLE dbo.UlazIzlazDetalj
	DROP CONSTRAINT DF_UlazIzlazDetalj_CProdPrenosBPor
GO
ALTER TABLE dbo.UlazIzlazDetalj
	DROP CONSTRAINT DF_UlazIzlazDetalj_PDV
GO
ALTER TABLE dbo.UlazIzlazDetalj
	DROP CONSTRAINT DF_UlazIzlazDetalj_ecBit
GO
ALTER TABLE dbo.UlazIzlazDetalj
	DROP CONSTRAINT DF_UlazIzlazDetalj_PredznakParcijalneNiv
GO
ALTER TABLE dbo.UlazIzlazDetalj
	DROP CONSTRAINT DF_UlazIzlazDetalj_PrenosRabat
GO
ALTER TABLE dbo.UlazIzlazDetalj
	DROP CONSTRAINT DF_UlazIzlazDetalj_vPrenos
GO
ALTER TABLE dbo.UlazIzlazDetalj
	DROP CONSTRAINT DF_UlazIzlazDetalj_MarzaPrenos
GO
ALTER TABLE dbo.UlazIzlazDetalj
	DROP CONSTRAINT DF_UlazIzlazDetalj_Kol1
GO
ALTER TABLE dbo.UlazIzlazDetalj
	DROP CONSTRAINT DF_UlazIzlazDetalj_Bruto1
GO
ALTER TABLE dbo.UlazIzlazDetalj
	DROP CONSTRAINT DF_UlazIzlazDetalj_vJCI
GO
CREATE TABLE dbo.Tmp_UlazIzlazDetalj
	(
	AutoID int NOT NULL,
	vID int NOT NULL,
	RedBr int NULL,
	ProID nvarchar(50) NOT NULL,
	Kol numeric(18, 9) NULL,
	Cena numeric(18, 9) NULL,
	CSaPor numeric(18, 9) NULL,
	Rabat numeric(18, 9) NULL,
	Porez numeric(18, 9) NULL,
	Tarifa numeric(18, 9) NULL,
	Koef numeric(18, 9) NULL,
	Realna numeric(18, 9) NULL,
	Fakturna numeric(18, 9) NULL,
	RabatFak numeric(18, 9) NULL,
	Akciza numeric(18, 9) NULL,
	Carina numeric(18, 9) NULL,
	Naziv nvarchar(2000) NULL,
	StaraCena numeric(18, 9) NULL,
	StaraCenaSaPor numeric(18, 9) NULL,
	StaraKol numeric(18, 9) NULL,
	Trosak numeric(18, 9) NULL,
	StvarnaKol numeric(18, 9) NULL,
	CProdPrenos numeric(18, 9) NULL,
	CProdPrenosBPor numeric(18, 9) NULL,
	PDV numeric(18, 9) NULL,
	ecBit tinyint NULL,
	PredznakParcijalneNiv smallint NULL,
	PrenosRabat numeric(18, 9) NULL,
	vPrenos int NULL,
	MarzaPrenos numeric(18, 9) NULL,
	Bruto numeric(18, 9) NULL,
	Neto numeric(18, 9) NULL,
	vJCI varchar(250) NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_UlazIzlazDetalj ADD CONSTRAINT
	DF_UID_RedBr DEFAULT (0) FOR RedBr
GO
ALTER TABLE dbo.Tmp_UlazIzlazDetalj ADD CONSTRAINT
	DF_UID_Kol DEFAULT (0) FOR Kol
GO
ALTER TABLE dbo.Tmp_UlazIzlazDetalj ADD CONSTRAINT
	DF_UID_Cena DEFAULT (0) FOR Cena
GO
ALTER TABLE dbo.Tmp_UlazIzlazDetalj ADD CONSTRAINT
	DF_UlazIzlazDetalj_CSaPor DEFAULT (0) FOR CSaPor
GO
ALTER TABLE dbo.Tmp_UlazIzlazDetalj ADD CONSTRAINT
	DF_UID_Rabat DEFAULT (0) FOR Rabat
GO
ALTER TABLE dbo.Tmp_UlazIzlazDetalj ADD CONSTRAINT
	DF_UID_Porez DEFAULT (0) FOR Porez
GO
ALTER TABLE dbo.Tmp_UlazIzlazDetalj ADD CONSTRAINT
	DF_UID_Tarifa DEFAULT (0) FOR Tarifa
GO
ALTER TABLE dbo.Tmp_UlazIzlazDetalj ADD CONSTRAINT
	DF_UID_Koef DEFAULT (1) FOR Koef
GO
ALTER TABLE dbo.Tmp_UlazIzlazDetalj ADD CONSTRAINT
	DF_UID_Realna DEFAULT (0) FOR Realna
GO
ALTER TABLE dbo.Tmp_UlazIzlazDetalj ADD CONSTRAINT
	DF_UlazIzlazDetalj_Fakturna DEFAULT (0) FOR Fakturna
GO
ALTER TABLE dbo.Tmp_UlazIzlazDetalj ADD CONSTRAINT
	DF_UlazIzlazDetalj_RabatFak DEFAULT (0) FOR RabatFak
GO
ALTER TABLE dbo.Tmp_UlazIzlazDetalj ADD CONSTRAINT
	DF_UlazIzlazDetalj_Akciza DEFAULT (0) FOR Akciza
GO
ALTER TABLE dbo.Tmp_UlazIzlazDetalj ADD CONSTRAINT
	DF_UlazIzlazDetalj_Carina DEFAULT (0) FOR Carina
GO
ALTER TABLE dbo.Tmp_UlazIzlazDetalj ADD CONSTRAINT
	DF_UlazIzlazDetalj_Naziv DEFAULT ('') FOR Naziv
GO
ALTER TABLE dbo.Tmp_UlazIzlazDetalj ADD CONSTRAINT
	DF_UlazIzlazDetalj_StaraCena DEFAULT (0) FOR StaraCena
GO
ALTER TABLE dbo.Tmp_UlazIzlazDetalj ADD CONSTRAINT
	DF_UlazIzlazDetalj_StaraCena1 DEFAULT (0) FOR StaraCenaSaPor
GO
ALTER TABLE dbo.Tmp_UlazIzlazDetalj ADD CONSTRAINT
	DF_UlazIzlazDetalj_StaraKol DEFAULT (0) FOR StaraKol
GO
ALTER TABLE dbo.Tmp_UlazIzlazDetalj ADD CONSTRAINT
	DF_UlazIzlazDetalj_Trosak DEFAULT (0) FOR Trosak
GO
ALTER TABLE dbo.Tmp_UlazIzlazDetalj ADD CONSTRAINT
	DF_UlazIzlazDetalj_StvarnaKol DEFAULT (0) FOR StvarnaKol
GO
ALTER TABLE dbo.Tmp_UlazIzlazDetalj ADD CONSTRAINT
	DF_UlazIzlazDetalj_CProdPrenos DEFAULT (0) FOR CProdPrenos
GO
ALTER TABLE dbo.Tmp_UlazIzlazDetalj ADD CONSTRAINT
	DF_UlazIzlazDetalj_CProdPrenosBPor DEFAULT (0) FOR CProdPrenosBPor
GO
ALTER TABLE dbo.Tmp_UlazIzlazDetalj ADD CONSTRAINT
	DF_UlazIzlazDetalj_PDV DEFAULT (0) FOR PDV
GO
ALTER TABLE dbo.Tmp_UlazIzlazDetalj ADD CONSTRAINT
	DF_UlazIzlazDetalj_ecBit DEFAULT (0) FOR ecBit
GO
ALTER TABLE dbo.Tmp_UlazIzlazDetalj ADD CONSTRAINT
	DF_UlazIzlazDetalj_PredznakParcijalneNiv DEFAULT (0) FOR PredznakParcijalneNiv
GO
ALTER TABLE dbo.Tmp_UlazIzlazDetalj ADD CONSTRAINT
	DF_UlazIzlazDetalj_PrenosRabat DEFAULT (0) FOR PrenosRabat
GO
ALTER TABLE dbo.Tmp_UlazIzlazDetalj ADD CONSTRAINT
	DF_UlazIzlazDetalj_vPrenos DEFAULT (0) FOR vPrenos
GO
ALTER TABLE dbo.Tmp_UlazIzlazDetalj ADD CONSTRAINT
	DF_UlazIzlazDetalj_MarzaPrenos DEFAULT (0) FOR MarzaPrenos
GO
ALTER TABLE dbo.Tmp_UlazIzlazDetalj ADD CONSTRAINT
	DF_UlazIzlazDetalj_Kol1 DEFAULT (0) FOR Bruto
GO
ALTER TABLE dbo.Tmp_UlazIzlazDetalj ADD CONSTRAINT
	DF_UlazIzlazDetalj_Bruto1 DEFAULT (0) FOR Neto
GO
ALTER TABLE dbo.Tmp_UlazIzlazDetalj ADD CONSTRAINT
	DF_UlazIzlazDetalj_vJCI DEFAULT ('') FOR vJCI
GO
IF EXISTS(SELECT * FROM dbo.UlazIzlazDetalj)
	 EXEC('INSERT INTO dbo.Tmp_UlazIzlazDetalj (AutoID, vID, RedBr, ProID, Kol, Cena, CSaPor, Rabat, Porez, Tarifa, Koef, Realna, Fakturna, RabatFak, Akciza, Carina, Naziv, StaraCena, StaraCenaSaPor, StaraKol, Trosak, StvarnaKol, CProdPrenos, CProdPrenosBPor, PDV, ecBit, PredznakParcijalneNiv, PrenosRabat, vPrenos, MarzaPrenos, Bruto, Neto, vJCI)
		SELECT AutoID, vID, RedBr, ProID, Kol, Cena, CSaPor, Rabat, Porez, Tarifa, Koef, Realna, Fakturna, RabatFak, Akciza, Carina, Naziv, StaraCena, StaraCenaSaPor, StaraKol, Trosak, StvarnaKol, CProdPrenos, CProdPrenosBPor, PDV, ecBit, PredznakParcijalneNiv, PrenosRabat, vPrenos, MarzaPrenos, Bruto, Neto, vJCI FROM dbo.UlazIzlazDetalj (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.UlazIzlazDetalj
GO
EXECUTE sp_rename N'dbo.Tmp_UlazIzlazDetalj', N'UlazIzlazDetalj', 'OBJECT'
GO
ALTER TABLE dbo.UlazIzlazDetalj ADD CONSTRAINT
	PK_UlazIzlazDetalj PRIMARY KEY CLUSTERED 
	(
	AutoID
	) WITH FILLFACTOR = 70 ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX IX_UlazIzlazDetalj ON dbo.UlazIzlazDetalj
	(
	vID
	) WITH FILLFACTOR = 70 ON [PRIMARY]
GO
CREATE  TRIGGER trigSetSumm
ON dbo.UlazIzlazDetalj
AFTER INSERT,  UPDATE

AS 

--                      0        1          2            3         4       5             6             7            8           9         10        11              12            13                14          15        16             17                   18                       19             20             21                22                           23                   24        25             26                                    27                   28                29              30        31      32
--SELECT [AutoID], [vID], [RedBr], [ProID], [Kol], [Cena], [CSaPor], [Rabat], [Porez], [Tarifa], [Koef], [Realna], [Fakturna], [RabatFak], [Akciza], [Carina], [Naziv], [StaraCena], [StaraCenaSaPor], [StaraKol], [Trosak], [StvarnaKol], [CProdPrenos], [CProdPrenosBPor], [PDV], [ecBit], [PredznakParcijalneNiv], [PrenosRabat], [vPrenos], [MarzaPrenos], [Bruto], [Neto], [vJCI] FROM [UlazIzlazDetalj]
----TODO
-- IF ( (SUBSTRING(COLUMNS_UPDATED(),1,1)=power(2,(3-1))
--       + power(2,(5-1))) 
--       AND (SUBSTRING(COLUMNS_UPDATED(),2,1)=power(2,(1-1)))
--       ) 
--PRINT 'Columns 3, 5 and 9 updated'

BEGIN


	DECLARE @vID AS INT
	DECLARE @NUM AS INT
	DECLARE @I AS INT
	
	--SELECT @vID = vID FROM inserted
	CREATE TABLE #Tmp
	(
		[AutoID] [int] IDENTITY (1, 1) NOT NULL ,
		vID INT
	)
	INSERT INTO #Tmp SELECT DISTINCT vID FROM inserted
	SET @NUM = @@ROWCOUNT
	SET @I = 0
	
	WHILE @I < @NUM
	BEGIN
		SET @I = @I + 1
		SELECT @vID = vID FROM #tmp WHERE AutoID = @I

declare @aid as int
insert into TempTrig(vid,opis,od,do)
select @vID, '',getdate(),getdate()
select @aid = max(aid) from TempTrig

		EXEC [trigSum] @vID

update TempTrig set do=getdate() where aid= @aid

	END
	
	--EXEC [trigSum] @vID
	DROP TABLE #Tmp


END
----Primjer
-- CREATE TRIGGER updEmployeeData 
-- ON employeeData 
-- FOR update AS
-- /*Check whether columns 2, 3 or 4 has been updated. If any or all of columns 2, 3 or 4 have been changed, create an audit record. The bitmask is: power(2,(2-1))+power(2,(3-1))+power(2,(4-1)) = 14. To check if all columns 2, 3, and 4 are updated, use = 14 in place of >0 (below).*/
-- 
--    IF (COLUMNS_UPDATED() & 14) > 0
-- /*Use IF (COLUMNS_UPDATED() & 14) = 14 to see if all of columns 2, 3, and 4 are updated.*/
--       BEGIN
-- -- Audit OLD record.
--       INSERT INTO auditEmployeeData
--          (audit_log_type,
--          audit_emp_id,
--          audit_emp_bankAccountNumber,
--          audit_emp_salary,
--          audit_emp_SSN)
--          SELECT 'OLD', 
--             del.emp_id,
--             del.emp_bankAccountNumber,
--             del.emp_salary,
--             del.emp_SSN
--          FROM deleted del
-- 
-- -- Audit NEW record.
--       INSERT INTO auditEmployeeData
--          (audit_log_type,
--          audit_emp_id,
--          audit_emp_bankAccountNumber,
--          audit_emp_salary,
--          audit_emp_SSN)
--          SELECT 'NEW',
--             ins.emp_id,
--             ins.emp_bankAccountNumber,
--             ins.emp_salary,
--             ins.emp_SSN
--          FROM inserted ins
--    END
GO
CREATE TRIGGER trigSetSummOnDel
ON dbo.UlazIzlazDetalj
FOR DELETE

AS 

BEGIN
	DECLARE @vID AS INT
	SELECT @vID = vID FROM deleted

	EXEC [trigSum] @vID
END
GO
COMMIT

BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
ALTER TABLE dbo.UlazIzlazDetalj
	DROP CONSTRAINT DF_UID_RedBr
GO
ALTER TABLE dbo.UlazIzlazDetalj
	DROP CONSTRAINT DF_UID_Kol
GO
ALTER TABLE dbo.UlazIzlazDetalj
	DROP CONSTRAINT DF_UID_Cena
GO
ALTER TABLE dbo.UlazIzlazDetalj
	DROP CONSTRAINT DF_UlazIzlazDetalj_CSaPor
GO
ALTER TABLE dbo.UlazIzlazDetalj
	DROP CONSTRAINT DF_UID_Rabat
GO
ALTER TABLE dbo.UlazIzlazDetalj
	DROP CONSTRAINT DF_UID_Porez
GO
ALTER TABLE dbo.UlazIzlazDetalj
	DROP CONSTRAINT DF_UID_Tarifa
GO
ALTER TABLE dbo.UlazIzlazDetalj
	DROP CONSTRAINT DF_UID_Koef
GO
ALTER TABLE dbo.UlazIzlazDetalj
	DROP CONSTRAINT DF_UID_Realna
GO
ALTER TABLE dbo.UlazIzlazDetalj
	DROP CONSTRAINT DF_UlazIzlazDetalj_Fakturna
GO
ALTER TABLE dbo.UlazIzlazDetalj
	DROP CONSTRAINT DF_UlazIzlazDetalj_RabatFak
GO
ALTER TABLE dbo.UlazIzlazDetalj
	DROP CONSTRAINT DF_UlazIzlazDetalj_Akciza
GO
ALTER TABLE dbo.UlazIzlazDetalj
	DROP CONSTRAINT DF_UlazIzlazDetalj_Carina
GO
ALTER TABLE dbo.UlazIzlazDetalj
	DROP CONSTRAINT DF_UlazIzlazDetalj_Naziv
GO
ALTER TABLE dbo.UlazIzlazDetalj
	DROP CONSTRAINT DF_UlazIzlazDetalj_StaraCena
GO
ALTER TABLE dbo.UlazIzlazDetalj
	DROP CONSTRAINT DF_UlazIzlazDetalj_StaraCena1
GO
ALTER TABLE dbo.UlazIzlazDetalj
	DROP CONSTRAINT DF_UlazIzlazDetalj_StaraKol
GO
ALTER TABLE dbo.UlazIzlazDetalj
	DROP CONSTRAINT DF_UlazIzlazDetalj_Trosak
GO
ALTER TABLE dbo.UlazIzlazDetalj
	DROP CONSTRAINT DF_UlazIzlazDetalj_StvarnaKol
GO
ALTER TABLE dbo.UlazIzlazDetalj
	DROP CONSTRAINT DF_UlazIzlazDetalj_CProdPrenos
GO
ALTER TABLE dbo.UlazIzlazDetalj
	DROP CONSTRAINT DF_UlazIzlazDetalj_CProdPrenosBPor
GO
ALTER TABLE dbo.UlazIzlazDetalj
	DROP CONSTRAINT DF_UlazIzlazDetalj_PDV
GO
ALTER TABLE dbo.UlazIzlazDetalj
	DROP CONSTRAINT DF_UlazIzlazDetalj_ecBit
GO
ALTER TABLE dbo.UlazIzlazDetalj
	DROP CONSTRAINT DF_UlazIzlazDetalj_PredznakParcijalneNiv
GO
ALTER TABLE dbo.UlazIzlazDetalj
	DROP CONSTRAINT DF_UlazIzlazDetalj_PrenosRabat
GO
ALTER TABLE dbo.UlazIzlazDetalj
	DROP CONSTRAINT DF_UlazIzlazDetalj_vPrenos
GO
ALTER TABLE dbo.UlazIzlazDetalj
	DROP CONSTRAINT DF_UlazIzlazDetalj_MarzaPrenos
GO
ALTER TABLE dbo.UlazIzlazDetalj
	DROP CONSTRAINT DF_UlazIzlazDetalj_Kol1
GO
ALTER TABLE dbo.UlazIzlazDetalj
	DROP CONSTRAINT DF_UlazIzlazDetalj_Bruto1
GO
ALTER TABLE dbo.UlazIzlazDetalj
	DROP CONSTRAINT DF_UlazIzlazDetalj_vJCI
GO
CREATE TABLE dbo.Tmp_UlazIzlazDetalj
	(
	AutoID int NOT NULL IDENTITY (1, 1),
	vID int NOT NULL,
	RedBr int NULL,
	ProID nvarchar(50) NOT NULL,
	Kol numeric(18, 9) NULL,
	Cena numeric(18, 9) NULL,
	CSaPor numeric(18, 9) NULL,
	Rabat numeric(18, 9) NULL,
	Porez numeric(18, 9) NULL,
	Tarifa numeric(18, 9) NULL,
	Koef numeric(18, 9) NULL,
	Realna numeric(18, 9) NULL,
	Fakturna numeric(18, 9) NULL,
	RabatFak numeric(18, 9) NULL,
	Akciza numeric(18, 9) NULL,
	Carina numeric(18, 9) NULL,
	Naziv nvarchar(2000) NULL,
	StaraCena numeric(18, 9) NULL,
	StaraCenaSaPor numeric(18, 9) NULL,
	StaraKol numeric(18, 9) NULL,
	Trosak numeric(18, 9) NULL,
	StvarnaKol numeric(18, 9) NULL,
	CProdPrenos numeric(18, 9) NULL,
	CProdPrenosBPor numeric(18, 9) NULL,
	PDV numeric(18, 9) NULL,
	ecBit tinyint NULL,
	PredznakParcijalneNiv smallint NULL,
	PrenosRabat numeric(18, 9) NULL,
	vPrenos int NULL,
	MarzaPrenos numeric(18, 9) NULL,
	Bruto numeric(18, 9) NULL,
	Neto numeric(18, 9) NULL,
	vJCI varchar(250) NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_UlazIzlazDetalj ADD CONSTRAINT
	DF_UID_RedBr DEFAULT (0) FOR RedBr
GO
ALTER TABLE dbo.Tmp_UlazIzlazDetalj ADD CONSTRAINT
	DF_UID_Kol DEFAULT (0) FOR Kol
GO
ALTER TABLE dbo.Tmp_UlazIzlazDetalj ADD CONSTRAINT
	DF_UID_Cena DEFAULT (0) FOR Cena
GO
ALTER TABLE dbo.Tmp_UlazIzlazDetalj ADD CONSTRAINT
	DF_UlazIzlazDetalj_CSaPor DEFAULT (0) FOR CSaPor
GO
ALTER TABLE dbo.Tmp_UlazIzlazDetalj ADD CONSTRAINT
	DF_UID_Rabat DEFAULT (0) FOR Rabat
GO
ALTER TABLE dbo.Tmp_UlazIzlazDetalj ADD CONSTRAINT
	DF_UID_Porez DEFAULT (0) FOR Porez
GO
ALTER TABLE dbo.Tmp_UlazIzlazDetalj ADD CONSTRAINT
	DF_UID_Tarifa DEFAULT (0) FOR Tarifa
GO
ALTER TABLE dbo.Tmp_UlazIzlazDetalj ADD CONSTRAINT
	DF_UID_Koef DEFAULT (1) FOR Koef
GO
ALTER TABLE dbo.Tmp_UlazIzlazDetalj ADD CONSTRAINT
	DF_UID_Realna DEFAULT (0) FOR Realna
GO
ALTER TABLE dbo.Tmp_UlazIzlazDetalj ADD CONSTRAINT
	DF_UlazIzlazDetalj_Fakturna DEFAULT (0) FOR Fakturna
GO
ALTER TABLE dbo.Tmp_UlazIzlazDetalj ADD CONSTRAINT
	DF_UlazIzlazDetalj_RabatFak DEFAULT (0) FOR RabatFak
GO
ALTER TABLE dbo.Tmp_UlazIzlazDetalj ADD CONSTRAINT
	DF_UlazIzlazDetalj_Akciza DEFAULT (0) FOR Akciza
GO
ALTER TABLE dbo.Tmp_UlazIzlazDetalj ADD CONSTRAINT
	DF_UlazIzlazDetalj_Carina DEFAULT (0) FOR Carina
GO
ALTER TABLE dbo.Tmp_UlazIzlazDetalj ADD CONSTRAINT
	DF_UlazIzlazDetalj_Naziv DEFAULT ('') FOR Naziv
GO
ALTER TABLE dbo.Tmp_UlazIzlazDetalj ADD CONSTRAINT
	DF_UlazIzlazDetalj_StaraCena DEFAULT (0) FOR StaraCena
GO
ALTER TABLE dbo.Tmp_UlazIzlazDetalj ADD CONSTRAINT
	DF_UlazIzlazDetalj_StaraCena1 DEFAULT (0) FOR StaraCenaSaPor
GO
ALTER TABLE dbo.Tmp_UlazIzlazDetalj ADD CONSTRAINT
	DF_UlazIzlazDetalj_StaraKol DEFAULT (0) FOR StaraKol
GO
ALTER TABLE dbo.Tmp_UlazIzlazDetalj ADD CONSTRAINT
	DF_UlazIzlazDetalj_Trosak DEFAULT (0) FOR Trosak
GO
ALTER TABLE dbo.Tmp_UlazIzlazDetalj ADD CONSTRAINT
	DF_UlazIzlazDetalj_StvarnaKol DEFAULT (0) FOR StvarnaKol
GO
ALTER TABLE dbo.Tmp_UlazIzlazDetalj ADD CONSTRAINT
	DF_UlazIzlazDetalj_CProdPrenos DEFAULT (0) FOR CProdPrenos
GO
ALTER TABLE dbo.Tmp_UlazIzlazDetalj ADD CONSTRAINT
	DF_UlazIzlazDetalj_CProdPrenosBPor DEFAULT (0) FOR CProdPrenosBPor
GO
ALTER TABLE dbo.Tmp_UlazIzlazDetalj ADD CONSTRAINT
	DF_UlazIzlazDetalj_PDV DEFAULT (0) FOR PDV
GO
ALTER TABLE dbo.Tmp_UlazIzlazDetalj ADD CONSTRAINT
	DF_UlazIzlazDetalj_ecBit DEFAULT (0) FOR ecBit
GO
ALTER TABLE dbo.Tmp_UlazIzlazDetalj ADD CONSTRAINT
	DF_UlazIzlazDetalj_PredznakParcijalneNiv DEFAULT (0) FOR PredznakParcijalneNiv
GO
ALTER TABLE dbo.Tmp_UlazIzlazDetalj ADD CONSTRAINT
	DF_UlazIzlazDetalj_PrenosRabat DEFAULT (0) FOR PrenosRabat
GO
ALTER TABLE dbo.Tmp_UlazIzlazDetalj ADD CONSTRAINT
	DF_UlazIzlazDetalj_vPrenos DEFAULT (0) FOR vPrenos
GO
ALTER TABLE dbo.Tmp_UlazIzlazDetalj ADD CONSTRAINT
	DF_UlazIzlazDetalj_MarzaPrenos DEFAULT (0) FOR MarzaPrenos
GO
ALTER TABLE dbo.Tmp_UlazIzlazDetalj ADD CONSTRAINT
	DF_UlazIzlazDetalj_Kol1 DEFAULT (0) FOR Bruto
GO
ALTER TABLE dbo.Tmp_UlazIzlazDetalj ADD CONSTRAINT
	DF_UlazIzlazDetalj_Bruto1 DEFAULT (0) FOR Neto
GO
ALTER TABLE dbo.Tmp_UlazIzlazDetalj ADD CONSTRAINT
	DF_UlazIzlazDetalj_vJCI DEFAULT ('') FOR vJCI
GO
SET IDENTITY_INSERT dbo.Tmp_UlazIzlazDetalj ON
GO
IF EXISTS(SELECT * FROM dbo.UlazIzlazDetalj)
	 EXEC('INSERT INTO dbo.Tmp_UlazIzlazDetalj (AutoID, vID, RedBr, ProID, Kol, Cena, CSaPor, Rabat, Porez, Tarifa, Koef, Realna, Fakturna, RabatFak, Akciza, Carina, Naziv, StaraCena, StaraCenaSaPor, StaraKol, Trosak, StvarnaKol, CProdPrenos, CProdPrenosBPor, PDV, ecBit, PredznakParcijalneNiv, PrenosRabat, vPrenos, MarzaPrenos, Bruto, Neto, vJCI)
		SELECT AutoID, vID, RedBr, ProID, Kol, Cena, CSaPor, Rabat, Porez, Tarifa, Koef, Realna, Fakturna, RabatFak, Akciza, Carina, Naziv, StaraCena, StaraCenaSaPor, StaraKol, Trosak, StvarnaKol, CProdPrenos, CProdPrenosBPor, PDV, ecBit, PredznakParcijalneNiv, PrenosRabat, vPrenos, MarzaPrenos, Bruto, Neto, vJCI FROM dbo.UlazIzlazDetalj (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_UlazIzlazDetalj OFF
GO
DROP TABLE dbo.UlazIzlazDetalj
GO
EXECUTE sp_rename N'dbo.Tmp_UlazIzlazDetalj', N'UlazIzlazDetalj', 'OBJECT'
GO
ALTER TABLE dbo.UlazIzlazDetalj ADD CONSTRAINT
	PK_UlazIzlazDetalj PRIMARY KEY CLUSTERED 
	(
	AutoID
	) WITH FILLFACTOR = 70 ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX IX_UlazIzlazDetalj ON dbo.UlazIzlazDetalj
	(
	vID
	) WITH FILLFACTOR = 70 ON [PRIMARY]
GO
CREATE  TRIGGER trigSetSumm
ON dbo.UlazIzlazDetalj
AFTER INSERT,  UPDATE

AS 

--                      0        1          2            3         4       5             6             7            8           9         10        11              12            13                14          15        16             17                   18                       19             20             21                22                           23                   24        25             26                                    27                   28                29              30        31      32
--SELECT [AutoID], [vID], [RedBr], [ProID], [Kol], [Cena], [CSaPor], [Rabat], [Porez], [Tarifa], [Koef], [Realna], [Fakturna], [RabatFak], [Akciza], [Carina], [Naziv], [StaraCena], [StaraCenaSaPor], [StaraKol], [Trosak], [StvarnaKol], [CProdPrenos], [CProdPrenosBPor], [PDV], [ecBit], [PredznakParcijalneNiv], [PrenosRabat], [vPrenos], [MarzaPrenos], [Bruto], [Neto], [vJCI] FROM [UlazIzlazDetalj]
----TODO
-- IF ( (SUBSTRING(COLUMNS_UPDATED(),1,1)=power(2,(3-1))
--       + power(2,(5-1))) 
--       AND (SUBSTRING(COLUMNS_UPDATED(),2,1)=power(2,(1-1)))
--       ) 
--PRINT 'Columns 3, 5 and 9 updated'

BEGIN


	DECLARE @vID AS INT
	DECLARE @NUM AS INT
	DECLARE @I AS INT
	
	--SELECT @vID = vID FROM inserted
	CREATE TABLE #Tmp
	(
		[AutoID] [int] IDENTITY (1, 1) NOT NULL ,
		vID INT
	)
	INSERT INTO #Tmp SELECT DISTINCT vID FROM inserted
	SET @NUM = @@ROWCOUNT
	SET @I = 0
	
	WHILE @I < @NUM
	BEGIN
		SET @I = @I + 1
		SELECT @vID = vID FROM #tmp WHERE AutoID = @I

declare @aid as int
insert into TempTrig(vid,opis,od,do)
select @vID, '',getdate(),getdate()
select @aid = max(aid) from TempTrig

		EXEC [trigSum] @vID

update TempTrig set do=getdate() where aid= @aid

	END
	
	--EXEC [trigSum] @vID
	DROP TABLE #Tmp


END
----Primjer
-- CREATE TRIGGER updEmployeeData 
-- ON employeeData 
-- FOR update AS
-- /*Check whether columns 2, 3 or 4 has been updated. If any or all of columns 2, 3 or 4 have been changed, create an audit record. The bitmask is: power(2,(2-1))+power(2,(3-1))+power(2,(4-1)) = 14. To check if all columns 2, 3, and 4 are updated, use = 14 in place of >0 (below).*/
-- 
--    IF (COLUMNS_UPDATED() & 14) > 0
-- /*Use IF (COLUMNS_UPDATED() & 14) = 14 to see if all of columns 2, 3, and 4 are updated.*/
--       BEGIN
-- -- Audit OLD record.
--       INSERT INTO auditEmployeeData
--          (audit_log_type,
--          audit_emp_id,
--          audit_emp_bankAccountNumber,
--          audit_emp_salary,
--          audit_emp_SSN)
--          SELECT 'OLD', 
--             del.emp_id,
--             del.emp_bankAccountNumber,
--             del.emp_salary,
--             del.emp_SSN
--          FROM deleted del
-- 
-- -- Audit NEW record.
--       INSERT INTO auditEmployeeData
--          (audit_log_type,
--          audit_emp_id,
--          audit_emp_bankAccountNumber,
--          audit_emp_salary,
--          audit_emp_SSN)
--          SELECT 'NEW',
--             ins.emp_id,
--             ins.emp_bankAccountNumber,
--             ins.emp_salary,
--             ins.emp_SSN
--          FROM inserted ins
--    END
GO
CREATE TRIGGER trigSetSummOnDel
ON dbo.UlazIzlazDetalj
FOR DELETE

AS 

BEGIN
	DECLARE @vID AS INT
	SELECT @vID = vID FROM deleted

	EXEC [trigSum] @vID
END
GO
COMMIT

------------------------------------------


