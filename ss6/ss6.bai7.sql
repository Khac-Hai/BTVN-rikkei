create schema bai7;
set search_path to bai7;

create table Department(
    id serial primary key ,
    name varchar(50)
);

create table Employee(
    id serial primary key ,
    full_name varchar(100),
    department_id int,
    salary numeric(10,2)
);

INSERT INTO Department (name) VALUES
                                  ('Sales'),
                                  ('Marketing'),
                                  ('Engineering'),
                                  ('Human Resources'),
                                  ('Finance');
INSERT INTO Employee (full_name, department_id, salary) VALUES
                                                            ('Nguyen Van A', 3, 75000000.00),  -- Engineering
                                                            ('Tran Thi B', 1, 60000000.00),     -- Sales
                                                            ('Le Van C', 2, 45000000.00),      -- Marketing
                                                            ('Pham Thi D', 3, 80000000.00),    -- Engineering
                                                            ('Hoang Van E', 4, 35000000.00),    -- Human Resources
                                                            ('Do Thi F', 1, 65000000.00),      -- Sales
                                                            ('Bui Van G', 5, 55000000.00);     -- Finance

select d.name, e.full_name
from Department d join Employee E on d.id = E.department_id;

select d.name, avg(e.salary)
from Department d join Employee E on d.id = E.department_id
group by d.id;

select d.name, avg(e.salary) as "Trung bình"
from Department d join Employee E on d.id = E.department_id
group by d.id
having avg(e.salary) > 10000000;

select d.name
from Department d left join Employee E on d.id = E.department_id
where e.id isnull;