USE diablo;

SELECT name, DATE_FORMAT(start, '%Y-%m-%d') AS `start`
FROM games
WHERE YEAR(start) IN (2011,2012)
ORDER BY start, name
LIMIT 50;

SELECT user_name, SUBSTRING(email, LOCATE('@', email) + 1) AS `email_provider`
FROM users
ORDER BY email_provider, user_name;

SELECT user_name, ip_address
FROM users
WHERE ip_address LIKE ('___.1%.%.___')
ORDER BY user_name;


SELECT name AS `game`,
CASE
    WHEN HOUR(start) < 12 THEN 'Morning'
    WHEN HOUR(start) < 18 THEN 'Afternoon'
    WHEN HOUR(start) < 24 THEN 'Evening'
END AS `Part of the day`,
CASE
    WHEN duration < 4 THEN 'Extra Short'
    WHEN duration < 7 THEN 'Short'
    WHEN duration < 11 THEN 'Long'
    ELSE 'Extra Long'
END AS `Duration`
FROM games;

SELECT 
	product_name,
    order_date,
    DATE_ADD(order_date, INTERVAL 3 DAY) AS `pay_due_date`,
    DATE_ADD(order_date, INTERVAL 1 MONTH) AS `deliver_due_date`
    FROM orders;
    
    