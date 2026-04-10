-- ---------------------------------------------------------------------------------
-- 1. BASIC DELETION SYNTAX (Standard Operations)
-- ---------------------------------------------------------------------------------
DELETE FROM users WHERE id = 2;              	-- IT WILL DELETE ONE ROW
DELETE FROM users WHERE gender = 'Other';    	-- WARNING -- IT WILL DELETE MULTIPLE ROWS
-- (Crucial for data analytics when cleaning up incomplete records)
DELETE FROM users WHERE salary IS NULL;      	-- IT WILL DELETE ALL ROWS WHERE SALARY IS MISSING
DELETE FROM users;         						-- WARNING -- DELETES ALL DATA FROM THE TABLE

-- ---------------------------------------------------------------------------------
-- 2. ADVANCED DELETION SYNTAX (Added for Data Analytics Workflows)
-- ---------------------------------------------------------------------------------
-- Delete in chunks using LIMIT.
	-- (Best practice for large datasets to avoid locking the database or crashing the server).
		DELETE FROM users WHERE salary < 20000 LIMIT 1000;                -- DELETES ONLY 1000 ROWS AT A TIME
-- Delete exact duplicate records (keeping the row with the lowest/oldest ID)
	-- Useful when cleaning messy datasets based on unique constraints like email
		DELETE t1 FROM users t1
		INNER JOIN users t2
		WHERE t1.id > t2.id AND t1.email = t2.email;

-- ---------------------------------------------------------------------------------
-- 3. TRUNCATE TABLE SECTION (The nuclear option)
-- ---------------------------------------------------------------------------------
-- TRUNCATE is a DDL (Data Definition Language) command. 
-- DANGER: This aggressively deletes ALL data and resets the AUTO_INCREMENT counter back to 1.
-- It is vastly faster than 'DELETE FROM users;' for large datasets because it essentially 
-- drops and recreates the table behind the scenes, bypassing row-by-row transaction logs.
TRUNCATE TABLE users;
--    DELETE vs. TRUNCATE:
--       - DELETE removes specific rows (using WHERE) or all rows. It logs each 
--         deletion (slower) and keeps the auto-increment counter where it left off.
--       - TRUNCATE removes all rows instantly. It cannot be filtered with a WHERE 
--         clause, and it resets your auto-increment IDs to 1. 

-- ---------------------------------------------------------------------------------
-- 4. **** BEST PRACTICES TO FOLLOW ****
-- ---------------------------------------------------------------------------------
-- BEST PRACTICE A: First run SELECT before running DELETE.
	-- Always preview the exact data you are targeting before pulling the trigger.
	SELECT * FROM users WHERE id = 2;   -- 1. IT WILL SELECT THE ROW(S) THAT YOU WANT TO DELETE
	DELETE FROM users WHERE id = 2;     -- 2. IT WILL DELETE THE VERIFIED ROW
	SELECT * FROM users;       			-- 3. VERIFY THE DELETION WAS SUCCESSFUL
-- BEST PRACTICE B: Use Transactions (The Analyst's Safety Net).
	-- By wrapping your DELETE in a transaction, you can "undo" the action if you make a mistake.
		-- Step 1: Start the transaction
			START TRANSACTION;
		-- Step 2: Execute your deletion
			DELETE FROM users WHERE gender = 'Male';
		-- Step 3: Check your data. 
			-- If you made a mistake, run ROLLBACK to undo the deletion:
				ROLLBACK; 
			-- If you are absolutely sure the deletion is correct, run COMMIT to save it permanently:
				COMMIT;

-- =================================================================================
-- SUMMARY OF DATA DELETION FOR ANALYTICS:
-- =================================================================================
-- 1. TARGETING: The `DELETE` statement removes rows from a table based on a `WHERE` clause.
-- 2. MISSING VALUES: In analytics, always use `IS NULL` or `IS NOT NULL` when hunting for empty fields. Using mathematical operators like `= NULL` will fail.
-- 3. THE DANGER ZONE: Omitting the `WHERE` clause deletes ALL rows. Be highly intentional.
-- 4. PREVIEWING: Always use `SELECT` with your exact `WHERE` clause to preview data before deleting.
-- 6. DATA CLEANING: `IS NULL` is your best friend for stripping out incomplete records.
-- 6. PERFORMANCE: For massive tables, never run a blank `DELETE`. Chunk it with `LIMIT` or use `TRUNCATE TABLE` if wiping the entire dataset.
-- 7. SAFETY: In production environments, wrap your analytical data pruning in a `START TRANSACTION` so you can `ROLLBACK` accidental wipes.
-- =================================================================================