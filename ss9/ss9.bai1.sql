create table Orders(
    order_id serial primary key ,
    customer_id int,
    order_date date,
    total_amount decimal(10,2)
);
INSERT INTO Orders (order_id, customer_id, order_date, total_amount) VALUES
                                                                         (1, 101, '2025-01-10', 250.00),
                                                                         (2, 102, '2025-01-12', 150.50),
                                                                         (3, 103, '2025-01-15', 300.00),
                                                                         (4, 101, '2025-01-20', 175.75),
                                                                         (5, 104, '2025-01-22', 220.00),
                                                                         (6, 105, '2025-01-25', 199.99),
                                                                         (7, 102, '2025-01-28', 180.00),
                                                                         (8, 106, '2025-01-30', 275.25),
                                                                         (9, 101, '2025-02-02', 320.00),
                                                                         (10, 107, '2025-02-05', 400.00);
EXPLAIN ANALYZE
SELECT * FROM Orders WHERE customer_id = 1;
create index idx_btree_customer on Orders(customer_id);
-- Trước index
-- Seq Scan on orders  (cost=0.00..28.12 rows=7 width=28) (actual time=0.017..0.017 rows=0.00 loops=1)
--   Filter: (customer_id = 1)
--   Rows Removed by Filter: 10
--   Buffers: shared hit=1
-- Planning:
--   Buffers: shared hit=8
-- Planning Time: 0.128 ms
-- Execution Time: 0.028 ms

-- Sau index
-- Seq Scan on orders  (cost=0.00..1.12 rows=1 width=28) (actual time=0.010..0.010 rows=0.00 loops=1)
--   Filter: (customer_id = 1)
--   Rows Removed by Filter: 10
--   Buffers: shared hit=1
-- Planning:
--   Buffers: shared hit=15 read=1
-- Planning Time: 0.848 ms
-- Execution Time: 0.018 ms

