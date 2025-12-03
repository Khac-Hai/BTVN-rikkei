create schema quanlythongtinsinhvien;
set search_path to quanlythongtinsinhvien;

create table students(
    id serial primary key ,
    name varchar(50),
    age int,
    major varchar(50),
    gpa decimal(10,2)
);

insert into students(name, age, major, gpa) VALUES
('An',20,'CNTT',3.5),
('Bình',21,'Toán',3.2),
('Cường',22,'CNTT',3.8),
('Dương',20,'Vật lý',3.0),
('Em',21,'CNTT',2.9);

insert into students(name, age, major, gpa) VALUES
('Hùng',23,'Hoá học', 3.4);

update students set gpa=3.6
where name = 'Bình';

delete from students
where gpa < 3.0;

select students.name,students.major
from students
order by gpa desc ;

select *from students
where major = 'CNTT';

select *from students
where gpa between 3.0 and 3.6;

select *from students
where name ILIKE 'c%';

select *from students
order by id
limit 3;
