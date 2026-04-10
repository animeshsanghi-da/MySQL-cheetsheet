-- *****************************************************************************************************************************************
-- AGGREGATE FUNCTIONS :-
-- *****************************************************************************************************************************************
SELECT COUNT(*) FROM users;                                                     -- count all rows
SELECT COUNT(*) AS number_of_users FROM users WHERE gender = 'Female';          -- count, WITH where clause
---------------------------------------------------------------------------------------------------------------------------------------------
SELECT MIN(salary) AS min_salary, MAX(salary) AS max_salary FROM users;         -- max, min
SELECT ABS(-25), ABS(10-50);													-- abs (Absolute Value: returns its positive version)
---------------------------------------------------------------------------------------------------------------------------------------------
SELECT SUM(salary) AS total_payroll FROM users;                                 -- sum
---------------------------------------------------------------------------------------------------------------------------------------------
SELECT AVG(salary) AS avg_salary FROM users;                                    -- avg
---------------------------------------------------------------------------------------------------------------------------------------------
SELECT RAND();																	-- rand()	(RANDOM NUMBER B/W 0 TO 1)
-- Practival usage:-
	-- To get a random number in a particular range:-
		SELECT FLOOR(RAND() * 6) + 1 AS dice_roll;					-- Rolling a standard 6-sided die (Numbers 1 through 6)
		SELECT FLOOR(RAND() * 9000) + 1000 AS random_pin;			-- Generating a random 4-digit PIN (Numbers 1000 through 9999)
	-- To get a random result
		SELECT * FROM users ORDER BY RAND() LIMIT 1;				-- Picking a Random Row (Like a Raffle)
-- *****************************************************************************************************************************************
-- STRING FUNCTIONS :-
-- *****************************************************************************************************************************************
SELECT id, name, LENGTH(name) AS name_length FROM users;                        -- length of string (counts BYTES)
SELECT id, name, CHAR_LENGTH(name) AS name_length FROM users;                   -- length of string (counts CHARACTERS)
---------------------------------------------------------------------------------------------------------------------------------------------
SELECT name, LOWER(name) AS lowercase_name FROM users;                          -- convert to lowercase
SELECT name, UPPER(name) AS uppercase_name FROM users;                          -- convert to uppercase
---------------------------------------------------------------------------------------------------------------------------------------------
SELECT id, CONCAT(name, ' <', email, '>') AS user_contact FROM users;           -- concat (combine two or more strings)
---------------------------------------------------------------------------------------------------------------------------------------------
-- ADDED FOR ANALYTICS:
SELECT TRIM(name) AS clean_name FROM users;                                     -- trim (removes leading/trailing spaces)
SELECT SUBSTRING(name, 1, 3) AS first_three_letters FROM users;                 -- substring (extracts a portion of a string)
SELECT REPLACE(gender, 'Female', 'F') AS short_gender FROM users;               -- replace (finds and replaces a specific substring)
SELECT REPLACE(REPLACE(REPLACE(gender, 'Other', 'O'), 'Female', 'F'), 'Male', 'M') AS short_gender FROM users;		-- Nested REPLACE

-- *****************************************************************************************************************************************
-- DATE FUNCTIONS :- (Shows the local date and time of the MYSQL server)
-- *****************************************************************************************************************************************
SELECT NOW() AS date_and_time, CURRENT_TIMESTAMP AS timestamp_;                 -- now(), current_timestamp
SELECT LOCALTIME AS localtime_, LOCALTIMESTAMP AS localtimestamp_;				-- localtime, localtimestamp
SELECT CURDATE() AS date_, CURTIME() AS time_;                                  -- curdate(), curtime()
SELECT CURRENT_DATE AS date_, CURRENT_TIME AS time_;                            -- current_date, current_time
SELECT CURRENT_USER() AS user_;                                                 -- current_user
-- Difference between functions and keywords:-
    -- NOW(), CURDATE(), CURTIME():
		-- Are functions. They almost always require ().
    -- LOCALTIME, LOCALTIMESTAMP, CURRENT_TIMESTAMP, CURRENT_DATE, CURRENT_TIME, CURRENT_USER:
		-- Are standard SQL keywords. They can be used without ().
-- (Note: Using a reserved keyword as an alias without backticks can throw an error, e.g., SELECT CURRENT_DATE AS current_date)
    -- TIP:- Try not to use reserved keywords of MySQL as aliases.
    -- To fix this, you must wrap the aliases in backticks (the key typically to the left of the '1' on your keyboard, i.e., ` `) or choose different names.
    -- Also, it is not strictly necessary to use "AS", though it improves readability.
---------------------------------------------------------------------------------------------------------------------------------------------
SELECT name, YEAR(date_of_birth) AS birth_year FROM users;                      -- year
SELECT name, MONTH(date_of_birth) AS birth_month FROM users;                    -- month
SELECT name, MONTHNAME(date_of_birth) AS birth_month FROM users;                -- month name
SELECT name, DAY(date_of_birth) AS birth_day FROM users;                        -- day
SELECT YEAR(NOW()) AS current_year;                                             -- year(now())
---------------------------------------------------------------------------------------------------------------------------------------------
-- ADDED FOR ANALYTICS:
SELECT DATE_FORMAT(NOW(), '%Y-%m') AS year_month_;                              -- date_format (custom formatting, great for grouping by month)
---------------------------------------------------------------------------------------------------------------------------------------------
SELECT name, DATEDIFF(CURDATE(), date_of_birth) AS days_lived FROM users;       		-- datediff, curdate (difference in days)
SELECT name, DATEDIFF(CURDATE(), date_of_birth)/365 AS years_lived FROM users;  		-- datediff/365, curdate (difference in years)
SELECT name, ROUND(DATEDIFF(CURDATE(), date_of_birth)/365) AS years_lived FROM users;  	-- round, datediff/365, curdate (difference in rounded years)
---------------------------------------------------------------------------------------------------------------------------------------------
SELECT name, TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) AS age FROM users;   -- timestampdiff, year, curdate (to find age from dob)
---------------------------------------------------------------------------------------------------------------------------------------------
SELECT NOW() AS date_and_time, SYSDATE() AS timestamp_;                         -- now(), sysdate()
    -- NOW()    :- Returns the time the statement began executing. If a query takes 10 seconds to run, NOW() will show the same time at the start and the end.
    -- SYSDATE():- Returns the exact moment the function is executed. In a slow query, SYSDATE() values might change from row to row.
        -- Example:-
            SELECT NOW(), SLEEP(2), NOW();                                      -- Both timestamps will be identical.
            SELECT SYSDATE(), SLEEP(2), SYSDATE();                              -- The second timestamp will be 2 seconds later than the first.

-- *****************************************************************************************************************************************
-- MATHEMATICAL FUNCTIONS :-
-- *****************************************************************************************************************************************
SELECT salary, ROUND(salary) AS rounded, FLOOR(salary) AS floored, CEIL(salary) AS ceiled FROM users;   -- round, floor, ceil
---------------------------------------------------------------------------------------------------------------------------------------------
SELECT id, MOD(id, 2) AS remainder FROM users;                                  -- mod
    SELECT id, id % 2 AS remainder FROM users;                                  -- ALTERNATE SYNTAX USING %
        SELECT * FROM users WHERE id % 2 = 0;                                   -- Common Use Case (filtering for even IDs)

-- *****************************************************************************************************************************************
-- CONDITIONAL & NULL HANDLING FUNCTIONS :-
-- *****************************************************************************************************************************************
SELECT IFNULL(NULL, 'NOT APPLICABLE') AS ifnull_;									-- Replace NULL with a default value
---------------------------------------------------------------------------------------------------------------------------------------------
SELECT name, gender, IF(gender = 'Female', 'Yes', 'No') AS is_female FROM users;    -- if (simple if/else)
---------------------------------------------------------------------------------------------------------------------------------------------
-- ADDED FOR ADVANCED ANALYTICS:
SELECT id, name, salary, 
       CASE 
           WHEN salary > 65000 THEN 'High'
           WHEN salary BETWEEN 55000 AND 65000 THEN 'Medium'
           ELSE 'Low' 
       END AS salary_tier 
FROM users;                                                                     	-- case statement (multiple conditions)

SELECT id, name, COALESCE(date_of_birth, 'No DOB Provided', 'Hello') AS DOB FROM users;		-- coalesce (returns the first non-null value in a list)

-- *****************************************************************************************************************************************
-- ADVANCED USAGES :-
-- *****************************************************************************************************************************************
-- Every Function :-
    -- MAX, MIN, COUNT, SUM, AVG,                    -- Aggregates
    -- LENGTH, LOWER, UPPER, CONCAT, TRIM, SUBSTRING,-- Strings
    -- NOW, CURDATE, CURTIME, DATEDIFF, SYSDATE,     -- Dates
    -- ROUND, FLOOR, CEIL, MOD, ABS,                 -- Math
    -- IF, COALESCE, IFNULL                          -- Conditionals
-- and Keyword :-
    -- CURRENT_TIMESTAMP, CURRENT_DATE, CURRENT_TIME, CURRENT_USER, 
    -- YEAR, MONTH, DAY, HOUR, MINUTE, SECOND,       -- Date Parts
    -- TIMESTAMPDIFF,                                -- Date Calculation
    -- CASE, WHEN, THEN, ELSE, END                   -- Logic
-- can be used with:-
    -- WHERE, (for example):-
        SELECT MIN(salary) AS min_salary FROM users WHERE gender = 'Female';        -- min/max WITH where
    -- GROUP BY, (for example):-
        SELECT gender, AVG(salary) AS avg_salary FROM users GROUP BY gender;        -- avg WITH group by
    -- WHERE, IN, GROUP BY, (for example):-
        SELECT gender, MIN(salary) AS min_salary, MAX(salary) AS max_salary 
        FROM users 
        WHERE gender IN ('Female', 'Male') 
        GROUP BY gender;                                                            -- min, max WITH where - in, group by  (ADVANCED ADD ON)
    -- HAVING, (for example - ADDED FOR ANALYTICS):-
        SELECT gender, AVG(salary) AS avg_salary 
        FROM users 
        GROUP BY gender 
        HAVING AVG(salary) > 50000;                                                 -- having (filters AFTER grouping, unlike WHERE)
---------------------------------------------------------------------------------------------------------------------------------------------
-- ADDED FOR ANALYTICS: WINDOW FUNCTIONS (Crucial for modern data analysis)
SELECT id, name, gender, salary, 
       RANK() OVER (PARTITION BY gender ORDER BY salary DESC) as salary_rank,
       ROW_NUMBER() OVER (ORDER BY date_of_birth ASC) as age_order
FROM users;                                  	-- Window functions perform calculations across a set of table rows related to the current row.

-- *****************************************************************************************************************************************
-- DATA :-
-- *****************************************************************************************************************************************
SELECT * FROM users;

-- *****************************************************************************************************************************************
-- SUMMARY :-
-- *****************************************************************************************************************************************
-- This cheatsheet serves as a quick-reference guide for the most critical MySQL functions used in daily data analysis, categorized by their primary use cases:
	-- Aggregate Functions (COUNT, SUM, AVG, MIN, MAX):
		-- The foundation of analytics, used to summarize and calculate metrics across large datasets.
	-- String Functions (TRIM, SUBSTRING, CONCAT, REPLACE):
		-- Essential tools for data cleaning, standardizing text, and extracting specific string patterns.
	-- Date & Time Functions (DATE_FORMAT, DATEDIFF, NOW):
		-- Crucial for time-series analysis, calculating tenures/ages, and grouping data by specific timeframes (e.g., month over month).
	-- Numeric Functions (ROUND, FLOOR, MOD):
		-- Used for mathematical transformations and bucketing continuous numerical data.
	-- Conditional Logic & NULLs (CASE WHEN, IF, COALESCE):
		-- Powerful functions for creating custom data tiers, handling missing information (NULLs) gracefully, and applying business logic directly in the query.
	-- Advanced Analytics (Window Functions, HAVING):
		-- Next-level tools for complex data manipulation, such as ranking rows within specific categories (RANK(), ROW_NUMBER()) and filtering data after it has been aggregated.
