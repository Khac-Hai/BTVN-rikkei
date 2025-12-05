create schema bai4;
set search_path to bai4;

-- Bảng customers
CREATE TABLE customers (
                           customer_id SERIAL PRIMARY KEY,
                           customer_name VARCHAR(100),
                           city VARCHAR(50)
);

-- Bảng orders
CREATE TABLE orders (
                        order_id SERIAL PRIMARY KEY,
                        customer_id INT REFERENCES customers(customer_id),
                        order_date DATE,
                        total_amount NUMERIC(10, 2)

);

-- Bảng order_items
CREATE TABLE order_items (
                             item_id SERIAL PRIMARY KEY,
                             order_id INT REFERENCES orders(order_id),
                             product_name varchar(100),
                             quantity INT,
                             price NUMERIC(10, 2)
);

-- Chèn dữ liệu vào bảng customers
INSERT INTO customers (customer_id, customer_name, city) VALUES
                                                             (1, 'Nguyễn Văn A', 'Hà Nội'),
                                                             (2, 'Trần Thị B', 'Đà Nẵng'),
                                                             (3, 'Lê Văn C', 'Hồ Chí Minh'),
                                                             (4, 'Phạm Thị D', 'Hà Nội');



-- Chèn dữ liệu vào bảng orders
INSERT INTO orders (order_id, customer_id, order_date, total_amount) VALUES
                                                                        (101, 1, '2024-12-20', 3000),
                                                                        (102, 2, '2025-01-05', 1500),
                                                                        (103, 1, '2025-02-10', 2500),
                                                                        (104, 3, '2025-02-15', 4000),
                                                                        (105, 4, '2025-03-01', 800);


-- Chèn dữ liệu vào bảng order_items
INSERT INTO order_items (item_id, order_id, product_name, quantity, price) VALUES
                                                                             (1, 101, 1, 2, 1500),
                                                                             (2, 102, 2, 1, 1500),
                                                                             (3, 103, 3, 5, 500),
                                                                             (4, 104, 2, 4, 1000);

select c.customer_name, o.order_date, o.total_amount
from customers c join orders o on c.customer_id = o.customer_id;

select sum(orders.total_amount) as "Tổng doanh thu",
       avg(orders.total_amount) as "Trung bình giá trị đơn hàng",
       max(orders.total_amount) as "Đơn hàng lớn nhất",
       min(orders.total_amount) as "Đơn hàng nhỏ nhất",
       count(orders.order_id) as "Số lượng đơn hàng"
from orders;

select c.city, sum(o.total_amount)
from customers c join orders o on c.customer_id = o.customer_id
group by c.city
having sum(o.total_amount) > 10000;

select c.customer_name, o.order_date, oi.quantity, oi.price
from customers c join orders o on c.customer_id = o.customer_id
join order_items oi on o.order_id = oi.order_id;

select c.customer_name, sum(o.total_amount)
from customers c join orders o on c.customer_id = o.customer_id
group by c.customer_name
order by sum(o.total_amount) desc
limit 1;

(select customers.city from customers)
union
(SELECT c.city
from customers c join orders o on c.customer_id = o.customer_id);

(select customers.city from customers)
except
(SELECT c.city
 from customers c join orders o on c.customer_id = o.customer_id);