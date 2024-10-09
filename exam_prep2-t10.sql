DELIMITER $$

CREATE FUNCTION udf_average_lesson_price_by_city (name VARCHAR(40))
RETURNS DECIMAL(19,2)
DETERMINISTIC 
	BEGIN 
		DECLARE average_lesson_price DECIMAL(19,2);
        
        SELECT AVG(ds.average_lesson_price) INTO average_lesson_price
        FROM driving_schools AS ds
			JOIN cities AS c ON c.id = ds.city_id
		WHERE c.name = `name`;
	
    RETURN average_lesson_price;
	END $$
DELIMITER ;