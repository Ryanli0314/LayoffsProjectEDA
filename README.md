# LayoffsProjectEDA
Using SQL to conduct data cleaning and Exploratory Data Analysis on a dataset about layoffs data.
Applied techniques ranging from:

1. Basic SQL:

Data Retrieval and Filtering: 
SELECT (including creating new columns with calculations), WHERE (using comparison operators, LIKE for pattern matching, AND, OR, NOT), GROUP BY (with aggregate functions like AVG, MAX, MIN, COUNT), ORDER BY (with ASC and DESC), HAVING (filtering after aggregation), LIMIT (limiting the number of rows returned). DISTINCT is used to retrieve unique combinations of values. Aliasing: Renaming columns using AS.

2. Intermediate SQL:

Data Joining: JOIN (specifically INNER JOIN) to combine data from multiple tables based on a common column.
Data Combining: UNION to combine the results of multiple SELECT statements.
String Manipulation: Functions like LENGTH, UPPER, LOWER, TRIM, LTRIM, RTRIM, LEFT, RIGHT, SUBSTRING, REPLACE, LOCATE, and CONCAT for various string operations.
Conditional Logic: CASE statements for conditional logic within queries.
Subqueries: Nested queries within the main query.
Window Functions: ROW_NUMBER(), RANK(), DENSE_RANK() for assigning ranks or numbers within a partition of data.
Common Table Expressions (CTEs): Creating temporary, named result sets to simplify complex queries.

3. Advanced SQL:

Temporary Tables: Creating temporary tables for intermediate results.
Stored Procedures: Creating reusable blocks of SQL code with parameters.
Triggers and Events: Automated actions triggered by database events (e.g., inserting, updating, deleting data) and scheduled events for automation tasks. The notes mention potential challenges with triggers and events, such as event scheduler settings and permissions.
