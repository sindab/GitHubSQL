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
  FROM [Prokontik13].[dbo].[vPar]
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
 
GO


