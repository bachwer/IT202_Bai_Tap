``` mermaid
flowchart TD
    %% =========================
    %% KHỐI 1: KIỂU DỮ LIỆU SQL
    %% =========================
    subgraph L1 ["LESSON 01: DATA TYPES"]
        direction TB
        DT["Kiểu dữ liệu SQL"]

        DT --> Num["Numeric"]
        Num --> I1["INT / BIGINT<br/>ID, số lượng"]
        Num --> I2["DECIMAL(p,s)<br/>Tiền, điểm"]
        Num --> I3["FLOAT / DOUBLE<br/>Số xấp xỉ"]

        DT --> Str["String"]
        Str --> S1["CHAR(n)<br/>Độ dài cố định"]
        Str --> S2["VARCHAR(n)<br/>Phổ biến nhất"]
        Str --> S3["NVARCHAR(n)<br/>Unicode"]
        Str --> S4["TEXT / BLOB<br/>Dữ liệu lớn"]

        DT --> Time["Date & Time"]
        Time --> T1["DATE<br/>YYYY-MM-DD"]
        Time --> T2["DATETIME<br/>YYYY-MM-DD HH:MM:SS"]
        Time --> T3["TIMESTAMP<br/>Audit / Log"]
    end

    %% =========================
    %% KHỐI 2: RÀNG BUỘC SQL
    %% =========================
    subgraph L2 ["LESSON 02: CONSTRAINTS"]
        direction TB
        CS["Ràng buộc dữ liệu"]

        CS --> C1["NOT NULL<br/>Không để trống"]
        CS --> C2["UNIQUE<br/>Giá trị duy nhất"]
        CS --> C3["PRIMARY KEY<br/>Định danh bản ghi"]
        CS --> C4["FOREIGN KEY<br/>Liên kết bảng"]
        CS --> C5["CHECK<br/>Giới hạn giá trị"]
        CS --> C6["DEFAULT<br/>Giá trị mặc định"]

        C3 --> Rule1["PK = NOT NULL + UNIQUE"]
        C4 --> Rule2["Con → Cha (PK)"]
    end

    %% =========================
    %% KHỐI 3: DDL
    %% =========================
    subgraph L3 ["LESSON 03: DDL"]
        direction TB
        DDL["Data Definition Language"]

        DDL --> D1["CREATE TABLE<br/>Tạo cấu trúc"]
        DDL --> D2["ALTER TABLE<br/>Sửa cấu trúc"]
        DDL --> D3["DROP TABLE<br/>Xóa bảng"]

        D1 --> CT1["Tên bảng"]
        D1 --> CT2["Cột + Kiểu dữ liệu"]
        D1 --> CT3["Constraints"]

        D2 --> A1["ADD COLUMN"]
        D2 --> A2["DROP COLUMN"]
        D2 --> A3["MODIFY COLUMN"]

        D3 --> Danger["⚠ Không thể khôi phục"]
    end

    %% =========================
    %% LIÊN KẾT LOGIC
    %% =========================
    DT -->|Chọn đúng| D1
    CS -->|Áp dụng khi| D1
    CS -->|Có thể thêm bằng| D2

    %% =========================
    %% STYLE
    %% =========================
    classDef core fill:#2563eb,color:white,stroke:#1e3a8a,stroke-width:2px;
    class DT,CS,DDL core;
```

# Ex1
```sql
create Table class
(
    Id        int         NOT NULL primary key,
    ClassName varchar(50) NOT NULL,
    Year      YEAR        NOT NULL
);

create Table students
(
    Id          int          not null primary key,
    FullName    varchar(255) NOT NULL,
    DateOfBirth Date         not null,
    ClassId     int,
    foreign key (ClassId) references class (Id)
);
```


# Ex2
```sql
create table Subject
(
    idMon  int primary key,
    MaMon  varChar(255) NOT NULL UNIQUE,
    credit int check (credit > 0)

);

create table students
(
    id         int primary key,
    MaSinhVien varchar(255) UNIQUE not null,
    HoTen      varchar(255)        Not Null

);

create table DANG_Ki
(
    MaxSv varchar(255),
    MaxMH VARCHAR(255),
    PRIMARY KEY (MaxSv, MaxMH),

    FOREIGN KEY (MaxSv) references students (Masinhvien),
    FOREIGN KEY (MaxMH) references Subject (MaMon)
);

```


# Ex3
```sql
create table student
(
    id         int AUTO_INCREMENT primary key,
    MaSinhVien varchar(255) unique not null,
    HoTen      varchar(255)        not null
);
CREATE table enrollment
(
    MaSinhVien varchar(255),
    MaMon      varchar(255),
    NgayDangKi date not null,

    Primary key (MaSinhVien, MaMon),

    foreign key (MaSinhVien) REFERENCES student (MaSinhVien),
    foreign key (MaMon) references subject (MaMon)
);
```
#4
```sql
Create Table Teacher
(
    MaGiangVien VARCHAR(255) primary key,
    HoTen       varchar(255)        Not NUll,
    Email       varchar(255) unique not null
);


create table subject
(
    id       int auto_increment primary key,
    MaMon    varchar(255) unique not null,
    TenMon   varchar(255)        not null,
    SoTinChi int check (SoTinChi > 0)
);


ALTER TABLE subject
    ADD MaGiangVien VARCHAR(255);


alter table subject
    ADD constraint fk_Subject_teacher
        FOREIGN KEY (MaGiangVien) references Teacher (MaGiangVien);
```

#5
```sql
create table Student
(
    idStudents  int auto_increment primary key,
    FullName    varchar(255) not null,
    StudentCode varchar(255) not null unique,
    DateOB      Date         not null
);
# Môn học
create table Subject
(
    idSubject    int auto_increment primary key,
    SubjectName  varchar(255) not null,
    SubjectCode  varchar(255) not null unique,
    NumberCredit int check (NumberCredit > 0)
);
# Điểm quá trình
create table ScoreTheProcess
(
    idStudent int,
    idSubject int,
    point     int check (point > 0 and point < 11),
    primary key (idStudent, idSubject),
    foreign key (idStudent) references Student (idStudents),
    foreign key (idSubject) references Subject (idSubject)
);
# Điểm cuối kỳ
create table FinalScore
(
    idStudent int,
    idSubject int,
    point     int check (point > 0 and point < 11),
    primary key (idStudent, idSubject),
    foreign key (idStudent) references Student (idStudents),
    foreign key (idSubject) references Subject (idSubject)
);
```

#6
```sql

# Sinh viên
create table students
(
    idStudents  int auto_increment primary key,
    FullName    varchar(255) not null,
    StudentCode varchar(255) not null unique,
    DateOB      date         not null,
    Email       varchar(255) not null unique
);

# Môn học
create table Subject
(
    idSubject    int auto_increment primary key,
    SubjectName  varchar(255) not null,
    SubjectCode  varchar(255) not null unique,
    NumberCredit int check (NumberCredit > 0)
);
# Lớp học
create table classes
(
    idClass   int auto_increment primary key,
    ClassName varchar(255)        not null,
    ClassCode varchar(255) unique not null
);

# Giảng viên
create table teacher
(
    idTeacher int auto_increment primary key,
    TeachCode varchar(255) unique not null,
    FullName  varchar(255)        not null,
    DateOB    DATE                not null,
    Email     varchar(255)        not null UNIQUE
);

# Đăng ký môn học
CREATE TABLE enrollment
(
    IdStudent INT NOT NULL,
    IdSubject INT NOT NULL,
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (IdStudent, IdSubject),

    FOREIGN KEY (IdStudent) REFERENCES students (idStudents),
    FOREIGN KEY (IdSubject) REFERENCES Subject (idSubject)
);

# Kết quả học tập
create table LearningOutcomes
(
    idStudent int         not null,
    point     int check ( point > 0 and point < 11 ),
    Rating    varchar(20) not null,
    primary key (IdStudent),
    FOREIGN KEY (IdStudent) references students (idStudents)
);
```

#7

```sql
CREATE TABLE Customer
(
    customer_id  SERIAL PRIMARY KEY,
    full_name    VARCHAR(100) NOT NULL,
    cccd         VARCHAR(12)  NOT NULL UNIQUE,
    phone_number VARCHAR(15)  NOT NULL UNIQUE,
    email        VARCHAR(100),
    created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Account
(
    account_id     SERIAL PRIMARY KEY,
    customer_id    INT            NOT NULL,
    account_number VARCHAR(20)    NOT NULL UNIQUE,
    balance        NUMERIC(18, 2) NOT NULL DEFAULT 0,
    status         VARCHAR(20)             DEFAULT 'Active',
    created_at     TIMESTAMP               DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_account_customer
        FOREIGN KEY (customer_id)
            REFERENCES Customer (customer_id),

    CONSTRAINT chk_balance_non_negative
        CHECK (balance >= 0)
);

CREATE TABLE Partner
(
    partner_id   SERIAL PRIMARY KEY,
    partner_name VARCHAR(100) NOT NULL UNIQUE,
    partner_code VARCHAR(50)  NOT NULL UNIQUE,
    created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE TuitionBill
(
    bill_id      SERIAL PRIMARY KEY,
    partner_id   INT            NOT NULL,
    bill_code    VARCHAR(50)    NOT NULL UNIQUE,
    student_name VARCHAR(100)   NOT NULL,
    amount       NUMERIC(18, 2) NOT NULL,
    status       VARCHAR(20)    NOT NULL DEFAULT 'Unpaid',
    created_at   TIMESTAMP               DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_bill_partner
        FOREIGN KEY (partner_id)
            REFERENCES Partner (partner_id),

    CONSTRAINT chk_bill_amount_positive
        CHECK (amount > 0),

    CONSTRAINT chk_bill_status
        CHECK (status IN ('Unpaid', 'Paid', 'Cancelled'))
);

CREATE TABLE Transaction
(
    transaction_id   SERIAL PRIMARY KEY,
    account_id       INT            NOT NULL,
    bill_id          INT UNIQUE,
    amount           NUMERIC(18, 2) NOT NULL,
    transaction_type VARCHAR(20)    NOT NULL DEFAULT 'TuitionPayment',
    status           VARCHAR(20)    NOT NULL DEFAULT 'Pending',
    created_at       TIMESTAMP               DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_transaction_account
        FOREIGN KEY (account_id)
            REFERENCES Account (account_id),

    CONSTRAINT fk_transaction_bill
        FOREIGN KEY (bill_id)
            REFERENCES TuitionBill (bill_id),

    CONSTRAINT chk_transaction_amount_positive
        CHECK (amount > 0),

    CONSTRAINT chk_transaction_status
        CHECK (status IN ('Pending', 'Success', 'Failed'))
);




```
