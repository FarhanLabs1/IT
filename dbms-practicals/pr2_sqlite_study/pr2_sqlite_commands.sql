-- ========================================================================
-- PR2 | SQLite commands (manual pages 9-10) | database: SQLite
-- ========================================================================
-- HOW TO USE:  Do the STEPS in order, one at a time.
--   - Copy ONLY the lines of one step (the lines under the STEP heading, nothing from other steps).
--   - Paste them at the sqlite> prompt and press Enter, then move on to the next STEP.
--   - 'Expected' shows what you should see. Steps marked [ERROR DEMO] are SUPPOSED to give an error.
--   - Running the whole file at once also works:  sqlite3 test.db < pr2_sqlite_commands.sql
-- NOTES:
--   * SQLite is NOT MySQL: this file runs in the sqlite3 shell, not in sudo mysql.
--   * Run the whole file at once with:  sqlite3 test.db < pr2_sqlite_commands.sql
--   * The manual's 'SELECT * FROM Students' is a typo; the table used in the example is guru100.

-- ---------- STEP 1: [TERMINAL] Install SQLite on Ubuntu ----------
-- sudo apt update
-- sudo apt install sqlite3 -y
-- sqlite3 --version
-- Expected: Prints the SQLite version, e.g. 3.45.1

-- ---------- STEP 2: [TERMINAL] Start SQLite with a database file (created if it does not exist) ----------
-- sqlite3 test.db
-- Expected: Prompt changes to  sqlite>

-- ---------- STEP 3: CREATE TABLE ----------
CREATE TABLE guru99 (Id INT, Name VARCHAR);
-- Expected: No output means success

-- ---------- STEP 4: Show the tables  (SQLite dot-command) ----------
.tables
-- Expected: guru99

-- ---------- STEP 5: ALTER TABLE - rename the table ----------
ALTER TABLE guru99 RENAME TO guru100;
-- Expected: No output means success

-- ---------- STEP 6: ALTER TABLE - add a column ----------
ALTER TABLE guru100 ADD COLUMN Age INT;
-- Expected: No output means success

-- ---------- STEP 7: INSERT a value ----------
INSERT INTO guru100 VALUES (1, 'Mike', 25);
-- Expected: No output means success

-- ---------- STEP 8: Display all values ----------
SELECT * FROM guru100;
-- Expected: 1|Mike|25

-- ---------- STEP 9: Show the table structure  (SQLite dot-command) ----------
.schema guru100
-- Expected: CREATE TABLE statement with the Age column

-- ---------- STEP 10: DROP TABLE ----------
DROP TABLE guru100;
.tables
-- Expected: No output - the table is gone

-- ---------- STEP 11: [TERMINAL] Quit SQLite ----------
-- .quit
-- Expected: Back to the Ubuntu prompt
