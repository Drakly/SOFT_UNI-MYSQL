USE soft_uni_3;

SELECT 
	e.employee_id,
    e.job_title,
    e.address_id,
    a.address_text
    FROM employees AS e
    JOIN addresses AS a ON a.address_id = e.address_id
    ORDER BY a.address_id LIMIT 5;
    
    
SELECT 
	e.first_name,
    e.last_name,
    t.name,
    a.address_text
    FROM employees AS e
		JOIN addresses AS a ON a.address_id = e.address_id
        JOIN towns AS t ON t.town_id = a.town_id
	ORDER BY e.first_name, e.last_name LIMIT 5;
    
    
SELECT 
	e.employee_id,
    e.first_name,
    e.last_name,
    d.name 
    FROM employees AS e
    JOIN departments AS d ON d.department_id = e.department_id
WHERE d.name = 'Sales'
ORDER BY e.employee_id DESC;


SELECT 
	e.employee_id,
    e.first_name,
    e.salary,
    d.name
    FROM employees AS e
		JOIN departments AS d ON d.department_id = e.department_id
WHERE e.salary > 15000
ORDER BY e.department_id DESC LIMIT 5;


SELECT 
	e.employee_id,
    e.first_name
    FROM employees AS e
    LEFT JOIN employees_projects AS ep ON e.employee_id = ep.employee_id
WHERE ep.project_id IS NULL
ORDER BY e.employee_id DESC LIMIT 3;


SELECT 
	e.first_name,
    e.last_name,
    e.hire_date,
    d.name AS 'dept_name'
    FROM employees AS e
		JOIN departments AS d ON d.department_id = e.department_id
	WHERE e.hire_date > '1999/01-01' AND d.name IN ('Sales', 'Finance')
    ORDER BY e.hire_date;
    
    
SELECT 
	e.employee_id,
    e.first_name,
    p.name AS 'project_name'
FROM employees AS e
	JOIN employees_projects AS ep ON e.employee_id = ep.employee_id
    JOIN projects AS p ON ep.project_id = p.project_id
WHERE DATE (p.start_date) > '2002-08-13' AND p.end_date IS NULL
ORDER BY e.first_name, p.name LIMIT 5;


SELECT 
	e.employee_id,
    e.first_name,
	CASE 
		WHEN YEAR(p.start_date) >= '2005' THEN NULL
        ELSE p.name
	END AS 'project_name'
    FROM employees AS e
		JOIN employees_projects AS ep ON e.employee_id = ep.employee_id
        JOIN projects AS p ON ep.project_id = p.project_id
	WHERE e.employee_id = 24 
    ORDER BY project_name;
    
SELECT MIN(avg_salary) AS lowest_avg_salary
FROM (SELECT AVG(salary) AS avg_salary
		FROM employees
		GROUP BY department_id) AS department_averages;