create schema bai6;
set search_path to bai6;

create table Orders(
    id serial primary key ,
    customer_id int,
    order_date date,
    total_amount numeric(10,2)
);

INSERT INTO Orders (customer_id, order_date, total_amount) VALUES
                                                               (101, '2025-10-01', 1500000.00),
                                                               (102, '2025-10-05', 450000.50),
                                                               (101, '2025-11-10', 3200000.00),
                                                               (103, '2024-12-20', 800000.00),
                                                               (102, '2025-01-15', 2100000.99);

select sum(total_amount) "tổng doanh thu",
       count(id) "số đơn hàng",
       avg(total_amount) "giá trị trung bình"
from Orders;

select extract(year from order_date),
       sum(total_amount)
from Orders
group by order_date
order by order_date;

select extract(year from order_date),
       sum(total_amount)
from Orders
group by order_date
having sum(total_amount) > 500000
order by order_date;

select *
from Orders
order by total_amount desc
limit 5;