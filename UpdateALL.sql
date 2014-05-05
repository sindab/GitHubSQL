--BLAGAJNA
if not exists (select * from [EcINI] where Modul = 'Temeljnica' and Kljuc = 'Duguje')
	INSERT INTO [EcINI]([Modul], [Kljuc], [Vrijednost])
	VALUES('Temeljnica', 'Duguje', '0')

if not exists (select * from [EcINI] where Modul = 'Temeljnica' and Kljuc = 'Potrazuje')
	INSERT INTO [EcINI]([Modul], [Kljuc], [Vrijednost])
	VALUES('Temeljnica', 'Potrazuje', '0')

--
