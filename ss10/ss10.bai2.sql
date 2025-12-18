CREATE TABLE customers (
                           id SERIAL PRIMARY KEY,
                           name TEXT NOT NULL,
                           credit_limit NUMERIC(10, 2) NOT NULL
);

CREATE TABLE orders (
                        id SERIAL PRIMARY KEY,
                        customer_id INTEGER REFERENCES customers(id),
                        order_amount NUMERIC(10, 2) NOT NULL
);
INSERT INTO customers (name, credit_limit) VALUES
                                               ('Anh Tuấn', 2000.00),
                                               ('Chị Mai', 1500.00);

create function  check_credit_limit()
returns trigger
as $$
declare total_order numeric;
        limit_amount numeric;
    begin
        select coalesce(sum(order_amount),0)
        into total_order
        from orders
        where customer_id = new.customer_id;

        select credit_limit
        into limit_amount
        from customers
        where id = new.customer_id;

        if total_order + new.order_amount > limit_amount then
            raise exception 'Đã vượt hạn mức';
        end if;
        return new;
    end;
$$ language plpgsql;

create trigger trg_check_credit
before insert on orders
for each row
execute function check_credit_limit();

INSERT INTO orders (customer_id, order_amount) VALUES
                                                   (1, 500.00),
                                                   (1, 1000.00);
INSERT INTO orders (customer_id, order_amount) VALUES
    (1, 600.00);

