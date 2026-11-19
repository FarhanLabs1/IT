-- ========================================================================
-- PR5 | PRIMARY KEY, FOREIGN KEY, ALTER, DROP and other constraints | database: farhan
-- ========================================================================
-- HOW TO USE:  Do the STEPS in order, one at a time.
--   - Copy ONLY the lines of one step (the lines under the STEP heading, nothing from other steps).
--   - Paste them at the mysql> prompt and press Enter, then move on to the next STEP.
--   - 'Expected' shows what you should see. Steps marked [ERROR DEMO] are SUPPOSED to give an error.
--   - Running the whole file at once also works:  sudo mysql --force < pr5_primary_foreign_key_constraints.sql
-- NOTES:
--   * The manual writes  CUSTOMER_ID INT references CUSTOMERS(ID).  MySQL (InnoDB) silently IGNORES that inline form, so no foreign key is created (MariaDB 10.5+ accepts it). This file uses the FOREIGN KEY (...) REFERENCES (...) clause, which works on both.
--   * The manual's 'other constraints' are UNIQUE, DEFAULT, CHECK and NOT NULL; they are shown on the PRODUCTS table.

-- ---------- STEP 1: [TERMINAL] Open terminal and log in to MySQL / MariaDB ----------
-- sudo mysql
-- Expected: Prompt changes to  MariaDB [(none)]>  or  mysql>

-- ---------- STEP 2: Create and select the database ----------
CREATE DATABASE IF NOT EXISTS farhan;
USE farhan;
-- Expected: Query OK, 1 row affected   |   Database changed

-- ---------- STEP 3: CREATE TABLE with PRIMARY KEY (ID is the primary key) ----------
DROP TABLE IF EXISTS ORDERS;
DROP TABLE IF EXISTS CUSTOMERS;
CREATE TABLE CUSTOMERS (
    ID INT NOT NULL,
    NAME VARCHAR(20) NOT NULL,
    AGE INT NOT NULL,
    ADDRESS CHAR(25),
    SALARY DECIMAL(18, 2),
    PRIMARY KEY (ID)
);
-- Expected: Query OK, 0 rows affected

-- ---------- STEP 4: Verify the table structure ----------
DESC CUSTOMERS;
-- Expected: 5 rows: ID (PRI), NAME, AGE, ADDRESS, SALARY

-- ---------- STEP 5: INSERT INTO (6 records) ----------
INSERT INTO CUSTOMERS (ID, NAME, AGE, ADDRESS, SALARY) VALUES
    (1, 'Ramesh', 32, 'Ahmedabad', 2000.00),
    (2, 'Khilan', 25, 'Delhi', 1500.00),
    (3, 'kaushik', 23, 'Kota', 2000.00),
    (4, 'Chaitali', 25, 'Mumbai', 6500.00),
    (5, 'Hardik', 27, 'Bhopal', 8500.00),
    (6, 'Komal', 22, 'MP', 4500.00);
-- Expected: Query OK, 6 rows affected

-- ---------- STEP 6: SELECT query ----------
SELECT * FROM CUSTOMERS;
-- Expected: All 6 rows

-- ---------- STEP 7: ALTER TABLE - ADD a column ----------
ALTER TABLE CUSTOMERS ADD Email VARCHAR(255);
-- Expected: Column Email added

-- ---------- STEP 8: ALTER TABLE - MODIFY the column size ----------
ALTER TABLE CUSTOMERS MODIFY Email VARCHAR(100);
-- Expected: Email is now VARCHAR(100)

-- ---------- STEP 9: Verify the ALTER ----------
DESC CUSTOMERS;
-- Expected: Email varchar(100) is listed

-- ---------- STEP 10: ALTER TABLE - DROP the column again ----------
ALTER TABLE CUSTOMERS DROP Email;
-- Expected: Email removed

-- ---------- STEP 11: CREATE TABLE ORDERS with a FOREIGN KEY (CUSTOMER_ID refers to CUSTOMERS.ID) ----------
CREATE TABLE ORDERS (
    ID INT NOT NULL,
    DATE DATETIME,
    CUSTOMER_ID INT,
    AMOUNT DOUBLE,
    PRIMARY KEY (ID),
    CONSTRAINT fk_customer
        FOREIGN KEY (CUSTOMER_ID)
        REFERENCES CUSTOMERS (ID)
);
-- Expected: Query OK - child table created

-- ---------- STEP 12: INSERT valid orders ----------
INSERT INTO ORDERS VALUES
    (102, '2009-10-08 00:00:00', 3, 3000),
    (100, '2009-10-08 00:00:00', 3, 1500),
    (101, '2009-11-20 00:00:00', 2, 1560),
    (103, '2008-05-20 00:00:00', 4, 2060);
-- Expected: 4 rows inserted

-- ---------- STEP 13: View the relationship (join both tables) ----------
SELECT o.ID AS order_id, c.NAME, o.AMOUNT
FROM ORDERS o
JOIN CUSTOMERS c ON o.CUSTOMER_ID = c.ID;
-- Expected: 4 rows: customer names with their order amounts

-- ---------- STEP 14: [ERROR DEMO] FOREIGN KEY - order for a customer that does not exist ----------
INSERT INTO ORDERS VALUES (104, '2010-01-01 00:00:00', 99, 500);
-- Expected: ERROR 1452: Cannot add or update a child row - foreign key constraint fails   (expected)

-- ---------- STEP 15: [ERROR DEMO] FOREIGN KEY - delete a customer who has orders ----------
DELETE FROM CUSTOMERS WHERE ID = 3;
-- Expected: ERROR 1451: Cannot delete or update a parent row   (expected)

-- ---------- STEP 16: Create a PRODUCTS table with UNIQUE, DEFAULT, CHECK and NOT NULL ----------
DROP TABLE IF EXISTS PRODUCTS;
CREATE TABLE PRODUCTS (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) DEFAULT 'General',
    price INT CHECK (price > 0),
    serial_no VARCHAR(50) UNIQUE
);
-- Expected: Query OK - table created with all constraints

-- ---------- STEP 17: Insert a valid row and a row that uses the DEFAULT value ----------
INSERT INTO PRODUCTS VALUES (1, 'Laptop', 'Electronics', 55000, 'SN-001');
INSERT INTO PRODUCTS (product_id, product_name, price, serial_no) VALUES (2, 'Pen', 10, 'SN-002');
SELECT * FROM PRODUCTS;
-- Expected: Row 2 has category = General (DEFAULT)

-- ---------- STEP 18: [ERROR DEMO] CHECK - price below 0 ----------
INSERT INTO PRODUCTS VALUES (3, 'Eraser', 'Stationery', -5, 'SN-003');
-- Expected: ERROR: check constraint violated (MySQL 3819 / MariaDB 4025)   (expected)

-- ---------- STEP 19: [ERROR DEMO] UNIQUE - duplicate serial_no ----------
INSERT INTO PRODUCTS VALUES (4, 'Mouse', 'Electronics', 500, 'SN-001');
-- Expected: ERROR 1062: Duplicate entry 'SN-001'   (expected)

-- ---------- STEP 20: [ERROR DEMO] NOT NULL - NULL product name ----------
INSERT INTO PRODUCTS VALUES (5, NULL, 'Electronics', 200, 'SN-005');
-- Expected: ERROR 1048: Column 'product_name' cannot be null   (expected)

-- ---------- STEP 21: DROP DATABASE - create a throw-away database first ----------
CREATE DATABASE Employee;
SHOW DATABASES;
-- Expected: Employee is listed

-- ---------- STEP 22: DROP DATABASE - delete it ----------
DROP DATABASE Employee;
SHOW DATABASES;
-- Expected: Employee is no longer listed

-- ---------- STEP 23: DROP TABLE - child table first, then the parent ----------
DROP TABLE ORDERS;
DROP TABLE PRODUCTS;
DROP TABLE CUSTOMERS;
SHOW TABLES;
-- Expected: Empty set - all tables deleted
