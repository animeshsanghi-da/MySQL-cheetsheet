-- -------------------------------------------------------------------------
-- **CONDITIONS FOR UNION:
-- 		1. Same number of columns in all SELECT statements.
-- 		2. Compatible data types in corresponding columns across tables.
-- 		3. Columns will be matched by their ordinal position, not by their names.
-- -------------------------------------------------------------------------
-- View the raw tables
SELECT * FROM users;
SELECT * FROM staging_users;

-- -------------------------------------------------------------------------
-- 1. UNION (Implies UNION DISTINCT)
-- -------------------------------------------------------------------------
-- DEFINITION: Combines result sets and removes duplicate rows.
	SELECT id, name, email, gender, date_of_birth, salary FROM users
	UNION
	SELECT batch_id, first_name, email_address, gender, date_of_birth, salary FROM staging_users;

-- -------------------------------------------------------------------------
-- 2. UNION ALL
-- -------------------------------------------------------------------------
-- DEFINITION: Combines result sets and keeps all repetitive (duplicate) rows.
	SELECT id, name, email, gender, date_of_birth, salary FROM users
	UNION ALL
	SELECT batch_id, first_name, email_address, gender, date_of_birth, salary FROM staging_users;

-- -------------------------------------------------------------------------
-- 3. ADVANCED ANALYTICS PATTERNS
-- -------------------------------------------------------------------------
-- A. Adding a "Source" Column (Data Lineage)
	-- Very useful in data analytics to track where the combined data came from.
		SELECT 'Active Table' AS source_table, id, name, email, salary FROM users
		UNION ALL
		SELECT 'Staging Table' AS source_table, batch_id, first_name, email_address, salary FROM staging_users;

-- B. Using ORDER BY and LIMIT with UNION
	-- NOTE: ORDER BY and LIMIT must be placed at the very end of the entire query. 
	-- They apply to the final combined result set, not the individual SELECTs.
		SELECT id, name, salary FROM users
		UNION ALL
		SELECT batch_id, first_name, salary FROM staging_users
		ORDER BY salary DESC  -- Sorts the completely merged dataset
		LIMIT 10;             -- Returns only the top 10 highest salaries overall

/* =========================================================================
SUMMARY:
* PURPOSE: UNION and UNION ALL are used to vertically stack data from multiple queries into a single result set.
* UNION vs UNION ALL: 
	- UNION removes duplicates (slower execution).
	- UNION ALL keeps duplicates (faster execution). In data analytics, default to UNION ALL unless you specifically need deduplication.
* RULES: Queries must have the same number of columns, matching data types, and in the same sequential order.
* NAMING: The column names in your final output are always determined by the column names in your FIRST SELECT statement.
* SORTING: To sort the final output, apply a single ORDER BY clause at the very end of the script.
========================================================================= */