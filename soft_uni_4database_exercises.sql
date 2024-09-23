USE soft_uni;

SELECT 
	department_id,
    MIN(salary) AS `minimum_salary`
FROM employees
WHERE hire_date > '2000-01-01'
GROUP BY department_id
HAVING department_id IN (2, 5, 7 )
ORDER BY department_id;    

SET SQL_SAFE_UPDATES = 0;

CREATE TABLE highest_paid_employees
SELECT * FROM employees
WHERE salary > 30000;

DELETE FROM highest_paid_employees
WHERE manager_id = 42;

UPDATE highest_paid_employees
SET salary = salary + 5000
WHERE department_id = 1;

SELECT 
	department_id,
    AVG(salary) AS `avg_salary`
FROM highest_paid_employees
GROUP BY department_id
ORDER BY department_id;


SELECT 
	department_id,
    MAX(salary) AS `max_salary`
FROM employees
GROUP BY department_id
HAVING max_salary < 30000 OR max_salary > 70000
ORDER BY department_id;


SELECT 
	COUNT(*) AS ''
    FROM employees
    WHERE manager_id IS NULL;
    
    
SELECT 
	department_id,
    (SELECT DISTINCT e.salary
    FROM employees AS e
    WHERE e.department_id = employees.department_id
    ORDER BY e.salary DESC
    LIMIT 1 OFFSET 2 ) AS 'third_highest_salary'
FROM employees
GROUP BY department_id
HAVING third_highest_salary IS NOT NULL
ORDER BY department_id;


SELECT 
	first_name,
    last_name,
    department_id
FROM employees
WHERE salary > (
	SELECT AVG(salary)
    FROM employees AS e
    WHERE e.department_id = employees.department_id
)
GROUP BY department_id, employee_id
ORDER BY department_id, employee_id LIMIT 10;


SELECT 
	department_id,
    SUM(salary) AS `total_salary`
FROM employees
GROUP BY department_id 
ORDER BY department_id;
    