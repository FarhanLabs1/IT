-- ========================================================================
-- PR9 | Oracle PL/SQL - implicit, explicit, FOR-loop and parameterised cursors (as in the manual) | database: Oracle
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

-- ---------- STEP 3: Remove an old CUSTOMERS table (ignore the error the first time) ----------
DROP TABLE customers;
-- Expected: Table dropped   (ORA-00942 'table does not exist' is fine)

-- ---------- STEP 4: Create the CUSTOMERS table ----------
CREATE TABLE customers (
    id NUMBER NOT NULL,
    name VARCHAR2(20) NOT NULL,
    age NUMBER NOT NULL,
    address VARCHAR2(25),
    salary NUMBER(18, 2),
    PRIMARY KEY (id)
);
-- Expected: Table created.

-- ---------- STEP 5: Insert 6 customers (copy all lines together) ----------
INSERT INTO customers VALUES (1, 'Ramesh', 32, 'Ahmedabad', 2000.00);
INSERT INTO customers VALUES (2, 'Khilan', 25, 'Delhi', 1500.00);
INSERT INTO customers VALUES (3, 'kaushik', 23, 'Kota', 2000.00);
INSERT INTO customers VALUES (4, 'Chaitali', 25, 'Mumbai', 6500.00);
INSERT INTO customers VALUES (5, 'Hardik', 27, 'Bhopal', 8500.00);
INSERT INTO customers VALUES (6, 'Komal', 22, 'MP', 4500.00);
COMMIT;
-- Expected: 1 row(s) inserted (6 times)   |   Commit complete.

-- ---------- STEP 6: View all rows ----------
SELECT * FROM customers;
-- Expected: 6 customers (Ramesh ... Komal)

-- ---------- STEP 7: IMPLICIT cursor - SQL%FOUND / SQL%NOTFOUND / SQL%ROWCOUNT (manual example) ----------
DECLARE
    total_rows NUMBER(2);
BEGIN
    UPDATE customers
    SET salary = salary + 500;
    IF sql%notfound THEN
        dbms_output.put_line('no customers selected');
    ELSIF sql%found THEN
        total_rows := sql%rowcount;
        dbms_output.put_line(total_rows || ' customers selected ');
    END IF;
END;
/
-- Expected: 6 customers selected
PL/SQL procedure successfully completed.

-- ---------- STEP 8: Check the table after the update ----------
SELECT * FROM customers;
-- Expected: Salaries are now 2500, 2000, 2500, 7000, 9000, 5000

-- ---------- STEP 9: EXPLICIT cursor - DECLARE, OPEN, FETCH, CLOSE (manual example) ----------
DECLARE
    c_id customers.id%TYPE;
    c_name customers.name%TYPE;
    c_addr customers.address%TYPE;
    CURSOR c_customers IS
        SELECT id, name, address FROM customers;
BEGIN
    OPEN c_customers;
    LOOP
        FETCH c_customers INTO c_id, c_name, c_addr;
        EXIT WHEN c_customers%NOTFOUND;
        dbms_output.put_line(c_id || ' ' || c_name || ' ' || c_addr);
    END LOOP;
    CLOSE c_customers;
END;
/
-- Expected: 1 Ramesh Ahmedabad
2 Khilan Delhi
3 kaushik Kota
4 Chaitali Mumbai
5 Hardik Bhopal
6 Komal MP

-- ---------- STEP 10: CURSOR FOR loop (no OPEN / FETCH / CLOSE needed) ----------
DECLARE
    CURSOR c_customers IS
        SELECT id, name, salary FROM customers;
BEGIN
    FOR rec IN c_customers LOOP
        dbms_output.put_line(rec.id || ' ' || rec.name || ' ' || rec.salary);
    END LOOP;
END;
/
-- Expected: One line per customer: id, name, salary

-- ---------- STEP 11: PARAMETERISED cursor ----------
DECLARE
    CURSOR c_city(p_city VARCHAR2) IS
        SELECT id, name FROM customers WHERE address = p_city;
BEGIN
    FOR rec IN c_city('Delhi') LOOP
        dbms_output.put_line(rec.id || ' ' || rec.name || ' lives in Delhi');
    END LOOP;
END;
/
-- Expected: 2 Khilan lives in Delhi
