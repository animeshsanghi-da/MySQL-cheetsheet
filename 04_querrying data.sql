-- ==========================================
-- 1. BASIC DATA RETRIEVAL
-- ==========================================
SELECT * FROM users;
SELECT id, name FROM users;

-- ==========================================
-- 2. FILTERING DATA (WHERE CLAUSE)
-- ==========================================
-- 2.1. Using comparative operators (=, <>, !=, >, >=, <, <=)
SELECT * FROM users WHERE gender = 'Male';

SELECT * FROM users WHERE gender <> 'Male';
SELECT * FROM users WHERE gender != 'Male';

SELECT * FROM users WHERE id > 2;   -- Strictly greater than
SELECT * FROM users WHERE id >= 2;  -- Greater than or equal to
SELECT * FROM users WHERE id < 3;   -- Strictly less than
SELECT * FROM users WHERE id <= 3;  -- Less than or equal to

	-- Note: Standard comparative operators (=, !=) do not work properly with NULL. 
	-- You must use IS NULL or IS NOT NULL instead.

-- 2.2. Using IS operator with value NULL & NOT NULL
SELECT * FROM users WHERE date_of_birth IS NULL;
SELECT * FROM users WHERE date_of_birth IS NOT NULL;

-- 2.3. Using BETWEEN operator by giving two values separated by AND logical operator.
	-- Note: Date strings should standardly be 'YYYY-MM-DD'. BETWEEN is inclusive.
SELECT * FROM users WHERE date_of_birth BETWEEN '1990-01-01' AND '1996-01-01'; 

-- 2.4. Using IN operator by giving unlimited values in parenthesis ().
SELECT * FROM users WHERE gender IN ('Male', 'Other');
SELECT * FROM users WHERE gender NOT IN ('Male', 'Other');

-- 2.5. Combining multiple conditions using AND & OR Logical Operators.
SELECT * FROM users WHERE gender = 'Male' AND id >= 10; -- Both conditions must be true
SELECT * FROM users WHERE gender = 'Male' OR id < 4;    -- At least one condition must be true
SELECT * FROM users WHERE date_of_birth IS NOT NULL AND id < 10;
SELECT * FROM users WHERE date_of_birth IS NOT NULL AND id BETWEEN 5 AND 15;

	-- AND & OR logical operators can be used an unlimited number of times in a syntax.
SELECT * FROM users WHERE id = 5 OR id = 4 OR id = 3;
SELECT * FROM users WHERE id = 3 AND name = 'Raj' AND gender = 'Male';

	-- Complex conditions: Always use parentheses () to group OR/AND logic properly.
SELECT * FROM users WHERE (id = 5 OR id < 4) AND date_of_birth IS NOT NULL;

-- 2.6. Using LIKE & NOT LIKE operators using % and _ wildcards for PATTERN MATCHING.
	-- The '%' wildcard represents zero, one, or multiple characters.
SELECT * FROM users WHERE name LIKE 'a%';   	-- Starts with 'a'
SELECT * FROM users WHERE name LIKE '%ka';  	-- Ends with 'ka'
SELECT * FROM users WHERE name LIKE '%ee%'; 	-- Contains 'ee' anywhere in the name
SELECT * FROM users WHERE name NOT LIKE 'a%';   -- Does not start with 'a'
	-- The '_' wildcard represents EXACTLY ONE single character.
SELECT * FROM users WHERE name LIKE '_a%';      -- Second letter must be 'a'
SELECT * FROM users WHERE name LIKE '__a%';     -- Third letter must be 'a'............. and so on

-- ==========================================
-- 3. SUBQUERIES in a FROM clause (Derived Tables)
-- ==========================================
-- Every subquery in a FROM clause (a "derived table") MUST have its own alias (e.g., 'abc').
-- Without an alias, MySQL will throw a syntax error.
SELECT COUNT(*) FROM (SELECT * FROM users WHERE name NOT LIKE 'a%') AS abc;

-- Note: The above is structurally identical in output to this simpler query:
SELECT COUNT(*) FROM users WHERE name NOT LIKE 'a%';

-- ==========================================
-- 4. SORTING AND PAGINATION
-- ==========================================

-- Sorting results
SELECT * FROM users ORDER BY date_of_birth ASC;  -- Ascending order (Default)
SELECT * FROM users ORDER BY name DESC;          -- Descending order

-- Limiting results
SELECT * FROM users LIMIT 2;  -- Get only the top 2 rows

-- Pagination (Skipping rows)
SELECT * FROM users LIMIT 2 OFFSET 1; -- Skip the first 1 row, then get the next 2 rows

-- Pagination Shorthand (Format: LIMIT offset, row_count)
SELECT * FROM users LIMIT 1, 2;       -- Skip the first 1 row, then get the next 2 rows

-- We can combine two or more CLAUSES.
-- Combining Sorting and Limiting (e.g., getting top/bottom N records)
SELECT * FROM users ORDER BY date_of_birth DESC LIMIT 3; -- Get 3 youngest users

-- Combining WHERE, NOT LIKE, and ORDER BY.
SELECT * FROM users WHERE name NOT LIKE 'a%' ORDER BY name ASC;

-- ==========================================
-- 5. SUBQUERIES & ADVANCED SORTING
-- ==========================================

-- To get the last 5 entries, in descending order (highest IDs first)
SELECT * FROM users ORDER BY id DESC LIMIT 5;

-- To get the last 5 entries, but display them in ascending order
-- Note: Every derived table must have an alias ('sub' in this case)
SELECT * FROM (SELECT * FROM users ORDER BY id DESC LIMIT 5) AS sub ORDER BY id ASC;

-- ==========================================
-- 6. AGGREGATION & GROUPING (CORE ANALYTICS)
-- ==========================================
SELECT COUNT(*) AS total_users FROM users;

-- Find distinct/unique values in a column
SELECT DISTINCT gender FROM users;

-- Count the number of users, grouped by their gender
SELECT gender, COUNT(*) AS user_count FROM users GROUP BY gender;

-- Find the oldest and youngest dates of birth
SELECT MIN(date_of_birth) AS oldest, MAX(date_of_birth) AS youngest FROM users;

-- (ADDED) Mathematical Aggregations using Salary
SELECT 
    gender, 
    SUM(salary) AS total_payroll, 
    AVG(salary) AS average_salary 
FROM users 
GROUP BY gender;

-- (ADDED) Filtering Aggregated Data using the HAVING clause. 
-- WHERE filters rows BEFORE grouping; HAVING filters AFTER grouping.
SELECT gender, COUNT(*) AS user_count 
FROM users 
GROUP BY gender 
HAVING user_count > 5; 

-- ==========================================
-- 7. ADVANCED ADD-ONS (WINDOW FUNCTIONS & DATE/STRING OP)
-- ==========================================

-- (ADDED) String and Date manipulation for reporting
SELECT 
    UPPER(name) AS uppercase_name,
    CONCAT(name, ' (', gender, ')') AS name_with_gender,
    YEAR(date_of_birth) AS birth_year,
    MONTH(created_at) AS account_creation_month
FROM users;

-- Window Functions (Analytics Power-tools)
-- ROW_NUMBER: Assigns a unique sequential integer to rows.
-- RANK: Assigns ranks, but skips numbers if there's a tie (1, 2, 2, 4).
-- DENSE_RANK: Assigns ranks without skipping numbers (1, 2, 2, 3).
SELECT 
    id AS original_messy_id,
    name, 
    salary,
    ROW_NUMBER() OVER (ORDER BY created_at ASC) AS clean_row_num,
    RANK() OVER (ORDER BY salary DESC) AS salary_rank,
    DENSE_RANK() OVER (ORDER BY salary DESC) AS dense_salary_rank
FROM users;