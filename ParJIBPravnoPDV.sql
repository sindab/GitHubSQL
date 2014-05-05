--JIB
UPDATE [dbo].[Par]
SET [PIB]=CASE ISNULL(JIB,'') WHEN '' THEN ISNULL(PIB,'') ELSE '4' + JIB END
WHERE ISNULL(PIB,'')='' and len(JIB)=12
go
UPDATE [dbo].[Par]
SET [PIB]=CASE ISNULL(JIB,'') WHEN '' THEN ISNULL(PIB,'') ELSE JIB END
WHERE ISNULL(PIB,'')='' and len(JIB)=13
go

--pravno
UPDATE [dbo].[Par]
SET [ecBit]=CASE ISNULL(PIB,'') WHEN '' THEN ecBit ELSE [dbo].[ecBitSet](ecBit, 13, 1) END
go

ALTER   FUNCTION [dbo].[ecBitSet] (@X bigInt, @N bigint, @Value bit)  
RETURNS bigint AS  
BEGIN 

IF (@Value = 1) 
BEGIN
--SET @X =  @X | dbo.ecBitMask(@N)   -- OR = |   ,   XOR = ^
--SET @X =  @X | @N   -- OR = |   ,   XOR = ^
SET @X =  @X | POWER(CAST(2 as bigint),@N)   -- OR = |   ,   XOR = ^
END
ELSE
BEGIN
--SET @X = @X & (~dbo.ecBitMask(@N))	-- AND = &  , NOT = ~
SET @X = @X & ~POWER(CAST(2 as bigint),@N)	-- AND = &  , NOT = ~
END

RETURN @X
END
go


--PDV
UPDATE [dbo].[Par]
SET [ecBit]=CASE LEN(ISNULL(RTRIM(LTRIM(PIB)),''))+LEN(ISNULL(RTRIM(LTRIM(JIB)),'')) WHEN 0 THEN [dbo].[ecBitSet](ecBit, 39, 0)/*ecBit | POWER(cast(2 as bigint),39)*/ ELSE ecBit END

