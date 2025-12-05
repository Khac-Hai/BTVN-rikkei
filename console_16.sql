CREATE DATABASE SalesDB;
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
--. Liệt kê đơn hàng kèm tên nhân viên xử lý.
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