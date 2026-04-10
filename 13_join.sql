-- -------------------------------------------------------------------------
-- 1. INNER JOIN (The Strict Filter)
-- -------------------------------------------------------------------------
-- DIFFERENCE: Returns ONLY records that have matching values in BOTH tables. 
			-- Unmatched rows are completely dropped from the result set.
-- WHEN TO USE: Use this when your analysis requires complete pairs (e.g., 
			-- finding only users who have actually provided a shipping address 
			-- to calculate average shipping costs).
	SELECT * FROM users u INNER JOIN addresses a ON u.id = a.user_id;
-- (Original: only matching pairs)
	SELECT u.name, a.city FROM users u INNER JOIN addresses a ON u.id = a.user_id;		
	-- ** NOTE: In MySQL, 'JOIN' without a prefix is strictly a synonym for 'INNER JOIN'.
-- (Original: similar to INNER JOIN (Default))
	SELECT u.name, a.city FROM users u JOIN addresses a ON u.id = a.user_id;			

-- -------------------------------------------------------------------------
-- 2. LEFT JOIN / LEFT OUTER JOIN (The Base Preserver)
-- -------------------------------------------------------------------------
-- DIFFERENCE: Returns ALL records from the LEFT table (users), and the matched 
			-- records from the RIGHT table (addresses). Unmatched records on 
			-- the right will return NULL.
-- WHEN TO USE: This is the most common join in analytics! Use it to keep your 
			-- base population intact. (e.g., auditing how many users exist vs. 
			-- how many have missing addresses by counting the NULLs).
-- (Original: all users)
	SELECT u.name, a.city FROM users u LEFT JOIN addresses a ON u.id = a.user_id;		

-- -------------------------------------------------------------------------
-- 3. RIGHT JOIN / RIGHT OUTER JOIN (The Reverse Preserver)
-- -------------------------------------------------------------------------
-- DIFFERENCE: Returns ALL records from the RIGHT table (addresses), and matched 
			-- records from the LEFT table (users). Unmatched left records are NULL.
-- WHEN TO USE: Less common in practice. You can usually achieve the exact same 
			-- result by flipping the tables and using a LEFT JOIN. Useful mainly 
			-- when adding a new table to the very end of a massive, complex query.
-- (Original: all addresses)
	SELECT u.name, a.city FROM users u RIGHT JOIN addresses a ON u.id = a.user_id;		

-- -------------------------------------------------------------------------
-- 4. CROSS JOIN (The Multiplier)
-- -------------------------------------------------------------------------
-- DIFFERENCE: Produces a Cartesian product. Every row in table 1 is paired with 
			-- every row in table 2. (If Users has 10 rows, Addresses has 10 rows, 
			-- the result is 100 rows).
-- WHEN TO USE: Generating combinations or "scaffolding" data. (e.g., creating a 
			-- grid of all possible calendar dates and all store locations to find 
			-- days with zero sales). WARNING: Can cause severe performance issues.
-- (Original: CROSS JOIN without ON)
	SELECT u.id, u.name, a.city FROM users u CROSS JOIN addresses a;					
-- (Original: CROSS JOIN with ON)
	-- CONTEXTUAL FIX: In standard SQL, a CROSS JOIN does not take an ON clause. 
	-- However, MySQL allows this syntax. When you add an ON clause to a CROSS JOIN 
	-- in MySQL, it behaves EXACTLY like an INNER JOIN.
	SELECT u.id, u.name, a.city FROM users u CROSS JOIN addresses a ON u.id = a.user_id;

-- -------------------------------------------------------------------------
-- 5. FULL OUTER JOIN (The Catch-All / MySQL Workaround)
-- -------------------------------------------------------------------------
-- DIFFERENCE: Returns ALL records when there is a match in either the left 
			-- or right table. 
-- WHEN TO USE: When you need a complete picture of both tables to find orphans 
			-- on both sides (e.g., users without addresses AND addresses 
			-- that somehow don't belong to any user).
-- CONTEXTUAL FIX: MySQL does not have a native 'FULL OUTER JOIN' command.
	-- To get this result, you must use UNION to combine a Left Join and a Right Join. 
	-- Unmatched pairs will return NULL values on their respective missing sides.
	SELECT u.id, u.name, a.city FROM users u LEFT JOIN addresses a ON u.id = a.user_id
	UNION
	SELECT u.id, u.name, a.city FROM users u RIGHT JOIN addresses a ON u.id = a.user_id;

/* =========================================================================
   EXTRA ANALYTICS SYNTAX & TIPS
   ========================================================================= */
-- A. THE 'USING' CLAUSE (Syntax shorthand)
	-- If the column names you are joining on are EXACTLY the same in both tables 
	-- (e.g., if both tables had a column named 'user_id'), use USING to save typing:
		SELECT u.name, a.city FROM users u INNER JOIN addresses a USING (user_id);
-- B. SELF JOIN (Comparing within the same table)
	-- You join a table to itself. You MUST use table aliases (e.g., u1, u2).
	-- WHEN TO USE: Hierarchical data or comparing rows. (e.g., finding users 
				-- who live in the same city).
		SELECT u1.name AS User1, u2.name AS User2, u1.city 
		FROM users u1 INNER JOIN users u2 ON u1.city = u2.city AND u1.id != u2.id;

/* =========================================================================
   QUICK SUMMARY FOR ANALYSTS:
   =========================================================================
   * INNER JOIN  : The strict filter. Give me data only where both sides match.
   * LEFT JOIN   : The preserver. Keep all my base data (left), add details from 
                   the right if they exist. (Your bread and butter for analytics).
   * RIGHT JOIN  : Same as LEFT JOIN, just read backwards.
   * FULL OUTER  : (Via UNION) The net. Catch everything, matched or not, from 
                   both tables.
   * CROSS JOIN  : The multiplier. Give me every possible combination.
   * SELF JOIN   : The mirror. Compare a table's rows against its own rows.
   ========================================================================= */