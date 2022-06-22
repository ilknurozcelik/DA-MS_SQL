/*SQL Programming with T-SQL */

/* Procedures resemble constructs in other programming languages because they can: */

/*
Accept input parameters and return multiple values in the form of output parameters to
the calling program.

Contain programming statements that perform operations in the database. These include
calling other procedures.

Return a status value to a calling program to indicate success or failure (and the reason
for failure).
*/

/*
Benefits of Using Stored Procedures:

Reduced server/client network traffic
Stronger security
Reuse of code
Easier maintenance
Improved performance
*/

/* How to Create a Stored Procedure Using Transact-SQL */

/*
To create a procedure in Query Editor
After opening a new Query window, you can use the following as the most basic syntax:
*/

CREATE PROCEDURE sp_FirstProc AS
BEGIN
	SELECT 'Welcome to procedural world.' AS message
END;

/* Call the stored procedure as follows: */

EXECUTE sp_FirstProc;

/* Using the ALTER PROCEDURE as below, you can change the query you wrote in the procedure. */

ALTER PROCEDURE sp_FirstProc AS
BEGIN
	SELECT 'Welcome to procedural world'
END;

/* to remove the stored procedure, you can use: */

DROP PROCEDURE sp_FirstProc;

/* Stored Procedure Parameters */

/* Parameters are used to exchange data between stored procedures and functions and
the application or tool that called the stored procedure or function: */

/*
Input parameters allow the caller to pass a data value to the stored procedure or function.

Output parameters allow the stored procedure to pass a data value or a cursor variable
back to the caller.

Every stored procedure returns an integer return code to the caller.
If the stored procedure does not explicitly set a value for the return code,
the return code is 0.
*/

/*
A procedure can have a maximum of 2100 parameters; each assigned a name, data type,
and direction. Optionally, parameters can be assigned default values.

The parameter values supplied with a procedure call must be constants or a variable.
*/

-- Create a procedure that takes one input parameter and returns one output parameter and a return code.

CREATE PROCEDURE sp_SecondProc @first_name varchar(20), @salary INT OUTPUT
AS
BEGIN

-- Set a value in the output parameter by using input parameter.
SELECT @salary = salary
FROM dbo.employees_B
WHERE first_name = @first_name

-- Returns salary of @name
RETURN @salary
END
GO

/*
call/execute the procedure:
*/

-- Declare the variables for the output salary.
DECLARE @salary_output INT

-- Execute the stored procedure and specify which variable are to receive the output parameter.
EXEC sp_SecondProc @first_name = 'Lisa', @salary = @salary_output OUTPUT

-- Show the values returned.
PRINT CAST(@salary_output AS VARCHAR(10)) + '$'
GO

--run all of these together

/*
You can assign a default value for the parameters.
If any value that is used as a parameter value is NULL, then the procedure
continues with the default parameter.
*/

-- Let's modify the procedure "sp_SecondProc":

ALTER PROCEDURE sp_SecondProc @first_name varchar(20) = 'Lisa', @salary INT OUTPUT
AS
BEGIN

-- Set a value in the output parameter by using input parameter.
SELECT @salary = salary
FROM dbo.employees_B
WHERE first_name = @first_name

-- Returns salary of @name
RETURN @salary
END
GO


/* Variables */

/*   You can store a value in a variable and then retrieve and reuse that value at any
point later in the same procedure. */

/* Declaring a Variable */

/*
The DECLARE statement initializes a variable by:

Assigning a name. The name must have a single @ as the first character.

Assigning a system-supplied or user-defined data type and a length.

For numeric variables, precision and scale are also assigned.

Setting the value to NULL.
*/

/* For example, the following DECLARE statement creates a local variable named @myfirstvar
with an int data type. */

DECLARE @myfirstvar INT

/* The following DECLARE statement creates three local variables named @LastName,
@FirstName and @StateProvince, and initializes each to NULL: */

DECLARE @LastName NVARCHAR(20), @FirstName NVARCHAR(20), @State NCHAR(2);

/* Setting a value in a variable */

/* When a variable is first declared, its value is set to NULL.
To assign a value to a variable, use the SET statement. */

--Declare a variable
DECLARE @Var1 VARCHAR(20)
DECLARE @Var2 VARCHAR(10)

--Set a value to the variable with "SET"
SET @Var1 = 'Data Scientist'

--Set a value to the variable with "SELECT"

SELECT @Var2 = 'Female'

--Get a result by using variable value
SELECT *
FROM dbo.employees_A
WHERE job_title = @Var1
AND gender = @Var2

-- execute all codes above


/* IF Statements */

-- Here is the syntax of IF...ELSE

IF Boolean_expression   
     { sql_statement | statement_block }   
[ ELSE   
     { sql_statement | statement_block } ]


/* Boolean_expression:
Is an expression that returns TRUE or FALSE. If the Boolean expression contains
a SELECT statement, the SELECT statement must be enclosed in parentheses. */

/* { sql_statement | statement_block }:
Unless a statement block is used, the IF or ELSE condition can affect the performance of only
one SQL statement. To define a statement block, use the control-of-flow keywords BEGIN and END. */

/* Example */

IF DATENAME(weekday, '2022-06-19') IN (N'Saturday', N'Sunday')
       SELECT 'Weekend' AS day_of_week;
ELSE 
       SELECT 'Weekday' AS day_of_week;


-----
IF DATENAME(weekday, GETDATE()) IN (N'Saturday', N'Sunday')
       SELECT 'Weekend' AS day_of_week;
ELSE 
       SELECT 'Weekday' AS day_of_week;

-----
IF 1 = 1 PRINT 'Boolean_expression is true.'  
ELSE PRINT 'Boolean_expression is false.' ;

----
IF 1 = 3 PRINT 'Boolean_expression is true.'  
ELSE PRINT 'Boolean_expression is false.' ;


/* WHILE Loops */

-- Syntax:

WHILE Boolean_expression   
     { sql_statement | statement_block | BREAK | CONTINUE }

-----

/* Boolean_expression:
Is an expression that returns TRUE or FALSE. If the Boolean expression contains
a SELECT statement, the SELECT statement must be enclosed in parentheses.*/

/*{sql_statement | statement_block}:
Is any SQL statement or statement grouping as defined with a statement block.
To define a statement block, use the control-of-flow keywords BEGIN and END. */

/* BREAK:
Causes an exit from the innermost WHILE loop.
Any statements that appear after the END keyword, marking the end of the loop, are executed. */

/* CONTINUE:
Causes the WHILE loop to restart, ignoring any statements after the CONTINUE keyword. */


/* Examples */

SELECT CAST(4599.999999 AS numeric(5,1)) AS col

/*
In the following query, we'll generate a while loop. We'll give a limit for the while loop,
and we want to break the loop when the variable divisible by 3.
In this example we use WHILE, IF, BREAK and CONTINUE statements together.
*/

-- Declaring a @count variable to delimited the while loop.
DECLARE @count as int

--Setting a starting value to the @count variable
SET @count=1

--Generating the while loop

WHILE  @count < 30 -- while loop condition
BEGIN  	 	
	SELECT @count, @count + (@count * 0.20) -- Result that is returned end of the statement.
	SET @count +=1 -- the variable value raised one by one to continue the loop.
	IF @count % 3 = 0 -- this is the condition to break the loop.
		BREAK -- If the condition is met, the loop will stop.
	ELSE
		CONTINUE -- If the condition isn't met, the loop will continue.
END;



/* User Defined Functions */

/* Types of Functions:

1. Scalar-valued Functions
2. Table-Valued Functions
*/

/* Scalar-valued functions return a single data value of the type defined in the
RETURNS clause. For an inline scalar function, the returned scalar value is the result
of a single statement. For a multistatement scalar function, the function body can contain
a series of Transact-SQL statements that return the single value. */

/* User-defined table-valued functions return a table data type. For an inline table-valued
function, there is no function body; the table is the result set of a single SELECT statement.*/


-- Scalar-Valued Function Example:

CREATE FUNCTION dbo.ufnGetAvgSalary(@job_title VARCHAR(15))  
RETURNS BIGINT 
AS   
-- Returns the stock level for the product.  
BEGIN  
    DECLARE @avg_salary BIGINT
	
    SELECT @avg_salary = AVG(salary)
    FROM dbo.employees_A   
    WHERE job_title = @job_title   
 
    RETURN @avg_salary  
END; 

--call the function:

SELECT dbo.ufnGetAvgSalary('Data Scientist') as avg_salary


-- Table-Valued Function Example:

CREATE FUNCTION dbo.job_of_employee (@job_title VARCHAR(15))  
RETURNS TABLE  
AS  
RETURN   
(  
	SELECT emp_id, first_name, salary
	FROM dbo.employees_A 
	WHERE	job_title = @job_title
); 

-- call the function:
select * from dbo.job_of_employee('Data Scientist');



select *
from dbo.employees_A