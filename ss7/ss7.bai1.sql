create database ss7;

create schema bai1;
set search_path to bai1;
create table book(
    book_id serial primary key ,
    title varchar(25),
    author varchar(100),
    genre varchar(50),
    price decimal (10,2),
    description text,
    created_at timestamp default current_timestamp
);
INSERT INTO book (title, author, genre, price, description)
VALUES
    ('The Quantum Code', 'Alice Newton', 'Science', 12.50, 'Explores the basics of quantum physics and its modern impact.'),
    ('Mystic River', 'Dennis Lehane', 'Drama', 15.90, 'A deep emotional story about loss and redemption.'),
    ('Star Voyage', 'Liam Carter', 'Science Fiction', 18.20, 'A journey across galaxies and the unknown universe.'),
    ('Ocean Deep', 'Marina Stone', 'Adventure', 10.99, 'Diving into the most mysterious parts of the ocean.'),
    ('Magic Tales', 'Evelyn Harper', 'Fantasy', 9.99, 'A world full of dragons, fairies, and enchantments.'),
    ('The Lost Tribe', 'John Kent', 'History', 13.40, 'Discovery of a forgotten civilization in the Amazon.'),
    ('War Echoes', 'David Stone', 'History', 16.30, 'Detailed chronicles of post-war reconstruction.'),
    ('Digital Mind', 'Eric Simon', 'Technology', 19.25, 'AI evolution and its future consequences.'),
    ('Moon Dance', 'Chloe Turner', 'Romance', 8.75, 'A love story written under the moonlight.'),
    ('Silent Forest', 'Mark Will', 'Horror', 14.60, 'A cursed woodland that no traveler returns from.'),
    ('The Golden Empire', 'Sophia Kent', 'History', 11.50, 'Rise and fall of an ancient kingdom.'),
    ('Magic Castle', 'Evelyn Harper', 'Fantasy', 10.40, 'Two young mages discover forbidden secrets.'),
    ('Love & Roses', 'Emily Collins', 'Romance', 7.99, 'A summer romance that changes everything.'),
    ('Code Zero', 'Robert Quinn', 'Technology', 22.10, 'Cybersecurity thriller set in 2050.'),
    ('Galactic Storm', 'Liam Carter', 'Science Fiction', 17.99, 'War between planets and alien alliances.'),
    ('Dark Night', 'Mark Will', 'Horror', 13.10, 'A town haunted by unsolved disappearances.'),
    ('Hidden Map', 'Anna West', 'Adventure', 12.20, 'A treasure hunt across ancient ruins.'),
    ('Ancient Myths', 'Oliver Grey', 'Fantasy', 9.20, 'Gods and heroes retold in a poetic style.'),
    ('Heart of Fire', 'Emily Collins', 'Romance', 8.20, 'Two strangers brought together by fate.'),
    ('Cyber Age', 'Eric Simon', 'Technology', 20.50, 'The world dominated by robots and AI.'),
    ('Secret of the Lake', 'John Kent', 'Horror', 12.90, 'A lake rumored to swallow anyone who dares swim.'),
    ('The Warrior King', 'Sophia Kent', 'History', 14.00, 'Memoirs of a powerful ancient ruler.'),
    ('Starfall', 'Liam Carter', 'Science Fiction', 16.60, 'A doomed planet searching for salvation.'),
    ('Mystic Flame', 'Evelyn Harper', 'Fantasy', 11.15, 'A witch who must restore balance to her realm.'),
    ('Love in Paris', 'Chloe Turner', 'Romance', 9.10, 'Two souls meet in the city of love.'),
    ('The Last Battle', 'David Stone', 'History', 15.40, 'The final conflict that shaped the empire.'),
    ('Deep Code', 'Robert Quinn', 'Technology', 18.99, 'A programmer uncovers a deadly cyber conspiracy.'),
    ('Forest of Souls', 'Mark Will', 'Horror', 13.75, 'Spirits seeking revenge on the living.'),
    ('Sky Kingdom', 'Anna West', 'Adventure', 12.60, 'Explorers find a floating land above the clouds.'),
    ('Titan Age', 'Oliver Grey', 'Fantasy', 10.30, 'Battle of gods and giants for world dominion.');

CREATE EXTENSION IF NOT EXISTS pg_trgm;

CREATE INDEX idx_book_author_trgm
    ON book
        USING GIN (author gin_trgm_ops);
CREATE INDEX idx_book_genre ON book(genre);

EXPLAIN ANALYZE
SELECT * FROM book WHERE author ILIKE '%Rowling%';

--truoc index
-- Seq Scan on book  (cost=0.00..1.38 rows=1 width=464) (actual time=0.021..0.021 rows=0.00 loops=1)
--   Filter: ((author)::text ~~* '%Rowling%'::text)
--   Rows Removed by Filter: 30
--   Buffers: shared hit=1
-- Planning:
--   Buffers: shared hit=8
-- Planning Time: 0.610 ms
-- Execution Time: 0.030 ms

-- sau index
-- Seq Scan on book  (cost=0.00..1.38 rows=1 width=464) (actual time=0.022..0.022 rows=0.00 loops=1)
--   Filter: ((author)::text ~~* '%Rowling%'::text)
--   Rows Removed by Filter: 30
--   Buffers: shared hit=1
-- Planning:
--   Buffers: shared hit=18 read=1
-- Planning Time: 0.681 ms
-- Execution Time: 0.032 ms

create index idx_pro_genre on book(genre);
CREATE INDEX idx_book_title
    ON book
        USING GIN (title gin_trgm_ops);

cluster book using idx_book_genre;
drop index idx_book_genre;
EXPLAIN ANALYZE
SELECT * FROM book WHERE genre = 'Fantasy';
--truoc idex
-- Seq Scan on book  (cost=0.00..1.38 rows=1 width=464) (actual time=0.010..0.012 rows=5.00 loops=1)
--   Filter: ((genre)::text = 'Fantasy'::text)
--   Rows Removed by Filter: 25
--   Buffers: shared hit=1
-- Planning:
--   Buffers: shared hit=8
-- Planning Time: 0.658 ms
-- Execution Time: 0.021 ms

--sau index
-- Seq Scan on book  (cost=0.00..1.38 rows=1 width=464) (actual time=0.013..0.014 rows=5.00 loops=1)
--   Filter: ((genre)::text = 'Fantasy'::text)
--   Rows Removed by Filter: 25
--   Buffers: shared hit=1
-- Planning:
--   Buffers: shared hit=51 read=3 dirtied=2
-- Planning Time: 2.068 ms
-- Execution Time: 0.031 ms

--Cau 5
-- B-tree cho cột genre cho hiệu suất tốt nhất khi truy vấn sử dụng điều kiện "=" vì PostgreSQL dùng được Index Scan thay vì Seq Scan.
-- GIN index với tsvector cho truy vấn toàn văn (full-text search) mang lại tốc độ tối ưu, đặc biệt khi truy vấn nhiều từ khóa trong title hoặc description.
-- GIN trigram index mang lại kết quả hiệu quả cho LIKE/ILIKE có wildcard ở đầu (%keyword), vốn B-tree không thể tối ưu.
-- Sau khi CLUSTER theo genre, dữ liệu được sắp xếp vật lý giúp truy vấn lặp lại theo cùng thể loại nhanh hơn đáng kể.
-- Hash index không được khuyến khích vì chỉ hỗ trợ so sánh "=" và không hỗ trợ LIKE/ILIKE, ORDER BY, hoặc full-text, đồng thời hiệu năng không vượt B-tree.
-- Ngoài ra, Hash index tiêu thụ nhiều bộ nhớ hơn và ít được tối ưu trong hệ thống logging/WAL so với B-tree/GIN.
