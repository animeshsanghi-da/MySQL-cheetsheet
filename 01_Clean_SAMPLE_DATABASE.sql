DROP DATABASE IF EXISTS startersql;

CREATE DATABASE IF NOT EXISTS startersql;
USE startersql;

-- ------------------------------------------------------------------------------
-- main table
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    gender ENUM('Male', 'Female', 'Other'),
    date_of_birth DATE,
    salary DECIMAL(10, 2),
	department_id INT,
    referred_by_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO users (name, email, gender, date_of_birth, salary, referred_by_id, department_id) VALUES
('Aarav', 'aarav@example.com', 'Male', '1995-05-14', 65000.00, NULL, 1),
('Ananya', 'ananya@example.com', 'Female', '1990-11-23', 72000.00, 1, 3),
('Raj', 'raj@example.com', 'Male', '1988-02-17', 58000.00, 1, 2),
('Sneha', 'sneha@example.com', 'Female', '2000-08-09', 50000.00, 2, 4),
('Farhan', 'farhan@example.com', 'Male', '1993-12-30', 61000.00, 1, 1),
('Priyanka', 'priyanka@example.com', 'Female', '1985-07-12', 84000.00, 2, 2),
('Aisha', 'aisha@example.com', 'Female', '1997-03-25', 56000.00, 3, 3),
('Aditya', 'aditya@example.com', 'Male', '1992-06-17', 69000.00, 3, 1),
('Meera', 'meera@example.com', 'Female', '1989-09-05', 77000.00, 3, 2),
('Ishaan', 'ishaan@example.com', 'Male', '2001-10-02', 45000.00, 5, 3),
('Tanvi', 'tanvi@example.com', 'Female', '1994-04-18', 62000.00, 6, 2),
('Rohan', 'rohan@example.com', 'Male', '1986-12-01', 75000.00, 2, 1),
('Zoya', 'zoya@example.com', 'Female', '1998-01-15', 54000.00, 1, 2),
('Karan', 'karan@example.com', 'Male', '1990-08-22', 68000.00, 8, 3),
('Nikita', 'nikita@example.com', 'Female', '1987-03-10', 71000.00, 9, 4),
('Manav', 'manav@example.com', 'Male', '1996-11-29', 61000.00, 7, 4),
('Divya', 'divya@example.com', 'Female', '1991-02-28', 57000.00, 10, 3),
('Harshit', 'harshit@example.com', 'Male', '1993-09-09', 65000.00, 12, 2),
('Ritika', 'ritika@example.com', 'Female', '1999-05-05', 52000.00, 4, 1),
('Imran', 'imran@example.com', 'Male', '1995-07-30', 63000.00, 15, 2),
('Juhi', 'juhi@example.com', 'Female', '1992-10-14', 59000.00, 10, 3),
('Tushar', 'tushar@example.com', 'Male', '1990-01-08', 73000.00, 11, 1),
('Lata', 'lata@example.com', 'Female', '1984-11-11', 78000.00, 4, 2),
('Yash', 'yash@example.com', 'Male', '1997-06-06', 64000.00, 6, 4),
('Fatima', 'fatima@example.com', 'Female', '1993-03-03', 55000.00, 20, 2);

-- ------------------------------------------------------------------------------
-- for INSERT data into existing table
-- for UNION and UNION ALL
CREATE TABLE IF NOT EXISTS staging_users (
    batch_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100),
    email_address VARCHAR(100),
    gender VARCHAR(50), -- Using VARCHAR here to represent raw text data
    date_of_birth DATE,
    salary DECIMAL(10, 2),
	dep_id INT,
    ref_by_id INT,
    is_active BOOLEAN   -- 1 = True (Active), 0 = False (Inactive)
);

INSERT INTO staging_users (first_name, email_address, gender, date_of_birth, salary, is_active, dep_id, ref_by_id) 
VALUES
('Aarav', 'aarav@example.com', 'Male', '1995-05-14', 65000.00, 0, 2, 22),	 -- Filtered out (inactive)
('Raj', 'raj@example.com', 'Male', '1988-02-17', 58000.00, 0, 3, 23),		 -- Filtered out (inactive)
('Ananya', 'ananya@example.com', 'Female', '1990-11-23', 72000.00, 1, 4, 25),-- Will be inserted
('bruce', 'bruce@example.com', 'Male', '1985-02-19', 85000.00, 1, 2, 15),   -- Will be inserted
('clark', 'clark@example.com', 'Male', '1988-06-18', 90000.00, 1, 1, 10),   -- Will be inserted
('diana', 'diana@example.com', 'Female', '1984-03-22', 95000.00, 1, 2, 18), -- Will be inserted
('barry', 'barry@example.com', 'Male', '1992-09-30', 60000.00, 0, 4, 27),   -- Filtered out (inactive)
('arthur', 'arthur@example.com', 'Male', '1986-01-29', 78000.00, 0, 3, 25); -- Filtered out (inactive)

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------
-- used in goup by, etc
CREATE TABLE IF NOT EXISTS department (
    dep_id INT PRIMARY KEY,
    department VARCHAR(100)
);

INSERT INTO department (dep_id, department) 
VALUES
(1, 'Marketing'),
(2, 'HR'),
(3, 'Sales'),
(4, 'IT');

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------
-- for FOREIGN KEY

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