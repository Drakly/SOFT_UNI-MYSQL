SELECT 
	c.id,
    c.name,
    c.continent,
    c.currency 
    FROM countries AS c
	ORDER BY currency DESC, id;