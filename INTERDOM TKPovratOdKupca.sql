SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

ALTER VIEW VTrgKnjigaNew

AS

--03.VIII 2011. - 40130 povrat od kupca zaduzenje
SELECT TOP 100 PERCENT
	vID 		= UIDSUMM.vid,
	mID 		= UI.mID,
	Dokument 	= dt.Naziv, 
	Broj 		= Broj,
	PrefBrSuf 	= PrefBrSuf,
	Datum 		= Datum ,
	DPO		= DPO,
	Partner		= Partner,
	ParID		= ParID,
	Grad		= Grad,
	JIB		= UI.JIB,
	PIB		= UI.PIB,
	ZaduzenjeBezPoreza = CASE dt.ecBit & 16384 WHEN 16384 THEN -1 ELSE 1 END * 
			CASE 
				When UI.Predznak = 1 /*AND UI.dtID NOT IN ('30130','40130')*/ THEN TotVPVr 
				When UI.Predznak = 0  and dt.dgId = 5 and TotEfektNiv <> 0 and M.[ecBit] & 268435456 <> 0 THEN TotEfektNiv --268435456 = POWER(2, 28)
				When UI.Predznak = 0  and dt.dgId = 5 and TotEfektNiv >= 0 and M.[ecBit] & 268435456 = 0 THEN TotEfektNiv 
				--MJENJAJU STRANU U ODNOSU NA PREDZNAK: povrat dobavljacu, izlazne prenosnice i medjuskladisnice
				When UI.dtID IN ('30220','30221','30224','40220','40221','30230','40230','30300') THEN TotVPVr * -1
			ELSE 0 
			END,

	RazduzenjeBezPoreza = CASE dt.ecBit & 16384 WHEN 16384 THEN -1 ELSE 1 END * 
			CASE 
				When UI.Predznak = -1 AND UI.dtID IN ('30300') THEN 0
				--When UI.Predznak = 1 AND UI.dtID IN ('30130','40130') THEN TotVPVr * -1
				When UI.Predznak = -1 and UI.dtID NOT IN ('30220','30221','30224','40220','40221','30230','40230') THEN TotVPVr 
				When UI.Predznak = 0  and dt.dgId = 5 and TotEfektNiv < 0 and M.[ecBit] & 268435456 = 0 THEN -1*TotEfektNiv
			ELSE 0 END,

	ZaduzenjeSaPorezom = CASE dt.ecBit & 16384 WHEN 16384 THEN -1 ELSE 1 END * 
			CASE 
				When UI.Predznak = 1 /*AND UI.dtID NOT IN ('30130','40130')*/ THEN TotMPVr
				When UI.Predznak = 0  and dt.dgId = 5 and TotEfektNiv <> 0 and M.[ecBit] & 268435456 <> 0 THEN TotEfektNivSPor 
				When UI.Predznak = 0  and dt.dgId = 5 and TotEfektNiv >= 0 and M.[ecBit] & 268435456 = 0 THEN TotEfektNivSPor 
				When UI.dtID IN ('30220','30221','30224','40220','40221','30230','40230')  THEN TotMPVr * -1
			ELSE 0 END,

	RazduzenjeSaPorezom = CASE dt.ecBit & 16384 WHEN 16384 THEN -1 ELSE 1 END * 
		CASE 
			--When UI.Predznak = 1 AND UI.dtID IN ('30130','40130') THEN TotMPVr * -1
			When UI.Predznak = -1 and UI.dtID NOT IN ('30220','30221','30224','40220','40221','30230','40230') THEN TotMPVr 
			When UI.Predznak = 0  and dt.dgId = 5 and TotEfektNiv < 0 and M.[ecBit] & 268435456 = 0 THEN -1*TotEfektNivSPor
		ELSE 0 END,

	ZaduzenjePorez = CASE dt.ecBit & 16384 WHEN 16384 THEN -1 ELSE 1 END * 
			CASE 
				When UI.Predznak = 1 /*AND UI.dtID NOT IN ('30130','40130')*/ THEN TotMPVr-TotVPVr 	
				When UI.Predznak = 0  and dt.dgId = 5 and TotEfektNiv <> 0 and M.[ecBit] & 268435456 <> 0 THEN (TotEfektNivSPor-TotEfektNiv) 
				When UI.Predznak = 0  and dt.dgId = 5 and TotEfektNiv >= 0 and M.[ecBit] & 268435456 = 0 THEN (TotEfektNivSPor-TotEfektNiv) 
				When UI.dtID IN ('30220','30221','30224','40220','40221','30230','40230')  THEN (TotMPVr-TotVPVr) * -1
			ELSE 0 END,

	RazduzenjePorez = CASE dt.ecBit & 16384 WHEN 16384 THEN -1 ELSE 1 END * 
			CASE 
				--When UI.Predznak = 1 AND UI.dtID IN ('30130','40130') THEN (TotMPVr-TotVPVr) * -1
				When UI.Predznak = -1 and UI.dtID NOT IN ('30220','30221','30224','40220','40221','30230','40230') THEN TotMPVr-TotVPVr 
				When UI.Predznak = 0  and dt.dgId = 5 and TotEfektNiv < 0 and M.[ecBit] & 268435456 = 0 THEN -1*(TotEfektNivSPor-TotEfektNiv)
			ELSE 0 END,

	VPRab		= CASE dt.ecBit & 16384 WHEN 16384 THEN -1 ELSE 1 END * 
			CASE
				When UI.dtID IN ('30130','40130','30230','40230','30224') THEN UIDSumm.TotVPRab * -1
				When UI.dtID IN ('30220','40220','40221','30221') THEN 0
			ELSE UIDSumm.TotVPRab END,

	MPRab		= CASE dt.ecBit & 16384 WHEN 16384 THEN -1 ELSE 1 END * 
		CASE
			When UI.dtID IN ('30130','40130','30230','40230','30224') THEN UIDSumm.TotMPRab * -1
			When UI.dtID IN ('30220','40220','40221','30221') THEN 0
		ELSE UIDSumm.TotMPRab END,

	RAS		= UI.RAS,
	dtID		= UI.dtID,
	DokBit		= dt.ecBit,
	Predznak	= dt.Predznak,
	DokGrupa	= dt.dgID

FROM UIDSUMMTrg UIDSUMM
LEFT JOIN UI ON UIDSUMM.vid = UI.VId
LEFT JOIN DokTip as dt ON dt.dtID = UI.dtID 
LEFT JOIN Magacin as M ON M.mID = UI.mID
WHERE  UI.RAS & 1 = 1 and dt.ecBit & 32 = 32 
Order By  Knjizenje

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO



SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

ALTER VIEW vTrgPorezNew

AS

SELECT TOP 100 PERCENT 
	UI.mID, p.vID, dt.Naziv AS DOKUMENT, UI.Datum, Stopa,
CASE dt.ecBit & 16384 WHEN 16384 THEN -1 ELSE 1 END * 
	CASE 
		When UI.Predznak = 1  /*AND UI.dtID NOT IN ('30130','40130')*/ THEN Osnovica 
		When UI.Predznak = 0  and dt.dgId = 5 and TotEfektNiv <> 0 and M.[ecBit] & 268435456 <> 0 THEN TotEfektNiv --268435456 = POWER(2, 28)
		When UI.Predznak = 0  and dt.dgId = 5 and TotEfektNiv >= 0 and M.[ecBit] & 268435456 = 0 THEN TotEfektNiv 
		/*MJENJAJU STRANU U ODNOSU NA PREDZNAK: 
			povrat dobavljacu, 
			izlazne prenosnice i medjuskladisnice*/ 
		When UI.dtID IN ('30220','30221','30224','40220','40221','30230','40230','30300') THEN Osnovica * -1
		ELSE 0 
	END as ZaduzenjeBezPoreza ,

CASE dt.ecBit & 16384 WHEN 16384 THEN -1 ELSE 1 END * 
	CASE 
		When UI.Predznak = -1 AND UI.dtID IN ('30300') THEN 0
		--When UI.Predznak = 1 AND UI.dtID IN ('30130','40130') THEN Osnovica * -1
		When UI.Predznak = -1 and UI.dtID NOT IN ('30220','30221','30224','40220','40221','30230','40230') THEN Osnovica 
		When UI.Predznak = 0  and dt.dgId = 5 and TotEfektNiv < 0 and M.[ecBit] & 268435456 = 0 THEN -1*TotEfektNiv
		ELSE 0 
	END As RazduzenjeBezPoreza,

CASE dt.ecBit & 16384 WHEN 16384 THEN -1 ELSE 1 END * 
	CASE 
		When UI.Predznak = 1 /*AND UI.dtID NOT IN ('30130','40130')*/ THEN Osnovica+Porez 
		When UI.Predznak = 0  and dt.dgId = 5 and TotEfektNiv <> 0 and M.[ecBit] & 268435456 <> 0 THEN (TotEfektNiv+TotPorezNiv) 
		When UI.Predznak = 0  and dt.dgId = 5 and TotEfektNiv >= 0 and M.[ecBit] & 268435456 = 0 THEN (TotEfektNiv+TotPorezNiv) 
		When UI.dtID IN ('30220','30221','30224','40220','40221','30230','40230')  THEN (Osnovica+Porez) * -1
		ELSE 0 
	END As ZaduzenjeSaPorezom,

CASE dt.ecBit & 16384 WHEN 16384 THEN -1 ELSE 1 END * 
	CASE 
		--When UI.Predznak = 1 AND UI.dtID IN ('30130','40130') THEN (Osnovica+Porez) * -1
		When UI.Predznak = -1 and UI.dtID NOT IN ('30220','30221','30224','40220','40221','30230','40230') THEN Osnovica+Porez 
		When UI.Predznak = 0  and dt.dgId = 5 and TotEfektNiv < 0 and M.[ecBit] & 268435456 = 0 THEN -1*(TotEfektNiv+TotPorezNiv)
		ELSE 0 
	END As RazduzenjeSaPorezom,


CASE dt.ecBit & 16384 WHEN 16384 THEN -1 ELSE 1 END * 
	CASE 
		When UI.Predznak = 1 /*AND UI.dtID NOT IN ('30130','40130')*/ THEN Porez 	
		When UI.Predznak = 0  and dt.dgId = 5 and TotEfektNiv <> 0 and M.[ecBit] & 268435456 <> 0 THEN TotPorezNiv
		When UI.Predznak = 0  and dt.dgId = 5 and TotEfektNiv >= 0 and M.[ecBit] & 268435456 = 0 THEN TotPorezNiv
		When UI.dtID IN ('30220','30221','30224','40220','40221','30230','40230')  THEN Porez * -1
		ELSE 0 
	END As ZaduzenjePorez,

CASE dt.ecBit & 16384 WHEN 16384 THEN -1 ELSE 1 END * 
	CASE 
		--When UI.Predznak = 1 AND UI.dtID IN ('30130','40130') THEN pOREZ * -1
		When UI.Predznak = -1 and UI.dtID NOT IN ('30220','30221','30224','40220','40221','30230','40230') THEN Porez
		When UI.Predznak = 0  and dt.dgId = 5 and TotEfektNiv < 0 and M.[ecBit] & 268435456 = 0 THEN -1*TotPorezNiv
	ELSE 0 
	END As RazduzenjePorez
FROM UIDPorezTrg p
LEFT JOIN UlazIzlaz UI ON p.vid = UI.Vid
LEFT JOIN DokTip as dt ON dt.dtID = UI.dtID 
LEFT JOIN ecMagacin as M ON M.mID = UI.mID
WHERE  UI.RAS & 1 = 1 and  dt.ecBit & 32 = 32 --Power(2,5) 
Order By ui.Datum, ui.Knjizenje

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

