CREATE TABLE products (
                          product_id SERIAL PRIMARY KEY,
                          product_name VARCHAR(100),
                          stock INT,
                          price NUMERIC(10,2)
);

CREATE TABLE orders (
                        order_id SERIAL PRIMARY KEY,
                        customer_name VARCHAR(100),
                        total_amount NUMERIC(10,2),
                        created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE order_items (
                             order_item_id SERIAL PRIMARY KEY,
                             order_id INT REFERENCES orders(order_id),
                             product_id INT REFERENCES products(product_id),
                             quantity INT,
                             subtotal NUMERIC(10,2)
);

INSERT INTO products (product_name, stock, price)
VALUES ('Nguyen Van C', 5, 100.00), ('Nguyen Van B', 1, 200.00);

begin;
select stock
from products
where product_id = 1;
select stock
from products
where product_id = 2;
update products set stock = stock -2
where product_id = 1;
update products set stock = stock -1
where product_id = 2;
insert into orders (customer_name, total_amount)
values ('Nguyen Van A',0);
select currval(pg_get_serial_sequence('orders','order_id')) as new_order_id;
insert into order_items(order_id, product_id, quantity, subtotal)
VALUES (1, 1, 2, 200.00), (1, 2, 1, 200.00);
update orders set total_amount=400
where order_id = 1;
commit;
select *from products;
select *from orders;
select *from order_items;

update products set stock =0
where product_id = 2;
begin;
select stock
from products
where product_id = 1;
select stock
from products
where product_id = 2;
update products set stock = stock -2
where product_id = 1;
update products set stock = stock -1
where product_id = 2;
rollback ;
select *from products;
select *from orders;
select *from order_items;
