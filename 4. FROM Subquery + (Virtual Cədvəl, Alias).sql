CREATE DATABASE IT_CompanyDB;

USE IT_CompanyDB;

-- FROM Subquery + (Virtual Cədvəl, Alias)


/* 🔹 Task 1

İşçilərin id, full_name və salary məlumatlarını FROM subquery istifadə edərək çıxar. */

select id, full_name, salary
from (
	select id, full_name, salary
	from Employees 
	) e;


/* 🔹 Task 2

İşçilərin full_name və department_id məlumatlarını FROM subquery üzərindən göstər. */

select full_name, department_id
from (
	select full_name, department_id
	from Employees 
	) e;


/* 🔹 Task 3

Projects cədvəlindən project_name və budget məlumatlarını FROM subquery ilə qaytar. */

select project_name, budget
from (
	select project_name, budget
	from Projects
	) p;


/* 🔹 Task 4

Customers cədvəlindən company_name və country məlumatlarını FROM subquery istifadə edərək çıxar. */

select company_name, country
from (
	select company_name, country
	from Customers 
	) c;


/* 🔹 Task 5

Orders cədvəlindən id və order_date məlumatlarını FROM subquery ilə göstər. */

select id, order_date
from (
	select id, order_date
	from Orders 
	) o;