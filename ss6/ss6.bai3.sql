create schema bai3;
set search_path to bai3;

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

select distinct Customer.name
from Customer;

select *from Customer
where email isnull ;

select *from Customer
order by points desc
limit 3
offset 1;

select *from Customer
order by name desc ;