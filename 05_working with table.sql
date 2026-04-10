-- ==============================================================================
-- 1. VIEWING CURRENT DATA
-- ==============================================================================
SELECT name, email FROM users;

-- ==============================================================================
-- 2. RENAMING TABLES
-- ==============================================================================
RENAME TABLE users TO programmes;
RENAME TABLE programmes TO users;

-- ==============================================================================
-- 3. ADDING & RENAMING & DROPPING COLUMNS
-- ==============================================================================
ALTER TABLE users ADD COLUMN is_active BOOLEAN DEFAULT TRUE;	-- column with a default value
ALTER TABLE users RENAME COLUMN is_active TO active_;
ALTER TABLE users DROP COLUMN active_;

-- ==============================================================================
-- 4. MODIFYING COLUMN TYPES AND POSITIONS
-- ==============================================================================
-- Modify a column's data type or constraints (e.g., changing max character length)
ALTER TABLE users MODIFY COLUMN name VARCHAR(120);				

-- Move a column to be the first column in the table
ALTER TABLE users MODIFY COLUMN email VARCHAR(100) FIRST;		

-- Move a column to a specific position (after another column)
ALTER TABLE users MODIFY COLUMN email VARCHAR(100) AFTER name;	

-- ==============================================================================
-- 5. RENAMING COLUMNS (Added for Analytics Prep)
-- ==============================================================================
-- **Useful for standardizing naming conventions (e.g., snake_case) before analysis.
-- **Syntax: CHANGE COLUMN old_name new_name data_type;
ALTER TABLE users CHANGE COLUMN name full_name VARCHAR(120);

-- ==============================================================================
-- 6. ADDING INDEXES (Added for Analytics Performance)
-- ==============================================================================
-- **Crucial for speeding up complex SELECT queries, JOINs, and WHERE clauses.
-- Add a standard index to a frequently queried column
ALTER TABLE users ADD INDEX idx_email (email);

-- ==============================================================================
-- 7. VERIFYING CHANGES
-- ==============================================================================
SELECT * FROM users;	-- View the entire table's data
DESCRIBE users;			-- View the updated table schema/structure