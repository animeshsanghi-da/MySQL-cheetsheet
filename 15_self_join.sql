/*
===============================================================================
               MySQL SELF JOIN CHEATSHEET FOR DATA ANALYTICS
===============================================================================
Context: A SELF JOIN is a standard join where a table is joined with itself.
It requires the use of table aliases (like 'a' and 'b') to act as if you are 
querying two distinct tables. 

Common Analytics Use Cases: 
- Hierarchical data (User/Referrer, Employee/Manager, Parent/Child categories)
- Comparing rows within the same table (e.g., finding overlapping dates)
===============================================================================
*/
-- ----------------------------------------------------------------------------
-- 1. BASE TABLE INSPECTION
-- ----------------------------------------------------------------------------
SELECT * FROM users;

-- ----------------------------------------------------------------------------
-- 2. THE DEFAULT SELF JOIN (Implicit INNER JOIN)
-- ----------------------------------------------------------------------------
	-- Table 'a' acts as the Referee (who were referred by someone else). Table 'b' acts as the Referrer.
	-- LOGIC: Returns ONLY users who were successfully referred by another user.
		SELECT a.id, a.name, a.referred_by_id, b.name AS referred_by_name FROM users a
		JOIN users b ON a.referred_by_id = b.id;

-- ----------------------------------------------------------------------------
-- 3. EXPLICIT INNER SELF JOIN
-- ----------------------------------------------------------------------------
	-- LOGIC: Exactly the same as the JOIN above. 
	-- Best Practice: Always explicitly write 'INNER JOIN' to make your intent clear to other data analysts reading your code.
		SELECT a.id, a.name, a.referred_by_id, b.name AS referred_by_name FROM users a
		INNER JOIN users b ON a.referred_by_id = b.id;

-- ----------------------------------------------------------------------------
-- 4. RIGHT SELF JOIN
-- ----------------------------------------------------------------------------
	-- LOGIC: Returns ALL users from table 'b' (the Referrers), and matches them to the users they referred (table 'a'). 
	-- If a user in table 'b' hasn't referred anyone, table 'a' columns return NULL.
		SELECT a.id, a.name, a.referred_by_id, b.name AS referred_by_name FROM users a
		RIGHT JOIN users b ON a.referred_by_id = b.id
		ORDER BY a.id;

-- ----------------------------------------------------------------------------
-- 5. LEFT SELF JOIN (Most Common in Data Analytics)
-- ----------------------------------------------------------------------------
	-- LOGIC: Returns ALL users from table 'a' (the Referees/New Users), regardless of whether they were referred. 
	-- If a user joined organically (no referrer), 'referred_by_name' will be NULL.
		SELECT a.id, a.name, a.referred_by_id, b.name AS referred_by_name FROM users a
		LEFT JOIN users b ON a.referred_by_id = b.id;

-- ----------------------------------------------------------------------------
-- 6. ADVANCED BONUS: AGGREGATING REFERRALS (The "Analytics" Step)
-- ----------------------------------------------------------------------------
	-- LOGIC: In analytics, you usually need to aggregate this data. This query calculates exactly how many people each user referred, ranking them.
		SELECT 
			b.id AS referrer_id, 
			b.name AS referrer_name, 
			COUNT(a.id) AS total_users_referred
		FROM users a 
		RIGHT JOIN users b 
			ON a.referred_by_id = b.id
		GROUP BY 
			b.id, 
			b.name
		ORDER BY 
			total_users_referred DESC;

/*
===============================================================================
                                 SUMMARY
===============================================================================
* ALIASES ARE MANDATORY: To perform a SELF JOIN, you must give the table two different aliases (e.g., 'a' and 'b') so MySQL knows which "copy"
  of the table you are pulling columns from.
* INNER JOIN: Intersections only. Strips out isolated records. (E.g., Only shows users who have a referrer).
* LEFT JOIN: Preserves the primary table ('a'). Useful for enriching a main dataset with optional parent data without losing the base rows.
* RIGHT JOIN: Preserves the lookup table ('b'). Useful for seeing all potential parents/referrers and identifying who they are tied to.
* ANALYTICS TIP: Always check for circular references in your raw data (e.g., User 1 refers User 2, but User 2's referred_by_id is somehow set back 
  to User 1) as this can cause infinite loops in recursive CTEs or skewed counts.
===============================================================================
*/