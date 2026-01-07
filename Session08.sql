create table customers(
    customer_id int Primary key auto_increment,
    customer_name varchar(255) not null ,
    email varchar(255) not null unique ,
    phone varchar(10) not null
);

create table categories(
    category_id int primary key auto_increment,
    category_name varchar(255) not null unique
);

create table products(
    product_id int primary key auto_increment,
    product_name varchar(255) not null unique ,
    price decimal(10,2) not null check(price > 0),
    category_id int not null ,
    foreign key (category_id) references categories(category_id)
);

create table order_Data(
    order_id int primary key auto_increment,
    customer_id int not null ,
    order_date datetime default(now()),
    status enum('Pending', 'Completed', 'Cancel') not null
);

create table order_items(
    order_item_id int primary key auto_increment,
    order_id int not null,
    product_id int not null ,
    quantity int not null check(quantity > 0),
    foreign key (order_id) references order_Data(order_id),
    foreign key (product_id) references products(product_id)
);
INSERT INTO customers (customer_name, email, phone) VALUES
('Nguyen Van A', 'a@gmail.com', '0900000001'),
('Tran Thi B', 'b@gmail.com', '0900000002'),
('Le Van C', 'c@gmail.com', '0900000003'),
('Pham Thi D', 'd@gmail.com', '0900000004'),
('Hoang Van E', 'e@gmail.com', '0900000005');


INSERT INTO categories (category_name) VALUES
('Laptop'),
('Phone'),
('Tablet'),
('Accessory'),
('Monitor');


INSERT INTO products (product_name, price, category_id) VALUES
('MacBook Air M1', 25000000, 1),
('iPhone 14', 22000000, 2),
('iPad Pro', 30000000, 3),
('Wireless Mouse', 500000, 4),
('Dell 27 Inch Monitor', 6000000, 5);


INSERT INTO order_Data (customer_id, status) VALUES
(1, 'Completed'),
(2, 'Pending'),
(3, 'Completed'),
(1, 'Completed'),
(3, 'Completed');

INSERT INTO order_items (order_id, product_id, quantity) VALUES
-- Đơn hàng 1 (customer 1)
(1, 1, 1),  -- MacBook Air M1
(1, 4, 2),  -- Wireless Mouse

-- Đơn hàng 2 (customer 2)
(2, 2, 1),  -- iPhone 14
(2, 5, 1),  -- Dell Monitor

-- Đơn hàng 3 (customer 3)
(3, 3, 1),  -- iPad Pro
(3, 4, 1),
(4, 3, 4),  -- iPad Pro
(5, 4, 2);  -- Wireless Mouse




# PHẦN A – TRUY VẤN DỮ LIỆU CƠ BẢN
#
# Lấy danh sách tất cả danh mục sản phẩm trong hệ thống.
select * from products;

# Lấy danh sách đơn hàng có trạng thái là COMPLETED
select * from order_Data
where status = 'Completed';


# Lấy danh sách sản phẩm và sắp xếp theo giá giảm dần
select * from products
order by price desc;

# Lấy 5 sản phẩm có giá cao nhất, bỏ qua 2 sản phẩm đầu tiên
select * from products
limit 5 offset 2;



# PHẦN B – TRUY VẤN NÂNG CAO
#
# Lấy danh sách sản phẩm kèm tên danh mục
select
    products.product_id,
    products.product_name,
    products.price,
    (select categories.category_name from categories where products.category_id = categories.category_id) as 'Category'
from products;



# Lấy danh sách đơn hàng gồm:
# order_id
# order_date
# customer_name
# status
select
    order_Data.order_id,
    order_Data.order_date,
    (select customer_name from  customers where customers.customer_id = order_Data.customer_id) as customer_name,
    order_Data.status
    from order_Data;


# Tính tổng số lượng sản phẩm trong từng đơn hàng
select
    order_Data.order_id,
    order_Data.order_date,
    (select sum(quantity)  from order_items where order_Data.order_id = order_items.order_id) as 'total_quantity'
from order_Data;


# Thống kê số đơn hàng của mỗi khách hàng
select
    customers.customer_name,
    (select count(order_Data.customer_id) from order_Data where customers.customer_id = order_Data.customer_id) as 'total_order'
     from customers;

# Lấy danh sách khách hàng có tổng số đơn hàng ≥ 2
select
    customer_name,
    (select count(order_Data.customer_id) from order_Data where customers.customer_id = order_Data.customer_id) as 'total_order'
from customers
join order_Data
    on customers.customer_id = order_Data.customer_id
where (select count(order_Data.customer_id) from order_Data where customers.customer_id = order_Data.customer_id ) >= 2
group by customers.customer_id, order_Data.customer_id;

# Thống kê giá trung bình, thấp nhất và cao nhất của sản phẩm theo danh mục

select
    categories.category_name,
    (select avg(products.price) from products where products.category_id = categories.category_id) as "AVG",
    (select max(products.price) from products where products.category_id = categories.category_id) as "Max",
    (select min(products.price) from products where products.category_id = categories.category_id) as "Min"
from products
join categories
    on categories.category_id = products.category_id
group by categories.category_id , products.category_id;



# PHẦN C – TRUY VẤN LỒNG (SUBQUERY)

# Lấy danh sách sản phẩm có giá cao hơn giá trung bình của tất cả sản phẩm
select * from products
where products.price > (select avg(products.price) from products );



# Lấy danh sách khách hàng đã từng đặt ít nhất một đơn hàng
select
    customer_name,
    (select count(order_Data.customer_id) from order_Data where customers.customer_id = order_Data.customer_id) as 'total_order'
from customers
join order_Data
    on customers.customer_id = order_Data.customer_id
where (select count(order_Data.customer_id) from order_Data where customers.customer_id = order_Data.customer_id ) >= 1
group by customers.customer_id, order_Data.customer_id;


# Lấy đơn hàng có tổng số lượng sản phẩm lớn nhất.
SELECT
    order_items.order_id,
    SUM(order_items.quantity) AS total_quantity
FROM order_items
GROUP BY order_items.order_id
HAVING SUM(order_items.quantity) = (
    SELECT MAX(total_qty)
    FROM (
        SELECT SUM(quantity) AS total_qty
        FROM order_items
        GROUP BY order_id
    ) AS temp
);


# Lấy tên khách hàng đã mua sản phẩm thuộc danh mục có giá trung bình cao nhất
SELECT DISTINCT c.customer_name
FROM customers c
JOIN order_Data o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE p.category_id = (
    SELECT category_id
    FROM products
    GROUP BY category_id
    ORDER BY AVG(price) DESC
    LIMIT 1
);



# Từ bảng tạm (subquery), thống kê tổng số lượng sản phẩm đã mua của từng khách hàng
    SELECT
    c.customer_name,
    t.total_quantity
FROM customers c
JOIN (
    SELECT
        o.customer_id,
        SUM(oi.quantity) AS total_quantity
    FROM order_Data o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY o.customer_id
) AS t
ON c.customer_id = t.customer_id;

# Viết lại truy vấn lấy sản phẩm có giá cao nhất, đảm bảo:
    SELECT *
FROM products
WHERE price = (
    SELECT MAX(price)
    FROM products
);
# Subquery chỉ trả về một giá trị
# Không gây lỗi “Subquery returns more than 1 row”
