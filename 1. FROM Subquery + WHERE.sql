CREATE DATABASE IT_CompanyDB;

USE IT_CompanyDB;

-- FROM Subquery + WHERE


/* 🔹 Task 1

İşçilərin full_name və salary məlumatlarını çıxar,

yalnız maaşı 1500-dən böyük olanlar göstərilsin. */

select full_name, salary
from (
	select full_name, salary
	from Employees
	) e
where salary > 1500;


/* 🔹 Task 2

Projects cədvəlindən project_name və budget məlumatlarını çıxar,

yalnız budget 50000-dən az olan layihələr göstərilsin. */

select project_name, budget
from (
	select project_name, budget
	from Projects
	) p
where budget < 50000;


/* 🔹 Task 3

Customers cədvəlindən company_name və country məlumatlarını çıxar,

yalnız country = 'UK' olanlar göstərilsin. */

select company_name, country
from (
	select company_name, country
	from Customers
	) c
where country = 'UK';


/* 🔹 Task 4

Employees cədvəlindən full_name və hire_date məlumatlarını çıxar,

yalnız 2023-cü ildən sonra işə başlayanlar göstərilsin. */

select full_name, hire_date
from (
	select full_name, hire_date
	from Employees 
	) e
where hire_date > '2023-01-01';


/* 🔹 Task 5

Orders cədvəlindən id və total_amount məlumatlarını çıxar,

yalnız total_amount ≥ 20000 olan sifarişlər göstərilsin. */

select id, total_amount
from (
	select id, total_amount
	from Orders
	) o
where total_amount >= 20000;