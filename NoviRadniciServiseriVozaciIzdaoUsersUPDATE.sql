SELECT 'Stari registar vozaca, servisera'
SELECT [dtID], [ID], [Naziv], [Vrijednost], [Datum], [VdtID], [vID], [ecBit], [Opis], [DatumDo], [VdtID2], [vID2], [VdtID3], [vID3], [AutoID], [LastEditDate], [CreationDate] 
FROM [RegSif]
Where dtID = 10427

SELECT 'Stari users, ostaju za plate'
SELECT [UserName], [Password], [Rights], [Lozinka], [UserType], [LastEditDate], [CreationDate] FROM [dbo].[Users]

SELECT 'Radnici iz plata'
SELECT [RadID], [JMBG], [Prezime], [Ime], [ecBit], BrLK
FROM [Radnik]

SELECT 'Stari za insert u nove'
/*
INSERT INTO [dbo].[Radnik](
[RadID], [JMBG], [Prezime], [Ime], [ecBit], [BrLK]
--, [ImeOca], [Titula], [Funkcija], [DjevPrezime], [MjestoRodjenja], [OpstinaRodjenja]
--, [DatumRodjenja], [Drzavljanstvo], [Nacionalnost], [PorodicnoStanje], [FaktorOdbitka]
--, [MjestoStan], [AdresaStan], [OpstinaStan], [TelefonStan], [TelefonMob], [Zanimanje]
--, [StrucnaSprema], [ZavrsenaSkola], [PoslovnaJedinica], [RadnoMjesto], [DatumPrvogZapos]
--, [PrethodniStazMj], [PrethodniStazDan], [DatumZapos], [TipRadnogOdnosa], [NacinPrestankaRO]
--, [DatumPrestankaRO], [BrLK], [BrRadneKnj], [OpstinaIzdavanjaRK], [LicniBrOsiguranja]
--, [NacinIsplate], [BrTekucegRn], [Banka], [Napomena], [ecFind], [PoreskaOlaksica], [Beneficija]
--, [LicniKoef], [PrethodniStazUFirmiMj], [PrethodniStazUFirmiDan]
, [Lozinka], [Pravo])
*/

SELECT [ID], '' JMBG, [Naziv], [Naziv], 0, [Opis], 'a', 9223372036854775807 /*Users - Rights, SVA PRAVA*/
FROM [RegSif]
Where dtID = 10427 and ID NOT IN (SELECT RadID FROM Radnik)

/*
-- Pojedinacno prebacivanje, rucno, ako ima plate
DECLARE @stari as int --Sifra iz RegSif
DECLARE @novi as int --Sifra iz Plate-Radnik
SET @stari = 1
SET @novi = 4
Update UlazIzlaz SET Vozac = @novi WHERE Vozac = @stari
Update UlazIzlaz SET Izdao = @novi WHERE Izdao = @stari
*/

Update UlazIzlaz SET Vozac = '0' WHERE ISNULL(Vozac,'') = ''
Update UlazIzlaz SET Izdao = '0' WHERE ISNULL(Izdao,'') = ''

--------------------------
SELECT 'Upisano ime umjesto sifre'
SELECT Vozac, Izdao 
FROM UlazIzlaz
WHERE ISNUMERIC(ISNULL(Vozac,0)) = 0 OR ISNUMERIC(ISNULL(Izdao,0)) = 0

Update UlazIzlaz SET Vozac = '0'/*UPISI SIFRU*/ WHERE ISNUMERIC(ISNULL(Vozac,0)) = 0 and Vozac = 'Pero'/*UPISI Naziv*/
Update UlazIzlaz SET Izdao = '0'/*UPISI SIFRU*/ WHERE ISNUMERIC(ISNULL(Izdao,0)) = 0 and Izdao = 'Pero'/*UPISI Naziv*/
-------------------------

