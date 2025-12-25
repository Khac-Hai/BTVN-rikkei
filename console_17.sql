-- Tạo bảng Book
CREATE TABLE Book (
                      book_id VARCHAR(10) PRIMARY KEY,
                      title VARCHAR(150) NOT NULL,
                      author VARCHAR(100) NOT NULL,
                      price DECIMAL(10,2) NOT NULL,
                      stock INT NOT NULL
);

-- Tạo bảng Member
CREATE TABLE Member (
                        member_id VARCHAR(10) PRIMARY KEY,
                        full_name VARCHAR(100) NOT NULL,
                        email VARCHAR(100),
                        phone VARCHAR(20),
                        address VARCHAR(255)
);

-- Tạo bảng BorrowRecord
CREATE TABLE BorrowRecord (
                              borrow_id VARCHAR(10) PRIMARY KEY,
                              member_id VARCHAR(10),
                              borrow_date DATE NOT NULL,
                              total_fee DECIMAL(10,2),
                              FOREIGN KEY (member_id) REFERENCES Member(member_id)
);

-- Tạo bảng BorrowDetails
CREATE TABLE BorrowDetails (
                               borrowdetail_id SERIAL PRIMARY KEY,
                               borrow_id VARCHAR(10),
                               book_id VARCHAR(10),
                               quantity INT NOT NULL,
                               fee DECIMAL(10,2) NOT NULL,
                               FOREIGN KEY (borrow_id) REFERENCES BorrowRecord(borrow_id),
                               FOREIGN KEY (book_id) REFERENCES Book(book_id)
);
-- Book
INSERT INTO Book VALUES
                     ('BK001', 'SQL Basics', 'John Doe', 200, 50),
                     ('BK002', 'Advanced Java', 'Jane Smith', 350, 40),
                     ('BK003', 'Python Guide', 'Alice Brown', 300, 60),
                     ('BK004', 'Web Development', 'Bob Green', 400, 30),
                     ('BK005', 'Data Structures', 'Carol White', 250, 45);

-- Member
INSERT INTO Member VALUES
                       ('M001', 'Nguyen Van A', 'a@gmail.com', '0911111111', 'Hanoi'),
                       ('M002', 'Tran Thi B', 'b@gmail.com', '0922222222', 'HCM'),
                       ('M003', 'Le Van C', 'c@gmail.com', '0933333333', 'Da Nang'),
                       ('M004', 'Pham Thi D', 'd@gmail.com', '0944444444', 'Hue'),
                       ('M005', 'Hoang Van E', 'e@gmail.com', '0955555555', 'Hai Phong');

-- BorrowRecord
INSERT INTO BorrowRecord VALUES
                             ('BR001', 'M001', '2025-05-01', 600),
                             ('BR002', 'M002', '2025-05-02', 900),
                             ('BR003', 'M003', '2025-05-03', 1200),
                             ('BR004', 'M004', '2025-05-04', 450),
                             ('BR005', 'M005', '2025-05-05', 700);

-- BorrowDetails
INSERT INTO BorrowDetails (borrow_id, book_id, quantity, fee)
VALUES
    ('BR001', 'BK001', 2, 200),
    ('BR001', 'BK002', 1, 350),
    ('BR002', 'BK003', 3, 300),
    ('BR003', 'BK004', 2, 400),
    ('BR004', 'BK005', 1, 250);
-- 3. Cập nhật dữ liệu (6 điểm)
-- Viết câu lệnh UPDATE tăng total_fee thêm 15% cho tất cả các phiếu mượn.
update BorrowRecord set total_fee = total_fee * 1.15;
-- 4. Xóa dữ liệu (6 điểm)
--Viết câu lệnh DELETE xóa tất cả phiếu mượn có total_fee < 500.
delete from BorrowRecord
where total_fee <500;
-- PHẦN 2: Truy vấn dữ liệu
--Lấy thông tin tất cả độc giả (member_id, full_name, email, phone, address) sắp xếp theo tên tăng dần.
select member_id,full_name,email,phone,address
from Member
order by full_name asc ;
--Lấy thông tin sách (book_id, title, author, price, stock) sắp xếp theo giá giảm dần.
select book_id, title, author, price, stock
from Book
order by price desc ;
--Lấy danh sách phiếu mượn (borrow_id, member_id, borrow_date, total_fee) sắp xếp theo ngày mượn giảm dần.
select borrow_id, member_id, borrow_date, total_fee
from BorrowRecord
order by borrow_date desc ;
--Lấy danh sách độc giả + tổng phí đã chi tiêu, sắp xếp theo tổng phí giảm dần.
select m.member_id,m.full_name,sum(BR.total_fee)
from Member m join BorrowRecord BR on m.member_id = BR.member_id
group by m.member_id,m.full_name
order by sum(BR.total_fee) desc ;
--Lấy các phiếu mượn thứ 2 đến thứ 4 khi sắp xếp theo borrow_id.
select borrow_id, member_id, borrow_date, total_fee
from BorrowRecord
order by borrow_id
offset 1
limit 3;
--Lấy danh sách độc giả đã mượn ít nhất 2 sách khác nhau và có tổng phí > 1000, gồm: member_id, full_name, số lượng sách đã mượn.
select br.member_id, M.full_name, count(distinct BD.book_id)
from BorrowRecord br join BorrowDetails BD on br.borrow_id = BD.borrow_id
join Member M on M.member_id = br.member_id
group by br.member_id, M.full_name
having sum(br.total_fee) >1000 and count(distinct BD.book_id) >=2;
-- PHẦN 3: Tạo View
--Tạo view hiển thị thông tin sách đã mượn với borrow_date < '2025-05-10', gồm: book_id, title, borrow_id, member_id, borrow_date.
create view v_borrow_date_book as
select bd.book_id, B.title,br.borrow_id,br.member_id,br.borrow_date
from BorrowRecord br join BorrowDetails BD on br.borrow_id = BD.borrow_id
join Book B on B.book_id = BD.book_id
where br.borrow_date <'2025-05-10';
--Tạo view hiển thị độc giả + phiếu mượn có total_fee > 600 và số lượng sách > 1, gồm: member_id, full_name, borrow_id, total_fee.
create view v_memer_borrow as
select m.member_id, m.full_name, BR.borrow_id, BR.total_fee, count(distinct BD.quantity)
from Member m join BorrowRecord BR on m.member_id = BR.member_id
join BorrowDetails BD on BR.borrow_id = BD.borrow_id
group by m.member_id, m.full_name, BR.borrow_id, BR.total_fee
having BR.total_fee > 600 and sum(BD.quantity)>1;
-- PHẦN 4: Tạo Trigger
--Tạo trigger check_insert_borrow để kiểm tra khi INSERT vào BorrowRecord:Nếu total_fee < 300 → thông báo lỗi "Tổng phí mượn không được nhỏ hơn 300" và hủy INSERT.
create function check_insert_borrow()
returns trigger as $$
begin
    if new.total_fee < 300 then
        raise exception 'Tổng phí mượn không được nhỏ hơn 300';
    end if;
    return new;
end;
$$ language plpgsql;
create trigger check_insert_borrow
before insert on BorrowRecord
for each row
execute function check_insert_borrow();
-- PHẦN 5: Stored Procedure
--Stored Procedure add_member để thêm một độc giả mới với đầy đủ thông tin.
create procedure add_member(
    p_member_id varchar,
    p_full_name varchar,
    p_email varchar,
    p_phone varchar,
    p_address varchar
)
language plpgsql
as $$
begin
    insert into Member(member_id, full_name, email, phone, address) VALUES ( p_member_id, p_full_name,p_email,p_phone,p_address);
end;
$$;
--Stored Procedure add_borrow để thêm một phiếu mượn mới, tham số đầu vào: p_member_id, p_borrow_date, p_total_fee.
create procedure add_borrow(
    p_member_id varchar,
    p_borrow_date date,
    p_total_fee decimal
)
language plpgsql
as $$
begin
    insert into BorrowRecord(member_id, borrow_date, total_fee) VALUES ( p_member_id, p_borrow_date,p_total_fee);
end;
$$;