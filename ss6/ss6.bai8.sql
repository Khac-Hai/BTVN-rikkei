create schema bai8;
set search_path to bai8;

create table Customer(
    id serial primary key ,
    name varchar(100)
);

INSERT INTO Customer (name) VALUES
                                ('Khach Hang Kim Cuong'),
                                ('Khach Hang Vang'),
                                ('Khach Hang Bac');

create table Orders(
                       id serial primary key ,
                       customer_id int,
                       order_date date,
                       total_amount numeric(10,2)
);

INSERT INTO Orders (customer_id, order_date, total_amount) VALUES
                                                               (1, '2025-10-01', 1500000.00),
                                                               (2, '2025-10-05', 450000.50),
                                                               (1, '2025-11-10', 3200000.00),
                                                               (3, '2024-12-20', 800000.00),
                                                               (2, '2025-01-15', 2100000.99);
select c.name, sum(O.total_amount)
from Customer c join Orders O on c.id = O.customer_id
group by c.name
order by sum(O.total_amount) desc;

select c.name, sum(O.total_amount)
from Customer c join Orders O on c.id = O.customer_id
group by c.name
having sum(O.total_amount)=(select max(total_spent)
                            from (select sum(total_amount) total_spent
                                  from Orders
                                  group by customer_id)x);

select c.name
from Customer c left join Orders O on c.id = O.customer_id
where O.id isnull ;

select c.name, sum(O.total_amount)
from Customer c join Orders O on c.id = O.customer_id
group by c.name
having sum(O.total_amount)>(select avg(total_spent)
                            from (select sum(total_amount) total_spent
                                  from Orders
                                  group by customer_id)x);
