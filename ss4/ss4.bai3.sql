create schema quanlysinhvien;
set search_path to quanlysinhvien;

create table Students(
    id serial primary key ,
    full_name varchar(50),
    gender varchar(10),
    birth_year int,
    major varchar(50),
    gpa decimal(10,2) null
);

insert into Students(full_name, gender, birth_year, major, gpa)
values
('Nguyễn Văn A','Nam',2002,'CNTT',3.6),
('Trần Thị Bích Ngọc','Nữ',2001,'Kinh tế',3.2),
('Lê Quốc Cường','Nam',2003,'CNTT',2.7),
('Phạm Minh Anh','Nữ',2000,'Luật',3.9),
('Nguyễn Văn A','Nam',2002,'CNTT',3.6),
('Lưu Đức Tài','2004',2004,'Cơ khí', null),
('Võ Thị Thu Hằng','Nữ',2001,'CNTT',3.0);

insert into Students(full_name, gender, birth_year, major, gpa)
values
    ('Phan Hoàng Nam','Nam',2003,'CNTT',3.8);

update Students set gpa=3.4
where full_name ='Lê Quốc Cường';

delete from Students
where gpa is null ;

select *from Students
where major='CNTT' and gpa >= 3.0
limit 3;

select distinct Students.major
from Students;

select *from Students
where major='CNTT'
order by gpa desc, full_name asc ;

select *from Students
where full_name ILIKE 'Nguyễn%';

select *from Students
where birth_year between 2001 and 2003;

create schema quanlyhocbong;
set search_path to quanlyhocbong;

create table students(
    id serial primary key ,
    name varchar(50),
    age int,
    major varchar(50),
    gpa decimal(3,2)
);

create table Scholarships(
    id serial primary key ,
    student_id int references students(id),
    name varchar(50),
    amount decimal(10,2),
    year int
);

insert into students(name,age,major,gpa)
values ('An',20,'CNTT',3.5),
       ('Bình',21,'Toán',3.2),
       ('Cường',22,'CNTT',3.8),
       ('Dương',20,'Vật lý',3.0),
       ('Em',21,'CNTT',2.9);

insert into Scholarships(student_id, name, amount, year)
values (1,'Học bổng xuất sắc',1000,2025),
       (3,'Học bổng xuất sắc',1200,2025),
       (2,'Học bổng khuyến khích',500,2025),
       (4,'Học bổng khuyến khích',400,2025);

insert into Scholarships(student_id, name, amount, year)
values (5,'Học bổng Khuyến khích',450,2025);

update students set gpa=4.0
from Scholarships
where students.id= Scholarships.student_id
and Scholarships.name ='Học bổng xuất sắc';

delete from Scholarships
where student_id in (
    select id from students
    where gpa <3.0);

delete from students
where gpa <3.0;

select students.name,students.major,Scholarships.name,Scholarships.amount
from students
join Scholarships on students.id = student_id
where year=2025
order by amount desc ;

SELECT s.name,
       s.major,
       sc.name,
       sc.amount
FROM students s
         JOIN scholarships sc ON s.id = sc.student_id
WHERE s.name ILIKE '%C%'
  AND sc.amount > 1000;

SELECT *
FROM students
ORDER BY gpa DESC
LIMIT 2

