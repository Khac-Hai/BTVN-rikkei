CREATE TABLE Sales (
                       sale_id SERIAL PRIMARY KEY,
                       customer_id INT,
                       product_id INT,
                       sale_date DATE,
                       amount DECIMAL(10, 2)
);

INSERT INTO Sales (customer_id, product_id, sale_date, amount) VALUES
                                                                   (101, 1, '2025-01-10', 250.00),
                                                                   (102, 2, '2025-01-12', 150.50),
                                                                   (103, 3, '2025-01-15', 300.00),
                                                                   (101, 4, '2025-01-20', 175.75),
                                                                   (104, 5, '2025-01-22', 220.00),
                                                                   (105, 6, '2025-01-25', 199.99),
                                                                   (102, 7, '2025-01-28', 180.00),
                                                                   (106, 8, '2025-01-30', 275.25),
                                                                   (101, 9, '2025-02-02', 320.00),
                                                                   (107, 10, '2025-02-05', 400.00);

create view CustomerSales as
    select customer_id, sum(amount) total_amount
        from Sales
        group by customer_id,amount;

SELECT * FROM CustomerSales WHERE total_amount > 1000;
create view v_CustomerSales as
select customer_id, amount
from Sales
with check option ;
update v_CustomerSales set amount=2000
where customer_id= 101;