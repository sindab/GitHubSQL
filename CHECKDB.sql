ALTER DATABASE DB_NAME SET EMERGENCY;
GO
ALTER DATABASE DB_NAME SET SINGLE_USER;
GO
DBCC CHECKDB (Prokontik13, REPAIR_ALLOW_DATA_LOSS) WITH NO_INFOMSGS, ALL_ERRORMSGS;
