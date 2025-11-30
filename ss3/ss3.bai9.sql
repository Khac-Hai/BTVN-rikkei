create database SchoolDB;
create schema school;
set search_path to school;
create table Students(
                         student_id serial primary key ,
                         name varchar(50),
                         dob date
);

create table Courses(
                        course_id serial primary key ,
                        course_name varchar(50),
                        credits int
);

create table Enrollments(
                            enrollment_id serial primary key ,
                            student_id int,
                            course_id int,
                            grade char(1) check ( grade in ('A', 'B', 'C', 'D', 'F')),
                            constraint fk_student foreign key (student_id) references Students(student_id),
                            constraint fk_course foreign key (course_id) references Courses(course_id)
);

