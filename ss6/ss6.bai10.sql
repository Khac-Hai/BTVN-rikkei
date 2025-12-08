create schema bai10;
set search_path to bai10;

create table OldCustomers(
    id serial primary key ,
    name varchar(100),
    city varchar(50)
);

create table NewCustomers(
    id serial primary key ,
    name varchar(100),
    city varchar(50)
);

INSERT INTO OldCustomers (name, city) VALUES
                                          ('Nguyễn Văn A', 'Hà Nội'),
                                          ('Trần Thị B', 'Hồ Chí Minh'),
                                          ('Lê Văn C', 'Đà Nẵng'),
                                          ('Phạm Thị D', 'Hải Phòng'),
                                          ('Hoàng Văn E', 'Cần Thơ');

INSERT INTO NewCustomers (name, city) VALUES
                                          ('Phan Văn F', 'Hà Nội'),
                                          ('Đỗ Thị G', 'Hồ Chí Minh'),
                                          ('Võ Văn H', 'Nha Trang');

select id, OldCustomers.name, OldCustomers.city
from OldCustomers
union
select NewCustomers.id, NewCustomers.name, NewCustomers.city
from NewCustomers;

select id, OldCustomers.name, OldCustomers.city
from OldCustomers
intersect
select NewCustomers.id, NewCustomers.name, NewCustomers.city
from NewCustomers;

select id, OldCustomers.name, OldCustomers.city
from OldCustomers
union
select NewCustomers.id, NewCustomers.name, NewCustomers.city
from NewCustomers;

select city, count(name)
    from (select  OldCustomers.name, OldCustomers.city
          from OldCustomers
          union all
          select  NewCustomers.name, NewCustomers.city
          from NewCustomers) as allcutomer
group by city;

select city, count(name)
from (select  OldCustomers.name, OldCustomers.city
      from OldCustomers
      union all
      select  NewCustomers.name, NewCustomers.city
      from NewCustomers) as allcutomer
group by city
having count(name) = (select max(customer_count_alias)
                      from (select count(name) as customer_count_alias
                            from (select name, city from OldCustomers
                                  union all
                                  select name, city from NewCustomers) as allcustomersinner
                            GROUP BY city) AS maxcounts);