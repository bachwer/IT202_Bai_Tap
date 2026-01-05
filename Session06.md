


#Ex1
```sql
create table customer(
    customerId int auto_increment primary key,
    fullName varchar(255) not null ,
    city varchar(255) not null
);

create table orderProduct(
    orderId int auto_increment primary key ,
    customerId int,
    orderDate date not null ,
    status Enum('Pending','completed','canceled'),
    foreign key (customerId) references customer(customerId)
);

insert into customer(fullName, city)
values
    ('Nguyen Van A', 'TP.HN'),
    ('Nguyen Van B', 'TP.HCM'),
    ('Nguyen van C', 'TP.DN'),
    ('Nguyen Van D', 'TP.HN'),
    ('Nguyen Van E', 'TP.CT');

insert into orderProduct(customerId, orderDate, status)
values
    (1, '2025-01-10', 'completed'),
    (2, '2025-12-30', 'pending'),
    (3, '2026-1-1', 'completed'),
    (4, '2025-12-2', 'canceled'),
    (4, '2025-12-3', 'completed');





SELECT
    o.orderId,
    c.FullName,
    o.orderDate,
    o.status
FROM orderProduct o
JOIN customer c
    ON o.customerId = c.customerId;


select
    c.customerId,
    c.fullName,
    Count(o.orderId) as totalOrder
from customer c
left join orderProduct o
    on c.customerId = o.customerId
group by c.customerId, c.fullName;


select
    c.customerId,
    c.fullName,
    Count(o.orderId) as totalOrder
from customer c
join orderProduct o
    on c.customerId = o.customerId
group by c.customerId, c.fullName
having count(o.orderId) >= 1;


select * from customer;

select *
from orderProduct;
```
#Ex2
```sql


alter table orderProduct
add totalAmount decimal(10,2);


UPDATE orderProduct
SET totalAmount = 1200000
WHERE orderId = 1;

UPDATE orderProduct
SET totalAmount = 800000
WHERE orderId = 2;

UPDATE orderProduct
SET totalAmount = 1500000
WHERE orderId = 3;

UPDATE orderProduct
SET totalAmount = 600000
WHERE orderId = 4;

UPDATE orderProduct
SET totalAmount = 2000000
WHERE orderId = 5;


select
    c.customerId,
    c.fullName,
    sum(o.totalAmount) as totalSpent
from customer c
join orderProduct o
on o.customerId = c.customerId
group by c.customerId, c.fullName;


select
    c.customerId,
    c.fullName,
    Max(o.totalAmount) as MaxOrderValue
from customer c
join orderProduct o
on c.customerId = o.customerId
group by c.customerId, c.fullName;


select
    c.customerId,
    c.fullName,
    sum(o.totalAmount) as TotalSpent
from customer c
join orderProduct o
on c.customerId = o.customerId
group by c.customerId, o.customerId
ORDER BY TotalSpent DESC;

```
#Ex3
```sql

```
#Ex4
#Ex5
#Ex6
