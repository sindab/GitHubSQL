/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [AutoID]
      ,[vID]
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
      ,[CenaUMoneti]
      ,[RokIsporuke]
  FROM [Prokontik13].[dbo].[UlazIzlazDetalj]
  where proid='1014887' --vid=10109853
  order by autoid
  
  select * from ulazizlaz where vid in (
  10123352,--30219
10126904,--30510
10109853,--30001
10128714--30500
  )