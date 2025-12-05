create schema bai1;
set search_path to bai1;
-- Bảng products (product_id, product_name, category)
CREATE TABLE products (
                          product_id INT PRIMARY KEY,
                          product_name VARCHAR(100) NOT NULL,
                          category VARCHAR(50)
);

-- Bảng orders (order_id, product_id, quantity, total_price)
CREATE TABLE orders (
                        order_id INT PRIMARY KEY,
                        product_id INT,
                        quantity INT NOT NULL,
                        total_price DECIMAL(10, 2) NOT NULL,
    -- Thiết lập khóa ngoại (Foreign Key) liên kết với bảng products
                        FOREIGN KEY (product_id) REFERENCES products(product_id)
);
INSERT INTO products (product_id, product_name, category) VALUES
                                                              (1, 'Laptop Dell', 'Electronics'),
                                                              (2, 'iPhone 15', 'Electronics'),
                                                              (3, 'Bàn học gỗ', 'Furniture'),
                                                              (4, 'Ghế xoay', 'Furniture');
INSERT INTO orders (order_id, product_id, quantity, total_price) VALUES
                                                                     (101, 1, 2, 2200),
                                                                     (102, 2, 3, 3300),
                                                                     (103, 3, 5, 2500),
                                                                     (104, 4, 4, 1600),
                                                                     (105, 1, 1, 1100);

--tổng doanh thu (SUM(total_price))
select p.category, sum(o.total_price * o.quantity ) as total_sales
from products p join orders o on p.product_id = o.product_id
group by p.category;

--số lượng sản phẩm bán được (SUM(quantity))
select p.category, sum(o.quantity) as total_quantity
from products p join orders o on p.product_id = o.product_id
group by p.category;

--Chỉ hiển thị những nhóm có tổng doanh thu lớn hơn 2000
select p.category, sum(o.total_price * o.quantity ) as total_sales
from products p join orders o on p.product_id = o.product_id
group by p.category
having sum(o.total_price * o.quantity ) > 2000;

--Sắp xếp kết quả theo tổng doanh thu giảm dần
select p.category, sum(o.total_price * o.quantity ) as total_sales
from products p join orders o on p.product_id = o.product_id
group by p.category
order by total_sales desc ;