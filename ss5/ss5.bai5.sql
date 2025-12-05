create schema bai5;
set search_path to bai5;

create table students(
    student_id serial primary key ,
    full_name varchar(100),
    major varchar(50)
);

create table courses(
    course_id serial primary key ,
    course_name varchar(100),
    credit int
);

create table enrollments(
    student_id int references students(student_id),
    course_id int references courses(course_id),
    score numeric(5,2)
);

INSERT INTO students (student_id, full_name, major) VALUES
                                                        (1, 'Nguyễn Văn A', 'Công nghệ Thông tin'),
                                                        (2, 'Trần Thị B', 'Quản trị Kinh doanh'),
                                                        (3, 'Lê Văn C', 'Kế toán'),
                                                        (4, 'Phạm Thu D', 'Ngôn ngữ Anh'),
                                                        (5, 'Hoàng Đức E', 'Công nghệ Thông tin'),
                                                        (6, 'Đỗ Thị G', 'Quản trị Kinh doanh');

INSERT INTO courses (course_id, course_name, credit) VALUES
                                                         (101, 'Cơ sở Dữ liệu', 3),
                                                         (102, 'Lập trình Java', 4),
                                                         (103, 'Marketing Cơ bản', 3),
                                                         (104, 'Kế toán Tài chính', 4),
                                                         (105, 'Tiếng Anh Học thuật', 2);

INSERT INTO enrollments (student_id, course_id, score) VALUES
                                                           (1, 101, 8.5), -- NV A học CS Dữ liệu, điểm 8.5
                                                           (1, 102, 7.0), -- NV A học Lập trình Java, điểm 7.0
                                                           (2, 103, 9.0), -- TT B học Marketing, điểm 9.0
                                                           (3, 104, 7.5), -- LV C học Kế toán, điểm 7.5
                                                           (4, 105, 8.8), -- PT D học Tiếng Anh, điểm 8.8
                                                           (5, 101, 6.5), -- HĐ E học CS Dữ liệu, điểm 6.5
                                                           (5, 102, 8.0), -- HĐ E học Lập trình Java, điểm 8.0
                                                           (6, 103, 7.2), -- ĐT G học Marketing, điểm 7.2
                                                           (2, 102, 6.0), -- TT B học Lập trình Java, điểm 6.0
                                                           (4, 104, 9.2); -- PT D học Kế toán, điểm 9.2

select s.full_name as "Tên sinh viên",
       c.course_name as "Môn học",
       e.score as "Điểm"
from students s join enrollments e on s.student_id = e.student_id
join courses c on e.course_id = c.course_id
order by s.full_name, c.course_name;

select s.full_name,
       avg(score),
       max(score),
       min(score)
from enrollments e join students s on s.student_id = e.student_id
group by s.full_name
order by  avg(score) desc;

select s.major, avg(e.score)
from students s join enrollments e on s.student_id = e.student_id
group by s.major
having avg(e.score) > 7.5;

select s.full_name,
       c.course_name,
       c.credit,
       e.score
from students s join enrollments e on s.student_id = e.student_id
                join courses c on e.course_id = c.course_id
group by s.full_name, c.course_name, c.credit, e.score

select s.full_name,
       avg(e.score)
from enrollments e join students s on s.student_id = e.student_id
group by s.full_name
having  avg(score) >(select avg(score)
                       from enrollments)
order by avg(e.score) desc ;

select s.student_id,
       s.full_name
from students s join enrollments e on s.student_id = e.student_id
where e.score >= 9.0
union
select s.student_id,
       s.full_name
from students s join enrollments e2 on s.student_id = e2.student_id;

select s.student_id,
       s.full_name
from students s join enrollments e on s.student_id = e.student_id
where e.score >= 9.0
except
select s.student_id,
       s.full_name
from students s join enrollments e2 on s.student_id = e2.student_id;
