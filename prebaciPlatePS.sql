DELETE FROM [EC201101].[dbo].[ObrIzdaci]
INSERT INTO [EC201101].[dbo].[ObrIzdaci]([ObrPeriod], [RadID], [Vrsta], [Osnovica], [Stopa], [Iznos], [ecBit])
SELECT [ObrPeriod], [RadID], [Vrsta], [Osnovica], [Stopa], [Iznos], [ecBit] 
FROM [EC201001].[dbo].[ObrIzdaci]

DELETE FROM [EC201101].[dbo].[ObrPeriod]
INSERT INTO [EC201101].[dbo].[ObrPeriod]([Naziv], [Oznaka], [DatumOd], [DatumDo], [BrojSati], [ecBit], [DatumIsplate], [DatumObracuna], [MinPlata], [BodVr], [StopaGot], [StopaZR], [IznosGot], [IznosZR])
SELECT [Naziv], [Oznaka], [DatumOd], [DatumDo], [BrojSati], [ecBit], [DatumIsplate], [DatumObracuna], [MinPlata], [BodVr], [StopaGot], [StopaZR], [IznosGot], [IznosZR] 
FROM [EC201001].[dbo].[ObrPeriod]

DELETE FROM [EC201101].[dbo].[ObrPlata]
INSERT INTO [EC201101].[dbo].[ObrPlata]([ObrPeriod], [RadID], [VrstaRada], [ProsPoSatu], [Stopa], [Sati], [BodPoSat], [BodZaRad], [Iznos], [ecBit])
SELECT [ObrPeriod], [RadID], [VrstaRada], [ProsPoSatu], [Stopa], [Sati], [BodPoSat], [BodZaRad], [Iznos], [ecBit] 
FROM [EC201001].[dbo].[ObrPlata]

DELETE FROM [EC201101].[dbo].[Radnik]
INSERT INTO [EC201101].[dbo].[Radnik]([RadID], [JMBG], [Prezime], [Ime], [ImeOca], [ecBit], [Titula], [Funkcija], [DjevPrezime], [MjestoRodjenja], [OpstinaRodjenja], [DatumRodjenja], [Drzavljanstvo], [Nacionalnost], [PorodicnoStanje], [FaktorOdbitka], [MjestoStan], [AdresaStan], [OpstinaStan], [TelefonStan], [TelefonMob], [Zanimanje], [StrucnaSprema], [ZavrsenaSkola], [PoslovnaJedinica], [RadnoMjesto], [DatumPrvogZapos], [PrethodniStazMj], [PrethodniStazDan], [DatumZapos], [TipRadnogOdnosa], [NacinPrestankaRO], [DatumPrestankaRO], [BrLK], [BrRadneKnj], [OpstinaIzdavanjaRK], [LicniBrOsiguranja], [NacinIsplate], [BrTekucegRn], [Banka], [Napomena], [PoreskaOlaksica], [Beneficija], [LicniKoef], [PrethodniStazUFirmiMj], [PrethodniStazUFirmiDan])
SELECT [RadID], [JMBG], [Prezime], [Ime], [ImeOca], [ecBit], [Titula], [Funkcija], [DjevPrezime], [MjestoRodjenja], [OpstinaRodjenja], [DatumRodjenja], [Drzavljanstvo], [Nacionalnost], [PorodicnoStanje], [FaktorOdbitka], [MjestoStan], [AdresaStan], [OpstinaStan], [TelefonStan], [TelefonMob], [Zanimanje], [StrucnaSprema], [ZavrsenaSkola], [PoslovnaJedinica], [RadnoMjesto], [DatumPrvogZapos], [PrethodniStazMj], [PrethodniStazDan], [DatumZapos], [TipRadnogOdnosa], [NacinPrestankaRO], [DatumPrestankaRO], [BrLK], [BrRadneKnj], [OpstinaIzdavanjaRK], [LicniBrOsiguranja], [NacinIsplate], [BrTekucegRn], [Banka], [Napomena], [PoreskaOlaksica], [Beneficija], [LicniKoef], [PrethodniStazUFirmiMj], [PrethodniStazUFirmiDan] 
FROM [EC201001].[dbo].[Radnik]

