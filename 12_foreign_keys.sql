CREATE DATABASE IF NOT EXISTS startersql;
USE startersql;
-- Note: The parent table must exist before creating the child table.
DROP TABLE IF EXISTS addresses; -- Drop child first to avoid FK constraint errors
-- =================================================================================
-- 2. CHILD TABLE (Referencing Table) WITH FOREIGN KEY
-- =================================================================================
CREATE TABLE addresses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    street VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(100),
    pincode INT,
    -- Creating the Foreign Key:
    -- CONSTRAINT fk_user : This will give a name to the constraint. 
    -- It is not compulsory but highly recommended for easier management later.
    CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- =================================================================================
-- 3. INSERTING SAMPLE DATA
-- =================================================================================
-- Inserting sample data with shuffled user_id:
INSERT INTO addresses (user_id, street, city, state, pincode) VALUES
(12, '101 MG Road', 'Bangalore', 'Karnataka', 560001),
(5, '22 Park Street', 'Kolkata', 'West Bengal', 700016),
(23, '45 Link Road', 'Mumbai', 'Maharashtra', 400050),
(8, '10 Connaught Place', 'Delhi', 'Delhi', 110001),
(17, '56 Marina Beach Rd', 'Chennai', 'Tamil Nadu', 600004);
-- **Run SAMPLE DATABASE for full data

-- =================================================================================
-- 4. ALTERING FOREIGN KEYS (DROP & ADD)
-- =================================================================================
-- To drop a foreign key:
	ALTER TABLE addresses DROP FOREIGN KEY fk_user;
-- To add a foreign key later (with ON DELETE and ON UPDATE actions):
	ALTER TABLE addresses ADD CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL ON UPDATE CASCADE;

-- =================================================================================
-- 5. ON DELETE & ON UPDATE OPTIONS (Referential Actions)
-- =================================================================================
	-- These rules dictate what happens to related rows in a child table 
	-- when a referenced row in the parent table is deleted or updated.
-- A. ON DELETE Options:
	--   1. ON DELETE CASCADE: 		Deletes all related rows in the child table automatically.
	--   2. ON DELETE SET NULL: 	Sets the foreign key to NULL in the child table. (Requires the child column to allow NULL values) (Idealy used).
	--   3. ON DELETE RESTRICT: 	Prevents deletion of the parent row if any child records exist. (Default)
	--   4. ON DELETE NO ACTION: 	Effectively the same as RESTRICT in standard MySQL.
-- B. ON UPDATE Options:
	--   1. ON UPDATE CASCADE: 		Automatically updates the foreign key in the child table to match the new primary key value in the parent table (Idealy used).
	--   2. ON UPDATE SET NULL: 	Sets the foreign key to NULL in the child table if the parent's primary key is changed.
	--   3. ON UPDATE RESTRICT: 	Prevents updating the parent's primary key if related child records exist. (Default)
	--   4. ON UPDATE NO ACTION: 	Effectively the same as RESTRICT in standard MySQL.
-- **Note: You can define both ON DELETE and ON UPDATE for a single foreign key.

-- =================================================================================
-- 6. DATA ANALYTICS & VIEWING COMMANDS
-- =================================================================================
-- Check existing foreign keys on a table (Very useful for analytics/debugging):
SELECT TABLE_NAME, COLUMN_NAME, CONSTRAINT_NAME, REFERENCED_TABLE_NAME, REFERENCED_COLUMN_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE REFERENCED_TABLE_SCHEMA = 'startersql' AND TABLE_NAME = 'addresses';

-- =================================================================================
-- 7. SELECTS
-- =================================================================================
-- BASIC SELECTS:
	SELECT * FROM users;		-- users data
	SELECT * FROM addresses;	-- addresses data
-- ANALYTICS JOIN EXAMPLE:	Because we have a Foreign Key, we can confidently join these tables to see which user lives where.
	-- To get all data of both tables
		SELECT * FROM users u JOIN addresses a ON u.id = a.user_id;
	-- To get data of selected columns from both tables
		SELECT u.id, u.name, a.street, a.city, a.state, a.pincode		
		FROM users u
		JOIN addresses a ON u.id = a.user_id
		ORDER BY a.id;
        -- In real-world queries, we use aliases (short names like u and a) to make the code cleaner and easier to read.
		-- Aliases are NOT mandatory; you can always use the full table name instead.
			-- Syntax: FROM users u  OR  FROM users AS u        

-- =================================================================================
-- 8. SUMMARY
-- =================================================================================
-- Why Foreign Keys Matter for Data Analytics
-- 		Referential Integrity:
-- 			Foreign Keys ensure that data in your child table (addresses) strictly corresponds to real, existing data in your parent table (users).
-- 			You cannot add an address for a user_id that doesn't exist.
-- 		Preventing "Orphaned" Records:
-- 			By using ON DELETE CASCADE, you guarantee that if a user is deleted from your system, all of their related addresses are scrubbed too.
-- 			This prevents analysts from querying dead/ghost data.
-- 		Reliable JOINs:
-- 			When performing data analytics, you will constantly use JOIN statements to connect tables.
-- 			A well-structured Foreign Key constraint acts as a map, guaranteeing that your JOIN operations will yield accurate,
-- 			1-to-1 or 1-to-many matches without returning unexpected NULL errors due to broken relationships.