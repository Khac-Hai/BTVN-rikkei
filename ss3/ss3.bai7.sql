create schema sales;
set search_path to sales;

create table Products(
    product_id serial primary key ,
    product_name varchar(225),
    price numeric(10,2),
    stock_quantity int
);

create table Orders(
    order_id serial primary key ,
    order_date date default current_date,
    member_id int,
    constraint fk_member foreign key (member_id) references libary.members(member_id)
);

create table OrederDetails(
    order_detail_id serial primary key ,
    order_id int,
    product_id int,
    quantity int,
    constraint fk_order foreign key (order_id) references Orders(order_id),
    constraint fk_product foreign key (product_id) references Products(product_id)
);