Use DataBeat_Task;

# Question: 1

#  Table - 1:

Drop table if exists Employees;
Create table Employees
(
EMP_ID int primary key,
FIRST_NAME varchar(50),
LAST_NAME varchar(50),
SALARY int,
JOINING_DATE datetime,
DEPARTMENT varchar(50)
);

Insert into Employees (EMP_ID, FIRST_NAME, LAST_NAME, SALARY, JOINING_DATE, DEPARTMENT)
VALUES  (001, "Manish", "Agarwal", 700000, '2019-04-20 09:00:00', "HR"),
		(002, "Niranjan", "Bose", 20000, '2019-02-11 09:00:00', "DA"),
		(003, "Vivek", "Singh", 100000, '2019-01-20 09:00:00', "DA"),
        (004, "Asutosh", "Kapoor", 700000, '2019-03-20 09:00:00', "HR"),
        (005, "Vihaan", "Banerjee", 300000, '2019-06-11 09:00:00', "DA"),
        (006, "Atul", "Diwedi", 400000, '2019-05-11 09:00:00', "Account"),
        (007, "Satyendra", "Tripathi", 95000, '2019-03-20 09:00:00', "Account"),
        (008, "Pritika", "Bhatt", 80000, '2019-02-11 09:00:00', "DA") ;
        
Select * from Employees;


#  Table - 2:

Create Table Variables_Details(
EMP_REF_ID int,
VARIABLES_DATE datetime,
VARIABLES_AMOUNT int,
foreign key(EMP_REF_ID)
references Employees(EMP_ID)
);

Insert Into Variables_Details (EMP_REF_ID, VARIABLES_DATE, VARIABLES_AMOUNT)
Values 	(1, '2019-02-20 00:00:00', 15000),
		(2, '2019-06-11 00:00:00', 30000),
        (3, '2019-02-20 00:00:00', 42000),
        (4, '2019-02-20 00:00:00', 14500),
        (5, '2019-06-11 00:00:00', 23500);
        
select * from Variables_Details;


#  Table - 3:


Create Table Designation_Tables(
EMP_REF_ID int,
EMP_TITLE varchar(50),
AFFECTED_FROM datetime,
Foreign Key (EMP_REF_ID)
references Employees(EMP_ID)
);

Insert into Designation_Tables(EMP_REF_ID, EMP_TITLE, AFFECTED_FROM)
Values  (1, 'Asst. Manager', '2019-02-20 00:00:00'),
		(2, 'Senior Analyst', '2019-01-11 00:00:00'),
        (8, 'Senio Analyst', '2019-04-06 00:00:00'),
        (5, 'Manager', '2019-10-06 00:00:00'),
        (4, 'Asst. Manager', '2019-12-06 00:00:00'),
        (7, 'Team Lead', '2019-06-06 00:00:00'),
        (6, 'Team Lead', '2019-09-06 00:00:00'),
        (3, 'Senior Analyst', '2019-08-06 00:00:00');
        
Select * from Designation_Tables;


# ------------------------------------------------------------------------------------------------------------------------------


# Question: 2


use databeat_task;


#  a) --

(SELECT 
    e.FIRST_NAME, e.LAST_NAME, e.DEPARTMENT
FROM
    Employees e
        JOIN
    Variables_Details v ON v.EMP_REF_ID = e.EMP_Id
ORDER BY v.VARIABLES_AMOUNT DESC
LIMIT 1) UNION (SELECT 
    e.FIRST_NAME, e.LAST_NAME, e.DEPARTMENT
FROM
    Employees e
        JOIN
    Variables_Details v ON v.EMP_REF_ID = e.EMP_Id
ORDER BY v.VARIABLES_AMOUNT ASC
LIMIT 1);



# b) --

(SELECT 
    d.EMP_TITLE
FROM
    Designation_Tables d
        JOIN
    Employees e ON e.EMP_ID = d.EMP_REF_ID
        JOIN
    Variables_Details v ON v.EMP_REF_Id = d.EMP_REF_ID
ORDER BY (e.SALARY + v.VARIABLES_AMOUNT) DESC
LIMIT 1) UNION (SELECT 
    d.EMP_TITLE
FROM
    Designation_Tables d
        JOIN
    Employees e ON e.EMP_ID = d.EMP_REF_ID
        JOIN
    Variables_Details v ON v.EMP_REF_Id = d.EMP_REF_ID
ORDER BY (e.SALARY + v.VARIABLES_AMOUNT) ASC
LIMIT 2);



# c) --

# cross join :  it combine or joins all the rows of first table with all the rows with second table

SELECT 
    *
FROM
    Employees
        CROSS JOIN
    Designation_Tables;



# d) --

# different clauses and their order:  SELECT, FROM, WHERE, GROUP BY, HAVING, ORDER BY

use databeat_task;

SELECT 
    *
FROM
    Employees e
        JOIN
    Designation_Tables d ON e.EMP_ID = d.EMP_REF_ID
        JOIN
    Variables_Details v ON e.EMP_ID = v.EMP_REF_ID
WHERE
    d.AFFECTED_FROM BETWEEN '2019-07-01 00:00:00' AND '2019-12-31 00:00:00'
        AND e.DEPARTMENT LIKE '%A%'
ORDER BY v.VARIABLES_AMOUNT DESC
;


# --------------------------------------------------------------------------------------------------------------------------------------------

# Question 3  :

Drop procedure if exists for_cursor;
delimiter //
create procedure for_cursor()
begin
declare emp_names varchar(100);
declare emp_cur cursor for
select FIRST_NAME, LAST_NAME from Employees where DEPARTMENT = "HR";
open emp_cur;
cursorloop: loop
Fetch emp_cur into emp_names;
end loop cursorloop;
close emp_cur;
end //
delimiter ;




# a) --
# normalization: it helps us to reduce the redundancy in the data
# Issues due to redundancy: Insertion Anamoly, Deletion Anamoly, Updation Anamoly
# types: 1NF, 2NF, 3NF



# b)  --
#  stored procedure: in which we can save or stored sql code, if the same code we use againn and again then we can stored procedure, it helps to save 
# our time and energy.

use databeat_task;

delimiter &&
create procedure employee_procedure()
begin
(SELECT 
    e.FIRST_NAME, e.LAST_NAME, e.DEPARTMENT
FROM
    Employees e
        JOIN
    Variables_Details v ON v.EMP_REF_ID = e.EMP_Id
ORDER BY v.VARIABLES_AMOUNT DESC
LIMIT 1) UNION (SELECT 
    e.FIRST_NAME, e.LAST_NAME, e.DEPARTMENT
FROM
    Employees e
        JOIN
    Variables_Details v ON v.EMP_REF_ID = e.EMP_Id
ORDER BY v.VARIABLES_AMOUNT ASC
LIMIT 1);
end &&
delimiter ;

