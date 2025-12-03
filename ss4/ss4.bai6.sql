create schema quanlybook;
set search_path to quanlybook;


CREATE TABLE books (
      id serial PRIMARY KEY,
      title VARCHAR(255) NOT NULL,
      author VARCHAR(100) NOT NULL,
      category VARCHAR(50),
      publish_year INT,
      price INT,
      stock INT
);

INSERT INTO books (title, author, category, publish_year, price, stock) VALUES
     ('Lập trình C cơ bản', 'Nguyễn Văn Nam', 'CNTT', 2018, 95000, 20),
     ('Học SQL qua ví dụ', 'Trần Thị Hạnh', 'CSDL', 2020, 125000, 12),
     ('Lập trình C cơ bản', 'Nguyễn Văn Nam', 'CNTT', 2018, 95000, 20),
     ('Phân tích dữ liệu với Python', 'Lê Quốc Bảo', 'CNTT', 2022, 180000, NULL),
     ('Quản trị cơ sở dữ liệu', 'Nguyễn Thị Minh', 'CSDL', 2021, 150000, 5),
     ('Học máy cho người mới bắt đầu', 'Nguyễn Văn Nam', 'AI', 2023, 220000, 8),
     ('Khoa học dữ liệu cơ bản', 'Nguyễn Văn Nam', 'AI', 2023, 220000, NULL);

delete from books
where id not in(
    select min(id)
    from books
    group by title,author,publish_year
    );

update books set price=price*1.1
where  publish_year >= 2021 and price < 200000;

update books set stock=0
where stock is null;

select *from books
where category in ('CNTT','AI')
and price between 100000 and 250000
order by price desc , title asc ;

select *from books
where title ILIKE '%học%';

select distinct category
from books
where publish_year >2020;

select *from books
limit 2
offset 1;