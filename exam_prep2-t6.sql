SELECT 
	d.id,
    d.name,
    c.brand
    FROM instructors_driving_schools AS i
		RIGHT JOIN driving_schools AS d ON d.id = i.driving_school_id
        JOIN cars AS c ON c.id = d.car_id
	WHERE i.instructor_id IS NULL
    ORDER BY c.brand, d.id
    LIMIT 5;