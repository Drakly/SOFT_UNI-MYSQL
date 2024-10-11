SELECT 
	CONCAT(LEFT(p.description, 30), '...'),
    p.date 
    FROM photos AS p
    WHERE DAY(p.date) = 10
    ORDER BY p.date DESC;