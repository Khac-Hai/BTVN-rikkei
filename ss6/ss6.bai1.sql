create schema bai1;
set search_path to bai1;

create table Product(
    id serial primary key ,
    name varchar(100),
    category varchar(50),
    price numeric(10,2),
    stock int
);

INSERT INTO Product (name, category, price, stock) VALUES
                                                           ( 'Laptop X', 'Điện tử', 15000000.00, 15),
                                                           ('Smartphone Y', 'Điện tử', 8500000.00, 30),
                                                           ( 'Áo phông Z', 'Thời trang', 250000.00, 100),
                                                           ('Sách A', 'Văn phòng phẩm', 120000.00, 50),
                                                           ('Bàn phím cơ B', 'Điện tử', 1800000.00, 20);
select *
from Product;

select name, price
from Product
order by price desc
limit 3;

select name, category, price
from Product
where category ='Điện tử' and price < 10000000;

select name, stock
from Product
order by stock asc ;