create schema quanlyluong;
set search_path to quanlyluong;

create table Employees(
    employees_id serial primary key ,
    full_name varchar(225) not null ,
    department varchar(30) not null ,
    position varchar(30) not null ,
    salary decimal(10,2) not null ,
    bonus decimal(10,2) null ,
    join_year int
);

delete from quanlyluong.employees
where employees_id NOT IN (
    SELECT MIN(employees_id)
    FROM Employees
    GROUP BY full_name, department, position
);

update Employees set salary = salary*1.1
where department ='IT' and salary < 18000000;

update Employees set bonus = 500000
where bonus is null;

select *from Employees
where department in ('IT', 'HR') and join_year > 2020 and (salary + bonus) > 15000000;

select *from Employees
order by (salary + bonus) desc
limit 3;

select *from Employees
where full_name LIKE'Nguyễn%'
or full_name LIKE '%Hân';

select distinct Employees.department
from Employees
where bonus is not null ;

select *from Employees
where join_year between 2019 and 2022;