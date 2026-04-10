-- ---------------------------------------------------------------------------------
-- 1. BASIC UPDATES (Targeted using Primary Key)
-- ---------------------------------------------------------------------------------
UPDATE users SET name = 'Alicia' WHERE id = 1;						-- Update a single column for a specific record
UPDATE users SET name = 'Alice', gender = 'Female' WHERE id = 1;	-- Update multiple columns simultaneously for a specific record

-- ---------------------------------------------------------------------------------
-- 2. MYSQL WORKBENCH SAFE UPDATES
-- ---------------------------------------------------------------------------------
-- By default, MySQL Workbench prevents updates without a WHERE clause using a Primary Key.
-- We must turn this off to do bulk data cleaning.
SET SQL_SAFE_UPDATES = 0;  		-- TURN OFF safe updates

-- ---------------------------------------------------------------------------------
-- 3. MASS UPDATES (Affecting many or all rows)
-- ---------------------------------------------------------------------------------
-- WARNING: No WHERE clause. This updates every single row in the table!
UPDATE users SET gender = 'Other';

-- ---------------------------------------------------------------------------------
-- 4. CONDITIONAL UPDATES (Data Transformation)
-- ---------------------------------------------------------------------------------
UPDATE users SET gender = 'Female' WHERE gender = 'Male';			-- Change specific categories (e.g., standardizing text)
-- Mathematical updates (e.g., applying flat raises or fixing calculations)
UPDATE users SET salary = salary + 10000 WHERE gender = 'Female'; 	-- Adjusted from 'male' since the previous query changed them all

-- ---------------------------------------------------------------------------------
-- 5. HANDLING MISSING DATA (NULL VALUES)
-- ---------------------------------------------------------------------------------
UPDATE users SET salary = 0.00 WHERE salary IS NULL;
UPDATE users SET date_of_birth = '1900-01-01' WHERE date_of_birth IS NULL;

-- ---------------------------------------------------------------------------------
-- 6. ADVANCED ANALYTICS UPDATES (Data Cleaning & Formatting) -- [NEW ADDITIONS]
-- ---------------------------------------------------------------------------------

-- 6A. STRING CLEANING: Remove accidental spaces and standardize email casing
	UPDATE users SET name = TRIM(name), email = LOWER(REPLACE(email, ' ', ''));
		-- LOWER:	It will change the case to lower
		-- TRIM: 	It will remove space from starting and end
		-- REPLACE:	It will remove all the spaces

-- 6B. CONDITIONAL LOGIC (CASE STATEMENTS): Apply dynamic updates based on criteria
	-- Example: Tiered salary adjustments based on current salary brackets
	-- Format:- CASE WHEN condition1 THEN update1 ELSE update2 END;
	UPDATE users SET salary =
    CASE 
		WHEN salary < 30000 THEN salary * 1.15  					-- 15% bump for low income
		WHEN salary >= 30000 AND salary < 70000 THEN salary * 1.10 	-- 10% bump for mid
		ELSE salary * 1.05 											-- 5% bump for everyone else
	END;

-- 6C. DATE MANIPULATION: Set a default date for missing birthdays

-- ---------------------------------------------------------------------------------
-- 7. CLEANUP & VERIFICATION
-- ---------------------------------------------------------------------------------
SET SQL_SAFE_UPDATES = 1;  		-- TURN ON safe updates to prevent future accidents
-- Verify the final state of the data
SELECT * FROM users;
/*
====================================================================================
-- ---------------------------------------------------------------------------------
-- 8. SUMMARY OF UPDATE OPERATIONS FOR ANALYTICS:
-- ---------------------------------------------------------------------------------

1. TARGETED UPDATES: Use `WHERE id = ?` to fix specific anomalous records. Always 
   separate multiple column updates with commas.
2. SAFE UPDATES: MySQL Workbench blocks bulk updates by default. You must run 
   `SET SQL_SAFE_UPDATES = 0;` before cleaning data, and set it back to 1 afterward.
3. CONDITIONAL FORMATTING: Use `WHERE` clauses to target specific groups 
   (e.g., standardizing categorical variables like gender).
4. MATHEMATICAL OPERATIONS: You can reference the column itself to adjust numbers 
   (e.g., `salary = salary + X`).
5. NULL HANDLING: Use `IS NULL` to find missing data. You cannot update columns 
   defined as `NOT NULL` to fix NULLs, because the database prevents NULLs from 
   existing there in the first place.
6. STRING CLEANING: Functions like `TRIM()` and `LOWER()` are vital for standardizing 
   messy text data before analysis.
7. CASE STATEMENTS: The most powerful tool for analysts to apply complex, multi-tiered 
   logic to a single column update without running dozens of separate queries.
====================================================================================
*/