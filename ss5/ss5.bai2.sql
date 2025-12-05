--Viết truy vấn con (Subquery) để tìm sản phẩm có doanh thu cao nhất trong bảng orders
select p.product_name, sum(o.total_price * o.quantity ) as total_revenue
from products p join orders o on p.product_id = o.product_id
group by p.product_name
order by total_revenue desc
limit 1;

--Viết truy vấn hiển thị tổng doanh thu theo từng nhóm category (dùng JOIN + GROUP BY)
select p.category, sum(o.total_price * o.quantity ) as total_revenue
from products p join orders o on p.product_id = o.product_id
group by p.category;

--Dùng INTERSECT để tìm ra nhóm category có sản phẩm bán chạy nhất (ở câu 1) cũng nằm trong danh sách nhóm có tổng doanh thu lớn hơn 3000
SELECT p.category
FROM Products p JOIN orders o on p.product_id = o.product_id
GROUP BY p.product_name, p.category
HAVING SUM(o.quantity * o.total_price) = (SELECT MAX(revenue)
                                          FROM (SELECT SUM(quantity * total_price) AS revenue
                                                FROM orders
                                                GROUP BY product_id
                                                ) AS ProductRevenues
                                        )
INTERSECT
select p.category
from products p join orders o on p.product_id = o.product_id
group by p.category
having sum(o.total_price * o.quantity ) > 3000;