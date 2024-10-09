DELETE c
	FROM countries AS c
    LEFT JOIN movies AS m ON c.id = m.country_id
    WHERE country_id IS NULL;
    
    