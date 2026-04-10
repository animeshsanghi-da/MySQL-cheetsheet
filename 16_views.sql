/* ============================================================================
   MySQL VIEW CHEATSHEET FOR DATA ANALYTICS
   ============================================================================ */
-- 1. VIEWING THE MAIN TABLE
	SELECT * FROM users;

-- 2. CREATING A SIMPLE VIEW
	-- Context: Creates a virtual table based on a query. Great for filtering out noise.
		CREATE VIEW high_salary_users AS
		SELECT id, name, salary
		FROM users WHERE salary > 70000;

-- 3. QUERYING A VIEW
	-- Context: You query a view exactly like you would a normal table.
		SELECT * FROM high_salary_users;

-- 4. VIEWS ARE DYNAMIC (They don't store data)
	-- Context: A view is just a saved query. When the underlying main table gets updated, 
	-- querying the view will reflect those new changes immediately.
	-- Example of updating the base table:
		UPDATE users SET salary = 71000 WHERE id = 1;

-- 5. UPDATING RECORDS THROUGH A VIEW
	-- Context: If a view maps 1-to-1 with the main table (an "Updatable View"), 
	-- updating the view will update the base table.
	-- Example:
		UPDATE high_salary_users SET salary = 74000 WHERE id = 2;

-- 6. DELETING RECORDS THROUGH A VIEW
	-- Context: Deleting a row from an updatable view removes the row from the main table.
		DELETE FROM high_salary_users WHERE id = 6;

-- 7. MODIFYING A VIEW'S STRUCTURE (Two Methods)
	-- Method A: CREATE OR REPLACE (Overwrites the view if it exists)
		CREATE OR REPLACE VIEW high_salary_users AS
		SELECT id, name, email, gender, date_of_birth, salary, referred_by_id
		FROM users WHERE salary > 70000;

	-- Method B: ALTER VIEW (Alternative syntax to change an existing view)
		ALTER VIEW high_salary_users AS
		SELECT id, name, email, gender, salary
		FROM users WHERE salary > 70000;

-- 8. INSERTING DATA INTO A VIEW
	-- CONDITION: To do this, every column in the base table that does NOT have a 
	-- default value (e.g., restricted/NOT NULL constraints) MUST be included in the view and provided with values.
		INSERT INTO high_salary_users (name, email, gender, date_of_birth, salary, referred_by_id)
		VALUES ('Aloo', 'aloo@example.com', 'Male', '1996-10-28', 90000, 22);

-- 9. CREATING A READ-ONLY ANALYTICS VIEW (Added)
	-- Context: Used heavily in analytics to pre-join tables and calculate metrics.
		CREATE VIEW department_salary_summary AS
		SELECT 
			department_id, 
			COUNT(id) AS total_employees, 
			AVG(salary) AS average_salary
		FROM users
		GROUP BY department_id;

-- 10. USING "WITH CHECK OPTION" (Added)
	-- Context: Prevents you from inserting/updating rows through the view that would 
	-- immediately disappear from the view because they don't match the WHERE clause.
		CREATE OR REPLACE VIEW high_salary_users AS
		SELECT id, name, salary
		FROM users
		WHERE salary > 70000
		WITH CHECK OPTION; 
	-- Now, if you try to INSERT a user with a salary of 50000 through this view, MySQL will block it!

-- 11. CHECKING VIEW DEFINITION (Added)
	-- Context: If you forget how a view was built, this shows the exact CREATE statement.
		SHOW CREATE VIEW high_salary_users;

-- 12. DROPPING A VIEW
	-- Context: Deletes the view. This DOES NOT delete the underlying data in the 'users' table.
		DROP VIEW high_salary_users;

	-- Optional: Drop multiple views safely
		DROP VIEW IF EXISTS high_salary_users, department_salary_summary;


/*
Summary of MySQL Views for Data Analytics
1. What it is:
	A view is a virtual table based on the result-set of an SQL statement.
	It does not store data itself; it pulls data dynamically from the underlying tables every time you query it.
2. Why Analysts Use Them:
	Simplicity: They hide complex, massive queries (like multi-table JOINs and subqueries) behind a simple SELECT * FROM view_name.
	Security: You can restrict user access to specific columns or rows without giving them access to the entire base table
		(e.g., hiding a password or PII column).
	Consistency: Ensures everyone on the data team is pulling from the exact same business logic for metrics.
NOTE:- 	The Golden Rule of Updates: Only "simple" views (1-to-1 row mapping) are updatable.
		Once you introduce analytics functions like GROUP BY, SUM(), or DISTINCT, the view becomes strictly read-only.

** NOTE ON LIMITATIONS (Crucial for Analytics): 
	It is a misconception that you can do everything with a view that you can do with a table.
	You CANNOT update, insert, or delete data through a view if the view contains:
		Aggregate functions (SUM, MIN, MAX, COUNT), GROUP BY, HAVING, DISTINCT, or UNION.
	These are known as "Read-Only Views" and are the most common type used in Data Analytics.

*/
