
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

