create schema bai3;
set search_path to bai3;

CREATE TABLE post (
                      post_id SERIAL PRIMARY KEY,
                      user_id INT NOT NULL,
                      content TEXT,
                      tags TEXT[],
                      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                      is_public BOOLEAN DEFAULT TRUE
);

CREATE TABLE post_like (
                           user_id INT NOT NULL,
                           post_id INT NOT NULL,
                           liked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                           PRIMARY KEY (user_id, post_id)
);
INSERT INTO post (post_id, user_id, content, tags, is_public) VALUES
                                                                  (1, 101, 'Đây là bài đăng đầu tiên của tôi về SQL.', '{"sql", "database"}', TRUE),
                                                                  (2, 101, 'Hướng dẫn tối ưu hóa truy vấn cơ bản.', '{"sql", "performance", "tips"}', TRUE),
                                                                  (3, 102, 'Một vài suy nghĩ về công nghệ mới.', '{"tech", "future"}', TRUE),
                                                                  (4, 102, 'Dự án mới: Ứng dụng quản lý công việc.', '{"project", "app"}', FALSE); -- Bài đăng riêng tư

INSERT INTO post_like (user_id, post_id) VALUES
                                             (102, 1), -- User 102 thích bài đăng 1
                                             (103, 1), -- User 103 thích bài đăng 1
                                             (101, 3), -- User 101 thích bài đăng 3
                                             (103, 3), -- User 103 thích bài đăng 3
                                             (102, 2); -- User 102 thích bài đăng 2
create index idx_post_content_lower on post ((LOWER(content)));
explain analyse select *from post
where is_public = TRUE and content ILIKE '%du lịch%';
-- trước index
-- Seq Scan on post  (cost=0.00..19.25 rows=1 width=81) (actual time=0.343..0.343 rows=0.00 loops=1)
--   Filter: (is_public AND (content ~~* '%du lịch%'::text))
--   Rows Removed by Filter: 4
--   Buffers: shared hit=1
-- Planning:
--   Buffers: shared hit=2
-- Planning Time: 0.354 ms
-- Execution Time: 0.356 ms

-- sau index
-- Seq Scan on post  (cost=0.00..1.05 rows=1 width=81) (actual time=0.020..0.020 rows=0.00 loops=1)
--   Filter: (is_public AND (content ~~* '%du lịch%'::text))
--   Rows Removed by Filter: 4
--   Buffers: shared hit=1
-- Planning:
--   Buffers: shared hit=16 read=1
-- Planning Time: 0.796 ms
-- Execution Time: 0.029 ms

create index idx_post_tags_gin on post using gin(tags);
explain analyse select *from post where tags @> array ['travel'];
-- trước index
-- Seq Scan on post  (cost=0.00..1.05 rows=1 width=81) (actual time=0.264..0.264 rows=0.00 loops=1)
--   Filter: (tags @> '{travel}'::text[])
--   Rows Removed by Filter: 4
--   Buffers: shared hit=7
-- Planning:
--   Buffers: shared hit=16
-- Planning Time: 0.365 ms
-- Execution Time: 0.272 ms

--sau index
-- Seq Scan on post  (cost=0.00..1.05 rows=1 width=81) (actual time=0.011..0.011 rows=0.00 loops=1)
--   Filter: (tags @> '{travel}'::text[])
--   Rows Removed by Filter: 4
--   Buffers: shared hit=1
-- Planning:
--   Buffers: shared hit=23
-- Planning Time: 0.756 ms
-- Execution Time: 0.019 ms

create index idx_post_recent_public on post(created_at desc) where is_public = true;
explain analyse select *from post
where is_public = true and created_at >= now()- interval '7 days';
-- Seq Scan on post  (cost=0.00..1.07 rows=1 width=81) (actual time=0.012..0.013 rows=3.00 loops=1)
--   Filter: (is_public AND (created_at >= (now() - '7 days'::interval)))
--   Rows Removed by Filter: 1
--   Buffers: shared hit=1
-- Planning Time: 0.079 ms
-- Execution Time: 0.021 ms

select post_id, content, created_at
from post
where user_id in (101, 103, 105)
order by created_at desc
limit 50;

explain analyse select post_id, content, created_at
                from post
                where user_id in (101, 103, 105)
                order by created_at desc
                limit 50;
-- Limit  (cost=1.08..1.09 rows=3 width=44) (actual time=0.018..0.019 rows=2.00 loops=1)
--   Buffers: shared hit=1
--   ->  Sort  (cost=1.08..1.09 rows=3 width=44) (actual time=0.018..0.018 rows=2.00 loops=1)
--         Sort Key: created_at DESC
--         Sort Method: quicksort  Memory: 25kB
--         Buffers: shared hit=1
--         ->  Seq Scan on post  (cost=0.00..1.05 rows=3 width=44) (actual time=0.012..0.013 rows=2.00 loops=1)
-- "              Filter: (user_id = ANY ('{101,103,105}'::integer[]))"
--               Rows Removed by Filter: 2
--               Buffers: shared hit=1
-- Planning Time: 0.079 ms
-- Execution Time: 0.030 ms

