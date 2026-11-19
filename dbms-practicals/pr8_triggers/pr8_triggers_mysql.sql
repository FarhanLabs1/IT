-- ========================================================================
-- PR8 | Row-level triggers on CUSTOMERS | database: farhan
-- ========================================================================
-- HOW TO USE:  Do the STEPS in order, one at a time.
--   - Copy ONLY the lines of one step (the lines under the STEP heading, nothing from other steps).
--   - Paste them at the mysql> prompt and press Enter, then move on to the next STEP.
--   - 'Expected' shows what you should see. Steps marked [ERROR DEMO] are SUPPOSED to give an error.
--   - Running the whole file at once also works:  sudo mysql --force < pr8_triggers_mysql.sql
-- NOTES:
--   * MySQL supports only ROW-level triggers (FOR EACH ROW). Statement-level triggers exist only in Oracle.
--   * Oracle allows one trigger for 'BEFORE DELETE OR INSERT OR UPDATE'; in MySQL each event needs its own trigger (done below).
--   * Oracle's dbms_output.put_line is replaced by a log table, because a MySQL trigger cannot print text.

-- ---------- STEP 1: [TERMINAL] Open terminal and log in to MySQL / MariaDB ----------
-- sudo mysql
-- Expected: Prompt changes to  MariaDB [(none)]>  or  mysql>

-- ---------- STEP 2: Create and select the database ----------
CREATE DATABASE IF NOT EXISTS farhan;
USE farhan;
-- Expected: Query OK, 1 row affected   |   Database changed

-- ---------- STEP 3: Create the CUSTOMERS table (ID is the PRIMARY KEY) ----------
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

-- ---------- STEP 4: Insert 6 customers (copy the whole statement) ----------
INSERT INTO CUSTOMERS (ID, NAME, AGE, ADDRESS, SALARY) VALUES
    (1, 'Ramesh', 32, 'Ahmedabad', 2000.00),
    (2, 'Khilan', 25, 'Delhi', 1500.00),
    (3, 'kaushik', 23, 'Kota', 2000.00),
    (4, 'Chaitali', 25, 'Mumbai', 6500.00),
    (5, 'Hardik', 27, 'Bhopal', 8500.00),
    (6, 'Komal', 22, 'MP', 4500.00);
-- Expected: Query OK, 6 rows affected

-- ---------- STEP 5: View all rows ----------
SELECT * FROM CUSTOMERS;
-- Expected: All customers (ID, NAME, AGE, ADDRESS, SALARY)

-- ---------- STEP 6: Create a log table that will store the salary changes ----------
DROP TABLE IF EXISTS salary_log;
CREATE TABLE salary_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    cust_id INT,
    old_salary DECIMAL(18,2),
    new_salary DECIMAL(18,2),
    salary_diff DECIMAL(18,2),
    changed_at DATETIME
);
-- Expected: Query OK - log table created

-- ---------- STEP 7: Create trigger display_salary_changes - BEFORE UPDATE (manual example) ----------
DROP TRIGGER IF EXISTS display_salary_changes;
DELIMITER //
CREATE TRIGGER display_salary_changes
BEFORE UPDATE ON CUSTOMERS
FOR EACH ROW
BEGIN
    DECLARE sal_diff DECIMAL(18,2);
    IF NEW.ID > 0 THEN
        SET sal_diff = NEW.SALARY - OLD.SALARY;
        INSERT INTO salary_log (cust_id, old_salary, new_salary, salary_diff, changed_at)
        VALUES (OLD.ID, OLD.SALARY, NEW.SALARY, sal_diff, NOW());
    END IF;
END //
DELIMITER ;
-- Expected: Query OK - trigger created

-- ---------- STEP 8: Fire the trigger - update customer 2 (manual example) ----------
UPDATE CUSTOMERS
SET SALARY = SALARY + 500
WHERE ID = 2;
-- Expected: Query OK, 1 row affected

-- ---------- STEP 9: See what the trigger recorded ----------
SELECT cust_id, old_salary, new_salary, salary_diff FROM salary_log;
-- Expected: Old salary: 1500   New salary: 2000   Salary difference: 500

-- ---------- STEP 10: Create trigger check_salary - BEFORE INSERT (blocks negative salaries) ----------
DROP TRIGGER IF EXISTS check_salary;
DELIMITER //
CREATE TRIGGER check_salary
BEFORE INSERT ON CUSTOMERS
FOR EACH ROW
BEGIN
    IF NEW.SALARY < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Salary cannot be negative';
    END IF;
END //
DELIMITER ;
-- Expected: Query OK - trigger created

-- ---------- STEP 11: INSERT with a valid salary (works) ----------
INSERT INTO CUSTOMERS VALUES (7, 'Muffy', 24, 'Indore', 10000.00);
-- Expected: Query OK, 1 row affected

-- ---------- STEP 12: [ERROR DEMO] INSERT with a negative salary (trigger blocks it) ----------
INSERT INTO CUSTOMERS VALUES (8, 'Test', 30, 'Pune', -100.00);
-- Expected: ERROR 1644: Salary cannot be negative   (expected)

-- ---------- STEP 13: Create trigger log_deleted_customer - BEFORE DELETE ----------
DROP TABLE IF EXISTS deleted_customers;
CREATE TABLE deleted_customers (
    ID INT,
    NAME VARCHAR(20),
    deleted_at DATETIME
);
DROP TRIGGER IF EXISTS log_deleted_customer;
DELIMITER //
CREATE TRIGGER log_deleted_customer
BEFORE DELETE ON CUSTOMERS
FOR EACH ROW
BEGIN
    INSERT INTO deleted_customers VALUES (OLD.ID, OLD.NAME, NOW());
END //
DELIMITER ;
-- Expected: Query OK - trigger created

-- ---------- STEP 14: Fire the trigger - delete customer 7 ----------
DELETE FROM CUSTOMERS WHERE ID = 7;
SELECT ID, NAME FROM deleted_customers;
-- Expected: 7 | Muffy  is saved in deleted_customers

-- ---------- STEP 15: View all triggers ----------
SHOW TRIGGERS;
-- Expected: display_salary_changes, check_salary, log_deleted_customer

-- ---------- STEP 16: DROP a trigger ----------
DROP TRIGGER display_salary_changes;
DROP TRIGGER check_salary;
DROP TRIGGER log_deleted_customer;
-- Expected: Query OK
