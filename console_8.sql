
-- Bảng khách hàng
CREATE TABLE Customers (
                           CustomerID serial PRIMARY KEY ,
                           CustomerName VARCHAR(100),
                           City VARCHAR(50),
                           Country VARCHAR(50)
);

-- Bảng nhân viên
CREATE TABLE Employees (
                           EmployeeID serial PRIMARY KEY ,
                           EmployeeName VARCHAR(100),
                           Department VARCHAR(50)
);

-- Bảng sản phẩm
CREATE TABLE Products (
                          ProductID serial PRIMARY KEY ,
                          ProductName VARCHAR(100),
                          Category VARCHAR(50),
                          Price DECIMAL(10,2)
);

-- Bảng đơn hàng
CREATE TABLE Orders (
                        OrderID serial PRIMARY KEY ,
                        CustomerID INT,
                        EmployeeID INT,
                        OrderDate DATE,
                        FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
                        FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);

-- Bảng chi tiết đơn hàng
CREATE TABLE OrderDetails (
                              OrderDetailID serial PRIMARY KEY ,
                              OrderID INT,
                              ProductID INT,
                              Quantity INT,
                              FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
                              FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Dữ liệu mẫu
INSERT INTO Customers (CustomerName, City, Country) VALUES
                                                        ('Nguyen Van A','Hanoi','Vietnam'),
                                                        ('Tran Thi B','HCM','Vietnam'),
                                                        ('Le Van C','Da Nang','Vietnam'),
                                                        ('Pham Thi D','Hue','Vietnam'),
                                                        ('Hoang Van E','Hai Phong','Vietnam'),
                                                        ('Do Thi F','Can Tho','Vietnam'),
                                                        ('Nguyen Van G','Hanoi','Vietnam'),
                                                        ('Tran Van H','HCM','Vietnam'),
                                                        ('Le Thi I','Da Nang','Vietnam'),
                                                        ('Pham Van J','Hue','Vietnam');

INSERT INTO Employees (EmployeeName, Department) VALUES
                                                     ('Nguyen Van K','Sales'),
                                                     ('Tran Van L','Support'),
                                                     ('Le Thi M','Sales'),
                                                     ('Pham Van N','IT'),
                                                     ('Hoang Thi O','Sales');

INSERT INTO Products (ProductName, Category, Price) VALUES
                                                        ('Laptop','Electronics',1200),
                                                        ('Phone','Electronics',800),
                                                        ('Tablet','Electronics',600),
                                                        ('Desktop','Electronics',1500),
                                                        ('Monitor','Electronics',300),
                                                        ('Desk','Furniture',200),
                                                        ('Chair','Furniture',100),
                                                        ('Bookshelf','Furniture',250),
                                                        ('Printer','Office',400),
                                                        ('Scanner','Office',350);

INSERT INTO Orders (CustomerID, EmployeeID, OrderDate) VALUES
                                                           (1,1,'2025-11-01'),
                                                           (2,1,'2025-11-02'),
                                                           (3,2,'2025-11-03'),
                                                           (4,3,'2025-11-04'),
                                                           (5,4,'2025-11-05'),
                                                           (6,5,'2025-11-06'),
                                                           (7,1,'2025-11-07'),
                                                           (8,2,'2025-11-08'),
                                                           (9,3,'2025-11-09'),
                                                           (10,4,'2025-11-10');

INSERT INTO OrderDetails (OrderID, ProductID, Quantity) VALUES
                                                            (1,1,2),   -- Laptop
                                                            (1,2,1),   -- Phone
                                                            (2,3,3),   -- Tablet
                                                            (2,6,2),   -- Desk
                                                            (3,4,1),   -- Desktop
                                                            (3,7,5),   -- Chair
                                                            (4,5,2),   -- Monitor
                                                            (4,8,1),   -- Bookshelf
                                                            (5,9,4),   -- Printer
                                                            (5,10,2),  -- Scanner
                                                            (6,2,5),   -- Phone
                                                            (6,3,2),   -- Tablet
                                                            (7,1,1),   -- Laptop
                                                            (7,7,10),  -- Chair
                                                            (8,4,2),   -- Desktop
                                                            (8,6,3),   -- Desk
                                                            (9,5,4),   -- Monitor
                                                            (9,9,1),   -- Printer
                                                            (10,10,5), -- Scanner
                                                            (10,8,2);  -- Bookshelf

--1. Liệt kê tất cả đơn hàng cùng tên khách hàng.
select o.*, c.CustomerName
from Customers c join Orders o
                      on c.CustomerID = o.CustomerID;
--2. Liệt kê đơn hàng kèm tên nhân viên xử lý.
select o.*, e.EmployeeName
from employees e join Orders o
                      on e.EmployeeID = o.EmployeeID;
--3. Liệt kê chi tiết đơn hàng (OrderID, ProductName, Quantity).
select od.OrderID, p.ProductName, od.Quantity
from Products p join OrderDetails od
                     on p.ProductID = od.ProductID;
--4. Liệt kê khách hàng và sản phẩm họ đã mua.
select c.*, p.ProductName, od.Quantity, p.price
from Customers c join Orders o on c.CustomerID = o.CustomerID
                 join OrderDetails od on o.OrderID = od.OrderID
                 join Products p on od.ProductID = p.ProductID;
--5. Liệt kê nhân viên và khách hàng mà họ phục vụ.
--6. Liệt kê khách hàng ở Hà Nội và sản phẩm họ mua.
select c.* ,p.ProductName, OD.Quantity, P.price
from Customers c join Orders o on c.CustomerID = o.CustomerID
                 join OrderDetails OD on o.OrderID = OD.OrderID
                 join Products P on OD.ProductID = P.ProductID
where c.City = 'Hanoi';
--7. Liệt kê tất cả đơn hàng cùng tên khách hàng và nhân viên.
--8. Liệt kê sản phẩm và số lượng bán ra trong từng đơn hàng.
--9. Liệt kê khách hàng và số lượng sản phẩm họ đã mua.
select c.*, OD.Quantity
from Customers c join Orders o on c.CustomerID = o.CustomerID
                 join OrderDetails OD on o.OrderID = OD.OrderID;
--10. Liệt kê nhân viên và tổng số đơn hàng họ xử lý.
select e.*, count(o.OrderID)
from employees e join Orders O on e.EmployeeID = O.EmployeeID
group by e.EmployeeID;


--GROUP BY & HAVING
--1. Tính tổng số lượng sản phẩm bán ra theo từng sản phẩm.
SELECT p.ProductName, SUM(od.Quantity)
FROM OrderDetails od left join  Products p ON od.ProductID = p.ProductID
GROUP BY p.ProductID;
--2. Tính tổng doanh thu theo từng sản phẩm.
SELECT p.ProductName, SUM(od.Quantity * p.Price)
FROM OrderDetails od left join Products p ON od.ProductID = p.ProductID
GROUP BY p.ProductID;
--3. Tính tổng doanh thu theo từng khách hàng.
select p.productname, c.CustomerName,od.Quantity, sum(OD.quantity*p.Price)
from Customers c join Orders o on c.CustomerID = o.CustomerID
                 join OrderDetails OD on o.OrderID = OD.OrderID
                 join Products P on OD.ProductID = P.ProductID
group by p.productname, c.CustomerName, od.Quantity;
--4. Tính tổng doanh thu theo từng nhân viên.
select e.EmployeeName,P.ProductName,od.Quantity, sum(OD.Quantity*P.price)
from employees e join Orders O on e.EmployeeID = O.EmployeeID
                 join OrderDetails OD on O.OrderID = OD.OrderID
                 join Products P on OD.ProductID = P.ProductID
group by e.EmployeeName,P.ProductName, OD.Quantity;
--5. Liệt kê sản phẩm có doanh thu > 1000.
SELECT p.ProductName, SUM(od.Quantity * p.Price)
FROM OrderDetails od JOIN Products p ON od.ProductID = p.ProductID
GROUP BY p.ProductName
having SUM(od.Quantity * p.Price) > 1000;
--6. Liệt kê khách hàng có tổng số lượng mua > 5.
SELECT c.CustomerName, SUM(od.Quantity)
FROM Orders o JOIN Customers c ON o.CustomerID = c.CustomerID
              JOIN OrderDetails od ON o.OrderID = od.OrderID
GROUP BY c.CustomerName
HAVING SUM(od.Quantity) > 5;
--7. Liệt kê nhân viên có doanh thu trung bình > 500.
select e.EmployeeName, avg(OD.Quantity*P.price)
from employees e join Orders O on e.EmployeeID = O.EmployeeID
                 join OrderDetails OD on O.OrderID = OD.OrderID
                 join Products P on OD.ProductID = P.ProductID
group by e.EmployeeID
having avg(OD.Quantity*P.price) >500 ;
--8. Liệt kê thành phố có nhiều khách hàng nhất.
SELECT c.City, COUNT(*) AS CustomerCount
FROM Customers c
GROUP BY c.City
ORDER BY CustomerCount DESC
LIMIT 1;
--9. Liệt kê loại sản phẩm có tổng doanh thu cao nhất.
--b1: lay danh thu cao nhat (MAX)
--b2: lay duoc nhung san oham co danh thu = danh thu cao nhat
SELECT p.ProductID, p.ProductName, SUM(od.Quantity * p.Price)
FROM OrderDetails od left join Products p ON od.ProductID = p.ProductID
GROUP BY p.ProductID
order by SUM(od.Quantity * p.Price) desc
LIMIT 1;

SELECT p.*, SUM(od.Quantity * p.Price)
FROM OrderDetails od left join Products p ON od.ProductID = p.ProductID
GROUP BY p.ProductID
having SUM(od.Quantity * p.Price) = (SELECT  SUM(od.Quantity * p.Price)
                                     FROM OrderDetails od left join Products p ON od.ProductID = p.ProductID
                                     GROUP BY p.ProductID
                                     order by SUM(od.Quantity * p.Price) desc
                                     LIMIT 1)
;

--10. Liệt kê khách hàng có nhiều đơn hàng nhất.
--Truy vấn lồng (Subquery)
--1. Liệt kê khách hàng có tổng doanh thu lớn hơn trung bình.
select c.CustomerName, sum(OD.Quantity * p.Price)
from Customers c join Orders O on c.CustomerID = O.CustomerID
join OrderDetails OD on O.OrderID = OD.OrderID
join Products P on P.ProductID = OD.ProductID
group by c.CustomerName
having sum(OD.Quantity * p.Price) >(select avg(total)
                                    from (select sum(D.quantity*p2.Price) as total
                                        from Orders o2 join OrderDetails D on o2.OrderID = D.OrderID
                                        join Products P2 on D.ProductID = P2.ProductID
                                        group by o2.CustomerID) x);
--2. Liệt kê sản phẩm có giá cao hơn giá trung bình.
    select ProductName,Price
        from Products
    where Price > (select avg(Price)
                   from Products);
--3. Liệt kê nhân viên có số đơn hàng nhiều hơn trung bình.
SELECT e.EmployeeName, COUNT(*) AS TotalOrders
FROM Employees e JOIN Orders o ON e.EmployeeID = o.EmployeeID
GROUP BY e.EmployeeName
HAVING COUNT(*) > (SELECT AVG(cnt) FROM (SELECT COUNT(*) AS cnt
                                        FROM Orders
                                        GROUP BY EmployeeID) x);
--4. Liệt kê khách hàng mua nhiều sản phẩm nhất.
SELECT CustomerName, SUM(Quantity) AS TotalQty
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
GROUP BY CustomerName
ORDER BY TotalQty DESC
LIMIT 1;
--5. Liệt kê sản phẩm được mua nhiều nhất.
SELECT ProductName, SUM(Quantity) AS TotalSold
FROM Products p JOIN OrderDetails od ON p.ProductID = od.ProductID
GROUP BY ProductName
ORDER BY TotalSold DESC
LIMIT 1;
--6. Liệt kê khách hàng có đơn hàng gần nhất.
SELECT c.CustomerName, o.OrderDate
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID
ORDER BY o.OrderDate DESC
LIMIT 1;
--7. Liệt kê nhân viên xử lý đơn hàng gần nhất.
SELECT e.EmployeeName, o.OrderDate
FROM Employees e JOIN Orders o ON e.EmployeeID = o.EmployeeID
ORDER BY o.OrderDate DESC
LIMIT 1;
--8. Liệt kê sản phẩm có số lượng bán ra nhiều hơn sản phẩm "Phone".
SELECT ProductName, SUM(Quantity) AS TotalQty
FROM Products p JOIN OrderDetails od ON p.ProductID = od.ProductID
GROUP BY ProductName
HAVING SUM(Quantity) > (SELECT SUM(Quantity) FROM OrderDetails od2 JOIN Products p2 ON od2.ProductID = p2.ProductID
                        WHERE p2.ProductName = 'Phone');
--9. Liệt kê khách hàng có tổng số lượng mua nhiều hơn khách hàng "Tran Thi B".
SELECT c.CustomerName, SUM(od.Quantity) AS TotalQty
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
GROUP BY c.CustomerName
HAVING SUM(od.Quantity) >(SELECT SUM(od2.Quantity)
                        FROM Customers c2 JOIN Orders o2 ON c2.CustomerID = o2.CustomerID
                        JOIN OrderDetails od2 ON o2.OrderID = od2.OrderID
                        WHERE c2.CustomerName = 'Tran Thi B');
--10. Liệt kê sản phẩm có giá cao nhất trong từng loại.
SELECT p.*
FROM Products p
WHERE Price = (SELECT MAX(Price) FROM Products p2 WHERE p2.Category = p.Category);
--JOIN nâng cao
--. Liệt kê khách hàng chưa từng mua hàng.
SELECT *
FROM Customers
WHERE CustomerID NOT IN (SELECT CustomerID FROM Orders);
--2. Liệt kê nhân viên chưa từng xử lý đơn hàng.
SELECT *
FROM Employees
WHERE EmployeeID NOT IN (SELECT EmployeeID FROM Orders);
--3. Liệt kê sản phẩm chưa từng được bán.
SELECT *
FROM Products
WHERE ProductID NOT IN (SELECT ProductID FROM OrderDetails);
--4. Liệt kê khách hàng và tổng số sản phẩm họ mua theo từng loại.
SELECT c.CustomerName, p.Category, SUM(od.Quantity) AS TotalQty
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY c.CustomerName, p.Category;
--5. Liệt kê nhân viên và tổng doanh thu họ mang lại.
SELECT e.EmployeeName, SUM(od.Quantity * p.Price) AS Revenue
FROM Employees e JOIN Orders o ON e.EmployeeID = o.EmployeeID
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY e.EmployeeName;
--6. Liệt kê khách hàng và số lượng đơn hàng theo tháng.
SELECT c.CustomerName, DATE_TRUNC('month', o.OrderDate) AS Month, COUNT(*) AS OrderCount
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerName, Month
ORDER BY Month;
--7. Liệt kê sản phẩm bán chạy nhất theo từng tháng.
SELECT Month, ProductName, TotalQty FROM (SELECT DATE_TRUNC('month', o.OrderDate) AS Month,
                                                    p.ProductName,
                                                    SUM(od.Quantity) AS TotalQty,
                                                    RANK() OVER (PARTITION BY DATE_TRUNC('month', o.OrderDate)
                                                        ORDER BY SUM(od.Quantity) DESC) AS rnk
                                             FROM OrderDetails od JOIN Orders o ON od.OrderID = o.OrderID
                                             JOIN Products p ON od.ProductID = p.ProductID
                                             GROUP BY Month, p.ProductName
                                         ) t
WHERE rnk = 1;
--8. Liệt kê khách hàng mua nhiều loại sản phẩm nhất.
SELECT c.CustomerName, COUNT(DISTINCT p.Category) AS TypeCount
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY c.CustomerName
ORDER BY TypeCount DESC
LIMIT 1;
--9. Liệt kê nhân viên xử lý nhiều khách hàng khác nhau nhất.
SELECT e.EmployeeName, COUNT(DISTINCT o.CustomerID) AS CustomerCount
FROM Employees e JOIN Orders o ON e.EmployeeID = o.EmployeeID
GROUP BY e.EmployeeName
ORDER BY CustomerCount DESC
LIMIT 1;
--10. Liệt kê sản phẩm có tổng số lượng bán ra nhiều nhất theo từng nhân viên.
SELECT EmployeeName, ProductName, TotalQty FROM (SELECT e.EmployeeName, p.ProductName, SUM(od.Quantity) AS TotalQty,
                                                           RANK() OVER (PARTITION BY e.EmployeeName ORDER BY SUM(od.Quantity) DESC) AS rnk
                                                    FROM Employees e JOIN Orders o ON e.EmployeeID = o.EmployeeID
                                                    JOIN OrderDetails od ON o.OrderID = od.OrderID
                                                    JOIN Products p ON od.ProductID = p.ProductID
                                                    GROUP BY e.EmployeeName, p.ProductName
                                                ) t
WHERE rnk = 1;
--GROUP BY + HAVING nâng cao
--1. Liệt kê khách hàng có tổng doanh thu > 2000.
SELECT c.CustomerName, SUM(od.Quantity * p.Price) AS Revenue
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY c.CustomerName
HAVING SUM(od.Quantity * p.Price) > 2000;
--2. Liệt kê sản phẩm có tổng số lượng bán > 10.
SELECT p.ProductName, SUM(od.Quantity) AS TotalQty
FROM Products p JOIN OrderDetails od ON p.ProductID = od.ProductID
GROUP BY p.ProductName
HAVING SUM(od.Quantity) > 10;
--3. Liệt kê nhân viên có tổng doanh thu > 3000.
SELECT e.EmployeeName, SUM(od.Quantity * p.Price) AS Revenue
FROM Employees e JOIN Orders o ON e.EmployeeID = o.EmployeeID
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY e.EmployeeName
HAVING SUM(od.Quantity * p.Price) > 3000;
--4. Liệt kê thành phố có tổng doanh thu > 5000.
SELECT c.City, SUM(od.Quantity * p.Price) AS Revenue
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY c.City
HAVING SUM(od.Quantity * p.Price) > 5000;
--5. Liệt kê loại sản phẩm có tổng số lượng bán > 20.
SELECT p.Category, SUM(od.Quantity) AS TotalQty
FROM Products p JOIN OrderDetails od ON p.ProductID = od.ProductID
GROUP BY p.Category
HAVING SUM(od.Quantity) > 20;
--6. Liệt kê khách hàng có số đơn hàng > 2.
SELECT c.CustomerName, COUNT(o.OrderID) AS TotalOrders
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerName
HAVING COUNT(o.OrderID) > 2;
--7. Liệt kê nhân viên có số khách hàng phục vụ > 2.
SELECT e.EmployeeName, COUNT(DISTINCT o.CustomerID) AS TotalCustomers
FROM Employees e JOIN Orders o ON e.EmployeeID = o.EmployeeID
GROUP BY e.EmployeeName
HAVING COUNT(DISTINCT o.CustomerID) > 2;
--8. Liệt kê sản phẩm có doanh thu trung bình > 700.
SELECT p.ProductName, AVG(od.Quantity * p.Price) AS AvgRevenue
FROM Products p JOIN OrderDetails od ON p.ProductID = od.ProductID
GROUP BY p.ProductName
HAVING AVG(od.Quantity * p.Price) > 700;
--9. Liệt kê khách hàng có tổng số lượng mua > tổng số lượng trung bình.
SELECT c.CustomerName, SUM(od.Quantity) AS TotalQty
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
GROUP BY c.CustomerName
HAVING SUM(od.Quantity) > (SELECT AVG(t.total)
                           FROM (SELECT SUM(od2.Quantity) AS total
                           FROM Orders o2 JOIN OrderDetails od2 ON o2.OrderID = od2.OrderID
                           GROUP BY o2.CustomerID) t);
--10. Liệt kê nhân viên có tổng số đơn hàng > tổng số lượng trung bình.
SELECT e.EmployeeName, COUNT(*) AS TotalOrders
FROM Employees e JOIN Orders o ON e.EmployeeID = o.EmployeeID
GROUP BY e.EmployeeName
HAVING COUNT(*) > (SELECT AVG(x.cnt)
                   FROM (SELECT COUNT(*) AS cnt FROM Orders GROUP BY EmployeeID) x);
--Subquery nâng cao
--2. Liệt kê nhân viên xử lý đơn hàng có tổng doanh thu cao nhất.
SELECT e.EmployeeName, SUM(od.Quantity * p.Price) AS Revenue
FROM Employees e JOIN Orders o ON e.EmployeeID = o.EmployeeID
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY e.EmployeeName
ORDER BY Revenue DESC
LIMIT 1;
--3. Liệt kê khách hàng có đơn hàng nhiều sản phẩm nhất.
SELECT c.CustomerName, SUM(od.Quantity) AS TotalQty
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
GROUP BY c.CustomerName
ORDER BY TotalQty DESC
LIMIT 1;
--4. Liệt kê sản phẩm được mua bởi nhiều khách hàng nhất.
SELECT p.ProductName, COUNT(DISTINCT o.CustomerID) AS CustomerCount
FROM Products p JOIN OrderDetails od ON p.ProductID = od.ProductID
JOIN Orders o ON o.OrderID = od.OrderID
GROUP BY p.ProductName
ORDER BY CustomerCount DESC
LIMIT 1;
--5. Liệt kê khách hàng có tổng số lượng mua nhiều nhất.
SELECT c.CustomerName, SUM(od.Quantity) AS TotalQty
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
GROUP BY c.CustomerName
ORDER BY TotalQty DESC
LIMIT 1;
--6. Liệt kê nhân viên có số lượng khách hàng phục vụ nhiều nhất.
SELECT e.EmployeeName, COUNT(DISTINCT o.CustomerID) AS CustomerCount
FROM Employees e JOIN Orders o ON e.EmployeeID = o.EmployeeID
GROUP BY e.EmployeeName
ORDER BY CustomerCount DESC
LIMIT 1;
--7. Liệt kê sản phẩm có doanh thu cao nhất.
SELECT p.ProductName, SUM(od.Quantity * p.Price) AS Revenue
FROM Products p JOIN OrderDetails od ON p.ProductID = od.ProductID
GROUP BY p.ProductName
ORDER BY Revenue DESC
LIMIT 1;
--8. Liệt kê khách hàng có đơn hàng đầu tiên.
SELECT c.CustomerName, o.OrderDate
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID
ORDER BY o.OrderDate ASC
LIMIT 1;
--9. Liệt kê nhân viên xử lý đơn hàng đầu tiên.
SELECT e.EmployeeName, o.OrderDate
FROM Employees e JOIN Orders o ON e.EmployeeID = o.EmployeeID
ORDER BY o.OrderDate asc
LIMIT 1;
--10. Liệt kê sản phẩm có số lượng bán ra ít nhất.
SELECT p.ProductName, SUM(od.Quantity) AS TotalQty
FROM Products p JOIN OrderDetails od ON p.ProductID = od.ProductID
GROUP BY p.ProductName
ORDER BY TotalQty asc
LIMIT 1;