select [vID], [Dokument], [Datum], 
	sum([ZaduzenjeBezPoreza]) zbp, sum([RazduzenjeBezPoreza]) rbp, 
	sum([ZaduzenjeSaPorezom]) zsp, sum([RazduzenjeSaPorezom]) rsp, 
	sum([ZaduzenjePorez]) zp, sum([RazduzenjePorez]) rp
FROM (
	SELECT [vID], [Dokument], [Datum], 
	[ZaduzenjeBezPoreza], [RazduzenjeBezPoreza], [ZaduzenjeSaPorezom], [RazduzenjeSaPorezom], [ZaduzenjePorez], [RazduzenjePorez]
	FROM [VTrgKnjigaNew]
	where mid=1
	
	UNION ALL
	
	SELECT [vID], [DOKUMENT], [Datum], 
	-1*[ZaduzenjeBezPoreza], -1*[RazduzenjeBezPoreza], -1*[ZaduzenjeSaPorezom], -1*[RazduzenjeSaPorezom], -1*[ZaduzenjePorez], -1*[RazduzenjePorez] 
	FROM [vTrgPorezNew]
	where mid=1
	--order by vid
) t
group by [vID], [Dokument], [Datum]

having sum([ZaduzenjeBezPoreza]) + sum([RazduzenjeBezPoreza]) +
	sum([ZaduzenjeSaPorezom]) + sum([RazduzenjeSaPorezom]) +
	sum([ZaduzenjePorez]) + sum([RazduzenjePorez]) > 0

