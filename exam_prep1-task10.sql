DELIMITER $$

CREATE PROCEDURE increase_salaries_by_country(country_name VARCHAR(40))
BEGIN 
	UPDATE workers AS w
		JOIN countries_preserves AS cp ON w.preserve_id = cp.preserve_id
        JOIN countries AS c ON c.id = cp.country_id
	SET salary = w.salary * 1.05
    WHERE c.name = `country_name`;
END $$

DELIMITER ;

