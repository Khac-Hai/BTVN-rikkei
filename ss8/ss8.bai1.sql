create table order_detail(
    id serial primary key ,
    order_id int,
    product_name varchar(100),
    quantity int,
    unit_price numeric
);
-- Chèn dữ liệu mẫu cho order_id = 101
INSERT INTO order_detail (order_id, product_name, quantity, unit_price) VALUES
                                                                            (101, 'Product A', 2, 10.50),  -- Giá trị: 2 * 10.50 = 21.00
                                                                            (101, 'Product B', 5, 5.00),   -- Giá trị: 5 * 5.00 = 25.00
                                                                            (102, 'Product C', 1, 100.00); -- Đơn hàng khác

create or replace procedure Calculate_order_total(
    order_id_input INT,
    Total NUMERIC
)
language plpgsql
AS $$
BEGIN
    select sum(order_detail.quantity*unit_price)
    into Total
    from order_detail
    where order_id=order_id_input;
    if Total is null then
        Total:=0;
    end if;
END;
$$;
call Calculate_order_total(1,null);
