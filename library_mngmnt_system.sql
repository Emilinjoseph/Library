create database library;
use library;

create table Branch(
Branch_no int primary key auto_increment,
Branch_address text,
Contact_no varchar(15));

create procedure insert_branch(in branch_address text,in Contact_no varchar(15))
insert into branch(Branch_address,Contact_no) values(Branch_address,Contact_no);

call insert_branch('Thrissur','1234567890');
call insert_branch('Palakkad','1234567891');
call insert_branch('Tvm','1234567892');
call insert_branch('Kottayam','1234567893');
call insert_branch('Idukki','1234567894');

create table Employee(
Emp_Id int primary key auto_increment,
Emp_name varchar(15),
Position varchar(15),
Salary float,
Branch_id int,
foreign key (Branch_id) references branch(Branch_no)
on delete cascade);

create procedure insert_employee(in emp_name varchar(15),in position varchar(15),in salary float,Branch_id int)
insert into employee(Emp_name,position,salary,branch_id)values(emp_name,position,salary,Branch_id);

call insert_employee('Dolly','high',55000,1);
call insert_employee('Rachana','medium',27000,1);
call insert_employee('Achu','low',15000,1);
call insert_employee('Phiona','high',60000,2);
call insert_employee('Rinku','low',16000,3);



create table Customer(
Customer_Id int primary key auto_increment, 
Customer_name varchar(15),
Customer_address text,
Reg_date datetime default now());

create procedure insert_customer(in Customer_name varchar(15),in Customer_address text,in Reg_date datetime )
insert into Customer(Customer_name,Customer_address,Reg_date) values(Customer_name,Customer_address,Reg_date);

call insert_customer('A','AAAA','2021-2-3');
call insert_customer('B','BBBB','2022-1-3');
call insert_customer('C','CCCC','2000-2-4');
call insert_customer('D','DDDD','1999-5-6');
call insert_customer('E','EEEE',now());


create table IssueStatus(
Issue_Id int auto_increment primary key, 
Issued_cust int, 
Issued_book_name text,
Issue_date datetime default now(),
Isbn_book int ,
foreign key (Issued_cust) references Customer(Customer_Id)
on delete cascade,
foreign key (Isbn_book) references Books(ISBN)
on delete cascade);


delimiter $$
create procedure insert_issue_status(in Issued_cust int,in Isbn_book int)
begin
DECLARE  book_name text;
select Book_title into book_name from books where ISBN = Isbn_book  ;
insert into IssueStatus(Issued_cust,Issued_book_name,Issue_date,Isbn_book) values(Issued_cust,book_name,now(),Isbn_book);
end $$
delimiter ;
 
call insert_issue_status(1,1);
call insert_issue_status(2,1);
call insert_issue_status(1,2);
call insert_issue_status(2,3);
call insert_issue_status(3,4);
call insert_issue_status(3,5);
call insert_issue_status(4,6);
call insert_issue_status(4,7);
call insert_issue_status(4,8);

DELIMITER $$
CREATE TRIGGER before_insert_issue_status
before insert ON IssueStatus
FOR EACH ROW
BEGIN
 declare errmsg varchar(25);
 declare status1 varchar(3);
 select status into status1 from books where isbn=new.Isbn_book;
 set errmsg= concat(new.Isbn_book,' is not available');
 if status1='no' then signal sqlstate '45000'
 set message_text= errmsg;
 end if;
END $$
DELIMITER ;
 
DELIMITER $$
CREATE TRIGGER after_insert_issue_status
after INSERT ON IssueStatus
FOR EACH ROW
BEGIN
update books set status='no' where isbn=new.Isbn_book;
END $$
DELIMITER ;


create table ReturnStatus(
Return_Id int primary key auto_increment, 
Return_cust int,
Return_book_name varchar(50),
Return_date datetime,
Isbn_book2 int,
foreign key (Isbn_book2) references Books(ISBN)
on delete cascade);

delimiter $$
create procedure insert_return_status(in Return_cust int,in Isbn_book2 int)
begin
DECLARE  book_name text;
select Book_title into book_name from books where ISBN = Isbn_book2  ;
insert into ReturnStatus(Return_cust,Return_book_name,Return_date,Isbn_book2) values(Return_cust,book_name,now(),Isbn_book2);
end $$
delimiter ;

call insert_return_status(1,2);
call insert_return_status(2,3);
call insert_return_status(4,6);
call insert_return_status(4,7);
call insert_return_status(4,8);


DELIMITER $$
CREATE TRIGGER after_insert_return_status
after INSERT ON ReturnStatus
FOR EACH ROW
BEGIN
 update books set status='yes' where isbn=new.Isbn_book2;
END $$
DELIMITER ; 
 
create table Books(
ISBN int primary key auto_increment, 
Book_title varchar(100) unique not null,
Category varchar(20),
Rental_Price float,
Status varchar(5) not null, 
Author varchar(20),
Publisher varchar(20));

create procedure insert_books(in Book_title varchar(100),in Category varchar(20),in Rental_Price float,in Status varchar(5),in Author varchar(20),in Publisher varchar(20))
insert into Books(Book_title,category,Rental_Price,Status,Author,Publisher)
values(Book_title,category,Rental_Price,Status,Author,Publisher);

call insert_books('Book1','category1',100,'yes','Author1','Publisher1');
call insert_books('Book2','category2',150,'yes','Author2','Publisher2');
call insert_books('Book3','category3',200,'yes','Author3','Publisher1');
call insert_books('Book4','category1',100,'yes','Author3','Publisher2');
call insert_books('Book5','category2',150,'yes','Author2','Publisher1');
call insert_books('Book6','category3',200,'yes','Author1','Publisher2');
call insert_books('Book7','category1',150,'yes','Author3','Publisher1');
insert into Books(Book_title,category,Rental_Price,Status,Author,Publisher)
values
('The Red Signal: An Agatha Christie Short Story','short_story',100,'yes','Agatha Christie','HarperCollins UK'),
("Crossroads of Twilight: Book Ten of 'The Wheel of Time'",'fantasy novel',200,'yes','Robert Jordan','Tor Fantasy'),
('My Little Pony: Friendship is Magic #83','series',300,'yes','Thom Zahler','IDW Publishing'),
('Ask A Footballer','Nonfiction',200,'yes','James Milne','Hachette UK'),
('Ultimate Spider-Man Vol. 11: Carnage','Science fiction',100,'yes','Brian Michael Bendis','Marvel Entertainment');


select * from books;
select * from employee;
select * from customer;
select * from issuestatus;
select * from returnstatus;
select * from branch;

SET foreign_key_checks = 1;

truncate table branch;
truncate table employee;
truncate table customer;
truncate table issuestatus;
truncate table returnstatus;
truncate table books;

drop table branch;
drop table employee;
drop table customer;
drop table issuestatus;
drop table returnstatus;
drop table books;

drop procedure insert_branch;
drop procedure insert_employee;
drop procedure insert_customer;
drop procedure insert_issue_status; 

drop trigger before_insert_issue_status;
drop trigger after_insert_issue_status;
drop trigger after_insert_return_status;

-- Task
-- 1
select Book_title,category,Rental_Price from books;
-- 2
select emp_name,salary from employee order by salary desc;
-- 3
select Isbn_book,Issued_book_name,Issued_cust  from issuestatus order by  isbn_book  ;
-- 4
select category,count(ISBN) from books group by category;
-- 5
select emp_name,position from employee where salary >50000;
-- 6
select Customer_name from customer left join issuestatus 
on customer.Customer_Id=issuestatus.Issued_cust
where Issue_Id is null and reg_date<'2022-01-01' ;
-- 7
select branch_id,count(emp_id) as No_of_Employees from employee group by branch_id;
-- 8
select distinct(Customer_name) from customer inner join issuestatus 
on customer.Customer_Id=issuestatus.Issued_cust
where monthname(issuestatus.Issue_date)='June' and year(issuestatus.Issue_date)='2023';
-- 9
select Book_title from books where ISBN=any(select Isbn_book from issuestatus);
-- 10
select branch_id,count(emp_id) as Count_of_Employees from employee group by branch_id having count(emp_id)>5;

