<h1>Ex1: </h1>

  
```mermaid
flowchart TD
    %% KHỐI 1: LÝ THUYẾT CSDL
    subgraph S1 ["1. LÝ THUYẾT: CSDL"]
        direction TB
        DB("Cơ Sở Dữ Liệu (CSDL)")
        
        DB --> DacDiem{"Đặc điểm"}
        DacDiem --> F1["Có cấu trúc"]
        DacDiem --> F2["Bảo mật & Toàn vẹn"]
        DacDiem --> F3["Độc lập & Chia sẻ"]
        
        DB --> PhanLoai{"Phân loại"}
        PhanLoai --> T1["SQL (Quan hệ)"]
        PhanLoai --> T2["NoSQL (Phi quan hệ)"]
    end

    %% KHỐI 2: THIẾT KẾ ERD
    subgraph S2 ["2. THIẾT KẾ: ERD"]
        direction TB
        ERD("Mô hình ERD")
        
        ERD --> TP{"Thành phần"}
        TP --o Ent["Thực thể (HCN)"]
        TP --o Rel["Quan hệ (Hình thoi)"]
        TP --o Att["Thuộc tính (Oval)"]
        
        ERD --> Step["Quy trình: Thực thể -> Quan hệ -> Thuộc tính -> Chuẩn hóa"]
    end

    %% KHỐI 3: CÔNG CỤ MYSQL
    subgraph S3 ["3. CÔNG CỤ: MySQL"]
        direction TB
        MySQL("Hệ quản trị MySQL")
        MySQL --> SV["Server (Xử lý)"]
        MySQL --> DT["Database (Chứa bảng)"]
        MySQL --> TB["Table (Hàng/Cột)"]
    end

    %% KHỐI 4: NGÔN NGỮ SQL
    subgraph S4 ["4. THAO TÁC: SQL"]
        direction TB
        SQL("Ngôn ngữ SQL")
        
        SQL --> DDL["DDL: Định nghĩa (Create/Drop)"]
        SQL --> DML["DML: Thao tác (Select/Insert)"]
        SQL --> DCL["DCL: Kiểm soát (Grant/Revoke)"]
    end

    %% LIÊN KẾT GIỮA CÁC GIAI ĐOẠN
    T1 ==>|Cần thiết kế trước bằng| ERD
    ERD ==>|Triển khai lên| MySQL
    MySQL -.->|Được điều khiển bởi| SQL

    %% ĐỊNH DẠNG MÀU SẮC ĐƠN GIẢN
    classDef highlight fill:#f96,stroke:#333,stroke-width:2px,color:white;
    class DB,ERD,MySQL,SQL highlight;
  
```
<h1>Ex2: </h1>
<h3>Có 3 thực thể chính</h4>
<ul>
  <li>Sinh Viên>Sinh
  <li>Môn Học>Mô>l
  <li>Mục Tiêu Học>Mục>
</ul>
<h3>2. Các thuộc tính cơ bản của từng thực thể</h3>
<p>thực thể sinh viên: Mã Sinh viên, tên Sinh viên </p>
<p>thực thể Môn Học: Mã môn học, tên môn học, số tín chỉ </p>
<p>thựcthể sinh viên: Mã mục tiêu, nội dung mục tiêu </p>
<h3>3. Mối quan hệ giữa các thực thể</h3>
<p>Một sinh viên, có thể học nhiều môn</p>
<p>Một môn học có thể có nhiều học sinh>Mp>
<p>Môn môn học có thể có nhiều mục tiêu</p>
<p>Mỗi mục tiêu học tập chỉ thuộc về một môn học>Mp>

<h1>Ex3: </h1>
<h1>Ex4: </h1>
<h1>Ex5: </h1>
<h1>Ex6: </h1>
<h1>Ex7: </h1>
