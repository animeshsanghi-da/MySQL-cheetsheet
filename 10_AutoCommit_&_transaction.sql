-- ---------------------------------------------------------------------
-- 1: UNDERSTANDING & DISABLING AUTOCOMMIT
-- ---------------------------------------------------------------------
-- By default, MySQL automatically saves (commits) every query you run.
	-- Let's check the current status (1 = ON, 0 = OFF)
		SELECT @@autocommit; 
-- For data analytics, turn it OFF before doing massive data cleaning.
	-- This starts a manual transaction, giving you an "Undo" button.
		SET autocommit = 0; 

-- ---------------------------------------------------------------------
-- 2: THE "OOPS" SCENARIO (USING ROLLBACK)
-- ---------------------------------------------------------------------
-- Scenario: You want to delete inactive users, but you make a mistake and accidentally delete ALL users.
	SET SQL_SAFE_UPDATES = 0;
	DELETE FROM users; -- Uh oh.
-- Let's check the table. It's empty! 
	SELECT * FROM users; 
-- Because autocommit is 0, this isn't permanently saved to the database yet.
-- Let's undo the mistake.
	ROLLBACK; 
-- Check again. Phew! Your data is back.
	SELECT * FROM users; 

-- ---------------------------------------------------------------------
-- 3: THE SUCCESS SCENARIO (USING COMMIT)
-- ---------------------------------------------------------------------
-- Scenario: You are tasked with standardizing data for an analytics report. 
-- You need to give a 10% salary bump to everyone born before 1990.
-- Run the update:
	UPDATE users SET salary = salary * 1.10 WHERE date_of_birth < '1990-01-01';
-- Verify the update worked correctly (Check Raj, Priyanka, Meera, etc.)
	SELECT name, date_of_birth, salary FROM users WHERE date_of_birth < '1990-01-01';
-- Everything looks mathematically correct. Now we permanently save it.
	COMMIT; 
-- Once you type COMMIT, you can no longer ROLLBACK this specific change.

-- ---------------------------------------------------------------------
-- 4: USING EXPLICIT TRANSACTIONS (ALTERNATIVE METHOD)
-- ---------------------------------------------------------------------
-- If you want to leave autocommit ON (for normal workflow)
	SET autocommit = 1; -- Turn it back to default behavior
-- but still want safety for a specific scary query,
-- use START TRANSACTION.
	START TRANSACTION; 
	-- Delete outlier salaries
		DELETE FROM users WHERE salary < 50000;
	-- Verify
		SELECT COUNT(*) FROM users ORDER BY salary ASC;
-- Choose one of the following to end the transaction:
	ROLLBACK;  	-- Run this to undo the delete
	COMMIT; 	-- Run this to save the delete

-- ---------------------------------------------------------------------
-- BEST PRACTICES FOR DATA ANALYSTS
-- ---------------------------------------------------------------------
--  1. Always write `SELECT` statements to preview your `WHERE` clauses before putting them into an `UPDATE` or `DELETE`.
--  2. When manipulating raw data, always start with `SET autocommit = 0;`.
--  3. Don't forget to `COMMIT` or `ROLLBACK` when you are done! If you leave a transaction open, it can lock the tables for other users.