-- ========================================================================
-- 1. CREATE REQUIRED TABLES
-- ========================================================================
-- (log table, slightly enhanced with an 'action_type' column for better tracking)
	CREATE TABLE IF NOT EXISTS user_log (
		log_id INT AUTO_INCREMENT PRIMARY KEY,
		user_id INT,
		name VARCHAR(100),
		action_type VARCHAR(255), -- Added to see what triggered the log
		created_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP
	);
-- (New table for Analytics: Real-time aggregated metrics)
	CREATE TABLE IF NOT EXISTS company_metrics (
		metric_id INT AUTO_INCREMENT PRIMARY KEY,
		total_headcount INT DEFAULT 0,
		total_payroll DECIMAL(15,2) DEFAULT 0.00
	);
	-- Initialize our metrics table with a single row to update later
		INSERT INTO company_metrics (total_headcount, total_payroll) VALUES (25, 1000000.00);

-- ========================================================================
-- TRIGGER 1: AFTER INSERT (Your original, plus analytics tracking)
-- Use Case: Logging events and updating running totals when new data arrives.
-- ========================================================================
DELIMITER //
CREATE TRIGGER after_user_insert
AFTER INSERT ON users
FOR EACH ROW 		-- Executes the logic for every single row inserted
BEGIN
-- 1. Log the insertion (Your original logic)
    INSERT INTO user_log (user_id, name, action_type)
    VALUES (NEW.id, NEW.name, 'INSERT: New User Added');
-- 2. Analytics context: Update live dashboard metrics automatically
    UPDATE company_metrics 
    SET total_headcount = total_headcount + 1,
        total_payroll = total_payroll + NEW.salary;
END //
DELIMITER ;

-- ========================================================================
-- TRIGGER 2: BEFORE INSERT
-- Use Case: Data Cleaning and Validation before it enters your data warehouse.
-- ========================================================================
DELIMITER //
CREATE TRIGGER before_user_insert
BEFORE INSERT ON users
FOR EACH ROW
BEGIN
-- Data Cleaning: Ensure emails are always lowercase for accurate grouping/joining
    SET NEW.email = LOWER(NEW.email);
-- Data Validation: Prevent negative salaries from breaking analytical models
    IF NEW.salary < 0 THEN
        SET NEW.salary = 0; 
    END IF;
END //
DELIMITER ;

-- ========================================================================
-- TRIGGER 3: AFTER UPDATE
-- Use Case: Tracking Slowly Changing Dimensions (SCD) and historical changes.
-- ========================================================================
DELIMITER //
CREATE TRIGGER after_user_update
AFTER UPDATE ON users
FOR EACH ROW
BEGIN
-- Only log if the salary actually changed
    IF OLD.salary != NEW.salary THEN
	-- Log the old vs new value for historical analytics
        INSERT INTO user_log (user_id, name, action_type)
        VALUES (NEW.id, NEW.name, CONCAT('UPDATE: Salary changed from ', OLD.salary, ' to ', NEW.salary));
    -- Adjust the live payroll metrics by removing the old salary and adding the new one
        UPDATE company_metrics 
        SET total_payroll = total_payroll - OLD.salary + NEW.salary;
    END IF;
END //
DELIMITER ;

-- ========================================================================
-- TRIGGER 4: BEFORE DELETE
-- Use Case: Archiving records or preventing accidental data loss.
-- ========================================================================
DELIMITER //
CREATE TRIGGER before_user_delete
BEFORE DELETE ON users
FOR EACH ROW
BEGIN
-- Log who was deleted
    INSERT INTO user_log (user_id, name, action_type)
    VALUES (OLD.id, OLD.name, 'DELETE: User Removed');
-- Reduce our analytical totals
    UPDATE company_metrics 
    SET total_headcount = total_headcount - 1,
        total_payroll = total_payroll - OLD.salary;
END //
DELIMITER ;

-- ========================================================================
-- TESTING THE TRIGGERS (Executing Queries)
-- ========================================================================

-- 1. Test BEFORE INSERT (Capital email will be lowercased) 
-- & AFTER INSERT (Log created, metrics increased)
-- Note: Fixed syntax error in date '2005*09-15' to '2005-09-15'
	INSERT INTO users (name, email, gender, date_of_birth, salary) VALUES
	('Sohan', 'SOHAN@example.com', 'Male', '2005-09-15', 55000);

-- 2. Test BEFORE INSERT validation (Negative salary will be converted to 0)
	INSERT INTO users (name, email, gender, date_of_birth, salary) VALUES
	('Alice', 'ALICE@example.com', 'Female', '1995-10-20', -5000);

-- 3. Test AFTER UPDATE (Will trigger a log entry and adjust total payroll)
	UPDATE users SET salary = 60000 WHERE name = 'Sohan';

-- 4. Test BEFORE DELETE (Will trigger a log entry and reduce headcount)
	DELETE FROM users WHERE name = 'Alice';

-- ========================================================================
-- VIEWING THE ANALYTICS RESULTS
-- ======================================================================== */
-- See your clean, validated user table
	SELECT '--- USERS TABLE ---' AS Output;
	SELECT * FROM users;
-- See the automated audit trail built by triggers
	SELECT '--- AUDIT LOG TABLE ---' AS Output;
	SELECT * FROM user_log;
-- See the real-time aggregated analytics
	SELECT '--- REAL-TIME METRICS ---' AS Output;
	SELECT * FROM company_metrics;

-- ========================================================================
-- CLEANUP: How to remove triggers if you need to modify them
-- ========================================================================
	DROP TRIGGER IF EXISTS before_user_insert;
	DROP TRIGGER IF EXISTS after_user_insert;
	DROP TRIGGER IF EXISTS after_user_update;
	DROP TRIGGER IF EXISTS before_user_delete;

/*
-- ========================================================================
		Summary :-
-- ========================================================================
For data analytics, triggers act as an automated data-engineering pipeline built directly into your database. Here is what you need to remember:
	FOR EACH ROW:	This is mandatory in MySQL. It means the trigger will execute individually for every row affected by your SQL statement.
					If an UPDATE changes 1,000 rows, the trigger runs 1,000 times.
	BEFORE vs. AFTER:
		BEFORE: 	Best used for Data Cleaning & Validation. It allows you to intercept the data and modify it (SET NEW.column = ...)
					before it gets saved. (e.g., standardizing text, enforcing minimum values).
		AFTER: 		Best used for Logging & Aggregation. The data is already saved, so you use this to insert audit logs, update separate summary
					tables, or track historical changes.
	NEW vs. OLD Modifiers:
		NEW.column_name: 	Refers to the incoming data you are trying to write. Available in INSERT and UPDATE triggers.
		OLD.column_name: 	Refers to the existing data currently sitting in the table. Available in UPDATE and DELETE triggers.
	Analytics Use Cases:  Triggers save you from writing complex batch-processing scripts by handling real-time dimension tracking, automated aggregations (like running totals), and enforcing data quality at the source.
*/