SELECT 
	p.name,
    COUNT(w.is_armed) AS `armed_workers`
	FROM preserves AS p
		JOIN workers AS w ON p.id = w.preserve_id
	WHERE w.is_armed IS TRUE
    GROUP BY p.name
    ORDER BY armed_workers DESC, p.name;
	
    
    