-- ------------------------------------------------------------------------------
-- 1. BASIC INSERTS
-- ------------------------------------------------------------------------------
-- Method A: Insert all values explicitly. 
INSERT INTO users VALUES
(26, 'don', 'don@example.com', 'Male', '1990-09-08', NULL, DEFAULT);

-- Method B: Insert into specific columns. (Recommended best practice)
INSERT INTO users (name, email, gender, date_of_birth) VALUES
('tom', 'tom@example.com', 'Male', '1996-04-24');	-- Auto-increment handles ID, DEFAULT handles created_at.

-- Method C: Multiple row insertion (Bulk Insert).
INSERT INTO users (name, email, gender, date_of_birth) VALUES
('jerry', 'jerry@example.com', 'Female', '1995-06-29'),
('goli', 'goli@example.com', 'Other', '1989-02-20');

-- ------------------------------------------------------------------------------
-- 2. ADVANCED INSERTS FOR DATA ANALYTICS
-- ------------------------------------------------------------------------------
-- A. INSERT IGNORE
-- Useful when importing dirty data. If a duplicate email exists (UNIQUE constraint), 
-- it ignores the error and moves to the next row instead of failing the whole batch.
INSERT IGNORE INTO users (name, email, gender, date_of_birth) VALUES
('tom', 'tom@example.com', 'Male', '1996-04-24'), 		-- Ignored because email already exists
('alice', 'alice@example.com', 'Female', '1992-11-15'); -- Successfully inserted

-- B. ON DUPLICATE KEY UPDATE (UPSERT)
-- If the record doesn't exist, it INSERTs. If it hits a UNIQUE constraint (like email), it UPDATEs.
-- Perfect for keeping analytical dimensions up-to-date without writing separate UPDATE logic.
INSERT INTO users (name, email, gender, salary) VALUES
('don', 'don@example.com', 'Female', 75000.00)
AS new_data
ON DUPLICATE KEY UPDATE 
    salary = new_data.salary,	-- Updates the salary to the new value provided (75000.00) 
    name = new_data.name;		-- Updates the name in case it changed
-- verifying data.
SELECT * FROM users WHERE email IN ('don@example.com', 'alice@example.com');

-- C. INSERT ... SELECT (Staging to Production)
-- The most common way to move/transform data in analytics.
-- Make sure staging_users table exists.
INSERT INTO users (name, email, gender, date_of_birth, salary)
SELECT first_name, email_address, gender, date_of_birth, salary 
FROM staging_users WHERE is_active = 1;

-- ------------------------------------------------------------------------------
-- 3. VERIFY DATA
-- ------------------------------------------------------------------------------
SELECT * FROM users;
SELECT count(*) FROM users;



/*
==============================================================================
SUMMARY & BEST PRACTICES FOR DATA ANALYTICS:
==============================================================================

1. EXPLICIT COLUMNS: Always specify columns explicitly (e.g., `INSERT INTO table (col1)`). Using `INSERT INTO table VALUES (...)` without columns is brittle;
	if a DBA adds a new column to the table later, your pipeline will break.
2. BULK INSERTS: Always group multiple rows into a single `INSERT` statement separated by commas.
	It drastically reduces network overhead and is significantly faster for loading large datasets.
3. ENUM STRICTNESS: Ensure your string values perfectly match ENUM definitions (e.g., 'Other' instead of 'others', 'Male' instead of 'male').
	MySQL is strictly case-sensitive for ENUM constraints in modern strict modes.
4. HANDLING DUPLICATES: 
   - `INSERT IGNORE`: Use this to silently skip duplicate rows (great for log data).
   - `ON DUPLICATE KEY UPDATE`: Use this to update existing records with fresh data without throwing errors. This is the gold standard for syncing data (Upserts).
==============================================================================
*/