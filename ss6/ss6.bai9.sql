create schema bai9;
set search_path to bai9;

create table Product(
    id serial primary key ,
    name varchar(100),
    category varchar(50),
    price numeric(10,2)
);

create table Orders(
                       id serial primary key ,
                       order_date date,
                       total_amount numeric(10,2)
);

create table OrderDetail(
    id serial primary key ,
    order_id int references Orders(id),
    product_id int references Product(id),
    quantity int
);



INSERT INTO Product (name, category, price) VALUES
                                                ('Laptop Dell XPS 13', 'Electronics', 1299.99),
                                                ('Smartphone Samsung S23', 'Electronics', 899.00),
                                                ('Áo Thun Cotton', 'Apparel', 19.50),
                                                ('Bàn làm việc gỗ sồi', 'Furniture', 249.75),
                                                ('Chuột không dây Logitech MX', 'Electronics', 55.00),
                                                ('Sách "Đắc nhân tâm"', 'Books', 12.00),
                                                ('Bộ nồi inox 5 món', 'Kitchenware', 79.90),
                                                ('Giày thể thao Nike Air', 'Apparel', 99.99),
                                                ('Máy pha cà phê tự động', 'Kitchenware', 350.50),
                                                ('Tai nghe Bluetooth Sony', 'Electronics', 150.00);

INSERT INTO Orders (order_date, total_amount) VALUES
                                                  ('2023-10-01', 1338.99),
                                                  ('2023-10-05', 55.00),
                                                  ('2023-10-10', 899.00),
                                                  ('2023-10-15', 249.75),
                                                  ('2023-10-20', 115.90),
                                                  ('2023-10-25', 350.50),
                                                  ('2023-11-01', 199.98),
                                                  ('2023-11-05', 150.00);

INSERT INTO OrderDetail (order_id, product_id, quantity) VALUES
                                                             (1, 1, 1),    -- Order 101: 1 x Laptop Dell XPS 13
                                                             (1, 3, 2),    -- Order 101: 2 x Áo Thun Cotton
                                                             (2, 5, 1),    -- Order 102: 1 x Chuột không dây
                                                             (3, 2, 1),    -- Order 103: 1 x Smartphone Samsung S23
                                                             (4, 4, 1),    -- Order 104: 1 x Bàn làm việc
                                                             (5, 6, 3),    -- Order 105: 3 x Sách "Đắc nhân tâm"
                                                             (5, 7, 1),    -- Order 105: 1 x Bộ nồi inox
                                                             (6, 9, 1),    -- Order 106: 1 x Máy pha cà phê
                                                             (7, 8, 2),    -- Order 107: 2 x Giày thể thao
                                                             (8, 10, 1);   -- Order 108: 1 x Tai nghe Bluetooth

select p.name, sum(OD.quantity * p.price) as total_sales
from Product p join OrderDetail OD on p.id = OD.product_id
group by p.id;

select p.category, avg(OD.quantity*p.price) total_sales
from Product p join OrderDetail OD on p.id = OD.product_id
group by category;

select p.name,p.category, avg(OD.quantity*p.price) total_sales
from Product p join OrderDetail OD on p.id = OD.product_id
group by p.category, p.name
having avg(OD.quantity*p.price) > 500;

select p.name, sum(p.price*OD.quantity)
from Product p join OrderDetail OD on p.id = OD.product_id
group by p.name
having sum(p.price*OD.quantity) >(select avg(T1.sales)
                                  from (select sum(p2.price*O.quantity) as sales
                                            from Product p2 join OrderDetail O on p2.id = O.product_id
                                            group by p2.id)as T1);

select p.name, p.category, coalesce(sum(OD.quantity),0)
from Product p left join OrderDetail OD on p.id = OD.product_id
group by p.id, p.name, p.category;