/*
#Region " Radno stanje dokumenta (RAS) "
    'Table UI, field RAS (Radno stanje dokumenta)
    Public Enum ecDokRAS
        KnjizenjeURobno = 0
        KnjizenjeUKomitente = 1
        KnjizenjeUFinansije = 2
        Neproknjizen = 3
        'Brisan = 4
        Storno = 5
        UKoristenju = 6
        PazarZakljucenaKasa = 7 '0 pazar se moze knjiziti, 1 pazar se ne moze knjiziti, zakljuci kasu
        Rezervacija = 8
        UNarudzbi = 9
        Automatski = 10
        ParcijalnaNiv = 11
        AutoPrenosnicaOdMPFakture = 12
        FakturisanaOtpremnica = 13
        FiskalnaStampa = 14
        Garancija = 15 'Radni nalog servis
        LOHN = 16 'roba sa dokumenta je pod carinskim nadzorom, JCI
        PartnerUPdvSistemu = 17 'zbog PDV prijave, u trenutku izmjene partnera na dokumentu
    End Enum
#End Region
*/

SELECT [dbo].[ecBitTest] (
   RAS
  ,0) FROM dbo.UlazIzlaz WHERE vID = 1
  

