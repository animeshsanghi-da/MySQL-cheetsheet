-- 0. BASIC SELECTION
	SELECT * FROM users;

-- -----------------------------------------------------------------
-- 1. SCALAR SUBQUERY
-- ----------------------------------------------------------------- 
	-- Returns exactly one row and one column (a single value).
	-- Often used with aggregate functions like AVG(), MAX(), MIN(), SUM().
		SELECT id, name, salary FROM users
		WHERE salary > (SELECT AVG(salary) FROM users);

-- -----------------------------------------------------------------
-- 2. CORRELATED SUBQUERY
-- ----------------------------------------------------------------- 
	-- The inner query references a column from the outer query. 
	-- It executes once for EVERY row evaluated by the outer query.
	-- (Best Practice: Explicitly alias both tables ('a' and 'b') to avoid scope errors).
		SELECT id, name, gender, salary FROM users a
		WHERE salary > (
			SELECT AVG(salary) 
			FROM users b 
			WHERE b.gender = a.gender
		);

-- -----------------------------------------------------------------
-- 3. MULTI-ROW SUBQUERY (WITH 'IN')
-- -----------------------------------------------------------------
	-- Returns a single column but multiple rows (a list of values).
	-- Used to filter data based on a dynamically generated list.
		SELECT id, name, referred_by_id FROM users
		WHERE referred_by_id IN (SELECT id FROM users WHERE salary > 75000);

-----------------------------------------------------------------
-- 4. SUBQUERY IN 'FROM' CLAUSE (DERIVED TABLES)
-- -----------------------------------------------------------------
	-- Acts as a virtual table.
	-- CRITICAL SYNTAX FIX: In MySQL, every derived table MUST be given an alias. 
	-- Here, we added "AS male_users" to make it valid.
		SELECT id, name, gender
		FROM (SELECT * FROM users WHERE gender = 'Male') AS male_users
		WHERE salary > 60000;

-- -----------------------------------------------------------------
-- 5. SUBQUERY IN 'SELECT' CLAUSE (Added for Analytics)
-- -----------------------------------------------------------------
	-- Highly useful for calculating percentages or differences against a grand total without losing row-level details.
		SELECT id, name, salary,
			(SELECT AVG(salary) FROM users) AS company_avg_salary,
			salary - (SELECT AVG(salary) FROM users) AS difference_from_avg
		FROM users;

-- -----------------------------------------------------------------
-- 6. SUBQUERY WITH 'EXISTS' / 'NOT EXISTS' (Added for Analytics)
-- ----------------------------------------------------------------- */
	-- Returns a TRUE/FALSE boolean. Highly optimized for checking if a related record exists in another table. Often faster than 'IN'.
		SELECT id, name FROM users u
		WHERE EXISTS (
			SELECT 1 
			FROM orders o 
			WHERE o.user_id = u.id
		);

/* ====================================================================
SUMMARY OF MySQL SUBQUERIES
====================================================================
1. WHAT THEY ARE:
   - A subquery is a query nested inside another query (outer query). 
   - They allow you to perform multi-step data transformations in a single step.

2. TYPES BY OUTPUT:
   - Scalar Subqueries: Return 1 row & 1 column. (Use with =, >, <)
   - Multi-row Subqueries: Return 1 column & multiple rows. (Use with IN, ANY, ALL)
   - Derived Tables: Return a whole table of data. (Found in the FROM clause)

3. TYPES BY EXECUTION:
   - Independent/Uncorrelated: The inner query runs once independently, and 
     hands the result to the outer query. (Fast)
   - Correlated: The inner query depends on the outer query and must execute 
     row-by-row. (Can be slow on massive datasets).

4. PLACEMENT:
   - SELECT clause: To add aggregate columns alongside raw data.
   - FROM clause: To pre-filter or group data before joining/querying it (Requires ALIAS).
   - WHERE/HAVING clause: To filter data based on dynamic conditions.

PRO-TIP FOR DATA ANALYSTS: 
If your subqueries inside the FROM clause get too deeply nested or hard to read, look into using CTEs (Common Table Expressions using the `WITH` clause).
They do the same thing but make your code much easier to read!
====================================================================
*/