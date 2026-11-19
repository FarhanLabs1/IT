# DBMS Lab (PCC-209-ITT) - Practicals

One folder per experiment of the PREC Loni DBMS Lab Manual (2025-26). Each program is ONE `.sql` file split into numbered STEPS, and the matching PDF is in the sibling folder `dbms-pract-pdf` (same structure, same file names).

| Folder | Manual experiment | File(s) |
|--------|-------------------|---------|
| `pr1_mysql_study` | Exp 1 - Study of MySQL | `pr1_mysql_queries` |
| `pr2_sqlite_study` | Exp 2 - Study of SQLite | `pr2_sqlite_commands` (runs in `sqlite3`) |
| `pr4_ddl_and_dml` | Exp 4 - DDL and DML | `pr4_ddl_dml` |
| `pr5_primary_key_foreign_key` | Exp 5 - Primary key, foreign key, constraints | `pr5_primary_foreign_key_constraints` |
| `pr6_database_operations` | Exp 6 - Operations a to j (+ date and time) | `pr6_database_operations` (parts 6a to 6k inside the file) |
| `pr7_procedure_and_function` | Exp 7 - Stored procedure and function | `pr7_procedure_function_mysql`, `pr7_procedure_function_oracle` |
| `pr8_triggers` | Exp 8 - Triggers | `pr8_triggers_mysql`, `pr8_triggers_oracle` |
| `pr9_cursors` | Exp 9 - Cursors | `pr9_cursors_mysql`, `pr9_cursors_oracle` |

Experiment 3 (ER / EER diagram) is a drawing, so it has no SQL file.

## Why some experiments have a MySQL file and an Oracle file
The manual's Group C programs (Experiments 7, 8, 9) are written in Oracle PL/SQL and run on Oracle Live SQL. The `_oracle` files contain that code as in the manual (typos fixed). The `_mysql` files are the same programs converted to MySQL syntax. Use the one that matches the software you are asked to use. The Oracle files are untested (no Oracle database was available when they were written), so try them once on Live SQL or SQL*Plus.

## How to run (MySQL files)
1. Install: `sudo apt update && sudo apt install mariadb-server -y` (MySQL also works) and `sudo systemctl start mariadb`.
2. Log in: `sudo mysql`
3. Open a `.sql` file. Copy ONLY the lines under one STEP, paste them at the `mysql>` prompt (Ctrl+Shift+V in the Ubuntu terminal), press Enter, then do the next STEP.
4. Steps marked `[ERROR DEMO]` are supposed to show an error.

To run a whole file at once: `sudo mysql --force < pr4_ddl_and_dml/pr4_ddl_dml.sql` (`--force` keeps going after the error demos).
Every file is self-contained (it creates the database and tables it needs).

## Where the programs differ from the lab manual
- **Exp 1:** `INSERT INTO customers VALUES(101,'rahul','delhi')` fails after the table gets the extra `age` column, so a column list is used.
- **Exp 2:** `SELECT * FROM Students` is a typo for `guru100`.
- **Exp 4:** GRANT / REVOKE examples use PostgreSQL (`testdb=#`, `CREATE ROLE`); MySQL syntax is used. The manual drops SALARY and then still shows SALARY, so the table is restored after the ALTER step. TRUNCATE and DROP are done last so the other examples still have data.
- **Exp 5:** `CUSTOMER_ID INT references CUSTOMERS(ID)` is ignored by MySQL (no foreign key is created; MariaDB 10.5+ accepts it), so the `FOREIGN KEY (...) REFERENCES (...)` clause is used.
- **Exp 6:** `WHERE SALARY = SALARY + 1000` is never true, so the arithmetic is shown in the SELECT list. `!<` and `!>` do not exist in MySQL. `MINUS` is called `EXCEPT`. The `hostel1` / `hostel2` tables are created because the manual never creates them. Index operations were missing from the manual's examples and were added.
- **Exp 7, 8, 9 (MySQL files):** Oracle's `dbms_output`, `:NEW` / `:OLD`, `sql%rowcount` and cursor FOR loop do not exist in MySQL, so MySQL equivalents are used. MySQL has only row-level triggers (no statement-level triggers); the Oracle trigger file shows both.
- **Cursors (Exp 9)** are in the lab manual but not in the SPPU syllabus list; they are kept because the manual has them.

## Notes
- MySQL files tested on MariaDB 10.11; SQLite file tested on SQLite 3. `INTERSECT` / `EXCEPT` need MySQL 8.0.31+ or MariaDB 10.3+ (part 6h also has alternatives for older versions).
- CHECK violation error: MySQL = ERROR 3819, MariaDB = ERROR 4025.
