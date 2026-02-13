CREATE DATABASE IT_CompantDB;

USE IT_CompanyDB;

-- FROM Subquery + (JOIN, Aggregation, NON+Correlated, NOT+EXISTS, CASE)



/* Task: Hər department üçün aşağıdakı məlumatları çıxaran query yaz:

Department adı, İşçilərin sayı

Departmentdəki orta maaş

Departmentdəki ən yüksək maaş

Department maaşı ümumi şirkət ortalamasından yüksəkdirsə 'HIGH_PAY_DEPT', yoxdursa 'NORMAL' göstərin */

select 
    d.department_name,
    COUNT(t.id) as emp_count,
    AVG(t.salary) as avg_salary,
    MAX(t.salary) as max_salary,
    case 
        when AVG(t.salary) > (select AVG(salary) from Employees)
            then 'HIGH_PAY_DEPT'
        else 'NORMAL'
    end as pay_status
from (
        select e.id, e.salary, e.department_id, p.position_name
        from Employees e
        join Positions p 
        on p.id = e.position_id
     ) t
join Departments d 
on d.id = t.department_id
where exists (
        select 1
        from Employees e2
        join Positions p2 
		on p2.id = e2.position_id
        where e2.department_id = d.id
        and p2.position_name = 'Senior Developer'
     )
and not exists (
        select 1
        from Employees e3
        join Positions p3 
		on p3.id = e3.position_id
        where e3.department_id = d.id
        and p3.position_name = 'QA Engineer'
     )
group by d.department_name
having COUNT(t.id) >= 2;


/* 🧩 TASK (FROM subquery əsaslı)

IT_CompanyDB bazasında elə bir query yaz ki:

🔹 Çıxışda göstər: Department adı

Layihələrdə işləyən işçilərin sayı

Department üzrə orta maaş

Department üzrə maksimum maaş

Əgər department ortalama maaşı şirkət ortalamasından böyükdürsə → 'STRONG_DEPT', əks halda 'WEAK_DEPT' */

select 
	d.department_name,
	COUNT(t.id) as emp_count,
	AVG(salary) as avg_salary,
	MAX(salary) as max_salary,
	case 
	when AVG(salary) > (select AVG(salary) from Employees) then 'STRONG_DEPT'
	else 'WEAK_DEPT'
	end as dept
from (
	select e.id, e.department_id, full_name, salary
	from Employees e
	join Assignments a
	on e.id = a.employee_id
	) t

join Departments d
on d.id = t.department_id

where exists (
	select 1
	from Employees e2
	join Assignments a2
	on e2.id = a2.employee_id
	join Projects p
	on p.id = a2.project_id
	where e2.department_id = d.id
	and p.end_date is null
	)
and not exists (
select 1
from Employees e3
join Positions pos
on e3.position_id = pos.id
where e3.department_id = d.id
and pos.position_name = 'Team Lead'
)
group by d.department_name
having COUNT(t.id) >= 2;


/* 🧩 TASK — Advanced FROM Subquery Challenge

IT_CompanyDB-də elə query yaz ki, department üzrə aşağıdakıları göstərsin:

🔹 Çıxış sütunları: Department adı

Aktiv projectlərdə işləyən işçilərin sayı

Department üzrə orta maaş

Department üzrə maksimum maaş

Status: Əgər department avg maaşı şirkət avg maaşının 120%-indən böyükdürsə → 'ELITE'

Əks halda → 'STANDARD' */

select 
	d.department_name,
	COUNT(DISTINCT t.id) as emp_count,
	AVG(salary) as avg_salary,
	MAX(salary) as max_salary,
case 
	when AVG(Salary) > 1.2 * (select AVG(salary) from Employees) 
	then 'ELITE'
	else 'STANDARD'
end as Status
from (
	select e.id, e.department_id, e.salary
	from Employees e
	join Assignments a
	on a.employee_id = e.id
	join Projects p
	on p.id = a.project_id
	and p.end_date is null
) t
join Departments d
on t.department_id = d.id
where exists (
	select 1
	from Employees e2
	join Assignments a2
	on a2.employee_id = e2.id
	join Projects p
	on p.id = a2.project_id
	join Attendance att
	on e2.id = att.employee_id
	where e2.department_id = d.id
	and p.end_date is null
	and att.hours_worked >= 8
	)
and not exists (
	select 1
	from Employees e3
	where e3.department_id = d.id
	and salary < 1000
	)
group by d.department_name
having COUNT(DISTINCT t.id) >= 2;


/* 🧩 BOSS LEVEL TASK — Multi-Layer FROM Subquery

IT_CompanyDB-də elə query yaz ki, department üzrə aşağıdakıları göstərsin:

🔹 Çıxış sütunları: Department adı

Aktiv projectlərdə işləyən unikal işçilərin sayı

Bu işçilərin orta maaşı

Bu işçilərin maksimum maaşı

Status: Əgər department avg maaşı company avg maaşının 130%-indən böyükdürsə → 'TOP_TIER'

Əks halda → 'REGULAR' */

select 
	d.department_name,
	COUNT(distinct f.project_id) as emp_count,
	AVG(salary) as avg_salary,
	MAX(Salary) as max_salary,
	case 
		when AVG(salary) > 1.3 * (select AVG(salary) from Employees) then 'TOP_TIER'
		else 'REGULAR'
	end as Status
from (
	select t.id, t.salary, t.department_id, t.project_id
from (
	select e.id, e.salary, e.department_id, a.project_id
	from Employees e
	join Assignments a
	on a.employee_id = e.id
	join Projects p
	on p.id = a.project_id
	where p.end_date is null
	) t
) f
join Departments d
on d.id = f.department_id
where exists (
	select 1
	from Employees e2
	join Attendance att
	on att.employee_id = e2.id
	where e2.department_id = d.id
	and att.work_date >= DATEADD(DAY, -2, GETDATE())
    and att.hours_worked >= 8
    group by att.employee_id
    having COUNT(DISTINCT att.work_date) = 2
	)
and not exists (
	select 1
	from Employees e3
	where e3.department_id = d.id
		and not exists (
		select 1
		from Assignments a2
		where a2.employee_id = e3.id
		)
	)
group by d.department_name
having COUNT(distinct f.project_id) >= 2;


/* 🧩 TASK — Boss Level II (FROM subquery + aggregation + EXISTS/NOT EXISTS)

IT_CompanyDB-də department üzrə çıxış hazırlamaq:

🔹 Çıxış sütunları: Department adı

İndiki (aktiv) projectlərdə işləyən işçi sayı

Bu işçilərin orta maaşı

Bu işçilərin maksimum maaşı

Status: Əgər department avg maaşı bütün şirkət avg maaşının 125%-dən böyükdürsə → 'ELITE_DEPT'  

Əks halda → 'NORMAL_DEPT' 

🔥 MÜTLƏQ ŞƏRTLƏR

✅ FROM subquery istifadə et (istəyə görə multi-layer ola bilər)
✅ JOIN-lər: Employees + Assignments + Projects
✅ EXISTS (correlated): department-da ən az 1 işçi son 3 gündə ≥8 saat işləyib
✅ NOT EXISTS (correlated): department-da salary < 1000 olan işçi yoxdur
✅ HAVING: departmentda ən az 2 fərqli aktiv projectdə işçi olmalıdır
✅ Aggregation: COUNT, AVG, MAX
✅ CASE: status üçün
✅ Non-correlated subquery: company avg salary üçün */

select 
	d.department_name,
	COUNT(distinct f.project_id) as pro_count,
	AVG(salary) as avg_salary,
	MAX(salary) as max_salary,
	case 
		when AVG(salary) > 1.25 * (select AVG(salary) from Employees) then 'ELITE_DEPT'
		else 'NORMAL_DEPT' 
	end as dept
from (
	select t.id, t.salary, t.department_id, t.project_id
	from (
		select e.id, e.salary, e.department_id, a.project_id
		from Employees e
		join Assignments a
		on a.employee_id = e.id
		join Projects p
		on p.id = a.project_id
		and p.end_date is null
		) t
	) f
join Departments d
on d.id = f.department_id
where exists (
	select 1
	from Employees e2
	join Attendance att
	on e2.id = att.employee_id
	where e2.department_id = d.id
	and att.work_date >= DATEADD(DAY, -3, GETDATE())
    and att.hours_worked >= 8
    group by att.employee_id
    having COUNT(DISTINCT att.work_date) = 3
	)
and not exists(
	select 1
	from Employees e3
	where e3.department_id = d.id
	and salary < 1000
	)
group by d.department_name
having COUNT(distinct f.project_id) >= 2;


/* 🧩 INTERVIEW-STYLE TASK — “Employee Project Performance”

🔹 Məqsəd:

Department üzrə çıxış hazırlamaq: Department adı

Aktiv projectlərdə işləyən unikal işçilərin sayı

Bu işçilərin orta maaşı

Bu işçilərin maksimum maaşı

Department statusu: Əgər department-da çalışan işçilərin ortalama maaşı company 

avg salary-dən 20% yuxarıdır → 'HIGH_PERFORMANCE' Əks halda → 'STANDARD' 

🔹 Şərtlər

✅ FROM subquery mütləq
✅ JOIN-lər: Employees + Assignments + Projects
✅ Aktiv projectlər: Projects.end_date IS NULL
✅ Correlated EXISTS:

department-da ən az 1 işçi son 3 gündə hər gün ≥ 8 saat işləyib

✅ Correlated NOT EXISTS:

department-da heç bir işçi salary < 1000 olmamalıdır

✅ HAVING:

departmentda ən az 2 fərqli aktiv projectdə işçi olmalıdır

✅ Aggregation: COUNT, AVG, MAX
✅ CASE: status üçün
✅ Non-correlated subquery: company avg salary üçün */

select d.department_name,
	COUNT(distinct f.id) as emp_count,
	AVG(f.salary) as avg_salary,
	MAX(f.salary) as max_salary,
	case 
		when AVG(salary) > 1.2 * (select AVG(salary) from Employees) then 'HIGH_PERFORMANCE'
		else 'STANDARD'
	end as Department_statusu
from (
	select t.id, t.salary, t.department_id, t.project_id
	from (
	select e.id, e.salary, e.department_id, a.project_id
	from Employees e
	join Assignments a
	on a.employee_id = e.id
	join Projects p
	on p.id = a.project_id
	and p.end_date is null
	) t
) f
join Departments d
on d.id = f.department_id
where exists (
	select 1
	from Employees e2
	join Attendance att
	on e2.id = att.employee_id
	where e2.department_id = d.id
	and att.work_date >= DATEADD(DAY, -3, GETDATE())
    and att.hours_worked >= 8
    group by att.employee_id
    having COUNT(DISTINCT att.work_date) = 3
	)
and not exists (
	select 1
	from Employees e3
	where e3.department_id = d.id
	and salary < 1000
	)
group by department_name
having COUNT(distinct f.id) >= 2;





