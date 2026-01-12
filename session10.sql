# Ex1
DELIMITER $$
CREATE PROCEDURE get_post_by_user(
    in p_user_id int
)
begin
    select post_id as PostID,
           content as NoiDung,
           created_at ThoiGianTao
    FROM posts
    where user_id = p_user_id
    order by content desc;
end $$
DELIMITER ;
CALL get_post_by_user(1);

drop PROCEDURE get_post_by_user;


# ex2

DELIMITER $$

CREATE PROCEDURE CalculatePostLikes(
    IN p_post_id INT,
    OUT p_total_likes INT
)
BEGIN
    SELECT COUNT(*)
    INTO p_total_likes
    FROM likes
    WHERE post_id = p_post_id;
END $$

DELIMITER ;


CALL CalculatePostLikes(101, @total_likes);
SELECT @total_likes;


# Ex3

# Đếm số lượng bài viết (posts) của user đó.
# Nếu số bài viết ≥ 10, cộng thêm 50 điểm vào p_bonus_points.
# Nếu số bài viết ≥ 20, cộng thêm tổng cộng 100 điểm (thay vì chỉ 50).
# Cuối cùng, tham số p_bonus_points sẽ được sửa đổi và trả ra giá trị mới.

delimiter $$
create PROCEDURE CalculateBonusPoints(
    in p_user_id int,
    out p_bonus_points int
)
begin
    SELECT COUNT(*)
    INTO p_bonus_points
    FROM posts
    WHERE user_id = p_user_id;

    IF p_bonus_points >= 20 then
        set p_bonus_points = 100;
    ELSEIF p_bonus_points >= 10 then
        set p_bonus_points = 50;
    else
        set p_bonus_points = 0;
    end if;
END $$
DELIMITER ;


drop PROCEDURE CalculateBonusPoints;


CALL CalculateBonusPoints(3, @tesst);
SELECT @tesst;


# Ex4
delimiter $$
create procedure CreatePostWithValidation(
    in p_user_id int,
    in p_content TEXT,
    OUT result_message VARCHAR(255)
)
begin
    if (length(p_content) > 5) then
        insert into posts(user_id, content)
        value(p_user_id, p_content);
        set result_message = 'Them Thanh Cong';
    else
        set result_message = 'Nội dung quá ngắn';

    end if;
end $$
delimiter ;




CALL CreatePostWithValidation(3,' Da', @log );
select @log;



# Ex5

# 2)Viết procedure tên CalculateUserActivityScore nhận IN p_user_id (INT), trả về OUT activity_score (INT).
# Điểm được tính: mỗi post +10 điểm, mỗi comment +5 điểm, mỗi like nhận được +3 điểm.
# Sử dụng CASE hoặc IF để phân loại mức hoạt động (ví dụ: >500 “Rất tích cực”, 200-500 “Tích cực”, <200 “Bình thường”)
# và trả thêm OUT activity_level (VARCHAR(50)).
#
# Gợi ý: Dùng các SELECT COUNT riêng cho posts, comments, likes (JOIN posts và likes), tính tổng điểm, sau đó dùng CASE để xác định level.
#
# 3) Gọi thủ tục trên select ra activity_score và activity_level
#
# 4) Xóa thủ tục vừa khởi tạo trên

    delimiter $$
    create procedure CalculateUserActivityScore (
        in p_userId int,
        out activity_score int,
        out activity_level VARCHAR(50)
    )
    begin
         declare  numberPost int default 0;
         declare  numberLike int default 0;
         declare   numberCmt int default 0;

        select
        count(distinct p.post_id),
        count(distinct c.post_id) ,
        count(distinct l.post_id)
        INTO
        numberPost,
        numberCmt,
        numberLike

    from posts p
        left join comments c on p.post_id = c.post_id
        left join likes l on p.post_id = l.post_id
        where p.user_id = p_userId
    group by p.user_id ;

         set activity_score = (numberPost * 10) + (numberLike * 3) + (numberCmt *5);

         if(activity_score > 500) then
             set activity_level = 'Rat Tinh cuc';
        elseif (activity_score > 200) then
             set activity_level = 'Tich cuc';
        else
             set activity_level = 'BT';
        end if;


    end $$
delimiter ;

call CalculateUserActivityScore(3, @activity_score, @activity_level);


select @activity_score, @activity_level;

drop procedure CalculateUserActivityScore;

# Ex6



DElimiter  $$
create procedure NotifyFriendsOnNewPost (
    in p_user_id int,
    in p_content TEXT
)
    begin
        declare v_full_Name varchar(255);

        select users.full_name
            into  v_full_Name
        from users
            where users.user_id = p_user_id;

        insert into posts(user_id, content)
        value (p_user_id, p_content);

        insert into notifications (user_id, type, content)
            select  friend_id, 'new_post' ,
                    CONCAT(v_full_name, ' đã đăng một bài viết mới') from friends
                        where friends.user_id = p_user_id
                            and status = 'accepted'
                union
                select
                    user_id,
                    'new_post',
                    CONCAT(v_full_name, ' đã đăng một bài viết mới')
                            FROM friends
        WHERE friend_id = p_user_id
          AND status = 'accepted';


    end $$
delimiter ;

CALL NotifyFriendsOnNewPost(
    1,
    'Hôm nay mình vừa học xong Stored Procedure trong MySQL 😄'
);

SELECT n.*
FROM notifications n
WHERE n.type = 'new_post'
  AND n.content LIKE '%đã đăng một bài viết mới%'
ORDER BY n.created_at DESC;

DROP PROCEDURE IF EXISTS NotifyFriendsOnNewPost;
