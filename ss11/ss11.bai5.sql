create table customers(
    customer_id serial primary key ,
    name varchar(100),
    balance numeric(12,2)
);
create table products(
    product_id serial primary key ,
    name varchar(100),
    stock int,
    price numeric(10,2)
);

create table orders(
    order_id serial primary key ,
    customer_id int references customers(customer_id),
    total_amount numeric(12,2),
    created_at timestamp default now(),
    status varchar(20) default 'PENDING'
);

create table order_items(
    item_id serial primary key ,
    order_id int references orders(order_id),
    product_id int references products(product_id),
    quantity int,
    subtotal numeric(10,2)
);
INSERT INTO customers (name, balance)
VALUES
    ('Nguyen Van A', 2000.00),
    ('Tran Thi B', 1500.00),
    ('Le Van C', 800.00);
INSERT INTO products (name, stock, price)
VALUES
    ('Laptop Dell', 5, 1200.00),
    ('Chuột Logitech', 10, 25.00),
    ('Bàn phím cơ Keychron', 3, 90.00),
    ('Màn hình Samsung', 2, 300.00);
INSERT INTO orders (customer_id, total_amount, status)
VALUES
    (1, 1200.00, 'COMPLETED'),
    (2, 180.00, 'COMPLETED'),
    (3, 0.00, 'PENDING');
INSERT INTO order_items (order_id, product_id, quantity, subtotal)
VALUES
    (1, 1, 1, 1200.00),
    (2, 2, 2, 50.00),
    (2, 3, 1, 90.00);

BEGIN;
INSERT INTO orders (customer_id, total_amount, status)
SELECT customer_id, 0, 'PENDING'
FROM customers
WHERE name = 'Tran Thi B'
RETURNING order_id;
SAVEPOINT sp_product1;
DO $$
    DECLARE stock1 INT;
    BEGIN
        SELECT stock INTO stock1 FROM products WHERE product_id = 1;
        IF stock1 >= 1 THEN
            UPDATE products SET stock = stock - 1 WHERE product_id = 1;
            INSERT INTO order_items (order_id, product_id, quantity, subtotal)
            SELECT 1, 1, 1, price FROM products WHERE product_id = 1;
        END IF;
    END $$;
SAVEPOINT sp_product3;
DO $$
    DECLARE stock3 INT;
    BEGIN
        SELECT stock INTO stock3 FROM products WHERE product_id = 3;
        IF stock3 >= 2 THEN
            UPDATE products SET stock = stock - 2 WHERE product_id = 3;
            INSERT INTO order_items (order_id, product_id, quantity, subtotal)
            SELECT 1, 3, 2, price*2 FROM products WHERE product_id = 3;
        END IF;
    END $$;
UPDATE orders
SET total_amount = (
    SELECT COALESCE(SUM(subtotal),0)
    FROM order_items
    WHERE order_id = 1
)
WHERE order_id = 1;
UPDATE orders
SET status = 'COMPLETED'
WHERE order_id = 1
  AND EXISTS (SELECT 1 FROM order_items WHERE order_id = 1);
COMMIT;
