DROP DATABASE IF EXISTS startersql;
CREATE DATABASE IF NOT EXISTS startersql;
USE startersql;

-- =======================================================================================
-- 1. CREATING THE TABLE (With inline constraints: NOT NULL, ENUM, DEFAULT)
-- =======================================================================================
CREATE TABLE users (
    id INT,
    name VARCHAR(100) NOT NULL,                         -- NOT NULL: Ensures the column cannot be left blank
    email VARCHAR(100) NOT NULL,
    gender ENUM('Male', 'Female', 'Other'),             -- ENUM: Restricts data to specific values. Can take NULL unless NOT NULL is specified.
    date_of_birth DATE,
    salary DECIMAL(10, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP      -- DEFAULT: Automatically assigns current time if no value is passed
);
-- **NOTE: 	While naming a PRIMARY KEY, UNIQUE, or FOREIGN KEY is standard, NOT NULL is considered a "column attribute" in MySQL.
-- 			If you want a column to be NOT NULL, you just state it directly without the naming syntax.

-- =======================================================================================
-- 2. INSERTING INITIAL DATA
-- =======================================================================================
INSERT INTO users (name, email, gender, date_of_birth, salary) VALUES
('Aarav', 'aarav@example.com', null, '1995-05-14', 65000.00),
('Ananya', 'ananya@example.com', 'Female', '1990-11-23', 72000.00),
('Raj', 'raj@example.com', 'Male', '1988-02-17', 58000.00),
('Sneha', 'sneha@example.com', 'Female', '2000-08-09', 50000.00),
('Fatima', 'fatima@example.com', 'Female', '1993-03-03', 55000.00);

-- =======================================================================================
-- 3. ADDING CONSTRAINTS TO EXISTING COLUMNS VIA 'ALTER TABLE'
-- =======================================================================================

-- A. UNIQUE CONSTRAINT
-- Naming the constraint 'unique_email' helps if you want to reference or drop it later.
	ALTER TABLE users ADD CONSTRAINT unique_email UNIQUE (email);   
	-- INSERT INTO users (name, email, gender, date_of_birth, salary) VALUES
	-- ('Aarav', 'aarav@example.com', 'Male', '1995-05-14', 65000.00);      -- Uncommenting this throws an error: Duplicate entry for email

-- B. NOT NULL CONSTRAINT (Modifying existing constraints)
	ALTER TABLE users MODIFY COLUMN name VARCHAR(100) NULL;                 -- Modifying constraint to allow NULL values
	ALTER TABLE users MODIFY COLUMN name VARCHAR(100) NOT NULL;             -- Modifying constraint back to NOT NULL

-- C. CHECK CONSTRAINT
	-- Great for analytics to ensure dirty data (like future birth dates) doesn't enter the DB.
		ALTER TABLE users ADD CONSTRAINT chk_dob CHECK (date_of_birth < '2001-01-01'); 
	-- INSERT INTO users (name, email, gender, date_of_birth, salary) VALUES
	-- ('Aaravi', 'aaravi@example.com', 'Female', '2002-05-14', 65000.00);  -- Uncommenting this throws an error: Check constraint violated

-- D. PRIMARY KEY & AUTO_INCREMENT
	-- Added later. MySQL automatically populates the existing NULL id fields sequentially (1, 2, 3...).
		ALTER TABLE users MODIFY COLUMN id INT AUTO_INCREMENT, ADD PRIMARY KEY (id);

-- E. DEFAULT CONSTRAINT (Added via ALTER TABLE)
	ALTER TABLE users ADD COLUMN status VARCHAR(20);
	ALTER TABLE users ALTER COLUMN status SET DEFAULT 'Active';             -- All new rows will now have 'Active' as status if omitted

-- =======================================================================================
-- 4. ADDING A FOREIGN KEY CONSTRAINT (Requires a second table)
-- =======================================================================================
-- Explained in anothe file.

-- =======================================================================================
-- 5. HOW TO DROP CONSTRAINTS (Commented out for your reference)
-- =======================================================================================
ALTER TABLE users DROP INDEX unique_email;                   -- Drops a UNIQUE constraint
ALTER TABLE users DROP CHECK chk_dob;                        -- Drops a CHECK constraint
ALTER TABLE users ALTER COLUMN status DROP DEFAULT;          -- Drops a DEFAULT constraint
ALTER TABLE users DROP FOREIGN KEY fk_user_dept;             -- Drops a FOREIGN KEY constraint
ALTER TABLE users DROP PRIMARY KEY;                          -- Drops PRIMARY KEY (Note: must remove AUTO_INCREMENT first)
-- NOT NULL and NULL constraint can be altered not dropped. [Refer 3-B].

-- =======================================================================================
-- 6. VIEW FINAL DATA
-- =======================================================================================
SELECT * FROM users;
-- DESCRIBE users; -- Run this to see the final table schema and applied constraints