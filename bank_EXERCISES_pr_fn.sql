USE bank;

DELIMITER $$

CREATE PROCEDURE  usp_get_holders_full_name()
BEGIN 
	SELECT
		CONCAT_WS(' ', first_name, last_name) AS `full_name`
	FROM account_holders
    ORDER BY full_name, id;
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE usp_get_holders_with_balance_higher_than(`balance` DECIMAL(19,2))
BEGIN
	SELECT 
		ah.first_name, ah.last_name
	FROM account_holders AS ah
		JOIN accounts AS a ON ah.id = a.account_holder_id
	GROUP BY ah.id, ah.first_name, ah.last_name
    HAVING SUM(a.balance) > balance
    ORDER BY ah.id;

END $$

DELIMITER ;


DELIMITER $$
CREATE FUNCTION  ufn_calculate_future_value(`sum` DECIMAL(19, 4), `yearly_interest_rate` DECIMAL(19, 4), `number_of_years` INT)
RETURNS DECIMAL(19, 4)
DETERMINISTIC
	BEGIN
		DECLARE future_value DECIMAL(19, 4);
         
        SET future_value = sum * POWER(1 + yearly_interest_rate, number_of_years);
        
        RETURN future_value;
    END$$
    
DELIMITER ;

DELIMITER $$

CREATE PROCEDURE usp_calculate_future_value_for_account(`account_id` INT, `interest_rate` DECIMAL(19, 4))
BEGIN
	SELECT 
    a.id AS `account_id`,
    ah.first_name,
    ah.last_name,
    a.balance AS `current_balance`,
    bank.ufn_calculate_future_value(a.balance, interest_rate, 5) AS `balance_in_5_years`
    FROM account_holders AS ah
		JOIN accounts AS a ON ah.id = a.account_holder_id
	WHERE a.id = account_id;
    
END $$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE  usp_deposit_money(`account_id` INT, `money_amount` DECIMAL (19, 4))
BEGIN
	START TRANSACTION;
    IF ((SELECT COUNT(*) FROM accounts WHERE id = account_id) <> 1 OR money_amount < 0) THEN 
    ROLLBACK;
    ELSE 
		UPDATE accounts SET balance = balance + money_amount WHERE id = account_id;
        COMMIT;
	END IF;
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE  usp_withdraw_money(`account_id` INT, `money_amount` DECIMAL (19, 4))
BEGIN
	START TRANSACTION;
    IF ((SELECT COUNT(*) FROM accounts WHERE id = account_id) <> 1 OR money_amount < 0 OR(SELECT balance FROM accounts WHERE id = account_id) < money_amount) THEN 
    ROLLBACK;
    ELSE 
		UPDATE accounts SET balance = balance - money_amount WHERE id = account_id;
        COMMIT;
	END IF;
END $$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE usp_transfer_money(`from_account_id` INT, `to_account_id` INT, `amount` DECIMAL(19, 4))
BEGIN 
	START TRANSACTION;
    IF ((SELECT COUNT(*) FROM accounts WHERE id = from_account_id) <> 1 OR
		(SELECT COUNT(*) FROM accounts WHERE id = to_account_id) <> 1 OR 
        (SELECT balance  FROM accounts WHERE id = from_account_id) < amount OR 
        (SELECT balance FROM accounts WHERE id = to_account_id) < amount)  THEN
        ROLLBACK;
	ELSE 
		CALL usp_deposit_money(to_account_id, amount);
        CALL usp_withdraw_money(from_account_id, amount);
        COMMIT;
	END IF;
END $$

DELIMITER ;


CREATE TABLE logs(
	log_id INT PRIMARY KEY AUTO_INCREMENT,
    account_id INT,
    old_sum DECIMAL(19, 4),
    new_sum DECIMAL (19, 4)
);

DELIMITER $$

CREATE TRIGGER trg_log_balance_change
	AFTER UPDATE ON accounts
    FOR EACH ROW
    
    BEGIN
    IF OLD.balance <> NEW.balance THEN 
		INSERT INTO logs (account_id, old_sum, new_sum)
        VALUES (NEW.id, OLD.balance, NEW.balance); 
	END IF;
    END$$

DELIMITER ;


CREATE TABLE notification_emails(
    id INT AUTO_INCREMENT PRIMARY KEY,
    recipient INT,
    subject VARCHAR(255),
    body TEXT
);

DELIMITER $$
CREATE TRIGGER trg_create_notification_email
    AFTER INSERT ON logs
    FOR EACH ROW
BEGIN
    DECLARE email_subject VARCHAR(255);
    DECLARE email_body TEXT;
    SET email_subject = CONCAT('Balance change for account: ', NEW.account_id);
    SET email_body = CONCAT('On ', DATE_FORMAT(NOW(), '%Y-%m-%d'), ' your balance was changed from ', NEW.old_sum, ' to ', NEW.new_sum, '.');
    INSERT INTO notification_emails (recipient, subject, body)
    VALUES (NEW.account_id, email_subject, email_body);
END $$
DELIMITER ;