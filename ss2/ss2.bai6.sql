create schema shop;
set search_path to shop;

create table Users(
    user_id serial primary key ,
    username varchar(50) unique not null ,
    email varchar(100) unique not null ,
    password varchar(100) not null ,
    role varchar(20) check ( role IN ('Customer','Admin') )
);

create table Categories(
    category_id serial primary key ,
    category_name varchar(100) unique not null
);

create table Products(
    product_id serial primary key ,
    product_name varchar(100) not null,
    price numeric(10,2) check ( price > 0 ),
    stock int check ( stock >= 0 ),
    category_id int,
    constraint fk_categori foreign key (category_id) references Categories(category_id)
);

create table Orders(
    order_id serial primary key ,
    order_date date not null ,
    status varchar(20) check ( status IN ('Pending','Shipped','Delivered','Cancelled') ),
    user_id int,
   constraint fk_user foreign key (user_id) references Users(user_id)
);

create table OrderDetails(
    order_detail_id serial primary key ,
    order_id int,
    product_id int,
    quantity int check ( quantity > 0 ),
    price_each numeric(10,2) check ( price_each > 0 ),
    constraint fk_order foreign key (order_id) references Orders(order_id),
    constraint fk_product foreign key (product_id) references Products(product_id)
);

create table Payments(
    payment_id serial primary key ,
    order_id int,
    amount numeric(10,2) check ( amount >= 0 ),
    payment_date date not null ,
    method varchar(30) check ( method IN ('Credit Card','Momo','Bank Transfer','Cash')),
    constraint fk_order foreign key (order_id) references Orders(order_id)
);