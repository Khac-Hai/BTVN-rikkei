create table products(
    id serial primary key ,
    name varchar(100),
    price numeric,
    discount_percent int
);

create or replace procedure calculate_discount(p_id INT, OUT p_final_price NUMERIC)
    language plpgsql
AS $$
    declare
        v_price numeric;
        v_discount int;
BEGIN
    select products.price,products.discount_percent
    into v_price,v_discount
    from products
    where id=p_id;
    p_final_price = v_price - (v_price * v_discount / 100);
    if v_discount > 50 then
       v_discount:=50;
    end if;
    update products set price = p_final_price
        where id = p_id;
END;
$$;