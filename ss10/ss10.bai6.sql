CREATE TABLE products (
                          id SERIAL PRIMARY KEY,
                          name TEXT NOT NULL,
                          stock INTEGER NOT NULL CHECK (stock >= 0)
);
CREATE TABLE orders (
                        id SERIAL PRIMARY KEY,
                        product_id INTEGER REFERENCES products(id),
                        quantity INTEGER NOT NULL CHECK (quantity > 0),
                        order_status TEXT CHECK (order_status IN ('active', 'cancelled'))
);
CREATE OR REPLACE FUNCTION manage_inventory()
    RETURNS TRIGGER AS $$
DECLARE
    stock_now INTEGER;
BEGIN
    IF TG_OP = 'INSERT' THEN
        SELECT stock INTO stock_now FROM products WHERE id = NEW.product_id;
        IF stock_now < NEW.quantity THEN
            RAISE EXCEPTION 'Không đủ tồn kho để tạo đơn hàng!';
        END IF;
        UPDATE products SET stock = stock - NEW.quantity WHERE id = NEW.product_id;

    ELSIF TG_OP = 'UPDATE' THEN
        SELECT stock INTO stock_now FROM products WHERE id = NEW.product_id;
        IF stock_now + OLD.quantity < NEW.quantity THEN
            RAISE EXCEPTION 'Không đủ tồn kho để cập nhật đơn hàng!';
        END IF;
        UPDATE products
        SET stock = stock + OLD.quantity - NEW.quantity
        WHERE id = NEW.product_id;

    ELSIF TG_OP = 'DELETE' THEN
        UPDATE products SET stock = stock + OLD.quantity WHERE id = OLD.product_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_inventory_insert
    BEFORE INSERT ON orders
    FOR EACH ROW
EXECUTE FUNCTION manage_inventory();

CREATE TRIGGER trg_inventory_update
    BEFORE UPDATE ON orders
    FOR EACH ROW
EXECUTE FUNCTION manage_inventory();

CREATE TRIGGER trg_inventory_delete
    BEFORE DELETE ON orders
    FOR EACH ROW
EXECUTE FUNCTION manage_inventory();

INSERT INTO products (name, stock)
VALUES
('Áo thun', 100),
('Giày thể thao', 50);
INSERT INTO orders (product_id, quantity, order_status)
VALUES (1, 20, 'active');
UPDATE orders SET quantity = 30 WHERE id = 1;
DELETE FROM orders WHERE id = 1;
INSERT INTO orders (product_id, quantity, order_status)
VALUES (2, 100, 'active');
