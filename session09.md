
Ex1

```sql

create View view_users_firstname as
    SELECT user_id, username, full_name, email, created_at from users
where full_name like '%Nguyễn%';


select * from view_users_firstname;


insert into users(user_id, username, full_name, gender, email, password, birthdate, hometown)
values (214, 'Nguyen', 'Nguyễn bach', 'Nam','bac12h@gmail.com', 'bachbach', '2006-05-25', 'Hanoi');

select * from view_users_firstname;


DELETE from  users
where  user_id = 214;;

select * from view_users_firstname;

```

Ex2

```sql
create view view_user_post as
    select s.user_id,
           count(p.post_id) as total_user_post
from users s
    left join posts p on s.user_id = p.user_id
group by s.user_id;


select * from view_user_post;

select users.full_name,
        v.total_user_post
from users
    join view_user_post v
        on users.user_id = v.user_id

```


Ex3

```sql


explain analyze
select * from users
where hometown like '%Hà Nội';

create Index idx_hometown on users (hometown);

show index from users;


explain analyze
select * from users
where hometown like '%Hà Nội';


drop index idx_hometown on users;


```


Ex3

```sql
explain analyze
select *
from users
where hometown like '%Hà Nội';


# -> Filter: (users.hometown like '%Hà Nội')  (cost=2.75 rows=2.78) (actual time=0.0331..0.0645 rows=8 loops=1)
#     -> Table scan on users  (cost=2.75 rows=25) (actual time=0.0306..0.0547 rows=25 loops=1)


create Index idx_hometown on users (hometown);

show index from users;


EXPLAIN ANALYZE
SELECT *
FROM users
WHERE hometown = 'Hà Nội';
# -> Index lookup on users using idx_hometown (hometown = 'Hà Nội')  (cost=1.43 rows=8) (actual time=0.0587..0.0813 rows=8 loops=1)

DROP INDEX idx_hometown ON users;

```


Ex4

```sql

explain analyze
select *
from users
where hometown like '%Hà Nội';


# -> Filter: (users.hometown like '%Hà Nội')  (cost=2.75 rows=2.78) (actual time=0.0331..0.0645 rows=8 loops=1)
#     -> Table scan on users  (cost=2.75 rows=25) (actual time=0.0306..0.0547 rows=25 loops=1)


create Index idx_hometown on users (hometown);

show index from users;


EXPLAIN ANALYZE
SELECT *
FROM users
WHERE hometown = 'Hà Nội';
# -> Index lookup on users using idx_hometown (hometown = 'Hà Nội')  (cost=1.43 rows=8) (actual time=0.0587..0.0813 rows=8 loops=1)

DROP INDEX idx_hometown ON users;





# Tạo một truy vấn để tìm tất cả các bài viết (posts)
# trong năm 2026 của người dùng có user_id là 1. Trả về các cột post_id, content, và created_at.
# ex 4
select user_id,
       post_id,
       content,
       created_at

from posts
where user_id = 1 and created_at > '2025/12/31';

CREATE INDEX idx_user_id_created_at
ON posts (user_id, created_at);

show index from  posts;


EXPLAIN ANALYZE
SELECT *
FROM posts FORCE INDEX (idx_user_id_created_at)
WHERE user_id = 5
  AND created_at >= '2024-01-01';
#
# -> Filter: (posts.created_at >= TIMESTAMP'2024-01-01 00:00:00')  (cost=3.85 rows=11) (actual time=0.0317..0.0617 rows=11 loops=1)
#   /  -> Index lookup on posts using posts_fk_users (user_id = 5)  (cost=3.85 rows=11) (actual time=0.03..0.059 rows=11 loops=1)
#
#-> Index range scan on posts using idx_user_id_created_at over (user_id = 5 AND '2024-01-01 00:00:00' <= created_at), with index condition: ((posts.user_id = 5) and (posts.created_at >= TIMESTAMP'2024-01-01 00:00:00'))  (cost=0.71 rows=1) (actual time=0.0408..0.0719 rows=11 loops=1)


EXPLAIN ANALYZE
select
user_id,
username,
email
from users
where email = 'an@gmail.com';

create index idx_email
on users(email);



# -> Rows fetched before execution  (cost=0..0 rows=1) (actual time=500e-6..583e-6 rows=1 loops=1)
# -> Rows fetched before execution  (cost=0..0 rows=1) (actual time=334e-6..376e-6 rows=1 loops=1)
drop index idx_user_id_created_at on posts;
drop index idx_email on users;

```


Ex5


```sql
create index idx_hometown on users(hometown);

select * from users
where hometown = 'Hà Nội';


EXPLAIN ANALYZE
SELECT
    u.username,
    u.hometown,
    p.post_id,
    p.content
FROM users u
JOIN posts p
    ON u.user_id = p.user_id
WHERE u.hometown = 'Hà Nội'
ORDER BY u.username DESC
LIMIT 10;


#
#
# -> Limit: 10 row(s)  (cost=7.62 rows=1.18) (actual time=0.0687..0.0896 rows=10 loops=1)
#     -> Nested loop inner join  (cost=7.62 rows=1.18) (actual time=0.0681..0.0883 rows=10 loops=1)
#         -> Filter: (u.hometown = 'Hà Nội')  (cost=0.1 rows=0.1) (actual time=0.0537..0.0537 rows=1 loops=1)
#             -> Index scan on u using username (reverse)  (cost=0.1 rows=1) (actual time=0.0505..0.0505 rows=1 loops=1)
#         -> Index lookup on p using posts_fk_users (user_id = u.user_id)  (cost=3.43 rows=11.8) (actual time=0.0129..0.0322 rows=10 loops=1)
#
# -> Limit: 10 row(s)  (cost=34.6 rows=10) (actual time=0.0982..0.118 rows=10 loops=1)
#     -> Nested loop inner join  (cost=34.6 rows=94.7) (actual time=0.0975..0.117 rows=10 loops=1)
#         -> Sort: u.username DESC  (cost=1.43 rows=8) (actual time=0.0786..0.0786 rows=1 loops=1)
#             -> Index lookup on u using idx_hometown (hometown = 'Hà Nội')  (cost=1.43 rows=8) (actual time=0.0443..0.0533 rows=8 loops=1)
#         -> Index lookup on p using posts_fk_users (user_id = u.user_id)  (cost=3.11 rows=11.8) (actual time=0.018..0.0368 rows=10 loops=1)
#
#
#


```


Ex6

```sql

create view view_users_summary as
    select
        users.user_id,
        users.username,
        count(p.user_id) as 'total_posts'
    from users
     left join posts p on users.user_id = p.user_id
    group by users.user_id;




select * from view_users_summary
where total_posts > 5
```

Ex7

```sql


create view view_user_activity_status as
    select
    users.user_id ,users.username, users.gender, users.created_at,
    IF(count(distinct p.post_id) > 0
           or count(distinct c.comment_id) > 0, 'Active', 'Inactive') as status
    from users
    left join posts p
        on users.user_id = p.user_id
    left join comments c
        on users.user_id = c.user_id
    group by user_id, username, gender, created_at;


select * from view_user_activity_status;

select status,
       count(*) as user_count
from view_user_activity_status
group by status
order by user_count DESC;

```


Ex8

```sql

create view view_popular_posts as
    select
    p.post_id, username, p.content, count(c.post_id) as 'NumberComment', count(c.post_id) as 'likes'
from posts p
    left join users on p.user_id = users.user_id
    left join comments c on p.post_id =  c.post_id
    left join likes l on p.post_id = l.post_id
group by p.post_id;

select * from view_popular_posts;


select * from view_popular_posts
where  NumberComment + likes > 10
order by (NumberComment + likes) desc


```

Ex9

```sql

create index idx_user_gender on users(gender);
create view view_user_activity as
select users.user_id, count(p.user_id) as total_posts, count(c.post_id) astotal_comments
    from users
    left join posts p on p.user_id = users.user_id
    left join comments c on c.post_id = p.post_id
group by  users.user_id;

select * from view_user_activity;


select * from view_user_activity
where total_posts > 5 and astotal_comments > 5
limit 5
```

Ex10

```sql


# final
create index idx_name on users(username);

# create view view_user_activity_2

create view view_user_activity_2
as 
    
SELECT
    u.full_name,
    COALESCE(p.total_posts, 0)   AS total_posts,
    COALESCE(f.total_friends, 0) AS total_friends,

    CASE
        WHEN f.total_friends > 5 THEN 'Nhiều bạn bè'
        WHEN f.total_friends BETWEEN 2 AND 5 THEN 'Vừa đủ bạn bè'
        ELSE 'Ít bạn bè'
    END AS friend_status,

    CASE
        WHEN p.total_posts > 10 THEN p.total_posts * 1.1
        WHEN p.total_posts > 5  THEN p.total_posts
        ELSE p.total_posts * 0.9
    END AS post_activity_score

FROM users u
LEFT JOIN (
    SELECT user_id, COUNT(*) AS total_posts
    FROM posts
    GROUP BY user_id
) p ON p.user_id = u.user_id
LEFT JOIN (
    SELECT user_id, COUNT(*) AS total_friends
    FROM friends
    GROUP BY user_id
) f ON f.user_id = u.user_id;





```
