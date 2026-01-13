use social_network_pro;



create view vw_public_users as
select user_id, username, created_at
from users;

select *
from vw_public_users;


create index idx_username on users (username);


delimiter $$
create procedure sp_create_post(
    in p_user_id text,
    in p_content text
)
begin
    if exists(select 1
              from users
              where user_id = p_user_id) then
        insert into posts(user_id, content, created_at)
        values (p_user_id, p_content, now());


    end if;
end $$
delimiter ;


create view vw_recent_posts as
select
    post_id,
    user_id,
    content,
    created_at
from posts
where created_at >= date_sub(now(), interval 7 day);


select * from vw_recent_posts
order by created_at desc;


create index idx_post_user_id
on posts(user_id);


create index idx_posts_user_created on posts(user_id, created_at);

select *
from posts
where user_id = 1
order by created_at desc;



delimiter $$

create procedure sp_count_posts(
    in p_user_id int,
    out p_total int
)
begin
    select count(*)
    into p_total
    from posts
    where user_id = p_user_id;
end $$

delimiter ;


call sp_count_posts(1, @total);
select @total as total_posts;




delimiter $$

create procedure sp_add_friend(
    in p_user_id int,
    in p_friend_id int
)
begin
    if p_user_id = p_friend_id then
        signal sqlstate '45000';
    else
        insert into friends(user_id, friend_id)
        values (p_user_id, p_friend_id);
    end if;
end $$

delimiter ;


delimiter $$

create procedure sp_suggest_friends(
    in p_user_id int,
    inout p_limit int
)
begin
    declare counter int default 0;

    while counter < p_limit do
        select user_id, username
        from users
        where user_id != p_user_id
        limit counter, 1;

        set counter = counter + 1;
    end while;
end $$

delimiter ;

create index idx_likes_post_id
on likes(post_id);


select post_id, count(*) as total_likes
from likes
group by post_id
order by total_likes desc
limit 5;


create view vw_top_posts as
select post_id, count(*) as total_likes
from likes
group by post_id
order by total_likes desc
limit 5;



delimiter $$

create procedure sp_add_comment(
    in p_user_id int,
    in p_post_id int,
    in p_content text
)
begin
    declare user_count int;
    declare post_count int;

    select count(*) into user_count from users where user_id = p_user_id;
    select count(*) into post_count from posts where user_id = p_post_id;

    if user_count = 0 then
        signal sqlstate '45000';
    elseif post_count = 0 then
        signal sqlstate '45000';
    else
        insert into comments(user_id, post_id, content, created_at)
        values (p_user_id, p_post_id, p_content, now());
    end if;
end $$

delimiter ;


create view vw_post_comments as
select
    c.content,
    u.username,
    c.created_at
from comments c
join users u on c.user_id = u.user_id;


delimiter $$

create procedure sp_like_post(
    in p_user_id int,
    in p_post_id int
)
begin
    if exists (
        select 1 from likes
        where user_id = p_user_id and post_id = p_post_id
    ) then
        signal sqlstate '45000';
    else
        insert into likes(user_id, post_id)
        values (p_user_id, p_post_id);
    end if;
end $$

delimiter ;

create view vw_post_likes as
select post_id, count(*) as total_likes
from likes
group by post_id;



delimiter $$

create procedure sp_search_social(
    in p_option int,
    in p_keyword varchar(100)
)
begin
    if p_option = 1 then
        select * from users
        where username like concat('%', p_keyword, '%');
    elseif p_option = 2 then
        select * from posts
        where content like concat('%', p_keyword, '%');
    else
        signal sqlstate '45000';
    end if;
end $$

delimiter ;


call sp_search_social(1, 'an');
call sp_search_social(2, 'database');
