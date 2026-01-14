create database session13;
use session13;


create table users
(
    userId         int auto_increment primary key,
    userName       varchar(255) not null,
    email          varchar(255) unique,
    created_at     date default (now()),
    follower_count int  default 0,
    posts_count    int  default 0
);


create table posts
(
    postId     int auto_increment primary key,
    userId     int,
    content    Text,
    created_at DATETIME default (now()),
    likesCount int      default 0,
    foreign key (userId) references users (userId)
);


insert into users(userName, email)
values ('ChatGPT', 'openai@gmail.com'),
       ('Gemini', 'gemini@gmail.com'),
       ('Cloude', 'cloude@gmail.com');


delimiter $$

create trigger trg_after_insert_posts
    after insert
    on posts
    for each row
begin
    update users
    set posts_count = posts_count + 1
    where userId = NEW.userId;
end $$
delimiter ;


delimiter $$
create trigger trg_after_delete_posts
    after delete
    on posts
    for each row
begin
    update users
    set posts_count = posts_count - 1
    where userId = OLD.userId;
end $$
delimiter ;

INSERT INTO posts (userId, content, created_at)
VALUES (1, 'Hello world from Alice!', '2025-01-10 10:00:00'),
       (1, 'Second post by Alice', '2025-01-10 12:00:00'),
       (2, 'Bob first post', '2025-01-11 09:00:00'),
       (3, 'Charlie sharing thoughts', '2025-01-12 15:00:00');

SELECT *
FROM users;


DELETE
FROM posts
WHERE posts.postId = 2;


# Ex 2 --------------------------------------------------------
create table likes
(
    likeId int primary key auto_increment,
    userId int,
    postId int,
    likeAt datetime default (now()),
    foreign key (userId) references users (userId),
    foreign key (postId) references posts (postId)
);

insert into likes(userId, postId)
values (2, 1),
       (3, 1),
       (1, 3);


delimiter $$
create trigger likes_count
    after insert
    on likes
    for each row
begin
    update posts
    set posts.likesCount = posts.likesCount + 1
    where postId = new.postId;
end $$
delimiter ;

delimiter $$
create trigger likes_count
    after delete
    on likes
    for each row
begin
    update posts
    set posts.likesCount = posts.likesCount - 1
    where postId = old.postId;
end $$

delimiter ;

CREATE view statistics as
select users.userId,
       users.username,
       (count(p.userId)) as 'post_count',
       (count(l.postId)) as 'like_count'

from users
         left join posts p on users.userId = p.userId
         left join likes l on l.postId = p.postId
group by users.userId;
;

select *
from statistics;

INSERT INTO likes (userId, postId, likeAt)
VALUES (2, 3, NOW());


DELETE
FROM likes
WHERE userId = 2
  AND postId = 4;


# Ex 3 --------------------------------------------------------

ALTER TABLE likes
    ADD UNIQUE (userId, postId);

drop trigger trg_before_insert_likes;
drop trigger trg_after_insert_likes;

drop trigger trg_after_delete_likes;


delimiter $$
create trigger trg_before_insert_likes
    before insert
    on likes
    for each row
begin
    declare post_owner int;
    select userId
    into post_owner
    from posts
    where postId = new.postId;

    if post_owner = NEW.postId then
        signal sqlstate '45000'
            set message_text = 'Error';
    end if
    $$
end $$

delimiter ;


DELIMITER $$

CREATE TRIGGER trg_after_insert_likes
    AFTER INSERT
    ON likes
    FOR EACH ROW
BEGIN
    UPDATE posts
    SET likesCount = likesCount + 1
    WHERE postId = NEW.postId;
END$$

DELIMITER ;


delimiter $$

create trigger trg_after_delete_likes
    after delete
    on likes
    for each row
begin
    update posts
    set likesCount = GREATEST(likesCount - 1, 0)
    where postId = old.postId;
end $$
delimiter ;


delimiter $$
create trigger trg_after_update_likes
    after update
    on likes
    for each row
begin
    if old.postId <> NEW.postId then
        update posts
        set likesCount = greatest(likesCount - 1, 0)
        where postId = old.postId;

        update posts
        set likesCount = likesCount + 1
        where postId = new.postId;
    end if;
end $$
delimiter ;


# Ex4 --------

create table post_history
(
    historyId          int primary key auto_increment,
    postId             int,
    oldContent         TEXT,
    new_content        Text,
    changed_at         date default (now()),
    changed_by_user_id int,
    foreign key (postId) references posts (postId)
);


INSERT INTO post_history (postId, oldContent, new_content, changed_at, changed_by_user_id)
VALUES (1, 'Hello world from Alice!', 'Hello world from Alice (edited)', '2025-01-11', 1),

       (1, 'Hello world from Alice (edited)', 'Final version of Alice post', '2025-01-12', 1),

       (4, 'Second post by Alice', 'Second post by Alice - updated', '2025-01-13', 1),

       (3, 'Bob first post', 'Bob first post (fixed typo)', '2025-01-14', 2);


delimiter $$
create trigger update_post
    before update
    on posts
    for each row
begin
    if old.content <> new.content then
        insert into post_history(postId, oldContent, new_content, changed_at, changed_by_user_id)
        values (OLD.postId, old.content, new.content, now(), old.userId);
    end if;
end $$
delimiter ;


update posts
set content = 'Hello world '
where postId = 1;


SELECT historyId,
       postId,
       oldContent,
       new_content,
       changed_at,
       changed_by_user_id
FROM post_history
ORDER BY changed_at DESC;


INSERT INTO likes (userId, postId)
VALUES (2, 1);

SELECT postId, content, likesCount
FROM posts
WHERE postId = 1;


# Ex5 ------------------------------------------


delimiter $$
create procedure add_user(
    in p_username text,
    in p_email text
)
begin
    insert into users(userName, email)
    values (p_username, p_email);
end $$
delimiter ;

delimiter $$
create trigger checkUserAdd
    before insert
    on users
    for each row
begin
    if new.email not like '%@gmail.com%' then
        signal sqlstate '45000'
            set message_text = 'invalid email!!';
    end if;

    IF NEW.userName NOT REGEXP '^[A-Za-z0-9_]+$' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Username can only contain letters, numbers, and underscore';
    END IF;

end $$

delimiter ;


call add_user('user@123', 'user@123');

call add_user('user_123', 'user@gmail.com');


SELECT *
FROM users;


# Ex6 ---------------------------------
create table friendship
(
    follower_id int primary key auto_increment,
    followee_id int,
    status      enum ('Pending', 'accepted') DEFAULT 'accepted',
    foreign key (followee_id) references users (userId)
);


delimiter $$
create trigger follower_count
    after insert
    on friendship
    for each row
begin
    update users
    set follower_count = follower_count + 1
    where userId = new.follower_id;
end $$
delimiter ;

delimiter $$
create procedure follow_user(
    in p_follower_id int,
    in p_followee_id int,
    out p_status text
)
begin
    declare v_count int;
    if p_follower_id = p_follower_id then
        set p_status = 'Canot_follow_self';
    else
        select count(*)
        into v_count
        from friendship
        where follower_id = p_follower_id
          and followee_id = p_followee_id;

        IF v_count > 0 THEN
            DELETE
            FROM friendship
            WHERE follower_id = p_follower_id
              AND followee_id = p_followee_id;
            set p_status = 'Unfollow_Success';

        else
            INSERT INTO friendship(follower_id, followee_id)
            VALUES (p_follower_id, p_followee_id);

            SET p_status = 'FOLLOW_SUCCESS';


        end if;

    end if;

end $$
delimiter ;


CALL follow_user(2, 1, @status);
SELECT @status;



SELECT userId, follower_count
FROM users
WHERE userId = 1;
