CREATE TABLE Products (
                          product_id SERIAL PRIMARY KEY,
                          name VARCHAR(100),
                          price NUMERIC(10,2),
                          category_id INT
);

INSERT INTO Products (name, price, category_id) VALUES
                                                    ('Laptop A', 1500.00, 1),
                                                    ('Laptop B', 1200.00, 1),
                                                    ('Phone X', 800.00, 2),
                                                    ('Phone Y', 950.00, 2),
                                                    ('Tablet Z', 600.00, 3),
                                                    ('Tablet W', 650.00, 3),
                                                    ('Monitor M', 300.00, 4),
                                                    ('Monitor N', 350.00, 4);

create or replace procedure update_product_price(p_category_id INT, p_increase_percent NUMERIC)
language plpgsql
as $$
declare
    r record;
    new_price numeric;
begin
    for r in select product_id,price
                 from Products
                where category_id= p_category_id
        loop
        new_price := r.price+(r.price*p_increase_percent/100);
        update Products set price = new_price
        where product_id=r.product_id
        end loop;
end;
$$