create table user
(
    user_id    int primary key auto_increment,
    username   varchar(255) not null UNIQUE,
    password   varchar(255) not null,
    email      varchar(199) not null unique,
    created_at DATETIME default (now())
);

create table Posts
(
    post_id    int primary key auto_increment,
    user_id    int,
    content    TEXT not null,
    created_at datetime default (now()),
    foreign key (user_id) references user (user_id)
);


create table Comments
(
    comment_id int primary key auto_increment,
    post_id    int,
    user_id    int,
    contents   text,
    created_at datetime default (now()),
    foreign key (post_id) references Posts (post_id),
    foreign key (user_id) references user (user_id)
);

create table likes
(
    post_id    int,
    user_id    int,
    created_at datetime default (now()),
    PRIMARY KEY (user_id, post_id),
    foreign key (post_id) references Posts (post_id),
    foreign key (user_id) references user (user_id)
);

create table system_log
(
    log_id     int primary key auto_increment,
    content    Text,
    created_at datetime default (now()),
    type       varchar(10)

);


# Tạo tài khoản mới (username, email, password).
# Kiểm tra trùng username và email.
# Sử dụng Stored Procedure.
# Áp dụng Trigger để ghi log đăng ký.

delimiter $$
create trigger trg_after_insert_user
    after insert
    on user
    for each row
begin
    insert into system_log(type, system_log.content)
    values ('USER', concat('Success: Đăng kí thành công với user: ', new.username));
end $$

delimiter ;

delimiter $$
create procedure Create_Account_User(
    in p_userName varchar(255),
    in p_email varchar(100),
    in p_password varchar(100)
)
begin
    declare exit Handler for sqlexception
        begin
            rollback ;
        end;
    start transaction ;
    if exists (select 1 from user where username = p_userName) then
        rollback ;

    elseif exists (select 1 from user where email = p_email) then

        rollback ;

    else
        insert into user(username, password, email)
        values (p_userName, p_email, p_password);

        commit;
    end if;

end $$

delimiter ;

drop procedure Create_Account_User;

select *
from system_log;
select *
from user;

call Create_Account_User('Tuấn 1', 'passs 4', 'tuấn1@gmail.com');
call Create_Account_User('Tuấn 2', 'passs 4', 'tuấn2@gmail.com');
call Create_Account_User('Tuấn 3', 'passs 4', 'tuấn3@gmail.com');
call Create_Account_User('Tuấn 5', 'passs 4', 'tuấn6@gmail.com');
call Create_Account_User('Tuấn 6', 'passs 4', 'tuấn5@gmail.com');



# Tạo bảng user_log (log_id, user_id, action, log_time).
# Stored Procedure sp_register_user(p_username, p_password, p_email) với kiểm tra trùng → SIGNAL lỗi.
# Trigger AFTER INSERT trên Users ghi vào user_log.

#
#
# Tạo bài viết với nội dung văn bản.
# Sử dụng Stored Procedure.
# Trigger ghi log sự kiện đăng bài.

# Stored Procedure sp_create_post(p_user_id, p_content) kiểm tra content không rỗng.
# Tạo bảng post_log nếu cần.
# Trigger AFTER INSERT trên Posts ghi log.

delimiter $$
create trigger trg_after_insert_post
    after insert
    on Posts
    for each row
begin
    insert into system_log(type, system_log.content)
    values ('POST', concat('Success: created new post thành công với user: ', new.post_id));
end $$
delimiter ;


delimiter $$
create procedure Create_New_Post(
    in p_userId int,
    in p_content text
)
begin
    declare exit handler for sqlexception
        begin
            rollback ;
        end;
    start transaction ;

    if exists (select 1 from user where user_id = p_userId) and length(p_content) > 0 then
        insert into Posts(user_id, content)
        values (p_userId, p_content);
    else
        rollback ;
    end if;
end $$
delimiter ;


call Create_New_Post(13, 'Hello !');
call Create_New_Post(14, 'Hello 111');
call Create_New_Post(15, 'Hello2223');


select *
from Posts;
select *
from system_log;



alter table Posts
    add likes_count int not null check (likes_count >= 0 ) default 0;


delimiter $$
create trigger likes
    after insert
    on likes
    for each row
begin
    update Posts
    set likes_count = likes_count + 1
    where NEW.post_id = post_id;

end $$
delimiter ;

delimiter $$
create trigger likes_delete
    after delete
    on likes
    for each row
begin
    update Posts
    set likes_count = likes_count - 1
    where Old.post_id = post_id
      and post_id > 0;
end $$
delimiter ;


select *
from posts;

delete
from likes
where post_id = 1
  and user_id = 13;

insert into likes(post_id, user_id)
values (1, 13),
       (1, 14),
       (1, 15),
       (1, 16);



create table Friends
(
    user1  int,
    user2  int,
    status varchar(10),
    primary key (user1, user2)
);


# INSERT vào Friends với status = 'pending'.
# Kiểm tra hợp lệ (không tự gửi, không trùng).
# Gợi ý thực hiện:

delimiter $$
create procedure sp_send_friend_request(
    in p_sender_id int,
    in p_receiver_id int
)
begin
    DECLARE v_count INT;
    declare exit handler for sqlexception
        begin
            rollback ;
        end;


    SELECT COUNT(*)
    INTO v_count
    FROM user
    WHERE user_id IN (p_sender_id, p_receiver_id);

    IF v_count = 2 AND p_sender_id <> p_receiver_id THEN
        insert into Friends(user1, user2, status)
        VALUES (p_sender_id, p_receiver_id, 'PENDING');
        commit;
    else
        rollback;
    end if;
end;
delimiter ;


# Stored Procedure sp_send_friend_request(p_sender_id, p_receiver_id) với kiểm tra → SIGNAL lỗi nếu không hợp lệ.
# Trigger AFTER INSERT trên Friends ghi log.

delimiter $$
create trigger add_friend
    after insert
    on Friends
    for each row
begin
    insert into system_log(type, content)
    VALUES ('FRIENDS',
            CONCAT(
                    'USER: ', NEW.user1,
                    ' gui loi cho USER: ', NEW.user2,
                    ' | STATUS: ', NEW.status
            ));
end $$
delimiter ;


# Kiểm tra và demo:
#
# Gửi vài lời mời hợp lệ → SELECT Friends.
# Gửi không hợp lệ (tự gửi, trùng) → kiểm tra lỗi.
call sp_send_friend_request(14, 15);
call sp_send_friend_request(13, 14);
call sp_send_friend_request(13, 16);





select *
from Friends;
select *
from system_log;


#
# Bài 5: Chấp Nhận Lời Mời Kết Bạn
# Chức năng mô phỏng: Chấp nhận lời mời.

# Yêu cầu chi tiết:

# Cập nhật status từ 'pending' → 'accepted'.
# Tự động tạo bản ghi ngược lại để mối quan hệ đối xứng.
# Gợi ý thực hiện:

# Stored Procedure hoặc Trigger AFTER UPDATE trên Friends: nếu status thành 'accepted' thì INSERT bản ghi ngược.
# Kiểm tra và demo:

DELIMITER $$

CREATE PROCEDURE sp_accept_friend_request(
    IN p_user1 INT,
    IN p_user2 INT
)
BEGIN
    DECLARE v_exists INT;

    START TRANSACTION;

    -- Kiểm tra lời mời tồn tại
    SELECT COUNT(*) INTO v_exists
    FROM Friends
    WHERE user1 = p_user1
      AND user2 = p_user2
      AND status = 'PENDING';

    IF v_exists = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Friend request not found';
    END IF;

    -- Cập nhật chiều gốc
    UPDATE Friends
    SET status = 'ACCEPTED'
    WHERE user1 = p_user1
      AND user2 = p_user2;

    -- Tạo chiều ngược lại nếu chưa tồn tại
    INSERT INTO Friends(user1, user2, status)
    SELECT p_user2, p_user1, 'ACCEPTED'
    WHERE NOT EXISTS (
        SELECT 1 FROM Friends
        WHERE user1 = p_user2 AND user2 = p_user1
    );

    COMMIT;
END$$

DELIMITER ;

select *
from Friends;




call sp_accept_friend_request(13, 14);



DELIMITER $$

CREATE PROCEDURE sp_update_friend_status(
    IN p_user1 INT,
    IN p_user2 INT,
    IN p_new_status VARCHAR(10)
)
BEGIN
    DECLARE v_count INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Transaction failed - rollback';
    END;

    START TRANSACTION;

    -- Kiểm tra tồn tại quan hệ 2 chiều
    SELECT COUNT(*) INTO v_count
    FROM Friends
    WHERE (user1 = p_user1 AND user2 = p_user2)
       OR (user1 = p_user2 AND user2 = p_user1);

    IF v_count <> 2 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Friend relationship not complete';
    END IF;

    -- Update cả 2 chiều
    UPDATE Friends
    SET status = p_new_status
    WHERE (user1 = p_user1 AND user2 = p_user2)
       OR (user1 = p_user2 AND user2 = p_user1);

    COMMIT;
END$$

DELIMITER ;




CALL sp_update_friend_status(13, 14, 'BLOCKED');


DELIMITER $$

CREATE PROCEDURE sp_delete_friendship(
    IN p_user1 INT,
    IN p_user2 INT
)
BEGIN
    DECLARE v_count INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Delete failed - rollback';
    END;

    START TRANSACTION;

    -- Kiểm tra đủ 2 chiều
    SELECT COUNT(*) INTO v_count
    FROM Friends
    WHERE (user1 = p_user1 AND user2 = p_user2)
       OR (user1 = p_user2 AND user2 = p_user1);

    IF v_count <> 2 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot delete: relationship not symmetric';
    END IF;

    -- Xóa cả hai chiều
    DELETE FROM Friends
    WHERE (user1 = p_user1 AND user2 = p_user2)
       OR (user1 = p_user2 AND user2 = p_user1);

    COMMIT;
END$$

DELIMITER ;

CALL sp_delete_friendship(13, 14);


SELECT * FROM Friends;


DELIMITER $$

CREATE TRIGGER trg_before_delete_post
BEFORE DELETE ON Posts
FOR EACH ROW
BEGIN
    DELETE FROM Likes WHERE post_id = OLD.post_id;
    DELETE FROM Comments WHERE post_id = OLD.post_id;
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE sp_delete_post(
    IN p_post_id INT,
    IN p_user_id INT
)
BEGIN
    DECLARE v_owner INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Delete post failed - rollback';
    END;

    START TRANSACTION;

    -- Kiểm tra bài viết tồn tại & chủ sở hữu
    SELECT user_id INTO v_owner
    FROM Posts
    WHERE post_id = p_post_id
    FOR UPDATE;

    IF v_owner IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Post not found';
    END IF;

    IF v_owner <> p_user_id THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Permission denied';
    END IF;

    -- Xóa post (trigger sẽ xóa likes + comments)
    DELETE FROM Posts WHERE Posts.post_id = p_post_id;

    COMMIT;
END$$

DELIMITER ;


INSERT INTO Posts(user_id, content) VALUES (10, 'Hello');
INSERT INTO Likes(post_id, user_id) VALUES (1, 1);
INSERT INTO Comments(post_id, user_id, contents) VALUES ( 1, 13, 'Nice');


CALL sp_delete_post(1, 99);

SELECT * FROM Posts; -- vẫn còn



DELIMITER $$

CREATE PROCEDURE sp_delete_user(
    IN p_user_id INT
)
BEGIN
    DECLARE v_exists INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Delete user failed - rollback';
    END;

    START TRANSACTION;

    -- Kiểm tra user tồn tại
    SELECT COUNT(*) INTO v_exists
    FROM user
    WHERE user_id = p_user_id;

    IF v_exists = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'User not found';
    END IF;

    -- Xóa bạn bè (2 chiều)
    DELETE FROM Friends
    WHERE user1 = p_user_id OR user2 = p_user_id;

    -- Xóa likes & comments của user
    DELETE FROM Likes WHERE user_id = p_user_id;
    DELETE FROM Comments WHERE user_id = p_user_id;

    -- Xóa posts (trigger sẽ xóa likes + comments của post)
    DELETE FROM Posts WHERE user_id = p_user_id;

    -- Xóa user
    DELETE FROM user WHERE user.user_id = p_user_id;

    COMMIT;
END$$

DELIMITER ;

DELETE FROM user WHERE user.user_id = 10; -- KHÔNG dùng SP

CALL sp_delete_user(10);

