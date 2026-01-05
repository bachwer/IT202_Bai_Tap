


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


select
    o.orderDate,
    count(o.totalAmount) as TotalOrder
from orderProduct o
group by orderDate;

select
    o.orderDate,
    sum(o.totalAmount) as totalSpent
from orderProduct o
group by orderDate;

select
    o.orderDate,
    sum(o.totalAmount) as TotalSpent
from orderProduct o
group by orderDate
having TotalSpent > 1000000
ORDER BY o.orderDate;

```
#Ex4
```sql



create table products (
    productId int auto_increment primary key,
    productName varchar(255) not null,
    price decimal (10,2) not null
);

create table orderItem(
    orderItemId int auto_increment primary key,
    productId int,
    quantity int check(quantity > 0),
    foreign key (productId) references products(productId)
);

INSERT INTO products (productName, price) VALUES
('Laptop Dell Inspiron', 15000000.00),
('Laptop HP Pavilion', 18000000.00),
('Chuột Logitech', 350000.00),
('Bàn phím cơ AKKO', 1200000.00),
('Màn hình Samsung 24inch', 4200000.00),
('Tai nghe Sony', 2500000.00),
('USB Kingston 64GB', 280000.00),
('Ổ cứng SSD Samsung 512GB', 2200000.00),
('Webcam Logitech C920', 1900000.00),
('Loa Bluetooth JBL', 1700000.00);

INSERT INTO orderItem (productId, quantity) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 1),
(5, 2),
(6, 1),
(7, 5),
(8, 1),
(9, 2),
(10, 1);

# Hiển thị mỗi sản phẩm đã bán được bao nhiêu sản phẩm
select
    p.productId,
    p.productName,
    sum(o.quantity) as Selled
from products p
join orderItem o
    on p.productId = o.productId
group by o.productId, p.productName;



select
    p.productId,
    p.productName,
    sum(o.quantity * p.price) as TotalPrice
from products p
join orderItem o
on  p.productId = o.productId
group by  o.productId, p.productName;


select
    p.productId,
    p.productName,
    sum(o.quantity * p.price) as TotalPrice
from products p
join orderItem o
on  p.productId = o.productId
group by  o.productId, p.productName
having TotalPrice > 5000000
```
#Ex5

```sql


select
    c.customerId,
    c.fullName,
    Sum(o.totalAmount) as totalSpent,
    AVG(o.totalAmount) as AVG
from customer c
join orderProduct o
    on c.customerId = o.customerId
group by c.customerId, c.fullName;


select
    c.customerId,
    c.fullName,
    Sum(o.totalAmount) as totalSpent,
    Count(o.totalAmount) as totalOrder
from customer c
join orderProduct o
    on c.customerId = o.customerId
group by c.customerId, c.fullName
having totalOrder > 2 and totalSpent > 100000
order by totalSpent desc

```
#Ex6

```sql

SELECT
    p.productName AS productName,
    SUM(o.quantity) AS totalQuantitySold,
    SUM(o.quantity * p.price) AS totalRevenue,
    AVG(p.price) AS averagePrice
FROM products p
JOIN orderItem o
    ON p.productId = o.productId
GROUP BY p.productId, p.productName
HAVING SUM(o.quantity) >= 3
ORDER BY totalRevenue DESC
LIMIT 5;
```
