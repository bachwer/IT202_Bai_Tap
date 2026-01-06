#EX1
```sql
Create table customers(
    id int primary key auto_increment,
    name varchar(255) not null,
    email varchar(255) unique
);

Create table orders(
    id int primary key auto_increment,
    customer_id int,
    order_date Date Default(now()),
    total_amount DECIMAL(10,2),
    foreign key (customer_id) references customers(id)
);


INSERT INTO customers ( name, email) VALUES
('Nguyen Van A', 'a@gmail.com'),
( 'Tran Thi B', 'b@gmail.com'),
( 'Le Van C', 'c@gmail.com'),
( 'Pham Thi D', 'd@gmail.com'),
( 'Hoang Van E', 'e@gmail.com'),
( 'Do Thi F', 'f@gmail.com'),
( 'Bui Van G', 'g@gmail.com');




INSERT INTO orders (id, customer_id, order_date, total_amount) VALUES
(101, 1, '2024-01-10', 500000),
(102, 2, '2024-01-11', 750000),
(103, 1, '2024-01-15', 300000),
(104, 3, '2024-01-20', 900000),
(105, 5, '2024-02-01', 1200000),
(106, 2, '2024-02-05', 450000),
(107, 6, '2024-02-10', 650000);




SELECT *
FROM customers
WHERE id IN (
    SELECT customer_id
    FROM orders
);
```
#EX2
```sql



create table products(
    id int auto_increment primary key,
    name varchar(255) not null,
    price decimal(10,2) not null
);

create table order_item(
    order_id int auto_increment primary key ,
    product_id int,
    quantity int not null check(quantity > 0),
    foreign key (product_id) references products(id)
);


INSERT INTO products (name, price) VALUES
('Laptop Dell Inspiron', 15000000),
('Chuột Logitech', 350000),
('Bàn phím cơ Keychron', 2200000),
('Màn hình Samsung 24 inch', 4200000),
('Tai nghe Sony', 1800000),
('Ổ cứng SSD 512GB', 1600000),
('USB Kingston 64GB', 250000);

INSERT INTO order_item (product_id, quantity) VALUES
(1, 1),
(2, 2),
(3, 1),
(4, 1),
(5, 3),
(6, 2),
(7, 5);


Select * from products
where id in (select product_id from order_item)

```
#EX3
```sql


select * from orders
where total_amount > (select AVG(total_amount) from orders)
```
#EX4
```sql
select  s.name,
        (select count(customer_id) from orders where customer_id = s.id) as NumberOrder
from customers s
```
#EX5
```sql
select s.id,
       s.name,
       (select SUM(total_amount) from orders where customer_id = s.id) as totalPrice
from customers s
where (select SUM(total_amount)
       from orders
       where customer_id = s.id) = (select max(t.totalPrice)
                                        from (select sum(total_amount) as totalPrice
                                              from orders
                                              group by orders.customer_id) t);

```
#EX6
```sql
select c.id,
       c.name,
       sum(o.total_amount) as totalPrice
from customers c, orders o
where c.id = o.customer_id
group by c.id, c.name
having sum(o.total_amount) > (
    select avg(t.totalPrice)
    from (
        select sum(o2.total_amount) as totalPrice
        from orders o2
        group by o2.customer_id
    ) t
);

```
