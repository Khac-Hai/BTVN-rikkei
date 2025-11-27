-- tao database
create database UniversityDB;

-- tao schema
create schema university;

-- tao bang
set search_path to university;
create table Students(
                         student_id serial primary key,
                         first_name varchar(50) not null ,
                         last_name varchar(50) not null ,
                         birth_date date,
                         email varchar(30) not null unique
);

create table Courses(
                        course_id serial primary key,
                        course_name varchar(100) not null ,
                        credits int
);

create table Enrollments(
                            enrollment_id serial primary key,
                            student_id int references university.students(student_id),
                            course_id int references university.courses(course_id),
                            enrool_date date
);