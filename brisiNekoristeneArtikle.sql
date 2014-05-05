-- VAZNA NAPOMENA:

-- nije iskontrolisano ako ima vise magacina


-- definisi vID pocetnog stanja
declare @vIDps as int
set @vIDps = 10000001


-- Spisak artikala koji na pocetnom stanju nemaju kolicinu (tj. kol = 0) i koji nisu koristeni u drugim dokumentima
-- provjeri s njima da li se svi mogu brisati

select * 
--delete
from reg 
where  
	proid not in (select distinct proid from ulazizlazdetalj where vid = @vIDps and kol <> 0) and
	proid not in (select distinct proid from ulazizlazdetalj where vid <> @vIDps)


-- Nakon brisanja artikala iz registra, donji script brise artikle sa pocetnog stanja kojih nema u registru

select *
--delete
from ulazizlazdetalj
where vid = @vIDps and proid not in (select proid from reg)
