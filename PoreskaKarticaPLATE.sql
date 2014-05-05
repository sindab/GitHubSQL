INSERT INTO [RegSif](
[dtID], [ID], [Naziv], [Vrijednost], 
[Datum], [VdtID], [vID], [ecBit], [Opis], [DatumDo], 
[VdtID2], [vID2], [VdtID3], [vID3], [LastEditDate], [CreationDate])
SELECT '17015', 2, 'Poreska kartica', 1, 
getdate(), '17010', '2', 0, '', GetDate(), 
'17012','2', '17007', '1', GetDate(), GetDate()

INSERT INTO [RegSif](
[dtID], [ID], [Naziv], [Vrijednost], 
[Datum], [VdtID], [vID], [ecBit], [Opis], [DatumDo], 
[VdtID2], [vID2], [VdtID3], [vID3], [LastEditDate], [CreationDate])
SELECT '17012', '2', 'Obracun poreska kartica', 0, 
getdate(), 0, 0, 0, '', GetDate(), 
0, 0, 0, 0, GetDate(), GetDate()

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO






ALTER      PROCEDURE ecObracunIzdatakaZaPlatu(
	@ObrPeriod as int,
	@RadID as int,
	@PonistiObracun as int = 0
)

AS

DELETE FROM ObrIzdaci WHERE ObrPeriod = @ObrPeriod and RadID = @RadID

IF @PonistiObracun = 0
BEGIN

 	DECLARE @IznosSUM as numeric(19,8)
	SELECT @IznosSUM = (ISNULL(CASE WHEN SUM([OsnovicaZaDoprinoseIznos]) > 250 THEN SUM([OsnovicaZaDoprinoseIznos]) ELSE 250 END, 0)-20)/0.63848
	FROM [vObrPlata]
	WHERE [ObrPeriod] = @ObrPeriod and [RadID] = @RadID --and OsnovicaZaPorez = 1

	DECLARE @NeoporeziviDio as NUMERIC(19,6)
	SELECT @NeoporeziviDio = MinPlata FROM ObrPeriod WHERE AutoID = @ObrPeriod


	DECLARE @doprinosID AS VARCHAR(5)
	DECLARE @doprinosStopa AS NUMERIC(19,6)
	
	DECLARE crsDoprinos CURSOR FAST_FORWARD READ_ONLY FOR
	SELECT [ID], Vrijednost FROM RegSif WHERE dtID = '17014' 
	OPEN crsDoprinos
	FETCH NEXT FROM crsDoprinos INTO @doprinosID, @doprinosStopa
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF ISNULL(@IznosSUM, 0) > 0
		BEGIN
			INSERT INTO [ObrIzdaci]([ObrPeriod], [RadID], [Vrsta], [Osnovica], [Stopa], [Iznos], [ecBit])
			SELECT @ObrPeriod, @radID, @doprinosID, ROUND(@IznosSUM,2), @doprinosStopa, ROUND(@IznosSUM * @doprinosStopa,2), 2
		END
		FETCH NEXT FROM crsDoprinos INTO @doprinosID, @doprinosStopa
	END
	CLOSE crsDoprinos
	DEALLOCATE crsDoprinos

	--POREZ
	DECLARE @iznosDopSUM as NUMERIC(19,6)
	SELECT @iznosDopSUM = SUM([Iznos])
	FROM [ObrIzdaci]
	WHERE [ObrPeriod] = @ObrPeriod and [RadID] = @RadID and Vrsta NOT IN ('99')


	DECLARE @OsnovaZaPorez as NUMERIC(19,6)
	SET @OsnovaZaPorez = @IznosSUM - @iznosDopSUM - @NeoporeziviDio

	DECLARE @porezID AS VARCHAR(5)
	DECLARE @porezStopa AS NUMERIC(19,6)

	DECLARE @poreskaKartica as numeric(9,2)
	SELECT @poreskaKartica = ISNULL(SUM(Iznos),0) FROM ObrPlata WHERE [ObrPeriod] = @ObrPeriod and [RadID] = @RadID and VrstaRada = 2
	
	DECLARE crsporez CURSOR FAST_FORWARD READ_ONLY FOR
	SELECT TOP 1 [ID], Vrijednost FROM RegSif WHERE dtID = '17020' ORDER BY AutoID DESC --ZADNJE UNESENA PORESKA STOPA
	OPEN crsporez
	FETCH NEXT FROM crsporez INTO @porezID, @porezStopa
	WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO [ObrIzdaci]([ObrPeriod], [RadID], [Vrsta], [Osnovica], [Stopa], [Iznos], [ecBit])
		SELECT @ObrPeriod, RadID, @porezID, ROUND(@OsnovaZaPorez-ISNULL(PoreskaOlaksica,0),2), @porezStopa, CASE WHEN ROUND(((@OsnovaZaPorez-ISNULL(PoreskaOlaksica,0)) * @porezStopa) - @poreskaKartica,2) > 0 THEN ROUND(((@OsnovaZaPorez-ISNULL(PoreskaOlaksica,0)) * @porezStopa) - @poreskaKartica,2) ELSE 0 END , 4
		FROM Radnik WHERE RadID = @radID

		FETCH NEXT FROM crsporez INTO @porezID, @porezStopa
	END
	CLOSE crsporez
	DEALLOCATE crsporez
END
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

