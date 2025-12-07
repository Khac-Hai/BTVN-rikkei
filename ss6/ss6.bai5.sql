create schema bai5;
set search_path to bai5;

create table Course(
    id serial primary key ,
    title varchar(100),
    instructor varchar(50),
    price numeric(10,2),
    duration int
);

INSERT INTO Course (title, instructor, price, duration) VALUES
                                                            ('SQL Masterclass', 'Alice', 1200000.00, 45),
                                                            ('Python for Data Science', 'Bob', 2500000.00, 60),
                                                            ('Web Development Demo', 'Charlie', 500000.00, 20),
                                                            ('Advanced SQL Techniques', 'Alice', 1800000.00, 50),
                                                            ('Data Analytics Fundamentals', 'David', 950000.00, 30),
                                                            ('SQL and Database Design Demo', 'Eve', 650000.00, 25),
                                                            ('JavaScript Programming', 'Frank', 1500000.00, 40);

update Course set price = price*1.15
where duration > 30;

delete from Course
where title ILIKE '%Demo%';

select *from Course
where title ILIKE '%SQL%';

select *from Course
where price between '500000' and '2000000'
order by price desc
limit 3;