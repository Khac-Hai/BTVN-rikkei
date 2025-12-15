CREATE TABLE Customers (
                           customer_id SERIAL PRIMARY KEY,
                           name VARCHAR(100),
                           total_spent NUMERIC(10,2) DEFAULT 0
);

CREATE TABLE Orders (
                        order_id SERIAL PRIMARY KEY,
                        customer_id INT,
                        total_amount NUMERIC(10,2),
                        FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Dữ liệu mẫu
INSERT INTO Customers (name) VALUES
                                 ('Nguyễn Văn A'),
                                 ('Trần Thị B'),
                                 ('Lê Văn C');
create or replace procedure add_order_and_update_customer(p_customer_id INT, p_amount NUMERIC)
language plpgsql
as $$
begin
    if not exists(
        select 1 from customers
        where customer_id = p_customer_id
    )then
        raise exception 'Khách hàng với ID % không tồn tại.',p_customer_id;
    end if;
    insert into Orders(customer_id, total_amount)
    VALUES (p_customer_id,p_amount);
    update Customers set total_spent= total_spent+p_amount
    where customer_id=p_customer_id;
end;
$$;
call add_order_and_update_customer(1,500);
SELECT * FROM Orders;
SELECT * FROM Customers;