CREATE TABLE products (
                          id SERIAL PRIMARY KEY,
                          name TEXT NOT NULL,
                          stock INTEGER NOT NULL CHECK (stock >= 0)
);
CREATE TABLE orders (
                        id SERIAL PRIMARY KEY,
                        product_id INTEGER REFERENCES products(id),
                        quantity INTEGER NOT NULL CHECK (quantity > 0)
);

create function update_product_stock()
returns trigger
as $$
begin
    if tg_op ='insert' then
        update products set stock = stock - new.quantity
        where id = new.product_id;
    elsif tg_op ='update' then
        update products set stock = stock + old.quantity - new.quantity
        where id= old.product_id;
    elsif tg_op ='delete' then
        update products set stock = stock + old.quantity
        where id= old.product_id;
    end if;
    return new;
end;
$$ language plpgsql;

create trigger trg_update_stock_insert
after insert on orders
for each row
execute function update_product_stock();

create trigger trg_update_stock_update
after update on orders
for each row
execute function update_product_stock();

create trigger trg_update_stock_delete
after delete on orders
for each row
execute function update_product_stock();