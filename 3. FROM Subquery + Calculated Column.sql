CREATE DATABASE IT_CompanyDB;

USE IT_CompanyDB;

-- FROM Subquery + Calculated Column


/* 🔹 Task 1

İşçilərin full_name və salary göstərilsin,

amma salary-dən 10% bonus əlavə edilmiş yeni sütun də göstərilsin (new_salary adında). */

select full_name, salary, new_salary
from (
	select full_name, salary,  (salary * 1.1) as new_salary
	from Employees
	) e;


/* 🔹 Task 2

Projects cədvəlindən project_name və budget göstərilsin,

amma budget-in 1.2 dəfə artırılmış dəyəri də göstərilsin (adjusted_budget adında). */

select project_name, budget, adjusted_budget
from (
	select project_name, budget, (budget * 1.2) as adjusted_budget
	from Projects 
	) p;


/* 🔹 Task 3

Orders cədvəlindən id və total_amount göstərilsin,

amma total_amount-dən 5% vergi əlavə edilmiş sütun də olsun (total_with_tax). */

select id, total_amount, total_with_tax
from (
	select id, total_amount, (total_amount * 1.05) as total_with_tax
	from Orders
	) o;


/* 🔹 Task 4

Employees cədvəlindən full_name və salary göstərilsin,

amma maaşın 2 qatını göstərən yeni sütun əlavə et (double_salary). */

select full_name, salary, double_salary
from (
	select full_name, salary, (salary * 2) as double_salary
	from Employees
	) e;


/* 🔹 Task 5

OrderDetails cədvəlindən product_name, price və quantity göstərilsin,

amma ümumi məbləği (price * quantity) hesablayan sütun əlavə et (total_amount). */

select product_name, price, quantity, total_amount
from (
	select product_name, price, quantity, (price * quantity) as total_amount
	from OrderDetails
	) od;
