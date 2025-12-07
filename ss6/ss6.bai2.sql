create schema bai2;
set search_path to bai2;

create table Employee(
    id serial primary key ,
    full_name varchar(100),
    department varchar(50),
    salary numeric(10,2),
    hire_date date
);

INSERT INTO Employee (full_name, department, salary, hire_date) VALUES
                                                                        ('Nguyễn Văn An', 'IT', 12000000.00, '2023-05-15'),
                                                                        ('Trần Thị Bình', 'Sales', 9500000.00, '2022-11-20'),
                                                                        ('Lê Văn Chính', 'IT', 15000000.00, '2023-01-10'),
                                                                        ('Phạm Thị Mai', 'HR', 8000000.00, '2024-02-01'),
                                                                        ('Vũ Đình Khôi', 'Sales', 10500000.00, '2022-07-30'),
                                                                        ('Hoàng Anh Tú', 'Marketing', 7000000.00, '2023-10-25');

update Employee set salary = salary*1.1
where department = 'IT';

delete from Employee
where salary < 6000000;

select *from Employee
where full_name ILIKE '%an%';

select *from Employee
where hire_date between '2023-01-01' and '2023-12-31';
