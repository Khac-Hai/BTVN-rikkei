create schema bailam;
set search_path to bailam;
CREATE TABLE Product (
                         product_id VARCHAR(10) PRIMARY KEY,
                         product_name VARCHAR(100) NOT NULL,
                         product_price DECIMAL(10, 2) NOT NULL,
                         product_stock INT NOT NULL
);

-- Tạo bảng Customer
CREATE TABLE Customer (
                          customer_id VARCHAR(10) PRIMARY KEY,
                          customer_name VARCHAR(100) NOT NULL,
                          customer_email VARCHAR(100) NOT NULL,
                          customer_phone VARCHAR(20),
                          customer_address VARCHAR(255)
);

-- Tạo bảng Order
CREATE TABLE Orders (
                       order_id VARCHAR(10) PRIMARY KEY,
                       customer_id VARCHAR(10),
                       order_date DATE NOT NULL,
                       total_amount DECIMAL(10, 2),
                       FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

-- Tạo bảng OrderDetails
CREATE TABLE OrderDetails (
                              orderdetail_id SERIAL PRIMARY KEY,
                              order_id VARCHAR(10),
                              product_id VARCHAR(10),
                              quantity INT NOT NULL,
                              price DECIMAL(10, 2) NOT NULL,
                              FOREIGN KEY (order_id) REFERENCES Orders(order_id),
                              FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

-- Chèn dữ liệu vào bảng Product
INSERT INTO Product (product_id, product_name, product_price, product_stock)
VALUES
    ('P001', 'Laptop', 1200.0, 50),
    ('P002', 'Smartphone', 800.0, 100),
    ('P003', 'Tablet', 600.0, 30),
    ('P004', 'Headphones', 150.0, 200),
    ('P005', 'Charger', 50.0, 500);

-- Chèn dữ liệu vào bảng Customer
INSERT INTO Customer (customer_id, customer_name, customer_email, customer_phone, customer_address)
VALUES
    ('C001', 'Nguyen Thi A', 'a.nguyen@example.com', '0912345678', 'Hanoi, Vietnam'),
    ('C002', 'Tran Thi B', 'b.tran@example.com', '0923456789', 'Ho Chi Minh, Vietnam'),
    ('C003', 'Le Minh C', 'c.le@example.com', '0934567890', 'Danang, Vietnam'),
    ('C004', 'Pham Minh D', 'd.pham@example.com', '0945678901', 'Hue, Vietnam'),
    ('C005', 'Vu Minh E', 'e.vu@example.com', '0956789012', 'Hai Phong, Vietnam');

-- Chèn dữ liệu vào bảng Order
INSERT INTO Orders (order_id, customer_id, order_date, total_amount)
VALUES
    ('O001', 'C001', '2025-03-01', 2400.0),
    ('O002', 'C002', '2025-03-02', 1800.0),
    ('O003', 'C003', '2025-03-03', 1200.0),
    ('O004', 'C004', '2025-03-04', 480.0),
    ('O005', 'C005', '2025-03-05', 800.0);

-- Chèn dữ liệu vào bảng OrderDetails
INSERT INTO OrderDetails (order_id, product_id, quantity, price)
VALUES
    ('O001', 'P001', 2, 1200.0),
    ('O001', 'P002', 1, 800.0),
    ('O002', 'P003', 3, 600.0),
    ('O003', 'P004', 2, 150.0),
    ('O004', 'P005', 5, 50.0);

update Orders set total_amount = total_amount*0.9;
delete from Orders
where total_amount <200;
select customer_id,customer_name,customer_email,customer_phone,customer_address
from Customer
group by customer_id
order by customer_name asc ;
select product_id,product_name,product_price,product_stock
from Product
group by product_id
order by product_price desc ;
select order_id,customer_id,order_date,total_amount
from Orders
order by order_date desc ;
-- (3 điểm)
-- Lấy danh sách các khách hàng và tổng tiền đã chi tiêu khi mua sản phẩm, gồm mã khách hàng, họ tên khách hàng và tổng tiền chi tiêu, sắp xếp theo tổng tiền giảm dần.
select c.customer_id,c.customer_name, sum(O.total_amount)
from Customer c join Orders O on c.customer_id = O.customer_id
group by c.customer_id,c.customer_name
order by sum(O.total_amount) desc ;

-- (3 điểm)
-- Lấy thông tin các đơn hàng từ vị trí thứ 2 đến thứ 4 trong bảng Order được sắp xếp theo mã đơn hàng.
select *from Orders
order by order_id
offset 1
limit 3;
-- (5 điểm)
-- Lấy danh sách khách hàng đã mua ít nhất 2 sản phẩm khác nhau và có tổng số tiền chi tiêu trên 1000, gồm mã khách hàng, họ tên khách hàng và số lượng sản phẩm đã mua.
select c.customer_id, c.customer_name, count(distinct od.product_id)
from Customer c join Orders O on c.customer_id = O.customer_id
join OrderDetails OD on O.order_id = OD.order_id
group by c.customer_id,c.customer_name
having count(distinct od.product_id) >2 and sum(OD.quantity* OD.price) > 1000;


