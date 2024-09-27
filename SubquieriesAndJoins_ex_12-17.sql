USE geography_3;

SELECT
    c.country_code,
    COUNT(m.mountain_range) AS `mountain_range`
FROM countries AS c
         JOIN mountains_countries mc on c.country_code = mc.country_code
         JOIN mountains m on m.id = mc.mountain_id
WHERE c.country_name IN ('United States', 'Russia ', 'Bulgaria')
GROUP BY c.country_code
ORDER BY mountain_range DESC ;

SELECT
    c.country_name,
    r.river_name
FROM countries AS c
    LEFT JOIN countries_rivers cr on c.country_code = cr.country_code
    LEFT JOIN rivers r on r.id = cr.river_id
    JOIN continents ct on ct.continent_code = c.continent_code
WHERE ct.continent_name = 'Africa'
ORDER BY c.country_name LIMIT 5;

SELECT 
	c.continent_code,
    c.currency_code,
    COUNT(*) AS `currency_usage`
    FROM countries AS c
    GROUP BY c.continent_code, c.currency_code
    HAVING currency_usage > 1 AND currency_usage = (
			SELECT 
            COUNT(*) AS `max_usage`
            FROM countries
            WHERE continent_code = c.continent_code
            GROUP BY currency_code
            ORDER BY max_usage DESC LIMIT 1
            )
	ORDER BY c.continent_code, c.currency_code;
    
SELECT
    c.country_name,
    MAX(p.elevation) AS `highest_peak_elevation`,
    MAX(r.length) AS `longest_river_length`
FROM countries AS c
    JOIN mountains_countries AS mc ON c.country_code = mc.country_code
    JOIN peaks AS p ON mc.mountain_id = p.mountain_id
    JOIN countries_rivers cr on c.country_code = cr.country_code
    JOIN rivers r on r.id = cr.river_id
GROUP BY c.country_name
ORDER BY highest_peak_elevation DESC, longest_river_length DESC
LIMIT 5;
    