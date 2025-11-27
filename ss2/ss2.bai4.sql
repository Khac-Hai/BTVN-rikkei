create database ElearningDB;
create schema elearning;
set search_path to elearning;
create table Students(
                         student_id serial primary key ,
                         first_name varchar(50) not null ,
                         last_name varchar(50) not null ,
                         email varchar(30) unique not null
);

create table Instructors(
                            instructor_id serial primary key ,
                            first_name varchar(50) not null ,
                            last_name varchar(50) not null ,
                            email varchar(30) unique not null
);

create table Courses(
                        course_id serial primary key ,
                        course_name varchar(100) not null ,
                        instructor_id int not null ,
                        constraint pk_instructor foreign key (instructor_id) references Instructors(instructor_id)
);

create table Enrollments(
                            enrollment_id serial primary key ,
                            enroll_date date not null ,
                            student_id int not null ,
                            course_id int not null ,
                            constraint pk_student foreign key (student_id) references Students(student_id),
                            constraint pk_course foreign key (course_id) references Courses(course_id)
);

create table Assignments(
                            assignment_id serial primary key ,
                            title varchar(100) not null ,
                            due_date date not null ,
                            course_id int not null ,
                            constraint pk_course foreign key (course_id) references Courses(course_id)
);

create table Submissions(
                            submission_id serial primary key ,
                            submisson_date date not null ,
                            grade NUMERIC(10,2) CHECK (grade >= 0 AND grade <= 100),
                            assignment_id int not null ,
                            student_id int not null ,
                            constraint pk_assignment foreign key (assignment_id) references Assignments(assignment_id),
                            constraint pk_student foreign key (student_id) references Students(student_id)
);