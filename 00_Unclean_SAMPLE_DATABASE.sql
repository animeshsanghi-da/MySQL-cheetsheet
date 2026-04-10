DROP DATABASE IF EXISTS startersql;

CREATE DATABASE IF NOT EXISTS startersql;
USE startersql;

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    gender ENUM('Male', 'Female', 'Other'),
    date_of_birth DATE,
    salary DECIMAL(10, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO users (name, email, gender, date_of_birth, salary) VALUES
('   Aarav', '        aarav @example.com', 'Male', '1995-05-14', NULL),
('Ananya', 'Ananya@example.com', 'Female', '1990-11-23', 72000.00),
('  Raj', 'raj@example   .com', 'Male', NULL, 58000.00),
('Sneha      ', 'snEha@example.com', 'Female', '2000-08-09', NULL),
('Farhan', '         farhan@exa  mple.com', 'Male', '1993-12-30', 61000.00),
('  Priyanka', 'PRIYAN   KA@example.com', 'Female', '1985-07-12', 84000.00),
('Aisha', 'aisha@exam   ple.com', 'Female', '1997-03-25', 56000.00),
('Aditya    ', 'a  ditya@example.com', 'Male', '1992-06-17', 69000.00),
('Meera', '        meera@   example.com', 'Female', NULL, 77000.00),
('     Ishaan', 'is  haan@example.com', 'Male', '2001-10-02', 45000.00),
('Tanvi', 'tanvi@example.com           ', 'Female', '1994-04-18', 62000.00),
(' ', 'rohan@example   .com', 'Male', '1986-12-01', 75000.00),
('Zoya', 'zoya@exampl   e.com', 'Female', '1998-01-15', NULL),
('Karan', 'karan@exa   mple.com', 'Male', '1990-08-22', 68000.00),
('    Nikita', 'nikita@example.com', 'Female', '1987-03-10', 71000.00),
('Manav', 'manav@exa   m   ple.com', 'Male', NULL, 61000.00),
('Divya    ', 'divya@example.com', 'Female', '1991-02-28', 57000.00),
('Harshit', 'harshit@   example.com', 'Male', '1993-09-09', 65000.00),
('Ri    tika', 'riti   ka@example.com', 'Female', '1999-05-05', 52000.00),
('Imran', 'imran@exa   mple.com', 'Male', '1995-07-30', 63000.00),
('Juhi', 'juhi@example    com', 'Female', NULL, 59000.00),
('Tus   har', 'tushar@example.com', 'Male', '1990-01-08', 73000.00),
('Lata', 'lata@example.c    om', 'Female', '1984-11-11', 78000.00),
('Y   ash', 'yash@exa   mple.com', 'Male', '1997-06-06', 64000.00),
('Fat   ima', 'fatima   @example.com', 'Female', '1993-03-03', 55000.00);

-- ------------------------------------------------------------------------------
-- 1. CREATE THE STAGING TABLE
-- Note: Staging tables often have slightly looser constraints than production
-- tables (e.g., no UNIQUE constraints) to accept raw, messy data first.
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS staging_users (
    batch_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100),
    email_address VARCHAR(100),
    gender VARCHAR(50), -- Using VARCHAR here to represent raw text data
    date_of_birth DATE,
    salary DECIMAL(10, 2),
    is_active BOOLEAN   -- 1 = True (Active), 0 = False (Inactive)
);
-- ------------------------------------------------------------------------------
-- 2. INSERT MOCK DATA INTO STAGING
-- We include both active (1) and inactive (0) records to test our filter.
-- ------------------------------------------------------------------------------
INSERT INTO staging_users (first_name, email_address, gender, date_of_birth, salary, is_active) 
VALUES
('bruce', 'bruce@example.com', 'Male', '1985-02-19', 85000.00, 1),   -- Will be inserted
('clark', 'clark@example.com', 'Male', '1988-06-18', 90000.00, 1),   -- Will be inserted
('diana', 'diana@example.com', 'Female', '1984-03-22', 95000.00, 1), -- Will be inserted
('barry', 'barry@example.com', 'Male', '1992-09-30', 60000.00, 0),   -- Filtered out (inactive)
('arthur', 'arthur@example.com', 'Male', '1986-01-29', 78000.00, 0); -- Filtered out (inactive)


-- --------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE addresses (
id INT AUTO_INCREMENT PRIMARY KEY,
user_id INT,
street VARCHAR(255),
city VARCHAR(100),
state VARCHAR(100),
pincode INT,
CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

INSERT INTO addresses (user_id, street, city, state, pincode) VALUES
(12, '101 MG Road', 'Bangalore', 'Karnataka', 560001),
(5, '22 Park Street', 'Kolkata', 'West Bengal', 700016),
(23, '45 Link Road', 'Mumbai', 'Maharashtra', 400050),
(8, '10 Connaught Place', 'Delhi', 'Delhi', 110001),
(17, '56 Marina Beach Rd', 'Chennai', 'Tamil Nadu', 600004),
(1, '89 Jubilee Hills', 'Hyderabad', 'Telangana', 500033),
(14, '12 Koregaon Park', 'Pune', 'Maharashtra', 411001),
(25, '34 SG Highway', 'Ahmedabad', 'Gujarat', 380015),
(3, '78 MI Road', 'Jaipur', 'Rajasthan', 302001),
(19, '90 Ring Road', 'Surat', 'Gujarat', 395002),
(7, '11 FC Road', 'Pune', 'Maharashtra', 411004),
(21, '33 Salt Lake', 'Kolkata', 'West Bengal', 700091),
(10, '67 Indiranagar', 'Bangalore', 'Karnataka', 560038),
(4, '29 Bandra West', 'Mumbai', 'Maharashtra', 400050),
(16, '55 Vasant Kunj', 'Delhi', 'Delhi', 110070),
(2, '44 Banjara Hills', 'Hyderabad', 'Telangana', 500034),
(22, '88 T Nagar', 'Chennai', 'Tamil Nadu', 600017),
(11, '99 CG Road', 'Ahmedabad', 'Gujarat', 380009),
(24, '21 Malviya Nagar', 'Jaipur', 'Rajasthan', 302017),
(6, '77 Adajan', 'Surat', 'Gujarat', 395009),
(18, '15 Jayanagar', 'Bangalore', 'Karnataka', 560011),
(9, '49 Andheri East', 'Mumbai', 'Maharashtra', 400069),
(15, '63 Dwarka', 'Delhi', 'Delhi', 110075),
(20, '82 OMR', 'Chennai', 'Tamil Nadu', 600097),
(13, '19 Gachibowli', 'Hyderabad', 'Telangana', 500032);