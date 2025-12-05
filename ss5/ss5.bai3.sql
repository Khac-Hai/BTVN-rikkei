create schema bai3;
set search_path to bai3;

-- Bảng customers
CREATE TABLE customers (
                           customer_id SERIAL PRIMARY KEY,
                           customer_name VARCHAR(100) NOT NULL,
                           city VARCHAR(50)
);

-- Bảng orders
CREATE TABLE orders (
                        order_id SERIAL PRIMARY KEY,
                        customer_id INT NOT NULL,
                        order_date DATE NOT NULL,
                        total_price NUMERIC(10, 2), -- Sử dụng NUMERIC cho giá tiền
    -- Khóa ngoại liên kết với bảng customers
                        FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Bảng order_items
CREATE TABLE order_items (
                             item_id SERIAL PRIMARY KEY,
                             order_id INT NOT NULL,
                             product_id INT NOT NULL, -- Giả sử product_id là INT (mã sản phẩm)
                             quantity INT NOT NULL,
                             price NUMERIC(10, 2) NOT NULL,
    -- Khóa ngoại liên kết với bảng orders
                             FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- Chèn dữ liệu vào bảng customers
INSERT INTO customers (customer_id, customer_name, city) VALUES
                                                             (1, 'Nguyễn Văn A', 'Hà Nội'),
                                                             (2, 'Trần Thị B', 'Đà Nẵng'),
                                                             (3, 'Lê Văn C', 'Hồ Chí Minh'),
                                                             (4, 'Phạm Thị D', 'Hà Nội');



-- Chèn dữ liệu vào bảng orders
INSERT INTO orders (order_id, customer_id, order_date, total_price) VALUES
                                                                        (101, 1, '2024-12-20', 3000),
                                                                        (102, 2, '2025-01-05', 1500),
                                                                        (103, 1, '2025-02-10', 2500),
                                                                        (104, 3, '2025-02-15', 4000),
                                                                        (105, 4, '2025-03-01', 800);


-- Chèn dữ liệu vào bảng order_items
INSERT INTO order_items (item_id, order_id, product_id, quantity, price) VALUES
                                                                             (1, 101, 1, 2, 1500),
                                                                             (2, 102, 2, 1, 1500),
                                                                             (3, 103, 3, 5, 500),
                                                                             (4, 104, 2, 4, 1000);

--Viết truy vấn hiển thị tổng doanh thu và tổng số đơn hàng của mỗi khách hàng:
--Chỉ hiển thị khách hàng có tổng doanh thu > 2000
--Dùng ALIAS: total_revenue và order_count
select c.customer_id, c.customer_name, sum(o.total_price) as total_revenue, sum(o.order_id) as order_count
from customers c join orders o on c.customer_id = o.customer_id
group by c.customer_id, c.customer_name
having sum(o.total_price) >2000 ;

--Viết truy vấn con (Subquery) để tìm doanh thu trung bình của tất cả khách hàng
--Sau đó hiển thị những khách hàng có doanh thu lớn hơn mức trung bình đó
select c.customer_id, c.customer_name, sum(o.total_price) as total_revenue
from customers c join orders o on c.customer_id = o.customer_id
group by c.customer_id, c.customer_name
having sum(o.total_price) > (select avg(total_price)
                             from orders
    );

--Dùng HAVING + GROUP BY để lọc ra thành phố có tổng doanh thu cao nhất
select c.city, sum(o.total_price) as total_revenue
from customers c join orders o on c.customer_id = o.customer_id
group by c.city
order by total_revenue desc
limit 1;

--(Mở rộng) Hãy dùng INNER JOIN giữa customers, orders, order_items để hiển thị chi tiết:
--Tên khách hàng, tên thành phố, tổng sản phẩm đã mua, tổng chi tiêu
select c.customer_name, c.city, sum(oi.quantity) , sum(o.total_price)
from customers c join orders o on c.customer_id = o.customer_id
join order_items oi on o.order_id = oi.order_id
group by c.customer_name, c.city
order by sum(o.total_price) desc ;