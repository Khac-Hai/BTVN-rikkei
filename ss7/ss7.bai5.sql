create schema bai5;
set search_path to bai5;

CREATE TABLE customers (
                           customer_id SERIAL PRIMARY KEY,
                           full_name VARCHAR(100),
                           email VARCHAR(100) UNIQUE,
                           city VARCHAR(50)
);

CREATE TABLE products (
                          product_id SERIAL PRIMARY KEY,
                          product_name VARCHAR(100),
                          category TEXT[],
                          price NUMERIC(10,2)
);

CREATE TABLE orders (
                        order_id SERIAL PRIMARY KEY,
                        customer_id INT REFERENCES customers(customer_id),
                        product_id INT REFERENCES products(product_id),
                        order_date DATE,
                        quantity INT
);

INSERT INTO customers (full_name, email, city) VALUES
                                                   ('Nguyễn Văn A', 'nguyenvana@example.com', 'Hà Nội'),
                                                   ('Trần Thị B', 'tranthib@example.com', 'Đà Nẵng'),
                                                   ('Lê Văn C', 'levanc@example.com', 'TP. Hồ Chí Minh'),
                                                   ('Phạm Thị D', 'phamthid@example.com', 'Cần Thơ'),
                                                   ('Hoàng Văn E', 'hoangvane@example.com', 'Huế');
INSERT INTO products (product_name, category, price) VALUES
                                                         ('Laptop Dell XPS 13', ARRAY['Electronics', 'Computers'], 24999000.00),
                                                         ('Điện thoại iPhone 15', ARRAY['Electronics', 'Mobile'], 29999000.00),
                                                         ('Tai nghe Sony WH-1000XM5', ARRAY['Electronics', 'Audio'], 7990000.00),
                                                         ('Bàn phím cơ Keychron K2', ARRAY['Accessories', 'Computers'], 1890000.00),
                                                         ('Chuột Logitech MX Master 3', ARRAY['Accessories', 'Computers'], 2290000.00);
INSERT INTO orders (customer_id, product_id, order_date, quantity) VALUES
                                                                       (1, 1, '2025-12-01', 1),
                                                                       (1, 3, '2025-12-02', 2),
                                                                       (2, 2, '2025-12-03', 1),
                                                                       (2, 5, '2025-12-04', 1),
                                                                       (3, 4, '2025-12-05', 1),
                                                                       (3, 1, '2025-12-06', 1),
                                                                       (4, 2, '2025-12-07', 1),
                                                                       (4, 3, '2025-12-08', 1),
                                                                       (5, 5, '2025-12-09', 2),
                                                                       (5, 4, '2025-12-10', 1);

create index idx_pro_email on customers(email);
create index idx_hash_city on customers(city);
create index idx_gin_category on products using gin(category);
CREATE EXTENSION IF NOT EXISTS btree_gist;
create index idx_gist_price on products using gist(price);

EXPLAIN ANALYZE
select *from customers
where email = 'nguyenvana@example.com';
-- Index Scan using customers_email_key on customers  (cost=0.14..8.16 rows=1 width=558) (actual time=0.018..0.019 rows=1.00 loops=1)
--   Index Cond: ((email)::text = 'nguyenvana@example.com'::text)
--   Index Searches: 1
--   Buffers: shared hit=2
-- Planning Time: 0.058 ms
-- Execution Time: 0.029 ms

-- Seq Scan on customers  (cost=0.00..1.06 rows=1 width=558) (actual time=0.009..0.010 rows=1.00 loops=1)
--   Filter: ((email)::text = 'nguyenvana@example.com'::text)
--   Rows Removed by Filter: 4
--   Buffers: shared hit=1
-- Planning:
--   Buffers: shared hit=35 read=2
-- Planning Time: 1.000 ms
-- Execution Time: 0.018 ms

EXPLAIN ANALYZE
select *from products
where category @> array ['Electronics'];
-- Seq Scan on products  (cost=0.00..13.38 rows=1 width=270) (actual time=0.014..0.016 rows=3.00 loops=1)
--   Filter: (category @> '{Electronics}'::text[])
--   Rows Removed by Filter: 2
--   Buffers: shared hit=1
-- Planning Time: 0.074 ms
-- Execution Time: 0.025 ms

-- Seq Scan on products  (cost=0.00..1.06 rows=1 width=270) (actual time=0.011..0.012 rows=3.00 loops=1)
--   Filter: (category @> '{Electronics}'::text[])
--   Rows Removed by Filter: 2
--   Buffers: shared hit=1
-- Planning:
--   Buffers: shared hit=88
-- Planning Time: 1.051 ms
-- Execution Time: 0.020 ms

EXPLAIN ANALYZE
select *from products
where price between 500 and 1000;
-- Seq Scan on products  (cost=0.00..14.05 rows=1 width=270) (actual time=0.012..0.012 rows=0.00 loops=1)
--   Filter: ((price >= '500'::numeric) AND (price <= '1000'::numeric))
--   Rows Removed by Filter: 5
--   Buffers: shared hit=1
-- Planning Time: 0.053 ms
-- Execution Time: 0.021 ms

-- Seq Scan on products  (cost=0.00..1.07 rows=1 width=270) (actual time=0.009..0.009 rows=0.00 loops=1)
--   Filter: ((price >= '500'::numeric) AND (price <= '1000'::numeric))
--   Rows Removed by Filter: 5
--   Buffers: shared hit=1
-- Planning:
--   Buffers: shared hit=6
-- Planning Time: 0.079 ms
-- Execution Time: 0.016 ms

create index idx_order_date on orders(order_date);
cluster orders using idx_order_date;
analyse orders;

create view top3_customer as
    select c.customer_id,c.full_name,
           sum(o.quantity) total_item
        from customers c join orders o on c.customer_id = o.customer_id
        group by c.customer_id,c.full_name
        order by total_item desc
        limit 3;

create view product_revenue as
select p.product_id, p.product_name,
       sum(p.price*o.quantity)
    from products p join orders o on p.product_id = o.product_id
    group by p.product_id,p.product_name
    order by sum(p.price*o.quantity) desc ;

create view v_customer_city as
    select customer_id, full_name, city
        from customers
with check option ;

update v_customer_city set city='Hải Phòng'
where customer_id= 1;