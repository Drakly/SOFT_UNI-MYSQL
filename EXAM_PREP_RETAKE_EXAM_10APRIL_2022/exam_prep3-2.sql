INSERT INTO actors(first_name, last_name, birthdate, height, awards, country_id)
	SELECT 
		REVERSE(first_name),
		REVERSE(last_name),
        DATE_ADD(birthdate, INTERVAL - 2 DAY),
        height + 10,
        country_id,
        3
	FROM actors
    WHERE id <= 10;
        
        