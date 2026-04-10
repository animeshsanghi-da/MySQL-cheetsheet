1. CLAUSES: The Building Blocks
   Clauses are the primary commands that tell MySQL what action to take. Every query needs at least a few of these.
   - SELECT
   - FROM
   - WHERE
   - GROUP BY
   - HAVING
   - ORDER BY
   - LIMIT

2. OPERATORS: The Condition Checkers
   Operators are used mostly inside your WHERE clause to filter data.
   2.1. Comparison Operators: =, != or <>, >, <, >=, <=
   2.2. Logical Operators: AND, OR, IN (...), BETWEEN, IS NULL / IS NOT NULL

3. WILDCARDS: The Search Helpers
   Wildcards are used with the LIKE operator to search for partial text matches. Think of them as the "blank tiles" in Scrabble.
   - % (Percent Sign)
   - _ (Underscore)

4. DATA TYPES: The Storage Containers
   Before you can put data into a table, you have to tell MySQL exactly what kind of data is allowed in each column. Think of these as differently shaped Tupperware containers.
   - INT
   - VARCHAR(...)
   - DECIMAL(..., ...)
   - DATE / DATETIME
   - BOOLEAN

5. CONSTRAINTS: The Bouncers
   Constraints are strict rules you apply to a column when you create a table. They act like bouncers, rejecting any data that doesn't follow the rules.
   - PRIMARY KEY
   - FOREIGN KEY
   - NOT NULL
   - UNIQUE
   - AUTO_INCREMENT

6. FUNCTIONS: The Built-In Calculators
   Functions are pre-packaged mini-tools that perform a specific task or calculation on your data right inside your query.
   6.1. Aggregate Functions (Math for groups):
        - COUNT()
        - SUM()
        - AVG()
        - MAX() / MIN()
   6.2. Formatting Functions:
        - UPPER() / LOWER()
        - CONCAT()
        - NOW()

7. ALIASES: The Nicknames
   Sometimes column names in a database are long, ugly, or confusing (like emp_fst_nm_01). Aliases let you rename them temporarily just for the results you are looking at.
   - AS

8. JOINS: The Matchmakers
   While technically part of the FROM clause, JOIN is such a massive concept it gets its own category. It is how you combine data from two or more different tables based on a related column between them.
   - INNER JOIN
   - LEFT JOIN