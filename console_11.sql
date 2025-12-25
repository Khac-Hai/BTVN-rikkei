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
-- PHẦN 3: Tạo View
-- Hãy tạo một view để lấy thông tin các sản phẩm và đơn hàng đã được mua, với điều kiện ngày đặt hàng nhỏ hơn ngày 2025-03-10. Cần hiển thị các thông tin sau: Mã sản phẩm, Tên sản phẩm, Mã đơn hàng, Mã khách hàng, Ngày đặt hàng.
create view v_thong_tin as
select p.product_id,
       p.product_name,
       o.order_id,
       o.customer_id,
       o.order_date
from Product p join OrderDetails od on p.product_id = od.product_id
join Orders o on od.order_id = o.order_id
where o.order_date < '2025-03-10';
-- Hãy tạo một view để lấy thông tin khách hàng và các đơn hàng có giá trị lớn hơn 500, với điều kiện số lượng sản phẩm trong đơn hàng lớn hơn 2. Cần hiển thị các thông tin sau: Mã khách hàng, Họ tên khách hàng, Mã đơn hàng, Tổng tiền.
create view v_customer as
select c.customer_id,
       c.customer_name,
       o.order_id,
       o.total_amount
from Customer c join Orders o on c.customer_id = o.customer_id
join OrderDetails od on o.order_id = od.order_id
group by c.customer_id,c.customer_name,o.order_id,o.total_amount
having o.total_amount > 500 and sum(od.quantity) > 2;
-- PHẦN 4: Tạo Trigger
-- Hãy tạo một trigger check_insert_order để kiểm tra dữ liệu mỗi khi chèn vào bảng Order. Kiểm tra nếu tổng tiền trong đơn hàng nhỏ hơn 100, thì thông báo lỗi với nội dung "Tổng tiền đơn hàng không thể nhỏ hơn 100" và hủy thao tác chèn dữ liệu vào bảng.
create function check_insert_order()
returns trigger as $$
begin
    if new.total_amount < 100 then
        raise exception 'Tổng tiền đơn hàng không thể nhỏ hơn 100';
    end if;
    return new;
end;
$$ language plpgsql;
create trigger check_insert_order
before insert on Orders
for each row
execute function check_insert_order();
-- Hãy tạo một trigger có tên là update_product_stock_on_order để tự động giảm số lượng tồn kho sản phẩm khi có đơn hàng được chèn vào bảng OrderDetails.
create function update_product_stock_on_order()
    returns trigger as $$
begin
    update Product set product_stock = product_stock - new.quantity
    where product_id = new.product_id;
    return new;
end;
$$ language plpgsql;
create trigger update_product_stock_on_order
    before insert on Orders
    for each row
execute function update_product_stock_on_order();
-- PHẦN 5: Tạo Store Procedure
-- Viết store procedure có tên add_customer để thêm mới một khách hàng với đầy đủ các thông tin cần thiết.
create procedure add_customer(
    p_customer_id varchar,
    p_customer_name VARCHAR,
    p_customer_email VARCHAR,
    p_customer_phone VARCHAR,
    p_customer_address VARCHAR
)
language plpgsql
as $$
begin
    insert into Customer(customer_id, customer_name, customer_email, customer_phone, customer_address)
    values (p_customer_id,p_customer_name,p_customer_email,p_customer_phone,p_customer_address);
end;
$$;
-- Hãy tạo một Stored Procedure có tên add_order để thực hiện việc thêm một đơn hàng mới cho một khách hàng.
-- Procedure này nhận các tham số đầu vào:
-- p_customer_id: Mã khách hàng (customer_id).
-- p_order_date: Ngày đặt hàng (order_date).
-- p_total_amount: Tổng tiền đơn hàng (total_amount).
create procedure add_order(
    p_order_id varchar,
    p_customer_id varchar,
    p_order_date date,
    p_total_amount decimal
) language plpgsql
as $$
begin
    insert into Orders(order_id, customer_id, order_date, total_amount)
    values (p_order_id,p_customer_id,p_order_date,p_total_amount);
end;
$$
