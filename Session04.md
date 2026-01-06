```sql

create table students(
    student_id INT auto_increment primary key,
    full_name varchar(100) not null ,
    email varchar(150) unique not null,
    dateOfBrith date
);

# Khóa học (Course)
# Mỗi khóa học có mã khóa học riêng
# Có tên khóa học, mô tả ngắn
# Số buổi học của khóa học
create table course(
    course_id int auto_increment primary key,
    course_name varchar(150)not null ,
    description varchar(150),
    NumberLesson int check ( NumberLesson > 0 )
);

# Giảng viên (Teacher)
# Mỗi giảng viên có mã giảng viên
# Có họ tên, email
# Một giảng viên có thể dạy nhiều khóa học
create table lecturer(
    lecturer_id int auto_increment primary key ,
    lecturer_name varchar(150) not null ,
    email varchar(120) unique
);

# Đăng ký học (Enrollment)
# Sinh viên có thể đăng ký nhiều khóa học
# Mỗi lượt đăng ký lưu ngày đăng ký
# Không cho phép sinh viên đăng ký trùng một khóa học
create table enrollment(
    student_id int,
    course_id int,
    EnrollDate date default (CURRENT_DATE),
    primary key (student_id, course_id),
    foreign key(student_id) references students(student_id),
    foreign key(course_id) references course(course_id)
);

# Kết quả học tập (Score)
# Lưu điểm giữa kỳ và điểm cuối kỳ
# Điểm có giá trị từ 0 đến 10
# Mỗi sinh viên chỉ có một kết quả cho mỗi khóa học
create table score (
    midScore int check ( midScore >= 0 and midScore <= 10 ),
    finalScore int check (finalScore >= 0 and finalScore <=10),
    course_id int,
    student_id int,
    primary key (student_id, course_id),
    foreign key(student_id) references students(student_id),
    foreign key(course_id) references course(course_id)
);

insert into students(full_name, email, dateOfBrith)
values
    ('Nguyen Van A', 'anguyen@gmail.com', '2000-01-10'),
    ('Nguyen Van B', 'vnguyen@gmail.com', '2000-02-10'),
    ('Nguyen Van C', 'cnguyen@gmail.com', '2000-03-10'),
    ('Nguyen Van D', 'dnguyen@gmail.com', '2000-04-10'),
    ('Nguyen Van E', 'enguyen@gmail.com', '2000-05-10');


insert into course(course_name, description, NumberLesson)
values
    ('CSDL', 'Co SO DU LIEU', 12),
    ('LTHDT', 'Lap Trinh Huong Doi Tuong', 13),
    ('PY', 'Python', 11),
    ('Rust', 'Hacker', 9),
    ('LOL', 'League Of legends', 8);

insert into lecturer(lecturer_name, email)
values
    ('Nguyen Quang A', 'quanga@gmail.com'),
    ('Nguyen Quang B', 'quangb@gmail.com'),
    ('Nguyen Quang C', 'quangc@gmail.com'),
    ('Nguyen Quang D', 'quangd@gmail.com'),
    ('Nguyen Quang E', 'quange@gmail.com');

insert into enrollment(student_id, course_id)
values
    (1,2),
    (1,3),
    (2,1),
    (3,2),
    (4,3),
    (5,4);

insert into score(midScore, finalScore, course_id, student_id)
values
    (7,6,2,1),
    (6,3,3,2),
    (8,9,1,1),
    (10,8,2,3),
    (9,9,4,4);



# Cập nhật email cho một sinh viên
update students
set email = 'nguyenquangtoan@gmail.com'
where student_id = 1;

# Cập nhật mô tả cho một khóa học
update course
set description = 'Mot Khoa Hoc ra la khoai'
where course_id = 2;
# Cập nhật điểm cuối kỳ cho một sinh viên
update score
set finalScore = 10
where student_id = 2 and course_id = 3;



DELETE FROM enrollment
WHERE enrollment.student_id = 5 and enrollment.course_id = 4;

select * from students;
select * from lecturer;
select * from course;
select * from enrollment;
select * from score;


```
