CREATE DATABASE IT_CompanyDB;

USE IT_CompanyDB;

-- FROM Subquary + Nested Subquery


/* 🔹 Task 1

Hər department üçün: department_id

maaşı department üzrə orta maaşdan yüksək olan işçilərin sayı

FROM subquery içində orta maaşı əvvəlcə subquery-də hesabla. */

select full_name
from Employees e
where salary > (
	select AVG(salary) as avg_salary
	from Employees e2
	where e.department_id = e2.department_id
	);


/* 🔹 Task 2

Hər layihə üçün: project_name

layihədə çalışan işçilərin maaşlarının cəmi

yalnız maaşı 2000-dən çox olan işçilər daxil edilsin

FROM subquery + nested aggregation istifadə et. */

select p.project_name, SUM(e.salary) as total_salary
from Employees e
join Assignments a
    on e.id = a.employee_id
join Projects p
    on p.id = a.project_id
where e.salary > 2000
group by p.project_name;

--OR
select p.project_name, total_salary
from Projects p
join (
    select a.project_id, SUM(e.salary) as total_salary
    from Assignments a
    join Employees e
        on e.id = a.employee_id
    where e.salary > 2000
    group by a.project_id
) a
on p.id = a.project_id;


/* 🔹 Task 3

Hər müştəri üçün: company_name, ümumi sifariş sayı,

yalnız sifarişin ümumi məbləği 20000-dən çox olan sifarişlər nəzərə alınsın. */

select company_name, SUM(total_amount) as total_amount
from Customers c
join Orders o
on o.customer_id = c.id
where total_amount > 20000
group by company_name;

--OR
select company_name, total_amount
from Customers c
join (
	select o.customer_id, SUM(total_amount) as total_amount
	from Orders o
	where total_amount > 20000
    group by o.customer_id
	) o
on c.id = o.customer_id;


/* 🔹 Task 4

Hər işçi üçün: full_name

işçinin çalışdığı layihələrdəki ortalama layihə büdcəsi

Nested subquery içində Projects büdcəsini hesablamaq */

select full_name, AVG(budget) as avg_budget
from Employees e
join Assignments a
on e.id = a.employee_id
join Projects p
on p.id = a.project_id
group by full_name;

--OR
select full_name
from Employees e
join (
	select a.employee_id,  AVG(budget) as avg_budget
	from Assignments a
	join Projects p
	on p.id = a.project_id
	group by a.employee_id
	) a
on e.id = a.employee_id;


/* 🔹 Task 5

Hər product üçün: product_name

ümumi satış məbləği (price * quantity)

yalnız satış məbləği 10000-dən çox olanlar göstərilsin

FROM subquery içində hesablanmış məbləği əvvəlcə subquery-də yarat. */

select product_name, SUM(price * quantity) as total_sales
from OrderDetails
where price * quantity > 10000
group by product_name;

--OR
select od.product_name, P.total_sales
from OrderDetails od
join (
    select product_name, SUM(price * quantity) as total_sales
    from OrderDetails od
    where price * quantity > 10000
    group by product_name
) P
on od.product_name = P.product_name
group by od.product_name, P.total_sales;