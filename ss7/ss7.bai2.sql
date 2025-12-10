create schema bai2;
set search_path to bai2;

create table customer(
    customer_id serial primary key ,
    full_name varchar(100),
    email varchar(100),
    phone varchar(15)
);

create table orders(
    order_id serial primary key ,
    customer_id int references customer(customer_id),
    total_amount decimal(10,2),
    order_date date
);

create view v_order_summary as
    select c.full_name, o.total_amount, o.order_date
        from orders o join customer c on o.customer_id = c.customer_id;
select *from v_order_summary;
UPDATE orders
SET total_amount = 500000
WHERE order_id = 1;
create view v_monthly_sales as
    select sum(total_amount),
           date_trunc('month', order_date) as month
        from orders
group by date_trunc('month', order_date)
order by month;

DROP VIEW IF EXISTS v_order_summary; --DROP VIEW xoá View thường
DROP MATERIALIZED VIEW IF EXISTS v_monthly_sales;--DROP MATERIALIZED VIEW xoá View có lưu dữ liệu


