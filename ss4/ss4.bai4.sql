create schema quanlysanpham;
set search_path to quanlysanpham;

CREATE TABLE products (
   id SERIAL PRIMARY KEY,
   name VARCHAR(100) NOT NULL,
   category VARCHAR(50),
   price NUMERIC(15,0),
   stock INT,
   manufacturer VARCHAR(50)
);

INSERT INTO products ( name, category, price, stock, manufacturer) VALUES
   ('Laptop Dell XPS 13', 'Laptop', 25000000, 12, 'Dell'),
   ('Chuột Logitech M90', 'Phụ kiện', 150000, 50, 'Logitech'),
   ('Bàn phím cơ Razer', 'Phụ kiện', 2200000, 0, 'Razer'),
   ('Macbook Air M2', 'Laptop', 32000000, 7, 'Apple'),
   ('iPhone 14 Pro Max', 'Điện thoại', 35000000, 15, 'Apple'),
   ('Laptop Dell XPS 13', 'Laptop', 25000000, 12, 'Dell'),
   ('Tai nghe AirPods 3', 'Phụ kiện', 4500000, NULL, 'Apple');

INSERT INTO products (name, category, price, stock, manufacturer) VALUES
   ('Chuột không dây Logitech M170', 'Phụ kiện', 300000, 20, 'Logitech');

update products set price=price*1.1
where manufacturer ='Apple';

select *from products
where price between 1000000 AND 30000000;

select *from products
where stock is null;

select distinct products.manufacturer
from products;

select *from products
order by price desc ,name asc ;

select *from products
where name ILIKE '%laptop%';

select *from products
order by name
limit 2;