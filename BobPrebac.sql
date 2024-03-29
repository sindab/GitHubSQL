
------------------------------------------------------------
-- Import BOB
-- bobF je baza Finansijskog programa, zamjeni
-- Prokontik baza je Prokontik13 ako nije REPLACE sa ispravnim nazivom baze
------------------------------------------------------------


-- **************** KONTNI PLAN

USE bobF
DELETE FROM [Prokontik13].[dbo].[Konto] WHERE LEN(Konto) < 3
INSERT INTO [Prokontik13].[dbo].[Konto]
           ([Konto]
           ,[Naziv])
SELECT [Konto]
      ,[Naziv]
FROM [GKPlan]
GO

--TODO rucno podesi analiticka konta (kupci, dobavljaci, magacin...)


-- **************** Partneri
USE bobF
DELETE FROM [Prokontik13].[dbo].[Par] WHERE ParID > 0
INSERT INTO [Prokontik13].[dbo].[Par]
           ([ParID]
           ,[Naziv]
           ,[Adresa]
           ,[PostBr]
           ,[JIB]
           ,[ecBit]
           ,[Telefon]
           ,[Maticni]
           ,[Ziro]
           ,[Mail]
           ,[PIB]
           ,[Valuta]
           ,[Komercijalist]
           ,[Mobilni]
           ,[Fax]
           ,[KontaktOsoba]
           ,[RabatGrupa]
           ,[Web]
           ,[Polje1]
           ,[Opis]
           ,[KnjSifra]
           ,[OLDSifra]
           ,[Parent]
           ,[GrupaID]
           ,[Kredit]
           ,[Sjediste]
           )
SELECT k.[Sifra]
      ,k.[Naziv]
      ,isnull(k.[Adresa],'') adr
      ,isnull(s.ID,0) pb
      ,isnull(k.[PDVBroj],'') pdv
      ,case k.[PDVKorisnik] when 0 then 0 else POWER(CAST(2 as Bigint), 39)/*PDV*/ + 8192/*pravno*/ end + 2/*dobavljac*/ + 4/*kupac*/ + 8/*domaci*/
      ,isnull(k.[Telefon],'') t
      ,isnull(k.[Mat_Br],'') mb
      ,cast(isnull(k.[Ziro1],'') as nvarchar(20)) + cast(isnull(',' + k.[Ziro2],'') as nvarchar(20)) ziro
      ,isnull(k.[EMail],'') em
      ,isnull(k.[JIB],'') jib
      ,0,0,'','','','','','','',k.[Sifra],k.[Sifra],k.[Sifra],'',0,''
  FROM [Komitenti] k
  left join (select id,naziv from [Prokontik13].[dbo].[RegSif] where dtid='10402' ) s on k.grad COLLATE DATABASE_DEFAULT = s.naziv COLLATE DATABASE_DEFAULT
GO
  
/* 
-- greska, dupli naziv u reg sif
select id,naziv from [Prokontik13].[dbo].[RegSif] where dtid='10402' and id in ('73305','75450')
update [Prokontik13].[dbo].[RegSif] set naziv=naziv + 'I' where dtid='10402' and id in ('75450')
*/
  
  -- **************** Artikli

-- sredi jedinice mjere (RegSif.10428) u Prokontiku, dodaj one kojih nema i OBAVEZNO OBRISI DUPLE
USE bobF
insert into [Prokontik13].[dbo].[RegSif](dtid,id,naziv)
select distinct '10428',jm,jm COLLATE DATABASE_DEFAULT 
from (
	SELECT [JM] FROM [bobVP].[dbo].[SRoba]
	UNION ALL
	SELECT [JM] FROM [bobMP].[dbo].[SRoba]
) j
where ltrim(jm) COLLATE DATABASE_DEFAULT not in (select naziv COLLATE DATABASE_DEFAULT from [Prokontik13].[dbo].[RegSif] where dtid='10428')
GO
-------------------------------

--REPLACE bobVP i bobMP sa imenima baza vp i mp,
DELETE FROM [Prokontik13].[dbo].[Pro]
DELETE FROM [Prokontik13].[dbo].[Reg]
GO

INSERT INTO [Prokontik13].[dbo].[Reg]
           ([ProID],[Naziv],[JM]
           ,[Sinonima],[KratkiOpis]
           ,[Grupa],[Podgrupa],[PodPodgrupa]
           ,[Proizvodjac],[DobID],[SifraDob]
           ,[TipArtikla]
           ,[Opis],[SlikaPath],[Uslo],[Izaslo]
           ,[ecOsobine],[Aktivan],[KataloskiBroj],[Tarifa]
           ,[Carina],[Akciza],[Pakovanje],[Dimenzija],[Omjer],[Garancija],[CenaDob],[BC]
          )
  SELECT  [SRoba]
      ,r.[Naziv]
      ,isnull(s.id,0) jm
      ,[Stip],''
      ,'0','','' --GRUPA 0 VP?
      ,0,0,''
      ,1 --TipArtikla?
      ,'','',0,0
      ,0,1,'',1
      ,0,0,'','',0,'',0,''
  FROM [bobVP].[dbo].[SRoba] r
  left join (select dtid,id,naziv from [Prokontik13].[dbo].[RegSif] where dtid='10428' ) s on ltrim(jm) COLLATE DATABASE_DEFAULT = s.naziv COLLATE DATABASE_DEFAULT
UNION ALL
  SELECT  [SRoba]
      ,r.[Naziv]
      ,isnull(s.id,0) jm
      ,[Stip],''
      ,'1','','' --GRUPA 1 MP?
      ,0,0,''
      ,1 --TipArtikla?
      ,'','',0,0
      ,0,1,'',1
      ,0,0,'','',0,'',0,''
  FROM [bobMP].[dbo].[SRoba] r
  left join (select dtid,id,naziv from [Prokontik13].[dbo].[RegSif] where dtid='10428' ) s on ltrim(jm) COLLATE DATABASE_DEFAULT = s.naziv COLLATE DATABASE_DEFAULT
--UNION ALL
--  SELECT  [SRoba]
--      ,r.[Naziv]
--      ,isnull(s.id,0) jm
--      ,[Stip],''
--      ,'2','','' --GRUPA 2 fin?
--      ,0,0,''
--      ,1 --TipArtikla?
--      ,'','',0,0
--      ,0,1,'',1
--      ,0,0,'','',0,'',0,''
--  FROM /*[bobf].[dbo].*/[SRoba] r
--  left join (select dtid,id,naziv from [Prokontik13].[dbo].[RegSif] where dtid='10428' ) s on ltrim(jm) COLLATE DATABASE_DEFAULT = s.naziv COLLATE DATABASE_DEFAULT
GO


--********************* NALOG
USE bobF
DELETE FROM [Prokontik13].[dbo].[NalogG]
INSERT INTO [Prokontik13].[dbo].[NalogG]
           ([Broj],[Nalog],[Datum],[ecBit],[Napomena])
SELECT 0,[Nalog],[Datum],0,''
FROM [Nalozi]
GO

-- Promjeni brojeve naloga
DECLARE @vID as int
DECLARE	ecCursor CURSOR 
FOR SELECT vID FROM [Prokontik13].[dbo].NalogG ORDER BY Datum
DECLARE @count smallint
SELECT @count = 1
OPEN ecCursor
FETCH NEXT FROM ecCursor INTO @vID
WHILE (@@fetch_status <> -1)
BEGIN
	IF (@@fetch_status <> -2)
	BEGIN
		UPDATE [Prokontik13].[dbo].NalogG
		SET Broj = @count
		WHERE vID = @vID
	END
	FETCH NEXT FROM ecCursor INTO @vID
	SELECT @count = @count + 1
END
CLOSE ecCursor
DEALLOCATE ecCursor
GO
----------------------------------------
 
 
 USE bobF
DELETE FROM [Prokontik13].[dbo].[NalogS]
INSERT INTO [Prokontik13].[dbo].[NalogS]
           ([vID]
           ,[RBr]
           ,[mID]
           ,[dtID]
           ,[DokVID]
           ,[DokBroj]
           ,[DokDatum]
           ,[DokValuta]
           ,[ParID]
           ,[Opis]
           ,[Konto]
           ,[Duguje]
           ,[Potrazuje]
           ,[AK]
           ,[ecBit]
           ,[MjestoTroskaID])
select n.vid,0,1,'30001',0,k.Broj_F,k.datum,k.datum,k.sifra,k.dokument,isnull(k.konto,''),k.duguje,k.trazi,0,0,0
from (--- KUPCI
		--fakture duguje 
		SELECT   Broj_F,[Sifra],  Nalog, '2010'/*GK_Konto*/ AS konto, SUM(ISNULL(Iznos, 0)) AS Duguje, 0 AS Trazi,'KF' as Vrsta,isnull(P_G,'') as P_G, dokument, datum
		FROM         dbo.K_Fakture
		WHERE     (GK_Strana = 'D') 
		GROUP BY Broj_F,[Sifra], Nalog, /*GK_Konto,*/P_G, dokument, datum
		----fakture trazi
		--UNION ALL
		--SELECT    Broj_F,[Sifra],  Nalog, GK_Konto AS konto, 0 AS Duguje, SUM(ISNULL(Iznos, 0)) AS Trazi,'KF', isnull(P_G,'') as P_G, dokument, datum
		--FROM         dbo.K_Fakture
		--WHERE     (GK_Strana = 'P')  
		--GROUP BY Broj_F,[Sifra], Nalog, GK_Konto,P_G, dokument, datum
		-- stavke duguje
		UNION ALL
		SELECT    fak.Broj_F,ST.[Sifra],  FAK.Nalog, ST.GK_Konto AS konto, SUM(ISNULL(ST.Iznos, 0))  AS Duguje, 0 AS Trazi,'KS', isnull(P_G,'') as P_G, fak.dokument, fak.datum
		FROM         dbo.K_Stavke ST,dbo.K_fakture FAK
		WHERE     (ST.GK_Strana = 'D') 
		and ST.Sifra = FAK.Sifra and ST.Broj_f = FAK.Broj_F 
		GROUP BY fak.Broj_F,ST.[Sifra], FAK.Nalog, ST.GK_Konto,P_G, Fak.dokument, fak.datum
		-- stavke trazi
		UNION ALL
		SELECT    fak.Broj_F,ST.[Sifra],  FAK.Nalog, ST.GK_Konto AS konto, 0 AS Duguje, SUM(ISNULL(ST.Iznos, 0)) AS Trazi,'KS', isnull(P_G,'') as P_G, fak.dokument, datum
		FROM         dbo.K_Stavke ST,dbo.K_fakture FAK
		WHERE     (ST.GK_Strana = 'P') 
		and ST.Sifra = FAK.Sifra and ST.Broj_f = FAK.Broj_F 
		GROUP BY fak.Broj_F,ST.[Sifra], FAK.Nalog, ST.GK_Konto,P_G, Fak.dokument, fak.datum
		--  izvodi duguje
		--union all
		--SELECT   0,[Sifra],   Nalog, GK_Konto1 AS konto, SUM(ISNULL(Iznos, 0)) AS Duguje, 0 AS Trazi,'KI', isnull(P_G,'') as P_G, dokument, datum
		--FROM         dbo.K_Izvodi
		--GROUP BY [Sifra], Nalog, GK_Konto1,P_G, dokument, datum
		---- izvodi trazi
		--union all
		--SELECT     0,[Sifra], Nalog, GK_Konto2 AS konto, 0 AS Duguje, SUM(ISNULL(Iznos, 0)) AS Trazi,'KI', isnull(P_G,'') as P_G, dokument, datum
		--FROM         dbo.K_Izvodi
		--GROUP BY [Sifra], Nalog, GK_Konto2,P_G, dokument, datum
		--union all

		--- DOBAVLJACI
		----fakture duguje
		--SELECT    Broj_F,[Sifra],  Nalog, GK_Konto AS konto, SUM(ISNULL(Iznos, 0)) AS Duguje, 0 AS Trazi,'DF' as Vrsta, isnull(P_G,'') as P_G, dokument, datum
		--FROM         dbo.D_Fakture
		--WHERE     (GK_Strana = 'D')  
		--GROUP BY Broj_F,[Sifra], Nalog, GK_Konto,P_G, dokument, datum
		--fakture trazi
		UNION ALL
		SELECT    Broj_F,[Sifra],  Nalog, '4320'/*GK_Konto*/ AS konto, 0 AS Duguje, SUM(ISNULL(Iznos, 0)) AS Trazi,'DF', isnull(P_G,'') as P_G, dokument, datum
		FROM         dbo.D_Fakture
		WHERE     (GK_Strana = 'P') 
		GROUP BY Broj_F,[Sifra], Nalog, /*GK_Konto,*/P_G, dokument, datum
		-- stavke duguje
		UNION ALL
		SELECT   fak.Broj_F,ST.[Sifra],   FAK.Nalog, ST.GK_Konto AS konto, SUM(ISNULL(ST.Iznos, 0)) AS Duguje, 0 AS Trazi,'DS', isnull(P_G,'') as P_G, fak.dokument, fak.datum
		FROM         dbo.D_Stavke ST,dbo.D_fakture FAK
		WHERE     (ST.GK_Strana = 'D') 
		and ST.Sifra = FAK.Sifra and ST.Broj_f = FAK.Broj_F 
		GROUP BY fak.Broj_F,ST.[Sifra], FAK.Nalog, ST.GK_Konto,P_G, Fak.dokument, fak.datum
		-- stavke trazi
		UNION ALL
		SELECT    fak.Broj_F,ST.[Sifra],  FAK.Nalog, ST.GK_Konto AS konto, 0 AS Duguje, SUM(ISNULL(ST.Iznos, 0)) AS Trazi,'DS', isnull(P_G,'') as P_G, fak.dokument, fak.datum
		FROM         dbo.D_Stavke ST,dbo.D_fakture FAK
		WHERE     (ST.GK_Strana = 'P') 
		and ST.Sifra = FAK.Sifra and ST.Broj_f = FAK.Broj_F 
		GROUP BY fak.Broj_F,ST.[Sifra], FAK.Nalog, ST.GK_Konto,P_G, FAK.dokument, fak.datum
		--  izvodi duguje
		--union all
		--SELECT    0,[Sifra],  Nalog, GK_Konto1 AS konto, SUM(ISNULL(Iznos, 0)) AS Duguje, 0 AS Trazi,'DI', isnull(P_G,'') as P_G, dokument, datum
		--FROM         dbo.D_Izvodi
		--GROUP BY [Sifra], Nalog, GK_Konto1,P_G, dokument, datum
		---- izvodi trazi
		--union all
		--SELECT   0,[Sifra],   Nalog, GK_Konto2 AS konto, 0 AS Duguje, SUM(ISNULL(Iznos, 0)) AS Trazi,'DI', isnull(P_G,'') as P_G, dokument, datum
		--FROM         dbo.D_Izvodi
		--GROUP BY [Sifra], Nalog, GK_Konto2,P_G, dokument, datum
) k 
left join [Prokontik13].[dbo].[NalogG] n on k.nalog COLLATE DATABASE_DEFAULT = n.nalog COLLATE DATABASE_DEFAULT
where isnull(n.vid,0)>0  and isnull(k.konto,'')<>''
order by k.nalog
GO

INSERT INTO [Prokontik13].[dbo].[NalogS]
           ([vID]
           ,[RBr]
           ,[mID]
           ,[dtID]
           ,[DokVID]
           ,[DokBroj]
           ,[DokDatum]
           ,[DokValuta]
           ,[ParID]
           ,[Opis]
           ,[Konto]
           ,[Duguje]
           ,[Potrazuje]
           ,[AK]
           ,[ecBit]
           ,[MjestoTroskaID])
SELECT n.vid,0,1,'30001'
	  , k.[Brojac],0
      ,k.[Datum],k.[Datum]
      ,0--par?
      ,k.[Opis]
      ,k.[Konto]
      ,k.[Duguje]
      ,k.trazi
      ,0,0,0
  FROM [Knjizi] k
  left join [Prokontik13].[dbo].[NalogG] n on k.nalog COLLATE DATABASE_DEFAULT = n.nalog COLLATE DATABASE_DEFAULT
where k.konto not in (2010,2021,4320,4330)
GO

INSERT INTO [Prokontik13].[dbo].[NalogS]
           ([vID]
           ,[RBr]
           ,[mID]
           ,[dtID]
           ,[DokVID]
           ,[DokBroj]
           ,[DokDatum]
           ,[DokValuta]
           ,[ParID]
           ,[Opis]
           ,[Konto]
           ,[Duguje]
           ,[Potrazuje]
           ,[AK]
           ,[ecBit]
           ,[MjestoTroskaID])
SELECT n.vid,0,1,'30001'
	  , k.[Brojac],f.kif
      ,k.[Datum],k.[Datum]
      ,isnull(i.sifra,0)--par
      ,k.[Opis]
      ,k.[Konto]
      ,CASE k.[trazi] when 0 then isnull(fi.[iznos],k.[Duguje]) else 0 end
      ,CASE k.[Duguje] when 0 then isnull(fi.[iznos],k.trazi) else 0 end
      ,0,0,0
  FROM [Knjizi] k
  left join [Prokontik13].[dbo].[NalogG] n on k.nalog COLLATE DATABASE_DEFAULT = n.nalog COLLATE DATABASE_DEFAULT
  left join [K_Izvodi] I on k.nalog = i.nalog and i.zatvoreno = k.duguje+k.trazi and k.datum=i.datum and k.konto in (2010,2021)
  left join [K_IzvFak] fi on i.broj_i = fi.broj_i and i.sifra=fi.sifra
  left join [K_Fakture] F on fi.broj_f = F.broj_f and f.dokument=fi.dokument
where k.konto in (2010,2021) --and isnull(i.sifra,0)>0 
GO

INSERT INTO [Prokontik13].[dbo].[NalogS]
           ([vID]
           ,[RBr]
           ,[mID]
           ,[dtID]
           ,[DokVID]
           ,[DokBroj]
           ,[DokDatum]
           ,[DokValuta]
           ,[ParID]
           ,[Opis]
           ,[Konto]
           ,[Duguje]
           ,[Potrazuje]
           ,[AK]
           ,[ecBit]
           ,[MjestoTroskaID])
SELECT n.vid,0,1,'30001'
	  , k.[Brojac],f.kuf
      ,k.[Datum],k.[Datum]
      ,isnull(i.sifra,0)--par
      ,k.[Opis]
      ,k.[Konto]
      ,CASE k.[trazi] when 0 then isnull(fi.[iznos],k.[Duguje]) else 0 end
      ,CASE k.[Duguje] when 0 then isnull(fi.[iznos],k.trazi) else 0 end
      ,0,0,0
  FROM [Knjizi] k
  left join [Prokontik13].[dbo].[NalogG] n on k.nalog COLLATE DATABASE_DEFAULT = n.nalog COLLATE DATABASE_DEFAULT
  left join [d_Izvodi] I on k.nalog = i.nalog and isnull(i.zatvoreno,0) = k.duguje+k.trazi and k.datum=i.datum and k.konto in (4320,4330)
  left join [d_IzvFak] fi on i.broj_i = fi.broj_i and i.sifra=fi.sifra
  left join [d_Fakture] F on fi.broj_f = F.broj_f and f.dokument=fi.dokument
where k.konto in (4320,4330) --and isnull(i.sifra,0)>0
GO


--select * 
delete FROM [Prokontik13].[dbo].[NalogS] 
where konto in ('2010','2021') and parid=0
	and vid in (select vid from [Prokontik13].[dbo].nalogg where nalog like 'IF0%')
GO


--SrediRBrNalogStavke
DECLARE @vID as int
DECLARE	ecCursor1 CURSOR 
FOR SELECT vID FROM [Prokontik13].[dbo].NalogG ORDER BY Datum
OPEN ecCursor1
FETCH NEXT FROM ecCursor1 INTO @vID
WHILE (@@fetch_status <> -1)
BEGIN
	IF (@@fetch_status <> -2)
	BEGIN
		EXECUTE [Prokontik13].[dbo].[ecSrediRBrNalogStavke] @vID
	END
	FETCH NEXT FROM ecCursor1 INTO @vID
END
CLOSE ecCursor1
DEALLOCATE ecCursor1
GO


-- NEISPRAVNE STAVKE, nemam vezu s partnerom: --1271 rows
select * FROM [Prokontik13].[dbo].[NalogS] where konto in ('2010','2021') and parid=0
select * FROM [Prokontik13].[dbo].[NalogS] where konto in ('4320','4330') and parid=0
GO

----TODO Rucno po nalozima DELETE duple stavke naloga, svaka druga stavka iz donjeg query u edit modu, 
-- NAPOMENA vizuelni pregled obavezan, obrati paznju: ako ima 4 iste stavke ostavi 2 (nalog NBK004)
SELECT     vID, DokVID, DokBroj, DokDatum, DokValuta, ParID, Opis, Konto, Duguje, Potrazuje
FROM         NalogS AS n
WHERE     (AutoID IN
                          (SELECT     TOP (100) PERCENT n.AutoID
                            FROM          NalogS AS n LEFT OUTER JOIN
                                                       (SELECT     COUNT(AutoID) AS c, vID, DokDatum, DokValuta, ParID, Opis, Konto, Duguje, Potrazuje, DokBroj
                                                         FROM          NalogS AS NalogS_1
                                                         GROUP BY vID, DokDatum, DokValuta, ParID, Opis, Konto, Duguje, Potrazuje, DokBroj
                                                         HAVING      (COUNT(AutoID) > 1)) AS s ON n.vID = s.vID AND n.DokDatum = s.DokDatum AND n.DokValuta = s.DokValuta AND n.ParID = s.ParID AND n.Opis = s.Opis AND 
                                                   n.Konto = s.Konto AND n.Duguje = s.Duguje AND n.Potrazuje = s.Potrazuje
                            WHERE      (ISNULL(s.vID, 0) > 0)
                            ORDER BY n.vID, n.DokDatum, n.DokValuta, n.ParID, n.Opis, n.Konto, n.Duguje, n.Potrazuje)) AND (Konto IN (2010, 4320)) AND (vID IN
                          (SELECT     vID
                            FROM          vNalogG
                            GROUP BY vID
                            HAVING      (SUM(Duguje - Potrazuje) <> 0))) AND (ParID > 0)
ORDER BY vID, ParID, Opis, Konto, Duguje, Potrazuje
GO



--***************************************************--
-------**    ROBNO    **-------------------------------
--***************************************************--

--IME BAZE bobF zamjeni sa bazom iz koje citas lager
USE bobF

CREATE VIEW [dbo].[LagerSaFC]
AS
SELECT     SObjekat, SRoba,
      (SELECT     Cijena   FROM      Veze
                    WHERE      Veze.SRoba = SR.SRoba and Veze.SObjekat = sr.Sobjekat) AS Cijena, 
      (SELECT     Naziv  FROM      SRoba
                    WHERE      SRoba.SRoba = SR.SRoba) AS Naziv, 
      (SELECT     JM  FROM      SRoba
                    WHERE      SRoba.SRoba = SR.SRoba) AS JM, 
      (SELECT     STarifa  FROM      SRoba
                    WHERE      SRoba.SRoba = SR.SRoba) AS STarifa, 
      (SELECT     STaksa  FROM      SRoba
                    WHERE      SRoba.SRoba = SR.SRoba) AS STaksa, 
      (SELECT     SAkciza  FROM      SRoba
                    WHERE      SRoba.SRoba = SR.SRoba) AS SAkciza, 
--Inventura PS
      isnull( (SELECT     SUM( isnull(SI.StvarnaKolicina,0))   FROM   VeleInv ZI, VeleInvStavke SI
               WHERE     ZI.Sobjekat = SI.SObjekat AND ZI.Broj = SI.Broj AND ZI.P_R = '*' AND SR.Sobjekat = ZI.SObjekat and SR.Sroba = SI.Sroba and ZI.TipInv=0 ),0) 
      + isnull( (SELECT     SUM( isnull(SI.StvarnaKolicina,0))   FROM   MaloInv ZI, MaloInvStavke SI
               WHERE     ZI.Sobjekat = SI.SObjekat AND ZI.Broj = SI.Broj AND ZI.P_R = '*' AND SR.Sobjekat = ZI.SObjekat and SR.Sroba = SI.Sroba and ZI.TipInv=0),0) 
      As InvPS,
--Inventura Fin PS
      isnull( (SELECT     SUM( isnull(SI.StvarnaKolicina,0)*isnull(SI.Cijena,0))   FROM   VeleInv ZI, VeleInvStavke SI
               WHERE     ZI.Sobjekat = SI.SObjekat AND ZI.Broj = SI.Broj AND ZI.P_R = '*' AND SR.Sobjekat = ZI.SObjekat and SR.Sroba = SI.Sroba and ZI.TipInv=0),0) 
      + isnull( (SELECT     SUM( isnull(SI.StvarnaKolicina,0)*isnull(SI.Cijena,0))   FROM   MaloInv ZI, MaloInvStavke SI
               WHERE     ZI.Sobjekat = SI.SObjekat AND ZI.Broj = SI.Broj AND ZI.P_R = '*' AND SR.Sobjekat = ZI.SObjekat and SR.Sroba = SI.Sroba and ZI.TipInv=0),0) 
     As FinInvPS,
--Inventura Razlike
      isnull( (SELECT     SUM(  isnull(SI.StvarnaKolicina,0) - isnull(SI.KnjigKolicina,0)) FROM   VeleInv ZI, VeleInvStavke SI
                WHERE     ZI.Sobjekat = SI.SObjekat AND ZI.Broj = SI.Broj AND ZI.P_R = '*' AND SR.Sroba = SI.Sroba and ZI.tipInv = 1 and Sr.Sobjekat= ZI.SObjekat and ZI.TipInv=1),0) 
      + isnull( (SELECT     SUM(  isnull(SI.StvarnaKolicina,0) - isnull(SI.KnjigKolicina,0)) FROM   MaloInv ZI, MaloInvStavke SI
                WHERE     ZI.Sobjekat = SI.SObjekat AND ZI.Broj = SI.Broj AND ZI.P_R = '*' AND SR.Sroba = SI.Sroba and ZI.tipInv = 1 and Sr.Sobjekat= ZI.SObjekat and ZI.TipInv=1),0) 
     As InvRazlika,
--Inventura Fin Razlike
      isnull( (SELECT     SUM(  (isnull(SI.StvarnaKolicina,0) - isnull(SI.KnjigKolicina,0))*si.cijena)   FROM  VeleInv ZI, VeleInvStavke SI
                WHERE     ZI.Sobjekat = SI.SObjekat AND ZI.Broj = SI.Broj AND ZI.P_R = '*' AND SR.Sroba = SI.Sroba and ZI.tipInv = 1 and Sr.Sobjekat= ZI.SObjekat and ZI.TipInv=1),0) 
      +isnull( (SELECT     SUM(  (isnull(SI.StvarnaKolicina,0) - isnull(SI.KnjigKolicina,0))*si.cijena)  FROM  MaloInv ZI, MaloInvStavke SI
                WHERE     ZI.Sobjekat = SI.SObjekat AND ZI.Broj = SI.Broj AND ZI.P_R = '*' AND SR.Sroba = SI.Sroba and ZI.tipInv = 1 and Sr.Sobjekat= ZI.SObjekat and ZI.TipInv=1),0) 
      As FinInvRazlika,
--Kalkulacije
      isnull( (SELECT     SUM(isnull(SK.Kolicina,0))  FROM         VeleKalk ZK, VeleKalkStavke SK
                WHERE     ZK.Sobjekat = SK.SObjekat AND ZK.Broj = SK.Broj AND ZK.P_R = '*' AND SK.Sroba = SR.Sroba and Sr.Sobjekat= ZK.SObjekat),0) 
      + isnull( (SELECT     SUM(isnull(SK.Kolicina,0))  FROM         MaloKalk ZK, MaloKalkStavke SK
                WHERE     ZK.Sobjekat = SK.SObjekat AND ZK.Broj = SK.Broj AND ZK.P_R = '*' AND SK.Sroba = SR.Sroba and Sr.Sobjekat= ZK.SObjekat),0) 
      As UlazKalk,
--Fin Kalkulacije
      isnull( (SELECT     SUM(isnull(SK.Kolicina,0)*isnull(SK.Cijena,0))  FROM         VeleKalk ZK, VeleKalkStavke SK
                WHERE     ZK.Sobjekat = SK.SObjekat AND ZK.Broj = SK.Broj AND ZK.P_R = '*' AND SK.Sroba = SR.Sroba and Sr.Sobjekat= ZK.SObjekat),0) 
      + isnull( (SELECT     SUM(isnull(SK.Kolicina,0)*isnull(SK.Cijena,0))  FROM       MaloKalk ZK, MaloKalkStavke SK
                WHERE     ZK.Sobjekat = SK.SObjekat AND ZK.Broj = SK.Broj AND ZK.P_R = '*' AND SK.Sroba = SR.Sroba and Sr.Sobjekat= ZK.SObjekat),0) 
      As FinUlazKalk,
--Fin Kalkulacije FC
      isnull( (SELECT     SUM(isnull(SK.Kolicina,0)*isnull(SK.FakturnaCijena,0))  FROM         VeleKalk ZK, VeleKalkStavke SK
                WHERE     ZK.Sobjekat = SK.SObjekat AND ZK.Broj = SK.Broj AND ZK.P_R = '*' AND SK.Sroba = SR.Sroba and Sr.Sobjekat= ZK.SObjekat),0) 
      + isnull( (SELECT     SUM(isnull(SK.Kolicina,0)*isnull(SK.FakturnaCijena,0))  FROM       MaloKalk ZK, MaloKalkStavke SK
                WHERE     ZK.Sobjekat = SK.SObjekat AND ZK.Broj = SK.Broj AND ZK.P_R = '*' AND SK.Sroba = SR.Sroba and Sr.Sobjekat= ZK.SObjekat),0) 
      As FinFakUlazKalk,
--Fin Kalkulacije IFC
      isnull( (SELECT     SUM(isnull(SK.Kolicina,0)*isnull(SK.IzvornaFakturnaCijena,0))  FROM         VeleKalk ZK, VeleKalkStavke SK
                WHERE     ZK.Sobjekat = SK.SObjekat AND ZK.Broj = SK.Broj AND ZK.P_R = '*' AND SK.Sroba = SR.Sroba and Sr.Sobjekat= ZK.SObjekat),0) 
      + isnull( (SELECT     SUM(isnull(SK.Kolicina,0)*isnull(SK.IzvornaFakturnaCijena,0))  FROM       MaloKalk ZK, MaloKalkStavke SK
                WHERE     ZK.Sobjekat = SK.SObjekat AND ZK.Broj = SK.Broj AND ZK.P_R = '*' AND SK.Sroba = SR.Sroba and Sr.Sobjekat= ZK.SObjekat),0) 
      As FinIFakUlazKalk,
--Fin ZadnjaFC
      isnull( (SELECT     TOP 1 FakturnaCijena  FROM         VeleKalk ZK, VeleKalkStavke SK
                WHERE     ZK.Sobjekat = SK.SObjekat AND ZK.Broj = SK.Broj AND ZK.P_R = '*' AND SK.Sroba = SR.Sroba and Sr.Sobjekat= ZK.SObjekat and FakturnaCijena > 0 ORDER BY Datum DESC ),0) 
      + isnull( (SELECT     TOP 1 FakturnaCijena  FROM       MaloKalk ZK, MaloKalkStavke SK
                WHERE     ZK.Sobjekat = SK.SObjekat AND ZK.Broj = SK.Broj AND ZK.P_R = '*' AND SK.Sroba = SR.Sroba and Sr.Sobjekat= ZK.SObjekat and FakturnaCijena > 0 ORDER BY Datum DESC ),0) 
      As ZadnjaFC,
--Fin ZadnjaIFC
      isnull( (SELECT     TOP 1 IzvornaFakturnaCijena  FROM         VeleKalk ZK, VeleKalkStavke SK
                WHERE     ZK.Sobjekat = SK.SObjekat AND ZK.Broj = SK.Broj AND ZK.P_R = '*' AND SK.Sroba = SR.Sroba and Sr.Sobjekat= ZK.SObjekat ORDER BY Datum DESC ),0) 
      + isnull( (SELECT     TOP 1 IzvornaFakturnaCijena  FROM       MaloKalk ZK, MaloKalkStavke SK
                WHERE     ZK.Sobjekat = SK.SObjekat AND ZK.Broj = SK.Broj AND ZK.P_R = '*' AND SK.Sroba = SR.Sroba and Sr.Sobjekat= ZK.SObjekat ORDER BY Datum DESC ),0) 
      As ZadnjaIFC,
--Fakture
      isnull( (SELECT     SUM(isnull(SF.Kolicina,0))  FROM         VeleFakt ZF, VeleFaktStavke SF
                WHERE     ZF.Sobjekat = SF.SObjekat AND ZF.Broj = SF.Broj AND ZF.P_R = '*' AND SF.Sroba = SR.Sroba and Sr.Sobjekat= ZF.SObjekat),0) 
      + isnull( (SELECT     SUM(isnull(SF.Kolicina,0))  FROM       MaloFakt ZF, MaloFaktStavke SF
                WHERE     ZF.Sobjekat = SF.SObjekat AND ZF.Broj = SF.Broj AND ZF.P_R = '*' AND SF.Sroba = SR.Sroba and Sr.Sobjekat= ZF.SObjekat),0) 
      As IzlazFakt,
--Fin Fakture
      isnull( (SELECT     SUM(isnull(SF.Kolicina,0)*isnull(SF.Cijena,0))  FROM     VeleFakt ZF, VeleFaktStavke SF
                WHERE     ZF.Sobjekat = SF.SObjekat AND ZF.Broj = SF.Broj AND ZF.P_R = '*' AND SF.Sroba = SR.Sroba and Sr.Sobjekat= ZF.SObjekat),0) 
      + isnull( (SELECT     SUM(isnull(SF.Kolicina,0)*isnull(SF.Cijena,0))  FROM   MaloFakt ZF, MaloFaktStavke SF
                WHERE     ZF.Sobjekat = SF.SObjekat AND ZF.Broj = SF.Broj AND ZF.P_R = '*' AND SF.Sroba = SR.Sroba and Sr.Sobjekat= ZF.SObjekat),0) 
      As FinIzlazFakt,
--Fakture rezervisano
      isnull( (SELECT     SUM(isnull(SF.Kolicina,0))  FROM         VeleFakt ZF, VeleFaktStavke SF
                WHERE     ZF.Sobjekat = SF.SObjekat AND ZF.Broj = SF.Broj AND isnull(ZF.P_R,'') <> '*' AND SF.Sroba = SR.Sroba and Sr.Sobjekat= ZF.SObjekat),0) 
      + isnull( (SELECT     SUM(isnull(SF.Kolicina,0))  FROM  MaloFakt ZF, MaloFaktStavke SF
                WHERE     ZF.Sobjekat = SF.SObjekat AND ZF.Broj = SF.Broj AND isnull(ZF.P_R,'') <> '*' AND SF.Sroba = SR.Sroba and Sr.Sobjekat= ZF.SObjekat),0) 
      As RezervisanIzlazFakt,
--Rashodi
      isnull( (SELECT     SUM(isnull(SF.Kolicina,0))  FROM         VeleRashod ZF, VeleRashodStavke SF
                WHERE     ZF.Sobjekat = SF.SObjekat AND ZF.Broj = SF.Broj AND ZF.P_R = '*' AND SF.Sroba = SR.Sroba and Sr.Sobjekat= ZF.SObjekat),0) 
      + isnull( (SELECT     SUM(isnull(SF.Kolicina,0))  FROM       MaloRashod ZF, MaloRashodStavke SF
                WHERE     ZF.Sobjekat = SF.SObjekat AND ZF.Broj = SF.Broj AND ZF.P_R = '*' AND SF.Sroba = SR.Sroba and Sr.Sobjekat= ZF.SObjekat),0) 
      As IzlazRashod,
--Fin Rashodi
      isnull( (SELECT     SUM(isnull(SF.Kolicina,0)*isnull(SF.Cijena,0))  FROM     VeleRashod ZF, VeleRashodStavke SF
                WHERE     ZF.Sobjekat = SF.SObjekat AND ZF.Broj = SF.Broj AND ZF.P_R = '*' AND SF.Sroba = SR.Sroba and Sr.Sobjekat= ZF.SObjekat),0) 
      + isnull( (SELECT     SUM(isnull(SF.Kolicina,0)*isnull(SF.Cijena,0))  FROM   MaloRashod ZF, MaloRashodStavke SF
                WHERE     ZF.Sobjekat = SF.SObjekat AND ZF.Broj = SF.Broj AND ZF.P_R = '*' AND SF.Sroba = SR.Sroba and Sr.Sobjekat= ZF.SObjekat),0) 
      As FinIzlazRashod,
--Dostavnice izlaz
      isnull( (SELECT     SUM(isnull(SDO.Kolicina,0))  FROM         VeleDost ZDO, VeleDostStavke SDO
                WHERE     ZDO.Sobjekat = SDO.SObjekat AND ZDO.Broj = SDO.Broj AND ZDO.P_R = '*' AND SDO.Sroba = SR.Sroba and Sr.Sobjekat= ZDO.SObjekat),0) 
     +  isnull( (SELECT     SUM(isnull(SDO.Kolicina,0))  FROM         MaloDost ZDO, MaloDostStavke SDO
                WHERE     ZDO.Sobjekat = SDO.SObjekat AND ZDO.Broj = SDO.Broj AND ZDO.P_R = '*' AND SDO.Sroba = SR.Sroba and Sr.Sobjekat= ZDO.SObjekat),0) 
      As DostIzlaz,
--Rezervisan Dostavnice Izlaz
      isnull( (SELECT     SUM(isnull(SDO.Kolicina,0))  FROM         VeleDost ZDO, VeleDostStavke SDO
                WHERE     ZDO.Sobjekat = SDO.SObjekat AND ZDO.Broj = SDO.Broj AND isnull(ZDO.P_R,'') <> '*' AND SDO.Sroba = SR.Sroba and Sr.Sobjekat= ZDO.SObjekat),0) 
      + isnull( (SELECT     SUM(isnull(SDO.Kolicina,0))  FROM         MaloDost ZDO, MaloDostStavke SDO
                WHERE     ZDO.Sobjekat = SDO.SObjekat AND ZDO.Broj = SDO.Broj AND isnull(ZDO.P_R,'') <> '*' AND SDO.Sroba = SR.Sroba and Sr.Sobjekat= ZDO.SObjekat),0) 
      As RezervisanDostIzlaz,
--Fin Dostavnice Izlaz
      isnull( (SELECT     SUM(isnull(SDO.Kolicina,0)*isnull(SDO.IzlaznaCijena,0))  FROM         VeleDost ZDO, VeleDostStavke SDO
                WHERE     ZDO.Sobjekat = SDO.SObjekat AND ZDO.Broj = SDO.Broj AND ZDO.P_R = '*' AND SDO.Sroba = SR.Sroba and Sr.Sobjekat= ZDO.SObjekat),0) 
      + isnull( (SELECT     SUM(isnull(SDO.Kolicina,0)*isnull(SDO.IzlaznaCijena,0))  FROM         MaloDost ZDO, MaloDostStavke SDO
                WHERE     ZDO.Sobjekat = SDO.SObjekat AND ZDO.Broj = SDO.Broj AND ZDO.P_R = '*' AND SDO.Sroba = SR.Sroba and Sr.Sobjekat= ZDO.SObjekat),0) 
      As FinDostIzlaz,
--Dostavnice ulaz
      isnull( (SELECT     SUM(isnull(SDO.Kolicina,0))  FROM    VeleDost ZDO, VeleDostStavke SDO
                WHERE     ZDO.Sobjekat = SDO.SObjekat AND ZDO.Broj = SDO.Broj AND ZDO.P_R = '*' AND SDO.Sroba = SR.Sroba and Sr.Sobjekat= SDO.SObjekatU and SDO.SObjekatU not in ('001','005','007','008','016')),0)--iz razloga sto dostavnice na ove objekte prave aut. kalk. 
     + 
     isnull( (SELECT     SUM(isnull(SDO.Kolicina,0))  FROM    MaloDost ZDO, MaloDostStavke SDO
                WHERE     ZDO.Sobjekat = SDO.SObjekat AND ZDO.Broj = SDO.Broj AND ZDO.P_R = '*' AND SDO.Sroba = SR.Sroba and Sr.Sobjekat= SDO.SObjekatU),0) 
      As DostUlaz,
--Fin Dostavnice Ulaz
      isnull( (SELECT     SUM(isnull(SDO.Kolicina,0)*isnull(SDO.Cijena,0))  FROM         VeleDost ZDO, VeleDostStavke SDO
                WHERE     ZDO.Sobjekat = SDO.SObjekat AND ZDO.Broj = SDO.Broj AND ZDO.P_R = '*' AND SDO.Sroba = SR.Sroba and Sr.Sobjekat= SDO.SObjekatU),0) 
     + isnull( (SELECT     SUM(isnull(SDO.Kolicina,0)*isnull(SDO.Cijena,0))  FROM         MaloDost ZDO, MaloDostStavke SDO
                WHERE     ZDO.Sobjekat = SDO.SObjekat AND ZDO.Broj = SDO.Broj AND ZDO.P_R = '*' AND SDO.Sroba = SR.Sroba and Sr.Sobjekat= SDO.SObjekatU),0) 
      As FinDostUlaz,
--Pazari
      isnull( (SELECT     SUM(isnull(SF.Kolicina,0))  FROM MaloPazar ZF, MaloPazarStavke SF
                WHERE     ZF.Sobjekat = SF.SObjekat AND ZF.Broj = SF.Broj AND ZF.P_R = '*' AND SF.Sroba = SR.Sroba and Sr.Sobjekat= ZF.SObjekat),0) 
      As IzlazPazar,
--Fin pazar
      isnull( (SELECT     SUM(isnull(SF.Kolicina,0)*isnull(SF.Cijena,0)) FROM MaloPazar ZF, MaloPazarStavke SF
                WHERE     ZF.Sobjekat = SF.SObjekat AND ZF.Broj = SF.Broj AND ZF.P_R = '*' AND SF.Sroba = SR.Sroba and Sr.Sobjekat= ZF.SObjekat),0) 
      As FinIzlazPazar,
--Pazar rezervisano
      isnull( (SELECT     SUM(isnull(SF.Kolicina,0))  FROM  MaloPazar ZF, MaloPazarStavke SF
                WHERE     ZF.Sobjekat = SF.SObjekat AND ZF.Broj = SF.Broj AND isnull(ZF.P_R,'') <> '*' AND SF.Sroba = SR.Sroba and Sr.Sobjekat= ZF.SObjekat),0) 
      As RezervisanIzlazPAzar,
--Pazar kasa rezervisano
      isnull( (SELECT     SUM(isnull(SF.Kolicina,0))  FROM  MaloPazarStavke SF
                WHERE     SF.Sroba = SR.Sroba and Sr.Sobjekat= SF.SObjekat  and  SF.Broj is null ),0) 
      As RezervisanIzlazKasa
FROM  dbo.AktivneRobe As  SR
GO

--Rucno otvori dok. PS i uzmi vID -- 10000003
DECLARE @vID as integer
SET @vID = 10000003 --????????
--sifra njihovog magacina
DECLARE @mIDbob as nvarchar(5)
SET @mIDbob = '005'

DELETE FROM [Prokontik13].[dbo].[UlazIzlazDetalj] WHERE vID = @vID

INSERT INTO [Prokontik13].[dbo].[UlazIzlazDetalj]
           ([vID],[RedBr]
           ,[ProID]
           ,[Kol]
           ,[Cena],[CSaPor]
           ,[Rabat],[Porez],[Tarifa],[Koef]
           ,[Realna],[Fakturna]
           ,[RabatFak],[Akciza],[Carina]
           ,[Naziv]
           ,[StaraCena],[StaraCenaSaPor],[StaraKol],[Trosak],[StvarnaKol]
           ,[CProdPrenos],[CProdPrenosBPor],[PDV]
           ,[ecBit],[PredznakParcijalneNiv],[PrenosRabat],[vPrenos],[MarzaPrenos],[Bruto],[Neto]
           ,[vJCI],[CenaUMoneti])
SELECT @vID, 999
      ,[SRoba]
      ,[InvPS]+[InvRazlika]+[UlazKalk]-[IzlazFakt]-[IzlazRashod]-[DostIzlaz]+[DostUlaz]-[IzlazPazar] kol
      ,[Cijena],[Cijena]*1.17
      ,0,0.17,0.17,1
      ,case [UlazKalk] when 0 then ZadnjaFC else ([FinFakUlazKalk])/([UlazKalk]) end
      ,case [UlazKalk] when 0 then ZadnjaFC else ([FinFakUlazKalk])/([UlazKalk]) end --?[Realna],[Fakturna]  izvornaFC = FinIFakUlazKalk  --ZadnjaFC--
      ,0,0,0
      ,[Naziv]
      ,0,0,0,0,0
      ,0,0,0
      ,0,0,0,'',0,0,0
      ,'',0
  FROM [LagerSaFC]
  WHERE  [SObjekat] = @mIDbob

EXECUTE [Prokontik13].[dbo].[ecSredjivanjeRednogBroja] @vID
GO


