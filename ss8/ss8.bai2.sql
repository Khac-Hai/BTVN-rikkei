create table inventory(
    product_id serial primary key ,
    product_name varchar(100),
    quantity int
);
INSERT INTO inventory (product_name, quantity) VALUES
                                                   ('Bút bi', 100),
                                                   ('Vở học sinh', 50),
                                                   ('Thước kẻ', 30),
                                                   ('Tẩy', 5),
                                                   ('Balo', 0);

create or replace procedure check_stock(p_id int,p_qty int)
    language plpgsql
AS $$
    declare
        current_qty int;
BEGIN
    select inventory.quantity
        into current_qty
        from inventory
        where product_id=p_id;
    if current_qty <p_qty then
        raise exception 'Khong du hang ton kho';
    end if;
    raise exception 'Co hang.so luong hien co: %',current_qty;
END;
$$;
CALL check_stock(1, 5);
CALL check_stock(5, 5);
