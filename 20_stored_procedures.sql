-- --------------------------------------------------------------------------------------
-- 1. BASIC PROCEDURE: Multiple Result Sets
-- --------------------------------------------------------------------------------------
-- Create a procedure to retrieve data from multiple tables.
	DELIMITER //                            -- Changing the default delimiter from ; to //
	CREATE PROCEDURE get_all_tables()       -- Assigning a name to the procedure
	BEGIN                                   -- Procedure begins here...
		-- In analytics, returning multiple result sets at once can be useful for dashboards
		SELECT * FROM users;
		SELECT * FROM addresses;
		SELECT * FROM staging_users;
	END //                                  -- ...Procedure ends
	DELIMITER ;                             -- Revert the delimiter back to ;
-- Calling the procedure
	CALL get_all_tables();

-- --------------------------------------------------------------------------------------
-- 2. PROCEDURE WITH 'IN' PARAMETERS: Inserting and Viewing Data
-- --------------------------------------------------------------------------------------
-- Create a procedure to insert values dynamically.
	DELIMITER $$
	CREATE PROCEDURE adduser(
		IN a_name VARCHAR(100),
		IN a_email VARCHAR(100),
		IN a_gender ENUM('Male', 'Female', 'Other'),
		IN a_date_of_birth DATE,
		IN a_salary DECIMAL(10, 2),
		IN a_referred_by_id INT
	)
	BEGIN
		-- Insert the provided parameter values into the users table
		INSERT INTO users (name, email, gender, date_of_birth, salary, referred_by_id) 
		VALUES (a_name, a_email, a_gender, a_date_of_birth, a_salary, a_referred_by_id);
		
		-- Verify the insertion
		SELECT * FROM users;
	END $$
	DELIMITER ;
-- Inserting values using the procedure
	CALL adduser('chandu', 'chandu@example.com', 'Male', '1995-07-26', 80000.00, 22);

-- --------------------------------------------------------------------------------------
-- 3. PROCEDURE WITH 'OUT' PARAMETERS: Getting Aggregated Analytics
-- --------------------------------------------------------------------------------------
-- Useful for extracting a specific metric (e.g., total users, sum of sales).
	DELIMITER //
	CREATE PROCEDURE get_average_salary(
		OUT avg_salary DECIMAL(10, 2)       -- OUT parameter stores the result for later use
	)
	BEGIN
		-- Calculate average salary and store it directly into the OUT parameter
		SELECT AVG(salary) INTO avg_salary FROM users;
	END //
	DELIMITER ;
-- Call the procedure, passing a session variable (@avg_sal) to catch the output
	CALL get_average_salary(@avg_sal);
-- Select the variable to view your calculated metric
	SELECT @avg_sal AS average_company_salary;

-- --------------------------------------------------------------------------------------
-- 4. PROCEDURE WITH VARIABLES & CONTROL FLOW: Dynamic Logic
-- --------------------------------------------------------------------------------------
-- Determine a user's analytical segment based on conditional logic (IF/ELSE).
	DELIMITER $$
	CREATE PROCEDURE check_user_segment(
		IN p_user_id INT,
		OUT p_segment VARCHAR(50)
	)
	BEGIN
		-- Declare a local variable to hold the retrieved salary during execution
		DECLARE v_user_salary DECIMAL(10,2);

		-- Fetch the salary for the specific user and put it in our local variable
		SELECT salary INTO v_user_salary FROM users WHERE id = p_user_id;

		-- Use IF/ELSE control flow to categorize the user for analytical reporting
		IF v_user_salary > 100000 THEN
			SET p_segment = 'High Value';
		ELSEIF v_user_salary >= 50000 THEN
			SET p_segment = 'Medium Value';
		ELSE
			SET p_segment = 'Low Value';
		END IF;
	END $$
	DELIMITER ;
-- Test the logic on user ID 1
	CALL check_user_segment(1, @user_segment);
	SELECT @user_segment AS segment_category;

-- --------------------------------------------------------------------------------------
-- 5. METADATA & MAINTENANCE
-- --------------------------------------------------------------------------------------
-- Commands to manage your stored procedures.
	-- Get the list of procedures in your specific database
		SHOW PROCEDURE STATUS WHERE Db = 'startersql';
	-- View the exact code/script used to create a specific procedure
		SHOW CREATE PROCEDURE adduser;
	-- Drop a procedure safely (cleaning up after testing)
		DROP PROCEDURE IF EXISTS adduser;
		DROP PROCEDURE IF EXISTS get_all_tables;
		DROP PROCEDURE IF EXISTS get_average_salary;
		DROP PROCEDURE IF EXISTS check_user_segment;