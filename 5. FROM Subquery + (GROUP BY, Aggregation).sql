CREATE DATABASE IT_CompanyDB;

USE IT_CompanyDB;

-- FROM Subquery + (GROUP BY + Aggregation)


/* 🔹 Task 1

Hər department_id üzrə:

işçilərin sayı göstərilsin. */

select department_id, count_emp
from (
	select department_id, COUNT(*) as count_emp
	from Employees
	group by department_id
	) e;


/* 🔹 Task 2

Hər department_id üzrə:

orta maaş göstərilsin. */

select department_id, avg_salary
from (
	select department_id, AVG(salary) as avg_salary
	from Employees
	group  by department_id
	) e;


/* 🔹 Task 3

Hər customer_id üzrə:

sifarişlərin ümumi məbləği göstərilsin. */

select customer_id, total_amount
from (
	select customer_id, SUM(total_amount) as total_amount
	from Orders 
	group by customer_id
	) o;


/* 🔹 Task 4

Hər project_id üzrə:

həmin layihədə çalışan işçilərin sayı göstərilsin. */

select project_id, count_emp
from (
	select project_id, COUNT(employee_id) as count_emp
	from Assignments
	group by project_id
	) a;


/* 🔹 Task 5

Hər employee_id üzrə:

işlədiyi günlərin sayı göstərilsin. */

select employee_id, work_days
from (
	select employee_id, COUNT(work_date) as work_days
	from Attendance
	group by employee_id
	) a;