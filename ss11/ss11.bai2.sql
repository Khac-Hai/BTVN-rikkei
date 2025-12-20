create table accounts(
    account_id serial primary key ,
    owner_name varchar(100),
    balance numeric(10,2)
);
insert into accounts(owner_name, balance) VALUES ('A',500),('B',300);

begin;
update accounts set balance = balance - 100
where owner_name = 'A';
update accounts set balance = balance + 100
where owner_name = 'B';
commit;
select *from accounts;

begin;
update accounts set balance = balance - 100
where owner_name = 'A';
update accounts set balance = balance + 100
where owner_name = 'C';
rollback ;
select *from accounts;