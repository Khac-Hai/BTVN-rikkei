create database librarydb;
create schema libary;
set search_path to libary;

create table Books(
    book_id int primary key ,
    title varchar(225),
    author varchar(225),
    published_year int,
    available boolean default true

);

create table Members(
    member_id int primary key ,
    name varchar(225),
    email varchar(225) unique,
    join_date date default current_date
);