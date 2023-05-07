create database zomato;
use zomato;
create table golduser_signup(userid int, gold_signup_date date);
insert into golduser_signup values (1,'2017-09-22');
insert into golduser_signup (userid , gold_signup_date) values (2,'2017-04-3');
create table users( userid int,created_date date ,prodduct_id int);
select* from users;
drop table users;
create table users(userid int,signup_date date);
insert into users values (1,'2014-09-02');
insert into users values (2,'2015-01-15');
insert into users values (3,'2014-11-04');


create table sales (userid int, created_date date ,product_id int);
insert into sales values (1,'2017-04-19',2);
insert into sales values (3,'19-12-18',1);
set sql_safe_updates= 0;
delete from sales where userid = 3;
select * from sales;
set sql_safe_updates= 1;
insert into sales values (3,'2019-12-18',1);
insert into sales values (2,'2020-07-20',3);
insert into sales values (1,'2019-10-23',2);
insert into sales values (1,'2018-03-19',2);
insert into sales values (3,'2016-12-20',2);
insert into sales values (1,'2016-11-09',1);
insert into sales values (1,'2016-12-20',3);
insert into sales values (21,'2017-09-24',1);
insert into sales values (1,'2017-03-11',2);
insert into sales values (1,'2016-03-11',1);
insert into sales values (3,'2016-11-10',1);
insert into sales values (3,'2017-12-07',2);
insert into sales values (3, '2016-12-15',2);
insert into sales values (2,'2017-11-08',2);
insert into sales values (2,'2018-09-10',3);
set sql_safe_updates = 0;
update sales set userid = 2 where created_date ='2017-09-24';

create table product (product_id int , product_name varchar (50) ,price int);
insert into product (product_id, product_name, price) values (1,'p1',980),
(2,'p2',870),
(3,'p3',330);


select * from sales;
select* from users;
select * from product;
select * from golduser_signup;

---- WHAT IS THE TOTAL AMOUNT EACH CUSTOMER SPENT ON ZOMATO?

select *  FROM SALES inner JOIN PRODUCT ON SALES.PRODUCT_ID = PRODUCT.PRODUCT_ID;
select userid  ,sales.product_id , product_name ,price from sales inner join product on sales.product_id = product.product_id;

select userid ,sum(price) as total_amount from product inner join sales on product.product_id= sales.product_id group by userid; 



--- how many days has each customer visited zomato?

select * from sales;

select userid , count( distinct created_date) as no_of_visit from sales group by userid;


--- what is the first product purchased by each customer ?

select *, rank() over(partition by userid order by created_date )as rnk from sales;
select * from 
(select*,rank() over(partition by userid order by created_date) as rnk from sales )a where rnk = 1;


----- what is the most purchased item on the menu and how many times was it purchased by all customers?

select * from sales;

select userid , count(product_id ) as cnt   from sales where product_id
 = (select  product_id from sales group by product_id order by count(product_id) desc limit 1) group by userid ;




---- which item was the most  popular for each customer ?

select * from(
select * , rank() over(partition by userid order by cnt desc ) rnk from
(select  userid , product_id, count(product_id) as cnt 	from sales group by userid , product_id) a)b where rnk= 1 ;


-- which item was purchase first by customer after they became a member?

select * from sales;
select * from golduser_signup ;
update golduser_signup set userid = 3 where userid = 2;

select * from (select * , rank() over(partition by userid order by created_date ) rnk from (
select sales.userid , created_date ,product_id, gold_signup_date from sales inner join golduser_signup 
on sales.userid = golduser_signup.userid and created_date >= gold_signup_date)a)b where rnk = 1;
 
 
 -- which item was purchased just before the customer became a member?
 
 select *  from (select * , rank() over ( partition by userid order by created_date desc) rnk from  (select sales.userid , created_date, product_id, gold_signup_date from sales 
 inner join golduser_signup on sales.userid = golduser_signup.userid and created_date <= gold_signup_date) a)b where rnk = 1 ;
 
 
 -- what is the total orders and amount spent for each member before they became  a member ?
 
select userid , count(created_date) as total_order , sum(price ) as total_amount_spend from ( select c.* , product.price from 
 (select  sales.userid , created_date , product_id , gold_signup_date   from sales inner join golduser_signup
 on sales.userid = golduser_signup. userid and created_date <= gold_signup_date)c inner join product on c.product_id = product. product_id) e group by userid; 
 
 ------------------------------------
 
 -- if buying each product generates for eg  5 rs =2  zomato points and each product has different purchasing points  
 -- for eg for p1 5 rs = 1 zomato points for p2 10 rs = 5 zomato points  and p3 5 rs =1 zomato point ,
 -- so calculate points collected by each customers and for which product most points have been given till now,
select userid , product_id ,sum(Price)  from( select sales.* , price  from sales inner join product on sales.product_id = product.product_id )c group by
userid, product_id order by userid, product_id;

-------------------------------------------
 
 
 -- rank all the transaction of the customer
 
 select *, rank() over(partition by userid order by created_date ) from sales;
 
 
 ---- rank all the trasactions for each member whenever they are a zomato gold member for every non gold member trasaction mark as NA 
 