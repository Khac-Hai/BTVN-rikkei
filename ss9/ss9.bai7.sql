CREATE TABLE Customers (
                           customer_id SERIAL PRIMARY KEY,
                           name VARCHAR(100),
                           email VARCHAR(100)
);

CREATE TABLE Orders (
                        order_id SERIAL PRIMARY KEY,
                        customer_id INT,
                        amount NUMERIC(10,2),
                        order_date DATE,
                        FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

INSERT INTO Customers (name, email) VALUES
                                        ('Nguyễn Văn A', 'a@example.com'),
                                        ('Trần Thị B', 'b@example.com'),
                                        ('Lê Văn C', 'c@example.com');

INSERT INTO Orders (customer_id, amount, order_date) VALUES
                                                         (1, 500.00, '2025-12-01'),
                                                         (2, 750.00, '2025-12-05');

create or replace procedure add_order(p_customer_id INT, p_amount NUMERIC)
language plpgsql
as $$
begin
    if not exists(
        select 1 from customers
        where customer_id = p_customer_id
    )then
        raise exception 'Khách hàng với ID % không tồn tại.',p_customer_id;
    end if;
    insert into Orders(customer_id, amount, order_date)
    VALUES (p_customer_id,p_amount,current_date);
end;
$$;
CALL add_order(99, 400.00);
CALL add_order(1, 500.00);
SELECT * FROM Orders;