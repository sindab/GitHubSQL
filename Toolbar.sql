UPDATE [DokTip] 
SET ecBit = dbo.ecBitSet(ecBit, 4, 1) -- na toolbar
WHERE dtID IN ('18001','19001','30110','30210','40110','40210','48000','80000','90001','95100')
