-- ========================================================================
-- PR7 | Stored procedure and stored function (MySQL) | database: farhan
-- ========================================================================
-- HOW TO USE:  Do the STEPS in order, one at a time.
--   - Copy ONLY the lines of one step (the lines under the STEP heading, nothing from other steps).
--   - Paste them at the mysql> prompt and press Enter, then move on to the next STEP.
--   - 'Expected' shows what you should see. Steps marked [ERROR DEMO] are SUPPOSED to give an error.
--   - Running the whole file at once also works:  sudo mysql --force < pr7_procedure_function_mysql.sql
-- NOTES:
--   * Oracle PL/SQL (used in the manual) has dbms_output; MySQL shows results with SELECT instead.
--   * A procedure does not return a value (it can use OUT parameters). A function returns one value - see the function steps in this file.
--   * A function must RETURN a value, so it can be used inside a SELECT statement.
--   * Functions that read a table are declared READS SQL DATA (this also avoids ERROR 1418).

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

-- ---------- STEP 4: Insert 7 customers (copy the whole statement) ----------
INSERT INTO CUSTOMERS (ID, NAME, AGE, ADDRESS, SALARY) VALUES
    (1, 'Ramesh', 32, 'Ahmedabad', 2000.00),
    (2, 'Khilan', 25, 'Delhi', 1500.00),
    (3, 'kaushik', 23, 'Kota', 2000.00),
    (4, 'Chaitali', 25, 'Mumbai', 6500.00),
    (5, 'Hardik', 27, 'Bhopal', 8500.00),
    (6, 'Komal', 22, 'MP', 4500.00),
    (7, 'Muffy', 24, 'Indore', 10000.00);
-- Expected: Query OK, 7 rows affected

-- ---------- STEP 5: View all rows ----------
SELECT * FROM CUSTOMERS;
-- Expected: All customers (ID, NAME, AGE, ADDRESS, SALARY)

-- ---------- STEP 6: Create procedure find_min (the manual's example: 2 IN values, 1 OUT value) ----------
DROP PROCEDURE IF EXISTS find_min;
DELIMITER //
CREATE PROCEDURE find_min(IN x INT, IN y INT, OUT z INT)
BEGIN
    IF x < y THEN
        SET z = x;
    ELSE
        SET z = y;
    END IF;
END //
DELIMITER ;
-- Expected: Query OK - procedure created

-- ---------- STEP 7: Call find_min and show the OUT value ----------
SET @a = 23;
SET @b = 45;
CALL find_min(@a, @b, @c);
SELECT CONCAT('Minimum of (23, 45) : ', @c) AS result;
-- Expected: Minimum of (23, 45) : 23

-- ---------- STEP 8: Create procedure increase_salary (a task on the database) ----------
DROP PROCEDURE IF EXISTS increase_salary;
DELIMITER //
CREATE PROCEDURE increase_salary(IN p_id INT, IN p_percent DECIMAL(5,2))
BEGIN
    UPDATE CUSTOMERS
    SET SALARY = SALARY + (SALARY * p_percent / 100)
    WHERE ID = p_id;
    SELECT ID, NAME, SALARY FROM CUSTOMERS WHERE ID = p_id;
END //
DELIMITER ;
-- Expected: Query OK - procedure created

-- ---------- STEP 9: Demonstrate it - give customer 1 a 10 percent raise ----------
CALL increase_salary(1, 10);
-- Expected: Ramesh salary 2000.00 becomes 2200.00

-- ---------- STEP 10: Create procedure show_customers_by_city ----------
DROP PROCEDURE IF EXISTS show_customers_by_city;
DELIMITER //
CREATE PROCEDURE show_customers_by_city(IN p_city CHAR(25))
BEGIN
    SELECT ID, NAME, SALARY FROM CUSTOMERS WHERE ADDRESS = p_city;
END //
DELIMITER ;
-- Expected: Query OK - procedure created

-- ---------- STEP 11: Demonstrate it ----------
CALL show_customers_by_city('Delhi');
-- Expected: Khilan (1500.00)

-- ---------- STEP 12: List the stored procedures ----------
SHOW PROCEDURE STATUS WHERE Db = 'farhan';
-- Expected: find_min, increase_salary, show_customers_by_city

-- ---------- STEP 13: --- FUNCTION part starts here: a function RETURNS a value --- ----------
SELECT 'function steps start here' AS info;
-- Expected: Just a divider

-- ---------- STEP 14: Create function min_of (the same task as find_min, but it RETURNS a value) ----------
DROP FUNCTION IF EXISTS min_of;
DELIMITER //
CREATE FUNCTION min_of(x INT, y INT)
RETURNS INT
DETERMINISTIC
BEGIN
    IF x < y THEN
        RETURN x;
    END IF;
    RETURN y;
END //
DELIMITER ;
-- Expected: Query OK - function created

-- ---------- STEP 15: Call the function ----------
SELECT min_of(23, 45) AS minimum;
-- Expected: 23

-- ---------- STEP 16: Create function annual_salary (a task on the database) ----------
DROP FUNCTION IF EXISTS annual_salary;
DELIMITER //
CREATE FUNCTION annual_salary(p_id INT)
RETURNS DECIMAL(18,2)
READS SQL DATA
BEGIN
    DECLARE v_salary DECIMAL(18,2);
    SELECT SALARY INTO v_salary FROM CUSTOMERS WHERE ID = p_id;
    RETURN v_salary * 12;
END //
DELIMITER ;
-- Expected: Query OK - function created

-- ---------- STEP 17: Demonstrate it ----------
SELECT annual_salary(2) AS yearly_salary_of_khilan;
-- Expected: 18000.00

-- ---------- STEP 18: Create function salary_category ----------
DROP FUNCTION IF EXISTS salary_category;
DELIMITER //
CREATE FUNCTION salary_category(p_salary DECIMAL(18,2))
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
    IF p_salary >= 8000 THEN
        RETURN 'High';
    ELSEIF p_salary >= 4000 THEN
        RETURN 'Medium';
    ELSE
        RETURN 'Low';
    END IF;
END //
DELIMITER ;
-- Expected: Query OK - function created

-- ---------- STEP 19: Use the function on the whole table ----------
SELECT NAME, SALARY, salary_category(SALARY) AS category FROM CUSTOMERS;
-- Expected: Ramesh Low, Khilan Low, kaushik Low, Chaitali Medium, Hardik High, Komal Medium, Muffy High

-- ---------- STEP 20: List the stored functions ----------
SHOW FUNCTION STATUS WHERE Db = 'farhan';
-- Expected: min_of, annual_salary, salary_category
