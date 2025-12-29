
#2
```sql
create table students(
    studentsId int primary key,
    fullName varChar(255) not null ,
    dateOfBirth date  ,
    email VARCHAR(255) not null unique
);
insert into students(studentsId, fullName, dateOfBirth, email)
values
    (4, 'Nguyen Van A', '2003-05-11', 'anguy1n@gmail.com'),
    (2, 'Nguyen Van B', '2003-05-12', 'anguy2n@gmail.com'),
    (3, 'Nguyen Van C', '2003-05-15', 'anguy3n@gmail.com');
```

#3

```sql

update students
set email = 'minh.le@sv.edu.vn'
where students.studentsId = 3;

update students
set dateOfBirth = '2003-06-06'
where students.studentsId = 2;

DELETE  FROM students
where students.studentsId = 4;


SELECT * FROM students;

```

#4

```sql


Create table subject (
    subjectId int primary key,
    subjectName varChar(255) not null,
    creditNumber int check ( creditNumber > 0 )
);

insert subject
values
    (1,'CSDL', 16),
    (2, 'LTHDT', 12),
    (3, 'LTTD', 8);

update subject
set creditNumber = 15
where subject.subjectId = 3;

update subject
set subjectName = 'Co So Du Lieu'
where subject.subjectName = 'CSDL';

select *from subject
```

#5
```sql

create table students (
    studentsId int primary key,
    studentName varchar(255) not null,
    DOB date,
    email varchar(255) not null unique
);

create table subject (
    subjectId int primary key ,
    subjectName varchar(255) not null ,
    credit int check ( credit > 0 ) not null
);

CREATE TABLE enrollment (
    studentId INT,
    subjectId INT,
    enrollDate DATE DEFAULT (CURRENT_DATE),

    PRIMARY KEY (studentId, subjectId),

    FOREIGN KEY (studentId) REFERENCES students(studentsId),
    FOREIGN KEY (subjectId) REFERENCES subject(subjectId)
);


insert into students (studentsId, studentName, DOB, email)
values
    (1, 'Nguyen Van A', '2003-05-11', 'ngiuyen1@gmai.com'),
    (2, 'Nguyen Van B', '2003-05-12', 'ngiuyen2@gmai.com'),
    (3, 'Nguyen Van C', '2003-05-13', 'ngiuyen3@gmai.com');


insert into subject (subjectId, subjectName, credit)
values
    (101, 'CSDL', 14),
    (102, 'Java', 12),
    (103, 'React', 21);


insert into enrollment(studentId, subjectId)
values
    (1,101),
    (1,103),
    (2,102),
    (3,101);


select * from subject;


select * from students;

select * from enrollment;

select *  from enrollment
where studentId = 1;

select *  from enrollment
where studentId = 2;


```

#6
```sql

create table students (
    studentsId int primary key,
    studentName varchar(255) not null,
    DOB date,
    email varchar(255) not null unique
);

create table subject (
    subjectId int primary key ,
    subjectName varchar(255) not null ,
    credit int check ( credit > 0 ) not null
);


create table Score (
    studentId int,
    subjectId int,
    mid_Score int check(mid_Score > 0 and mid_Score < 11),
    final_Score int check(final_Score > 0 and final_Score < 11),
    primary key (studentId, subjectId),

    foreign key (studentId) references students(studentsId),
    foreign key (subjectId) references subject(subjectId)
);

insert Score
values
    (1, 101, 7, 9),
    (2, 101, 6, 6),
    (3, 101, 5, 9);


select * from Score;

select * from Score
where final_Score > 8;


```

#7
```sql



create table students (
    studentsId int primary key,
    studentName varchar(255) not null,
    DOB date,
    email varchar(255) not null unique
);

create table subject (
    subjectId int primary key ,
    subjectName varchar(255) not null ,
    credit int check ( credit > 0 ) not null
);

CREATE TABLE enrollment (
    studentId INT,
    subjectId INT,
    enrollDate DATE DEFAULT (CURRENT_DATE),

    PRIMARY KEY (studentId, subjectId),

    FOREIGN KEY (studentId) REFERENCES students(studentsId),
    FOREIGN KEY (subjectId) REFERENCES subject(subjectId)
);

create table Score (
    studentId int,
    subjectId int,
    mid_Score int check(mid_Score > 0 and mid_Score < 11),
    final_Score int check(final_Score > 0 and final_Score < 11),
    primary key (studentId, subjectId),

    foreign key (studentId) references students(studentsId),
    foreign key (subjectId) references subject(subjectId)
);



insert enrollment(studentId, subjectId)
values
    (1, 101),
    (1, 102);


insert Score
values
    (1, 101, 7, 9),
    (1, 102, 6, 6);




SELECT * FROM Score WHERE studentId = 1;


UPDATE Score
SET final_Score = 9
WHERE studentId = 1
  AND subjectId = 102;



DELETE FROM enrollment
WHERE studentId = 1
  AND subjectId = 102;

SELECT * FROM enrollment WHERE studentId = 1;



SELECT
    s.studentsId,
    s.studentName,
    sub.subjectName,
    sc.mid_Score,
    sc.final_Score
FROM Score sc
JOIN students s ON sc.studentId = s.studentsId
JOIN subject sub ON sc.subjectId = sub.subjectId
ORDER BY s.studentsId;

```

```sql

create table students (
    studentsId int primary key,
    studentName varchar(255) not null,
    DOB date,
    email varchar(255) not null unique
);

create table subject (
    subjectId int primary key ,
    subjectName varchar(255) not null ,
    credit int check ( credit > 0 ) not null
);

CREATE TABLE enrollment (
    studentId INT,
    subjectId INT,
    enrollDate DATE DEFAULT (CURRENT_DATE),

    PRIMARY KEY (studentId, subjectId),

    FOREIGN KEY (studentId) REFERENCES students(studentsId),
    FOREIGN KEY (subjectId) REFERENCES subject(subjectId)
);

create table Score (
    studentId int,
    subjectId int,
    mid_Score int check(mid_Score > 0 and mid_Score < 11),
    final_Score int check(final_Score > 0 and final_Score < 11),
    primary key (studentId, subjectId),

    foreign key (studentId) references students(studentsId),
    foreign key (subjectId) references subject(subjectId)
);



insert enrollment(studentId, subjectId)
values
    (1, 101),
    (1, 102);


insert Score
values
    (1, 101, 7, 9),
    (1, 102, 6, 6);




SELECT * FROM Score WHERE studentId = 1;


UPDATE Score
SET final_Score = 9
WHERE studentId = 1
  AND subjectId = 102;



DELETE FROM enrollment
WHERE studentId = 1
  AND subjectId = 102;

SELECT * FROM enrollment WHERE studentId = 1;



SELECT
    s.studentsId,
    s.studentName,
    sub.subjectName,
    sc.mid_Score,
    sc.final_Score
FROM Score sc
JOIN students s ON sc.studentId = s.studentsId
JOIN subject sub ON sc.subjectId = sub.subjectId
ORDER BY s.studentsId;



#thêm Cột phone cho student
ALTER TABLE students
ADD phone VARCHAR(15);

#thêm cột smester cho students
Alter table subject
add semester varchar(255);

#thay doi kieu du liẹu
ALTER TABLE subject
MODIFY semester int;


#kiem tra du liẹu sai
SELECT *
FROM subject
WHERE credit < 1;


# Trong bảng subject, cột semester không cần thiết vì:
# 	•	Học kỳ không phải thuộc tính cố định của môn học
# 	•	Học kỳ phù hợp hơn nếu gắn với đăng ký học (DangKy), không phải subject

#xoá cột khong cần thiết
ALTER TABLE subject
DROP COLUMN semester;



DESCRIBE students;
DESCRIBE subject;
DESCRIBE enrollment;

SHOW CREATE TABLE students;
```

<img width="336" height="364" alt="image" src="https://github.com/user-attachments/assets/8863fec3-9070-46a0-89d7-6f981661b77f" />

<img width="939" height="186" alt="image" src="https://github.com/user-attachments/assets/07255653-391f-4f38-b46d-40db595ca016" />
<img width="945" height="133" alt="image" src="https://github.com/user-attachments/assets/1262b2bf-91b4-430d-8940-7dfbc201a4b6" />
<img width="949" height="128" alt="image" src="https://github.com/user-attachments/assets/19b5503b-62fd-4c25-97f5-cf1dc06bc424" />
<img width="954" height="158" alt="image" src="https://github.com/user-attachments/assets/cfb36a6f-4581-48a4-97af-be4afad7d4f6" />




