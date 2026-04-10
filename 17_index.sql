-- 1. BASIC SELECT
	SELECT * FROM users;

-- 2. VIEWING INDEXES
	-- View all existing indexes on a specific table
		SHOW INDEXES FROM users;

-- 3. CREATING A SINGLE-COLUMN INDEX
	-- Speeds up queries that filter or sort by this specific column
		CREATE INDEX idx_email ON users(email);
	-- The above index improves the performance of queries like:
		SELECT * FROM users WHERE email = 'aarav@example.com';

-- 4. CREATING A MULTI-COLUMN (COMPOSITE) INDEX
	-- Useful for queries filtering on multiple columns simultaneously.
		CREATE INDEX idx_gender_salary ON users(gender, salary);
	-- EXAMPLE: THE LEFTMOST PREFIX RULE :- (For a multi-column index, the order of columns matters immensely.)
		-- This works efficiently (uses the index because 'gender' is the leftmost column):
			SELECT * FROM users WHERE gender = 'Male' AND salary > 70000;		
		-- This works efficiently (uses the index for the 'gender' part):
			SELECT * FROM users WHERE gender = 'Male';		
		-- This DOES NOT work efficiently (bypasses the index because the leftmost 'gender' is missing):
			SELECT * FROM users WHERE salary > 70000;							

-- 5. ADDITIONAL INDEX SYNTAX (Highly useful for Analytics)
	-- UNIQUE INDEX: Ensures all values in the index are distinct (prevents duplicates)
		CREATE UNIQUE INDEX idx_user_id ON users(user_id);
	-- PREFIX INDEX: Good for long text columns to save space (indexes only the first N characters)
		CREATE INDEX idx_last_name ON users(last_name(10));
	-- EXPLAIN STATEMENT: Crucial for analytics to verify if MySQL is actually using your index
		EXPLAIN SELECT * FROM users WHERE gender = 'Male' AND salary > 70000;

-- 6. DROPPING AN INDEX
	-- Remove an index when it is no longer needed or is slowing down writes
		DROP INDEX idx_gender_salary ON users;

-- =====================================================================
-- SUMMARY: BEST PRACTICES & PERFORMANCE NOTES
-- =====================================================================
/*
NOTE:
- This will use extra disk space (memory/storage overhead).
- This will slow down INSERT, UPDATE and DELETE operations because the index 
  must be updated every time the underlying data changes.
- Use indexes strategically, only when needed.

WHEN TO USE INDEXES:
1. On columns frequently used in WHERE clauses to filter large datasets.
2. On columns frequently used in JOIN conditions (like Primary/Foreign Keys).
3. On columns used in ORDER BY and GROUP BY clauses to speed up sorting and aggregations.
4. On large tables where queries are returning a small percentage of rows (high selectivity).
5. When enforcing unique constraints (e.g., User IDs, Email addresses).

WHEN NOT TO USE INDEXES:
1. On small tables (a full table scan is often faster for the engine anyway).
2. On columns with low cardinality / lots of duplicate values (e.g., a boolean 'is_active' 
   column, unless heavily skewed towards one value).
3. On tables with frequent, large batch INSERT/UPDATE/DELETE operations (e.g., logging tables).
4. On columns rarely used in WHERE, JOIN, or ORDER BY clauses.
5. Avoid over-indexing! Don't just blindly put an index on every single column.
*/