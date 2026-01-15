create database session14;
use session14;


create table account
(
    account_id   int primary key auto_increment,
    account_name varchar(255)   not null,
    balance      decimal(10, 2) not null check (balance >= 0)
);



insert into account(account_name, balance)
values ('Nguyễn Văn An', 1000.00),
       ('Trần Thị Bảy', 500.00);


DELIMITER //
create procedure transfer_money(
    in from_account int,
    in to_account int,
    in amount decimal(10, 2)
)
begin
    declare from_balance decimal(10, 2);
    declare exit handler for sqlexception
        begin
            rollback;
        end;

    start TRANSACTION ;

    select account.balance
    into from_balance
    from account
    where account_id = from_account
        for
    update;
    if from_balance >= amount then
        update account
        set balance = balance - amount
        WHERE account_id = from_account;


        update account
        set balance = balance + amount
        where account_id = to_account;

        commit;
    else
        rollback ;
    end if;
end //
delimiter ;


CALL transfer_money(1, 2, 200.00);

SELECT *
FROM account;


# --------------------EX2--------------------


CREATE TABLE products
(
    product_id   INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(50),
    price        DECIMAL(10, 2),
    stock        INT NOT NULL
);

CREATE TABLE orders
(
    order_id    INT PRIMARY KEY AUTO_INCREMENT,
    product_id  INT,
    quantity    INT NOT NULL,
    total_price DECIMAL(10, 2),
    FOREIGN KEY (product_id) REFERENCES products (product_id)
);

INSERT INTO products (product_name, price, stock)
VALUES ('Laptop Dell', 1500.00, 10),
       ('iPhone 13', 1200.00, 8),
       ('Samsung TV', 800.00, 5),
       ('AirPods Pro', 250.00, 20),
       ('MacBook Air', 1300.00, 7);


# Viết một Stored Procedure trong MySQL để xử lý đặt hàng, thực hiện theo các bước sau:
#
# Tham số đầu vào của Stored Procedure:
# ● p_product_id (INT) - ID của sản phẩm cần đặt hàng.
#
# ● p_quantity (INT) - Số lượng sản phẩm cần mua.
#
# Logic thực hiện trong Stored Procedure:
# ● Kiểm tra số lượng tồn kho (stock) của sản phẩm trong bảng products.
# ◦ Nếu số lượng trong kho không đủ (stock < p_quantity), rollback (ROLLBACK).
#   ● Nếu đủ hàng, thực hiện các thao tác sau:
#
# ◦ Tạo đơn hàng mới trong bảng orders.
#
# ◦ Giảm số lượng tồn kho (stock - p_quantity) trong bảng products.
#
# ◦ Commit transaction (COMMIT) để lưu thay đổi.


delimiter $$
create procedure Stored_Procedure(
    in p_product_id int,
    in p_quantity int
)
begin
    declare v_stock int;
    declare v_price decimal(10, 2);
    declare v_total_price decimal(10, 2);

    declare Exit HANDLER for sqlexception
        begin
            rollback ;
        end;

    start transaction ;

    select stock, price
    into v_stock, v_price
    from products
    where product_id = p_product_id
        for
    update;

    if v_stock >= p_quantity then
        SET v_total_price = v_price * p_quantity;

        insert into orders(product_id, quantity, total_price)
        values (p_product_id, p_quantity, v_total_price);

        update products
        set stock = stock - p_quantity
        where product_id = p_product_id;
        commit;
    else
        rollback ;
    end if;

end;

delimiter ;

drop procedure Stored_Procedure;

CALL Stored_Procedure(1, 2);
SELECT *
FROM orders;


# ----------------------EX3-----------------------


CREATE TABLE company_funds
(
    fund_id INT PRIMARY KEY AUTO_INCREMENT,
    balance DECIMAL(15, 2) NOT NULL -- Số dư quỹ công ty
);

CREATE TABLE employees
(
    emp_id   INT PRIMARY KEY AUTO_INCREMENT,
    emp_name VARCHAR(50)    NOT NULL, -- Tên nhân viên
    salary   DECIMAL(10, 2) NOT NULL  -- Lương nhân viên
);

CREATE TABLE payroll
(
    payroll_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_id     INT,                     -- ID nhân viên (FK)
    salary     DECIMAL(10, 2) NOT NULL, -- Lương được nhận
    pay_date   DATE           NOT NULL, -- Ngày nhận lương
    FOREIGN KEY (emp_id) REFERENCES employees (emp_id)
);


INSERT INTO company_funds (balance)
VALUES (50000.00);

INSERT INTO employees (emp_name, salary)
VALUES ('Nguyễn Văn An', 5000.00),
       ('Trần Thị Bốn', 4000.00),
       ('Lê Văn Cường', 3500.00),
       ('Hoàng Thị Dung', 4500.00),
       ('Phạm Văn Em', 3800.00);


# 2) Viết một Stored Procedure trong MySQL để thực hiện transaction nhằm chuyển lương cho nhân viên từ quỹ công ty, thực hiện theo các bước sau:

DELIMITER $$
create procedure Stored_Procedure_Ex3(# Tham số đầu vào của Stored Procedure:
# ● p_emp_id (INT) - ID của nhân viên nhận lương.
    in p_emp_id int,
    in p_company_funds int
)
begin
    declare emp_salary decimal(10, 2);
    declare emp_id_fake int;
    declare company_funds_fake decimal(10, 2);

    declare exit handler for sqlexception
        begin
            rollback ;
        end;

    start transaction;
    select company_funds.balance
    into company_funds_fake
    from company_funds
    where fund_id = p_company_funds
        for
    update;

    select emp_id, salary
    into emp_id_fake,emp_salary
    from employees
    where emp_id = p_emp_id
        for
    update;

    # Logic thực hiện trong Stored Procedure:
# ● Kiểm tra số dư của quỹ công ty (company_funds.balance).

    if emp_salary < company_funds_fake then
        # ● Thực hiện chuyển lương:
        # ◦ Thêm bản ghi vào bảng payroll để xác nhận lương đã được trả.

        insert into payroll(emp_id, salary, pay_date)
        values (p_emp_id, emp_salary, now());

        # ◦ Trừ lương của nhân viên khỏi company_funds.balance.
        update company_funds
        set balance = balance - emp_salary
        where fund_id = p_company_funds;

        commit;

    else
        # ◦ Nếu quỹ không đủ tiền để trả lương, rollback giao dịch (ROLLBACK).
        rollback ;

    end if;

end;

Delimiter ;
select *
from employees;
select *
from payroll;
select *
from company_funds;
call Stored_Procedure_Ex3(1, 1);
call Stored_Procedure_Ex3(2, 1);
call Stored_Procedure_Ex3(3, 1);
call Stored_Procedure_Ex3(4, 1);
call Stored_Procedure_Ex3(5, 1);


# ------------------_EX4---------------


CREATE TABLE students
(
    student_id   INT PRIMARY KEY AUTO_INCREMENT,
    student_name VARCHAR(50)
);

CREATE TABLE courses
(
    course_id       INT PRIMARY KEY AUTO_INCREMENT,
    course_name     VARCHAR(100),
    available_seats INT NOT NULL
);

CREATE TABLE enrollments
(
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id    INT,
    course_id     INT,
    FOREIGN KEY (student_id) REFERENCES students (student_id),
    FOREIGN KEY (course_id) REFERENCES courses (course_id)
);
INSERT INTO students (student_name)
VALUES ('Nguyễn Văn An'),
       ('Trần Thị Ba');

INSERT INTO courses (course_name, available_seats)
VALUES ('Lập trình C', 25),
       ('Cơ sở dữ liệu', 22);


#
#
# 2) Viết một Stored Procedure trong MySQL để thực hiện transaction nhằm đăng ký học phần cho một sinh viên vào một môn học bất kỳ, thực hiện theo các bước sau:

delimiter $$
create procedure Stored_Procedure_Ex4(# ● p_student_name (VARCHAR(50)) - Tên của sinh viên muốn đăng ký.
# ● p_course_name (VARCHAR(100)) - Tên môn học mà sinh viên muốn đăng ký.
    in p_student_Id int,
    in p_course_Id int
)
begin

    declare student_id_p int;
    declare course_i_p int;
    declare available_seats_p int;
    declare exit Handler for sqlexception
        begin
            rollback;
        end;

    START TRANSACTION;

    select students.student_id
    into student_id_p
    from students
    where student_id = p_student_Id;

    select course_id, available_seats
    into course_i_p, available_seats_p
    from courses
    where course_id = p_course_Id;

    if available_seats_p > 0 then
        insert into enrollments(student_id, course_id)
        values (student_id_p, course_i_p);

        update courses
        set available_seats = available_seats - 1
        where course_id = p_course_Id;

        commit;
    else
        rollback ;
    end if;
end;
delimiter ;


select *
from students;
select *
from enrollments;
select *
from courses;

call Stored_Procedure_Ex4(1, 1);
call Stored_Procedure_Ex4(1, 2);


# ---------------Ex5---------------------


create table users
(
    user_id     int primary key auto_increment,
    username    varchar(255) not null,
    posts_count int default 0
);

create table posts
(
    post_id    int primary key auto_increment,
    user_id    int,
    contents   varchar(255) not null,
    created_at datetime default (now()),
    foreign key (user_id) references users (user_id)
);



INSERT INTO users (username)
VALUES ('nguyenvana'),
       ('tranthib'),
       ('levanc');


delimiter $$
create procedure Store_Procedure_Ex5(
    in p_userId int,
    in p_contents text
)
begin

    declare exit handler for sqlexception
        begin
            rollback ;
        end;

    start transaction;
    if (length(p_contents) > 0) then
        insert into posts(user_id, contents)
        values (p_userId, p_contents);

        update users
        set posts_count =posts_count + 1
        where user_id = p_userId;
        commit;
    else
        rollback ;
    end if;
end;
delimiter ;



select * from users;
select * from posts;
call Store_Procedure_Ex5(1, 'SQL LCG?');
call Store_Procedure_Ex5(2, '');
call Store_Procedure_Ex5(212, 'SQL21321 LCG?');


# ---------_EX6 ----------

CREATE TABLE likes (
    like_id INT PRIMARY KEY AUTO_INCREMENT,
    post_id INT NOT NULL,
    user_id INT NOT NULL,

    CONSTRAINT fk_like_post
        FOREIGN KEY (post_id) REFERENCES posts(post_id),

    CONSTRAINT fk_like_user
        FOREIGN KEY (user_id) REFERENCES users(user_id),

    CONSTRAINT unique_like
        UNIQUE (post_id, user_id)
);

ALTER TABLE posts
ADD COLUMN likes_count INT DEFAULT 0;

DELIMITER $$

CREATE PROCEDURE like_post(
    IN p_post_id INT,
    IN p_user_id INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    INSERT INTO likes (post_id, user_id)
    VALUES (p_post_id, p_user_id);

    UPDATE posts
    SET likes_count = likes_count + 1
    WHERE post_id = p_post_id;

    COMMIT;
END$$

DELIMITER ;

CALL like_post(1, 1);


# --------EX7 --------


ALTER TABLE users
ADD COLUMN following_count INT DEFAULT 0,
ADD COLUMN  followers_count INT DEFAULT 0;

CREATE TABLE IF NOT EXISTS followers (
    follower_id INT NOT NULL,
    followed_id INT NOT NULL,

    PRIMARY KEY (follower_id, followed_id),

    CONSTRAINT fk_follower_user
        FOREIGN KEY (follower_id) REFERENCES users(user_id),

    CONSTRAINT fk_followed_user
        FOREIGN KEY (followed_id) REFERENCES users(user_id)
);

CREATE TABLE IF NOT EXISTS follow_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    follower_id INT,
    followed_id INT,
    error_message VARCHAR(255),
    created_at DATETIME DEFAULT NOW()
);

DELIMITER $$

CREATE PROCEDURE sp_follow_user(
    IN p_follower_id INT,
    IN p_followed_id INT
)
BEGIN
    proc: BEGIN
        DECLARE v_follower_exists INT;
        DECLARE v_followed_exists INT;
        DECLARE v_already_followed INT;

        -- Handler rollback khi có lỗi SQL
        DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            ROLLBACK;
            INSERT INTO follow_log(follower_id, followed_id, error_message)
            VALUES (p_follower_id, p_followed_id, 'SQL Exception');
        END;

        START TRANSACTION;

        -- 1. Không được tự follow chính mình
        IF p_follower_id = p_followed_id THEN
            INSERT INTO follow_log(follower_id, followed_id, error_message)
            VALUES (p_follower_id, p_followed_id, 'Cannot follow yourself');
            ROLLBACK;
            LEAVE proc;
        END IF;

        -- 2. Kiểm tra follower tồn tại
        SELECT COUNT(*) INTO v_follower_exists
        FROM users
        WHERE user_id = p_follower_id;

        -- 3. Kiểm tra followed tồn tại
        SELECT COUNT(*) INTO v_followed_exists
        FROM users
        WHERE user_id = p_followed_id;

        IF v_follower_exists = 0 OR v_followed_exists = 0 THEN
            INSERT INTO follow_log(follower_id, followed_id, error_message)
            VALUES (p_follower_id, p_followed_id, 'User not found');
            ROLLBACK;
            LEAVE proc;
        END IF;

        -- 4. Kiểm tra đã follow chưa
        SELECT COUNT(*) INTO v_already_followed
        FROM followers
        WHERE follower_id = p_follower_id
          AND followed_id = p_followed_id;

        IF v_already_followed > 0 THEN
            INSERT INTO follow_log(follower_id, followed_id, error_message)
            VALUES (p_follower_id, p_followed_id, 'Already followed');
            ROLLBACK;
            LEAVE proc;
        END IF;

        -- 5. Thực hiện follow
        INSERT INTO followers (follower_id, followed_id)
        VALUES (p_follower_id, p_followed_id);

        -- 6. Update count
        UPDATE users
        SET following_count = following_count + 1
        WHERE user_id = p_follower_id;

        UPDATE users
        SET followers_count = followers_count + 1
        WHERE user_id = p_followed_id;

        COMMIT;

    END proc;
END$$

DELIMITER ;



# --------EX8 --------
    create table if not exists comments (
    comment_id int primary key auto_increment,
    post_id int not null,
    user_id int not null,
    content text not null,
    created_at datetime default current_timestamp,
    foreign key (post_id) references posts(post_id),
    foreign key (user_id) references users(user_id)
);

create table if not exists comments (
    comment_id int primary key auto_increment,
    post_id int not null,
    user_id int not null,
    content text not null,
    created_at datetime default current_timestamp,
    foreign key (post_id) references posts(post_id),
    foreign key (user_id) references users(user_id)
);


alter table posts
add column comments_count int default 0;

delimiter $$

create procedure sp_post_comment(
    in p_post_id int,
    in p_user_id int,
    in p_content text,
    in p_force_error int -- 1 để gây lỗi update, 0 để chạy bình thường
)
begin
    declare exit handler for sqlexception
    begin
        rollback;
    end;

    start transaction;

    insert into comments(post_id, user_id, content)
    values (p_post_id, p_user_id, p_content);

    savepoint after_insert;

    if p_force_error = 1 then
        -- gây lỗi cố ý
        update posts
        set comments_count = comments_count + 1
        where post_id = -1;
        rollback to after_insert;
        commit;
    else
        update posts
        set comments_count = comments_count + 1
        where post_id = p_post_id;
        commit;
    end if;

end$$

delimiter ;
-- thành công
call sp_post_comment(1, 1, 'comment ok', 0);

-- rollback partial (insert comment giữ lại, count không tăng)
call sp_post_comment(1, 1, 'comment lỗi update', 1);




# --------EX9 --------

    create table if not exists delete_log (
    log_id int primary key auto_increment,
    post_id int,
    deleted_by int,
    deleted_at datetime default current_timestamp
);
delimiter $$

create procedure sp_delete_post(
    in p_post_id int,
    in p_user_id int
)
begin
    declare v_owner_id int;

    declare exit handler for sqlexception
    begin
        rollback;
    end;

    start transaction;

    select user_id
    into v_owner_id
    from posts
    where post_id = p_post_id
    for update;

    if v_owner_id is null or v_owner_id <> p_user_id then
        rollback;
    else
        delete from likes where post_id = p_post_id;
        delete from comments where post_id = p_post_id;
        delete from posts where post_id = p_post_id;

        update users
        set posts_count = posts_count - 1
        where user_id = p_user_id;

        insert into delete_log(post_id, deleted_by)
        values (p_post_id, p_user_id);

        commit;
    end if;

end$$

delimiter ;

-- hợp lệ
call sp_delete_post(1, 1);

-- không hợp lệ (không phải chủ post)
call sp_delete_post(2, 1);

# --------EX10 --------

create table if not exists friend_requests (
    request_id int primary key auto_increment,
    from_user_id int,
    to_user_id int,
    status enum('pending','accepted','rejected') default 'pending'
);

create table if not exists friends (
    user_id int,
    friend_id int,
    primary key (user_id, friend_id)
);

alter table users
add column  friends_count int default 0;


delimiter $$

create procedure sp_accept_friend_request(
    in p_request_id int,
    in p_to_user_id int
)
begin
    declare v_from_user int;
    declare v_status varchar(20);

    declare exit handler for sqlexception
    begin
        rollback;
    end;

    set transaction isolation level repeatable read;
    start transaction;

    select from_user_id, status
    into v_from_user, v_status
    from friend_requests
    where request_id = p_request_id
      and to_user_id = p_to_user_id
    for update;

    if v_status <> 'pending' then
        rollback;
    else
        insert into friends(user_id, friend_id)
        values (p_to_user_id, v_from_user),
               (v_from_user, p_to_user_id);

        update users
        set friends_count = friends_count + 1
        where user_id in (p_to_user_id, v_from_user);

        update friend_requests
        set status = 'accepted'
        where request_id = p_request_id;

        commit;
    end if;

end$$

delimiter ;

call sp_accept_friend_request(1, 2);
