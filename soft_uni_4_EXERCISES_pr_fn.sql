DELIMITER $$
CREATE PROCEDURE usp_get_employees_salary_above_35000()
BEGIN 
	SELECT 	
		first_name,
        last_name 
        FROM employees
        WHERE salary > 35000
        ORDER BY first_name, last_name, employee_id;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE usp_get_employees_salary_above(`salary` DECIMAL(19,4))
BEGIN
	SELECT 
		first_name,
        last_name
        FROM employees
        WHERE salary >= salary
        ORDER BY first_name, last_name, employee_id;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE usp_get_towns_starting_with(`string` VARCHAR(255))
BEGIN
	SELECT 
		name AS 'town_name'
        FROM towns
        WHERE towns.name LIKE CONCAT(string, '%')
        ORDER BY town_name;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE usp_get_employees_from_town(`town_name` VARCHAR(255))
BEGIN
	SELECT 
		e.first_name,
        e.last_name
        FROM employees AS e
			JOIN addresses AS a ON a.address_id = e.address_id
            JOIN towns AS t ON t.town_id = a.town_id
		WHERE t.name = town_name
        ORDER BY e.first_name, e.last_name, e.employee_id;
END$$
DELIMITER ;


DELIMITER $$
CREATE FUNCTION ufn_get_salary_level(`salary` DECIMAL(19,4))
	RETURNS VARCHAR(255)
    DETERMINISTIC
BEGIN 
	RETURN (
		SELECT 
        CASE 
        WHEN salary < 30000 THEN 'Low'
        WHEN salary <= 50000 THEN 'Average'
        WHEN salary > 50000 THEN 'High'
        END AS `salary_level`
        );
END$$

DELIMITER ;


DELIMITER $$
CREATE PROCEDURE usp_get_employees_by_salary_level(`salary_level` VARCHAR(255))
BEGIN
	SELECT 
    first_name,
    last_name
    FROM employees
    WHERE ufn_get_salary_level(salary) = salary_level
    ORDER BY first_name DESC, last_name DESC;
END$$
DELIMITER ;



DELIMITER $$
CREATE FUNCTION  ufn_is_word_comprised(`set_of_letters` varchar(50), `word` varchar(50))
RETURNS TINYINT
DETERMINISTIC
	BEGIN 
		RETURN (
			SELECT word REGEXP CONCAT('^[', set_of_letters, ']+$')
        );
	END $$
DELIMITER ;