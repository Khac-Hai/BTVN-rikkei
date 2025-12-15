CREATE TABLE Users (
                       user_id INT PRIMARY KEY,
                       email VARCHAR(100),
                       username VARCHAR(50)
);

INSERT INTO Users (user_id, email, username) VALUES
                                                 (1, 'alice@example.com', 'alice123'),
                                                 (2, 'bob@example.com', 'bobby'),
                                                 (3, 'carol@example.com', 'carol_c'),
                                                 (4, 'dave@example.com', 'dave_d'),
                                                 (5, 'eve@example.com', 'eve_e'),
                                                 (6, 'frank@example.com', 'frankie'),
                                                 (7, 'grace@example.com', 'grace_g'),
                                                 (8, 'heidi@example.com', 'heidi_h'),
                                                 (9, 'ivan@example.com', 'ivan_i'),
                                                 (10, 'judy@example.com', 'judy_j');

explain analyse
    SELECT * FROM Users WHERE email = 'example@example.com';
-- Seq Scan on users  (cost=0.00..12.75 rows=1 width=340) (actual time=0.024..0.024 rows=0.00 loops=1)
--   Filter: ((email)::text = 'example@example.com'::text)
--   Rows Removed by Filter: 10
--   Buffers: shared hit=1
-- Planning Time: 0.052 ms
-- Execution Time: 0.033 ms
create index idx_hash_email on Users(email);
explain analyse
SELECT * FROM Users WHERE email = 'example@example.com';
-- Seq Scan on users  (cost=0.00..1.12 rows=1 width=340) (actual time=0.012..0.012 rows=0.00 loops=1)
--   Filter: ((email)::text = 'example@example.com'::text)
--   Rows Removed by Filter: 10
--   Buffers: shared hit=1
-- Planning:
--   Buffers: shared hit=16 read=1
-- Planning Time: 0.807 ms
-- Execution Time: 0.024 ms
