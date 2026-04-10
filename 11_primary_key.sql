-- ---------------------------------------------------------------------
-- DROP PRIMARY KEY
-- ---------------------------------------------------------------------

ALTER TABLE users DROP PRIMARY KEY;
-- if a column is set to AUTO_INCREMENT, it must be defined as a key (usually the Primary Key)
-- By trying to drop the Primary Key while that column is still set to auto-increment, you're leaving the table in an "impossible" state.

-- 1. Remove Auto-Increment
		ALTER TABLE users MODIFY id INT;
-- 2. Drop the Primary Key
		ALTER TABLE users DROP PRIMARY KEY;

-- Shortcut (The "All-in-One" Method)
	-- In many MySQL versions, you can combine these into a single command to save time:
		ALTER TABLE users MODIFY id INT, DROP PRIMARY KEY;
SHOW INDEX FROM users;

-- ---------------------------------------------------------------------
-- DROP UNIQUE CONSTRAINT
-- ---------------------------------------------------------------------
ALTER TABLE users DROP INDEX email;
SHOW INDEX FROM users;

-- ---------------------------------------------------------------------
-- AUTO_INCREMENT
-- ---------------------------------------------------------------------
-- change the starting value of AUTO_INCREMENT:-
ALTER TABLE users AUTO_INCREMENT = 1000;
INSERT INTO users (name, email, gender, date_of_birth, salary) VALUES
('Aaravi', 'aaravi@example.com', 'Male', '1995-05-14', 64000.00),
('Ananyam', 'ananyam@example.com', 'Female', '1990-11-23', 71000.00);



SELECT * FROM users