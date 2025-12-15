CREATE TABLE Products (
                          product_id INT PRIMARY KEY,
                          category_id INT,
                          price DECIMAL(10, 2),
                          stock_quantity INT
);

INSERT INTO Products (product_id, category_id, price, stock_quantity) VALUES
                                                                          (1, 10, 99.99, 50),
                                                                          (2, 20, 149.50, 30),
                                                                          (3, 10, 79.00, 100),
                                                                          (4, 30, 199.99, 20),
                                                                          (5, 20, 129.99, 40),
                                                                          (6, 10, 89.50, 60),
                                                                          (7, 30, 179.00, 25),
                                                                          (8, 20, 139.00, 35),
                                                                          (9, 10, 109.99, 45),
                                                                          (10, 30, 159.99, 15);
-- Sort  (cost=28.22..28.24 rows=7 width=28) (actual time=0.032..0.032 rows=4.00 loops=1)
--   Sort Key: price
--   Sort Method: quicksort  Memory: 25kB
--   Buffers: shared hit=4 dirtied=1
--   ->  Seq Scan on products  (cost=0.00..28.12 rows=7 width=28) (actual time=0.012..0.013 rows=4.00 loops=1)
--         Filter: (category_id = 10)
--         Rows Removed by Filter: 6
--         Buffers: shared hit=1 dirtied=1
-- Planning:
--   Buffers: shared hit=20
-- Planning Time: 0.102 ms
-- Execution Time: 0.043 ms
create index idx_category on Products(category_id);
cluster Products using idx_category;
ANALYZE Products;
create index idx_price on Products(price);
explain analyse  SELECT * FROM Products WHERE category_id = 10 ORDER BY price;
-- Sort  (cost=1.17..1.18 rows=4 width=18) (actual time=0.015..0.016 rows=4.00 loops=1)
--   Sort Key: price
--   Sort Method: quicksort  Memory: 25kB
--   Buffers: shared hit=1
--   ->  Seq Scan on products  (cost=0.00..1.12 rows=4 width=18) (actual time=0.009..0.010 rows=4.00 loops=1)
--         Filter: (category_id = 10)
--         Rows Removed by Filter: 6
--         Buffers: shared hit=1
-- Planning:
--   Buffers: shared hit=28 read=3
-- Planning Time: 0.953 ms
-- Execution Time: 0.025 ms
