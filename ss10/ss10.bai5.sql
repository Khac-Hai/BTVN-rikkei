CREATE TABLE customers (
                           id SERIAL PRIMARY KEY,
                           name TEXT NOT NULL,
                           email TEXT,
                           phone TEXT,
                           address TEXT
);

CREATE TABLE customers_log (
                               log_id SERIAL PRIMARY KEY,
                               customer_id INTEGER,
                               operation TEXT CHECK (operation IN ('INSERT', 'UPDATE', 'DELETE')),
                               old_data JSONB,
                               new_data JSONB,
                               changed_by TEXT,
                               change_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
create function log_customer_changes()
returns trigger
as $$
declare user_name text := current_user;
begin
    insert into customers_log(customer_id, operation, old_data, new_data, changed_by, change_time)
    values (case tg_op
        when 'insert' then new.id
        else old.id
    end,
    tg_op,to_jsonb(old),to_jsonb(new),user_name,current_timestamp
           );
    return new;
end;
$$ language plpgsql;
create trigger trg_customers_insert
after insert on customers
for each row
execute function log_customer_changes();

create trigger trg_customers_update
after update on customers
for each row
execute function log_customer_changes();

create trigger trg_customers_delete
after delete on customers
for each row
execute function log_customer_changes();

INSERT INTO customers (name, email, phone, address)
VALUES ('Nguyễn Văn A', 'a@gmail.com', '0901234567', 'Hà Nội');
UPDATE customers
SET phone = '0907654321'
WHERE name = 'Nguyễn Văn A';
DELETE FROM customers
WHERE name = 'Nguyễn Văn A';
SELECT * FROM customers_log;
