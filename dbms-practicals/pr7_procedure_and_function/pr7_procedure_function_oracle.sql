-- ========================================================================
-- PR7 | Oracle PL/SQL - procedure and function (as in the manual) | database: Oracle
-- ========================================================================
-- HOW TO USE:  Do the STEPS in order, one at a time.
--   - Copy ONLY the lines of one step (the lines under the STEP heading, nothing from other steps).
--   - Paste them at the SQL> prompt and press Enter, then move on to the next STEP.
--   - 'Expected' shows what you should see. Steps marked [ERROR DEMO] are SUPPOSED to give an error.
--   - Oracle file: paste the steps one by one into Live SQL / SQL*Plus (not for MySQL).
-- NOTES:
--   * These are the Oracle PL/SQL programs exactly as written in the lab manual (typos like 'ISBEGIN' fixed).
--   * They could NOT be run in my test environment (it has no Oracle database), so unlike the MySQL files they are not tested. Run them once on Live SQL / SQL*Plus before the exam.
--   * Each PL/SQL block ends with a line containing only /   (it tells SQL*Plus to run the block). If Live SQL complains about the /, delete that line.

-- ---------- STEP 1: [TERMINAL OR BROWSER] Open Oracle Live SQL (the manual uses it) or SQL*Plus / SQL Developer ----------
-- Browser:  https://livesql.oracle.com  ->  Sign in  ->  SQL Worksheet
-- or start SQL*Plus / SQL Developer on the lab PC
-- Expected: The SQL worksheet opens (prompt SQL>)

-- ---------- STEP 2: Turn on output  (needed in SQL*Plus / SQL Developer; Live SQL shows output by itself) ----------
SET SERVEROUTPUT ON;
-- Expected: No output

-- ---------- STEP 3: Manual example - procedure findMin inside an anonymous block ----------
DECLARE
    a NUMBER;
    b NUMBER;
    c NUMBER;
    PROCEDURE findMin(x IN NUMBER, y IN NUMBER, z OUT NUMBER) IS
    BEGIN
        IF x < y THEN
            z := x;
        ELSE
            z := y;
        END IF;
    END;
BEGIN
    a := 23;
    b := 45;
    findMin(a, b, c);
    dbms_output.put_line(' Minimum of (23, 45) : ' || c);
END;
/
-- Expected: Minimum of (23, 45) : 23

-- ---------- STEP 4: Stored procedure (saved in the database) ----------
CREATE OR REPLACE PROCEDURE find_min_proc(x IN NUMBER, y IN NUMBER, z OUT NUMBER) IS
BEGIN
    IF x < y THEN
        z := x;
    ELSE
        z := y;
    END IF;
END;
/
-- Expected: Procedure created.

-- ---------- STEP 5: Call the stored procedure ----------
DECLARE
    c NUMBER;
BEGIN
    find_min_proc(23, 45, c);
    dbms_output.put_line('Minimum of (23, 45) : ' || c);
END;
/
-- Expected: Minimum of (23, 45) : 23

-- ---------- STEP 6: Stored function (it RETURNS a value) ----------
CREATE OR REPLACE FUNCTION find_min_fn(x IN NUMBER, y IN NUMBER) RETURN NUMBER IS
BEGIN
    IF x < y THEN
        RETURN x;
    ELSE
        RETURN y;
    END IF;
END;
/
-- Expected: Function created.

-- ---------- STEP 7: Call the stored function ----------
SELECT find_min_fn(23, 45) AS minimum FROM dual;
-- Expected: 23

-- ---------- STEP 8: Remove an old CUSTOMERS table (ignore the error the first time) ----------
DROP TABLE customers;
-- Expected: Table dropped   (ORA-00942 'table does not exist' is fine)

-- ---------- STEP 9: Create the CUSTOMERS table ----------
CREATE TABLE customers (
    id NUMBER NOT NULL,
    name VARCHAR2(20) NOT NULL,
    age NUMBER NOT NULL,
    address VARCHAR2(25),
    salary NUMBER(18, 2),
    PRIMARY KEY (id)
);
-- Expected: Table created.

-- ---------- STEP 10: Insert 6 customers (copy all lines together) ----------
INSERT INTO customers VALUES (1, 'Ramesh', 32, 'Ahmedabad', 2000.00);
INSERT INTO customers VALUES (2, 'Khilan', 25, 'Delhi', 1500.00);
INSERT INTO customers VALUES (3, 'kaushik', 23, 'Kota', 2000.00);
INSERT INTO customers VALUES (4, 'Chaitali', 25, 'Mumbai', 6500.00);
INSERT INTO customers VALUES (5, 'Hardik', 27, 'Bhopal', 8500.00);
INSERT INTO customers VALUES (6, 'Komal', 22, 'MP', 4500.00);
COMMIT;
-- Expected: 1 row(s) inserted (6 times)   |   Commit complete.

-- ---------- STEP 11: Task on the database - procedure to increase a customer's salary ----------
CREATE OR REPLACE PROCEDURE increase_salary(p_id IN NUMBER, p_amount IN NUMBER) IS
BEGIN
    UPDATE customers SET salary = salary + p_amount WHERE id = p_id;
    COMMIT;
    dbms_output.put_line('Salary of customer ' || p_id || ' increased by ' || p_amount);
END;
/
-- Expected: Procedure created.

-- ---------- STEP 12: Demonstrate it - raise customer 1 by 500 ----------
BEGIN
    increase_salary(1, 500);
END;
/
SELECT id, name, salary FROM customers WHERE id = 1;
-- Expected: Salary of customer 1 increased by 500   |   Ramesh 2500
