-- Tạo bảng Book(sách)
CREATE TABLE Book (
                      book_id VARCHAR(10) PRIMARY KEY,
                      book_title VARCHAR(150) NOT NULL,
                      book_price DECIMAL(10,2) NOT NULL,
                      book_stock INT NOT NULL
);

-- Tạo bảng Reader(người đọc)
CREATE TABLE Reader (
                        reader_id VARCHAR(10) PRIMARY KEY,
                        reader_name VARCHAR(100) NOT NULL,
                        reader_email VARCHAR(100),
                        reader_phone VARCHAR(20),
                        reader_address VARCHAR(255)
);

-- Tạo bảng Borrow(mượn)
CREATE TABLE Borrow (
                        borrow_id VARCHAR(10) PRIMARY KEY,
                        reader_id VARCHAR(10),
                        borrow_date DATE NOT NULL,
                        total_fee DECIMAL(10,2),
                        FOREIGN KEY (reader_id) REFERENCES Reader(reader_id)
);

-- Tạo bảng BorrowDetails(chi tiết mượn)
CREATE TABLE BorrowDetails (
                               borrowdetail_id SERIAL PRIMARY KEY,
                               borrow_id VARCHAR(10),
                               book_id VARCHAR(10),
                               quantity INT NOT NULL,
                               fee DECIMAL(10,2) NOT NULL,
                               FOREIGN KEY (borrow_id) REFERENCES Borrow(borrow_id),
                               FOREIGN KEY (book_id) REFERENCES Book(book_id)
);
-- Book
INSERT INTO Book VALUES
                     ('B001', 'Database Systems', 300.0, 40),
                     ('B002', 'Java Programming', 450.0, 60),
                     ('B003', 'Python Basics', 350.0, 50),
                     ('B004', 'Web Development', 500.0, 30),
                     ('B005', 'Data Structures', 400.0, 45);

-- Reader
INSERT INTO Reader VALUES
                       ('R001', 'Nguyen Van A', 'a@gmail.com', '0911111111', 'Hanoi'),
                       ('R002', 'Tran Thi B', 'b@gmail.com', '0922222222', 'HCM'),
                       ('R003', 'Le Van C', 'c@gmail.com', '0933333333', 'Da Nang'),
                       ('R004', 'Pham Thi D', 'd@gmail.com', '0944444444', 'Hue'),
                       ('R005', 'Hoang Van E', 'e@gmail.com', '0955555555', 'Hai Phong');

-- Borrow
INSERT INTO Borrow VALUES
                       ('BR001', 'R001', '2025-04-01', 900),
                       ('BR002', 'R002', '2025-04-02', 700),
                       ('BR003', 'R003', '2025-04-03', 1400),
                       ('BR004', 'R004', '2025-04-04', 500),
                       ('BR005', 'R005', '2025-04-05', 300);

-- BorrowDetails
INSERT INTO BorrowDetails (borrow_id, book_id, quantity, fee)
VALUES
    ('BR001', 'B001', 2, 300),
    ('BR001', 'B002', 1, 450),
    ('BR002', 'B003', 2, 350),
    ('BR003', 'B004', 2, 500),
    ('BR004', 'B005', 1, 400);

-- 3. Cập nhật dữ liệu (6 điểm)
-- Viết câu lệnh UPDATE để tăng total_fee thêm 10% cho tất cả các phiếu mượn.
update Borrow set total_fee = total_fee * 1.1;
--4. Xóa dữ liệu (6 điểm)
--Viết câu lệnh DELETE để xóa các phiếu mượn có total_fee < 400.
delete from Borrow
where total_fee < 400;
--PHẦN 2: Truy vấn dữ liệu
--Lấy thông tin độc giả gồm: mã độc giả, họ tên, email, số điện thoại, địa chỉ — sắp xếp theo họ tên tăng dần.
select reader_id,reader_name,reader_email,reader_phone,reader_address
from Reader
order by reader_name asc ;
--Lấy thông tin sách gồm: mã sách, tên sách, giá sách, số lượng tồn kho — sắp xếp theo giá giảm dần.
select book_id,book_title,book_stock,book_price
from Book
order by book_price desc;
--Lấy danh sách các phiếu mượn gồm: mã phiếu mượn, mã độc giả, ngày mượn, tổng phí — sắp xếp theo ngày mượn giảm dần.
select borrow_id,reader_id,borrow_date,total_fee
from Borrow
order by borrow_date desc ;
--Lấy danh sách độc giả và tổng phí đã chi, gồm: mã độc giả, họ tên, tổng phí — sắp xếp theo tổng phí giảm dần.
select r.reader_id, r.reader_name,sum(B.total_fee)
from Reader r join Borrow B on r.reader_id = B.reader_id
group by  r.reader_id, r.reader_name
order by sum(B.total_fee) desc ;
--Lấy thông tin các phiếu mượn từ vị trí thứ 3 đến thứ 5 trong bảng Borrow khi sắp xếp theo mã phiếu mượn.
select borrow_id
from Borrow
order by borrow_id
offset 2
limit 3;
--Lấy danh sách độc giả đã mượn ít nhất 2 cuốn sách khác nhau và có tổng phí > 800, gồm:
-- Mã độc giả
--Họ tên
--Số lượng sách đã mượn
select r.reader_id,r.reader_name,  count(distinct BD.book_id)
from Reader r join Borrow B on r.reader_id = B.reader_id
join BorrowDetails BD on B.borrow_id = BD.borrow_id
group by r.reader_id,r.reader_name
having sum(b.total_fee)>800 and count(distinct BD.book_id) >=2;
--PHẦN 3: Tạo View
--Tạo view hiển thị thông tin các sách đã được mượn với điều kiện ngày mượn < '2025-04-10', gồm:
--Mã sách
--Tên sách
--Mã phiếu mượn
--Mã độc giả
--Ngày mượn
create view v_thongtin as
select b.book_id,b.book_title, bo.borrow_id,bo.reader_id,bo.borrow_date
from Book b join BorrowDetails BD on b.book_id = BD.book_id
join Borrow bo on bo.borrow_id=BD.borrow_id
where bo.borrow_date <'2025-04-10';
--Tạo view hiển thị thông tin độc giả và các phiếu mượn có:
--Tổng phí > 600
--Tổng số lượng sách mượn > 1
--Hiển thị:
--Mã độc giả
--Họ tên độc giả
--Mã phiếu mượn
--Tổng phí
create view view_read_borrow as
select r.reader_id,r.reader_name,B.borrow_id,B.total_fee
from Reader r join Borrow B on r.reader_id = B.reader_id
join BorrowDetails BD on B.borrow_id = BD.borrow_id
group by r.reader_id,r.reader_name,B.borrow_id,B.total_fee
having count(distinct BD.quantity) >1 and B.total_fee > 600;
--PHẦN 4: Tạo Trigger
-- Tạo trigger check_insert_borrow: Khi INSERT vào bảng Borrow.Nếu total_fee < 200 → thông báo lỗi:"Tổng phí mượn không được nhỏ hơn 200".Hủy thao tác INSERT.
create function  check_insert_borrow()
returns trigger as $$
begin
    if new.total_fee < 200 then
    raise exception 'Tổng phí mượn không được nhỏ hơn 200';
    end if;
    return new;
end;
$$ language plpgsql;
create trigger check_insert_borrow
before insert on Borrow
for each row
execute function check_insert_borrow();
--PHẦN 5: Tạo Stored Procedure
--Tạo Stored Procedure add_reader để thêm mới một độc giả với đầy đủ thông tin.
create procedure add_reader(
    p_reader_id VARCHAR,
    p_reader_name VARCHAR,
    p_reader_email VARCHAR,
    p_reader_phone VARCHAR,
    p_reader_address VARCHAR
)
language plpgsql
as $$
begin
    insert into Reader(reader_id, reader_name, reader_email, reader_phone, reader_address)
    values ( p_reader_id,p_reader_name,p_reader_email,p_reader_phone,p_reader_address);
end;
$$;
--Tạo Stored Procedure add_borrow để thêm một phiếu mượn mới.
--Tham số đầu vào: p_reader_id, p_borrow_date, p_total_fee
create procedure add_borrow(
    p_reader_id varchar,
    p_borrow_date date,
    p_total_fee decimal
)
language plpgsql
as $$
begin
    insert into Borrow(reader_id, borrow_date, total_fee)
    values ( p_reader_id,p_borrow_date, p_total_fee);
end;
$$;