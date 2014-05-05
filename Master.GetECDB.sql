SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE   PROCEDURE GetECDatabases(
	@year as integer
)

AS

declare
  @cBaza   sysname

set nocount on

create table #ecDatabases
(
  dbID  smallint,
  AutoID    smallint,
  fID    smallint,
  Baza       varchar(255),
  Godina     smallint,
  License    bigint,
  Naziv      varchar(50),
  PostBroj   varchar(5),
  Adresa     varchar(50),
  Telefon    varchar(50)
)

insert into #ecDatabases(dbID, Baza)
  select dbID, name
    from master.dbo.sysdatabases

declare c cursor for
  select Baza from #ecDatabases
open c
fetch c into @cBaza
while @@Fetch_Status>=0 begin
  if has_dbaccess(@cBaza)=1 begin
    execute('if exists (select * from ['+@cBaza+']..sysobjects where name=''RadnikMagacin'') begin '+
               'update #ecDatabases set dbID = dbID '+
                 'where #ecDatabases.Baza='''+@cBaza+''' '+
            'end else begin '+
               'update #ecDatabases set dbID=null '+
                 'where #ecDatabases.Baza='''+@cBaza+''' '+
            'end')
  end
  fetch c into @cBaza
end
close c

---------------------------
delete from #ecDatabases where dbID is null
---------------------------

open c
fetch c into @cBaza
while @@Fetch_Status>=0 begin
  execute('update #ecDatabases '+
	'set AutoID = f.AutoID '+
	', fID = f.fID '+
	', Godina = f.Godina '+
	', License = f.ecLicenca '+
	', Naziv = f.Naziv '+
	', PostBroj = f.PostBroj '+
	', Adresa = f.Adresa '+
	', Telefon = f.Telefon '+
	'from ['+@cBaza+']..vFirma f '+
	'where f.BazaSys='''+@cBaza+''' and #ecDatabases.Baza='''+@cBaza+'''')

  fetch c into @cBaza
end
close c

---------------------------

deallocate c

select dbID, Baza, Godina, AutoID, fID, License, Naziv, PostBroj, Adresa, Telefon
from #ecDatabases 
where isnull(fID, 0) > 0 and Godina = @year
order by Baza

drop table #ecDatabases


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

