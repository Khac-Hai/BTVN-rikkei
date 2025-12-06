create schema bai6;
set search_path to bai6;

create table departments(
    dept_id serial primary key ,
    dept_name varchar(100)
);

create table employees(
    emp_id serial primary key ,
    emp_name varchar(100),
    dept_id int references departments(dept_id),
    salary numeric(10,2),
    hire_date date
);

create table projects(
    project_id serial primary key ,
    project_name varchar(100),
    dept_id int references departments(dept_id)
);

INSERT INTO departments (dept_name) VALUES
                                        ('Kỹ thuật (Engineering)'),
                                        ('Nhân sự (Human Resources)'),
                                        ('Kế toán (Accounting)'),
                                        ('Kinh doanh (Sales)'),
                                        ('Tiếp thị (Marketing)');

INSERT INTO employees (emp_name, dept_id, salary, hire_date) VALUES
                                                                 ('Nguyễn Văn A', 1, 75000.00, '2022-01-15'), -- Kỹ thuật
                                                                 ('Trần Thị B', 2, 55000.00, '2023-05-20'), -- Nhân sự
                                                                 ('Lê Văn C', 1, 82000.00, '2021-11-01'), -- Kỹ thuật
                                                                 ('Phạm Thị D', 3, 60000.00, '2024-03-10'), -- Kế toán
                                                                 ('Hoàng Văn E', 4, 68000.00, '2022-08-25'); -- Kinh doanh

INSERT INTO projects (project_name, dept_id) VALUES
                                                 ('Phát triển Ứng dụng X', 1), -- Kỹ thuật
                                                 ('Chiến dịch Marketing Mùa hè', 5), -- Tiếp thị
                                                 ('Nâng cấp Hệ thống ERP', 3), -- Kế toán
                                                 ('Tuyển dụng Kỹ sư Phần mềm', 2), -- Nhân sự
                                                 ('Phân tích Thị trường Q4', 4); -- Kinh doanh

select e.emp_name as "Tên nhân viên",
       d.dept_name as "Phòng ban",
       e.salary as "Lương"
from departments d join employees e on d.dept_id = e.dept_id;

select sum(salary),
       avg(salary),
       max(salary),
       min(salary),
       count(emp_name)
from employees;

select d.dept_name, avg(salary)
from departments d join employees e on d.dept_id = e.dept_id
group by d.dept_name
having avg(salary) > 15000;

select p.project_name, d.dept_name, e.emp_name
from departments d join employees e on d.dept_id = e.dept_id
join projects p on d.dept_id = p.dept_id;

select d.dept_name, e.emp_name, e.salary
from employees e join departments d on e.dept_id = d.dept_id
where (e.dept_id, e.salary) in (select dept_id, max(salary)
                                from employees
                                group by dept_id)
order by d.dept_name;

(select d.dept_name
from departments d join employees e on d.dept_id = e.dept_id)
union
(select d.dept_name
from departments d join projects p on d.dept_id = p.dept_id);

(select d.dept_name
 from departments d join employees e on d.dept_id = e.dept_id)
except
(select d.dept_name
 from departments d join projects p on d.dept_id = p.dept_id);