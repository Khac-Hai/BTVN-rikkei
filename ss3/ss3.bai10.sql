CREATE DATABASE CompanyDB;
create schema company;
set search_path to company;

create table Departments(
                            department_id serial primary key ,
                            department_name varchar(50)
);

create table Employees(
                          emp_id serial primary key ,
                          name varchar(50),
                          dob date,
                          department_id int,
                          constraint fk_department foreign key (department_id) references Departments(department_id)
);

create table Projects(
                         project_id serial primary key ,
                         project_name varchar(50),
                         start_date date,
                         end_date date
);

create table EmployeeProjects(
                                 emp_id int,
                                 project_id int,
                                 constraint fk_emp foreign key (emp_id) references Employees(emp_id),
                                 constraint fk_project foreign key (project_id) references Projects(project_id)
);

