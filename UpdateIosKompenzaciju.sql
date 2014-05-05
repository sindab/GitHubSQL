 --update iosfin set vidrobnokomp = null
 update iosfin 
	set vidrobnokomp = n.dokvid from nalogs n 
	where iosfin.vidizv=n.autoid and isnull(iosfin.vidkomp,0)<>0
 update iosfin 
	set vidrobnokomp = n.dokvid--, vIDFinKomp = iosfin.vIDIzv 
	from nalogs n 
	where iosfin.viddok=n.autoid and isnull(iosfin.vidkomp,0)<>0
	
	SELECT [AutoID]
      ,[vIDDok]
      ,[vIDIzv]
      ,[Iznos]
      ,[ecBit]
      ,[vIDKomp]
      ,[vidrobnokomp]
  FROM [IOSFin]
GO

