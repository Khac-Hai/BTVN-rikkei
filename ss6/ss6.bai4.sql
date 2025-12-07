create schema bai4;
set search_path to bai4;

create table Customer(
                         id serial primary key ,
                         name varchar(100),
                         email varchar(100),
                         phone varchar(20),
                         points int
);
INSERT INTO Customer (name, email, phone, points) VALUES
                                                      ('Trần Văn Mạnh', 'manh@example.com', '0901234567', 150),
                                                      ('Lê Thị Hà', 'ha@example.com', '0912345678', 300),
                                                      ('Phạm Duy Nam', 'nam@example.com', '0923456789', 80),
                                                      ('Nguyễn Quốc Việt', NULL, '0934567890', 250), -- Khách hàng không có email
                                                      ('Trần Duy Mạnh', 'duymanh@example.com', '0945678901', 500),
                                                      ('Vũ Thanh Xuân', 'xuan@example.com', '0956789012', 100),
                                                      ('Lê Thị Hà Giang', 'hagiang@example.com', '0967890123', 200);
create table OrderInfo(
    id serial primary key ,
    customer_id int references Customer(id),
    order_date date,
    total numeric(10,2),
    status varchar(20)
);

INSERT INTO OrderInfo (customer_id, order_date, total, status) VALUES
                                                                       (1, '2024-10-05', 1250000.00, 'Completed'),
                                                                       (2, '2024-10-10', 450000.00, 'Processing'),
                                                                       (3, '2024-09-28', 2100000.00, 'Completed'),
                                                                       (4, '2024-10-15', 800000.00, 'Pending'),
                                                                       (5, '2024-11-01', 5500000.00, 'Completed');

select *from OrderInfo
where total > 500000;

select *from OrderInfo
where order_date between '2024-10-01' and '2024-10-31';

select *from OrderInfo
where status <> 'Completed';

select *from OrderInfo
order by order_date desc
limit 2;