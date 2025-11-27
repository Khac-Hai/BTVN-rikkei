--Tao database
create database LibraryDB;
-- Tao Schema
create schema library;
set search_path to library;

-- Tao bang
create table Books(
    book_id serial primary key ,
    title varchar(100) not null ,
    author varchar(50) not null ,
    published_year int,
    price numeric(10,2)
);