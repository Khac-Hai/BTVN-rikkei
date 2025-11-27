create database SalesDB;
create schema sales;
set search_path to sales;
create table Customers(
    customer_id serial primary key ,
    first_name varchar(50) not null ,
    last_name varchar(50) not null ,
    email varchar(30) unique not null ,
    phone char(10)
);

create table Products(
    product_id serial primary key ,
    product_name varchar(100) not null ,
    price numeric(10,2) not null ,
    stock_quantity int not null
);

create table Orders(
    order_id serial primary key ,
    customer_id int references Customers(customer_id),
    order_date date
);

create table OrderItems(
    order_item_id serial primary key ,
    order_id int not null ,
    product_id int not null ,
    quantity INT NOT NULL CHECK (quantity >= 1),
    constraint fk_order foreign key (order_id) references Orders(order_id),
    constraint fk_product foreign key (product_id) references Products(product_id)
);