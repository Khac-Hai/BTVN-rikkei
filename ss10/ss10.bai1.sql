CREATE TABLE products (
                          id SERIAL PRIMARY KEY,
                          name TEXT NOT NULL,
                          price NUMERIC(10, 2) NOT NULL,
                          last_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO products (name, price) VALUES
                                       ('Laptop', 1500.00),
                                       ('Smartphone', 800.00),
                                       ('Tablet', 600.00);

create function update_last_modified()
returns trigger
as $$
    begin
        new.last_modified := current_timestamp;
        return new;
    end;
$$ language plpgsql;

create trigger trg_update_last_modified
before update on products
for each row
execute function update_last_modified();

update products set price= 850
where name = 'Smartphone';

select *from products
where name ='Smartphone';