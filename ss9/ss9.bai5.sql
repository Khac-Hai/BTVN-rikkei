CREATE TABLE Sales (
                       sale_id SERIAL PRIMARY KEY,
                       customer_id INT,
                       amount NUMERIC(10,2),
                       sale_date DATE
);

INSERT INTO Sales (customer_id, amount, sale_date) VALUES
                                                       (101, 250.00, '2025-01-10'),
                                                       (102, 150.50, '2025-01-12'),
                                                       (103, 300.00, '2025-01-15'),
                                                       (101, 175.75, '2025-01-20'),
                                                       (104, 220.00, '2025-01-22'),
                                                       (105, 199.99, '2025-01-25'),
                                                       (102, 180.00, '2025-01-28'),
                                                       (106, 275.25, '2025-01-30'),
                                                       (101, 320.00, '2025-02-02'),
                                                       (107, 400.00, '2025-02-05'),
                                                       (103, 500.00, '2025-02-10'),
                                                       (104, 600.00, '2025-02-15'),
                                                       (105, 700.00, '2025-02-20'),
                                                       (106, 800.00, '2025-02-25'),
                                                       (107, 900.00, '2025-03-01');


create or replace procedure calculate_total_sales(IN start_date DATE, IN end_date DATE, OUT total NUMERIC)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT SUM(amount)
    INTO total
    FROM Sales
    WHERE sale_date BETWEEN start_date AND end_date;
END;
$$;
CALL calculate_total_sales('2025-01-01'::DATE, '2025-01-31'::DATE);



