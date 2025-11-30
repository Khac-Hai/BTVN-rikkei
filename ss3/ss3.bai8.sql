alter table libary.books
add column genre varchar(225);

alter table libary.books
rename column available to is_available;

alter table libary.members
drop column email;

drop table sales.orederdetails;