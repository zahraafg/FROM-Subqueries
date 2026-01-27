CREATE DATABASE IT_CompanyDB;

USE IT_CompanyDB;

-- FROM Subquery + JOIN


/* 🔹 Task 1

Hər işçinin: full_name, department_name

göstərilsin, amma Employees subquery-dən gəlsin və Departments ilə JOIN et. */

select full_name, department_name
from (
	select department_id, full_name
	from Employees e
	) e
join (
	select id, department_name
	from Departments d
	) d
on e.department_id = d.id ;


/* 🔹 Task 2

Hər işçinin: full_name, position_name

göstərilsin, amma Employees subquery-dən gəlsin və Positions ilə JOIN et. */

select full_name, position_name
from (
	select position_id, full_name
	from Employees e
	)e
join (
	select id, position_name
	from Positions p
	) p
on p.id = e.position_id;


/* 🔹 Task 3

Hər layihənin: project_name, company_name (layihənin müştərisi)

göstərilsin, Projects subquery-dən gəlsin və Customers ilə JOIN et. */

select project_name, company_name
from (
	select customer_id, project_name
	from Projects p
	) p
join (
	select id, company_name
	from Customers
	) c
on p.customer_id = c.id;


/* 🔹 Task 4

Hər işçinin: full_name, project_name (işçinin çalışdığı layihələr)

göstərilsin, Assignments subquery-dən gəlsin və Projects ilə JOIN et. */

select full_name, project_name
from (
	select id, full_name
	from Employees e
	) e
join (
	select employee_id, a.project_id
	from Assignments a
	) a
on e.id = a.employee_id
join (
	select id, project_name
	from Projects p
	) p
on p.id = a.project_id;


/* 🔹 Task 5

Hər sifarişin: order id, company_name (sifarişi verən müştəri)

göstərilsin, Orders subquery-dən gəlsin və Customers ilə JOIN et. */

select [order id], company_name
from (
	select id as [order id], customer_id
	from Orders o
	) o
join (
	select id, company_name
	from Customers c
	) c
on o.customer_id = c.id;
