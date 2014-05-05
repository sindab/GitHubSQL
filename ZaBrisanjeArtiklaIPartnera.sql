USE [Prokontik]
GO

/****** Object:  View [dbo].[BrisanjeNeaktivnihArtikala_ZaProgramere]    Script Date: 10/21/2013 09:36:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [dbo].[BrisanjeNeaktivnihArtikala_ZaProgramere]

AS

-- --za brisanje
SELECT proid, Naziv
--DELETE
FROM Reg WHERE TipArtikla = 1 
and ProID NOT IN ( SELECT distinct proid FROM(
  SELECT distinct proid
  FROM [dbo].[UlazIzlazDetalj]
  where vid in (select vid from ulazizlaz where dtid in (30001,40001)) and 
  Kol<>0 and Cena<>0 
  --Kol+Cena<>0 
  
  UNION ALL
  
  SELECT distinct proid
  FROM [dbo].[UlazIzlazDetalj]
  where vid not in (select vid from ulazizlaz where dtid in (30001,40001))
) a ) 
and ProID NOT IN ( SELECT distinct proidmat FROM dbo.Normativ )
and ProID NOT IN ( SELECT distinct proidpro FROM dbo.Normativ )


/*
-- BRISANJE ZAVISNIH TABELA

select * --delete
 from normativ 
 where proidpro not in (select proid from reg)

select * --delete
 from normativ 
 where proidmat not in (select proid from reg)
 
select * -- delete
 from ulazizlazdetalj 
 where proid not in (select proid from reg)
 
select * -- delete
 from pro 
 where proid not in (select proid from reg) 
 
select * -- delete
 from BarCod 
 where proid not in (select proid from reg)
 
select * -- delete
 from  dbo.RegExtra
 where proid not in (select proid from reg)
*/
 
 
 /*--BRISANJE PARTNERA
 SELECT [ParID]
      ,[Naziv]
      ,[PostBr]
      ,[Grad]
      ,[Adresa]
      ,[JIB]
      ,[PIB]
      ,[Telefon]
      ,[Fax]
      ,[Mobilni]
      ,[KontaktOsoba]
      ,[Mail]
  FROM [dbo].[vPar]
  where isPravno=0 and ParID>0
	and (ParID not in (select parid from ulazizlaz))
	and (ParID not in (select parid from kasaG))
	and (ParID not in (select parid from nalogs))


	and adresa=''
	--and grad=''
	
	--and (telefon='' or fax='' or mobilni='')
	and telefon='' and fax='' and mobilni=''
	
	and kontaktosoba=''
	and mail=''
	and pib=''
 */


GO


