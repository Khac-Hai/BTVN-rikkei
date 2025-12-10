create schema bai4;
set search_path to bai4;

CREATE TABLE customer (
                          customer_id SERIAL PRIMARY KEY,
                          full_name VARCHAR(100),
                          region VARCHAR(50)
);

CREATE TABLE orders (
                        order_id SERIAL PRIMARY KEY,
                        customer_id INT REFERENCES customer(customer_id),
                        total_amount DECIMAL(10,2),
                        order_date DATE,
                        status VARCHAR(20)
);

CREATE TABLE product (
                         product_id SERIAL PRIMARY KEY,
                         name VARCHAR(100),
                         price DECIMAL(10,2),
                         category VARCHAR(50)
);

CREATE TABLE order_detail (
                              order_id INT REFERENCES orders(order_id),
                              product_id INT REFERENCES product(product_id),
                              quantity INT,
                              PRIMARY KEY (order_id, product_id)
);
INSERT INTO customer (customer_id, full_name, region) VALUES
                                                          (1, 'Trần Văn An', 'Miền Nam'),
                                                          (2, 'Lê Thị Bình', 'Miền Bắc'),
                                                          (3, 'Nguyễn Hữu Cường', 'Miền Trung');
INSERT INTO product (product_id, name, price, category) VALUES
                                                            (101, 'Laptop Dell XPS 13', 35000000.00, 'Electronics'),
                                                            (102, 'Bàn phím cơ Logitech', 2500000.00, 'Accessories'),
                                                            (103, 'Áo thun Cotton Trắng', 250000.00, 'Apparel'),
                                                            (104, 'Sách: Lập trình SQL cơ bản', 150000.00, 'Books');
INSERT INTO orders (order_id, customer_id, total_amount, order_date, status) VALUES
                                                                                 (1001, 1, 35000000.00, '2025-11-20', 'Completed'),
                                                                                 (1002, 2, 500000.00, '2025-11-25', 'Pending'),
                                                                                 (1003, 3, 2750000.00, '2025-12-01', 'Completed'),
                                                                                 (1004, 1, 150000.00, '2025-12-05', 'Processing');

INSERT INTO order_detail (order_id, product_id, quantity) VALUES
                                                              (1001, 101, 1),
                                                              (1002, 103, 2),
                                                              (1003, 102, 1),
                                                              (1003, 104, 1),
                                                              (1004, 104, 1);

create view v_revenue_by_region as
    select c.region,
           sum(o.total_amount) as total_revenue
        from customer c join orders o on c.customer_id = o.customer_id
        group by c.region;

select region, total_revenue
    from v_revenue_by_region
order by total_revenue desc
limit 3;

create materialized view mv_monthly_sales as
    select date_trunc('month', order_date)as month,
           sum(total_amount) as monthly_revenue
from orders
group by date_trunc('month', order_date);

create view v_order_status as
    select order_id, customer_id,status
        from orders
where status = 'Processing'
with check option ;

update v_order_status set status ='Shipper'
where order_id = 1002;

update v_order_status set status ='Completed'
where order_id = 1004;

create view v_revenue_above_avg as
    select region, total_revenue
        from v_revenue_by_region
where total_revenue >(select avg(total_revenue)
                      from v_revenue_by_region);

select *from v_revenue_by_region;