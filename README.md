# BÁO CÁO PHÂN TÍCH VÀ THIẾT KẾ CSDL
## ĐỀ TÀI: HỆ THỐNG ĐẶT MÓN TRONG NHÀ HÀNG

---

## 1. GIỚI THIỆU ĐỀ TÀI

### 1.1. Tên đề tài
Hệ thống quản lý đặt món trong nhà hàng

### 1.2. Mục tiêu
- Xây dựng hệ thống quản lý đặt món hiệu quả
- Tối ưu hóa quy trình phục vụ khách hàng
- Quản lý thông tin món ăn, khách hàng và đơn hàng

### 1.3. Phạm vi ứng dụng
- Quản lý thông tin khách hàng
- Quản lý menu và món ăn
- Xử lý đơn đặt món
- Quản lý thanh toán
- Báo cáo doanh thu

---

## 2. PHÂN TÍCH YÊU CẦU

### 2.1. Yêu cầu chức năng

#### 2.1.1. Quản lý khách hàng
- Đăng ký thông tin khách hàng mới
- Cập nhật thông tin khách hàng
- Tra cứu lịch sử đặt món

#### 2.1.2. Quản lý menu
- Thêm, sửa, xóa món ăn
- Phân loại món ăn theo danh mục
- Cập nhật giá cả và tình trạng món ăn

#### 2.1.3. Quản lý đặt món
- Tạo đơn đặt món mới
- Cập nhật trạng thái đơn hàng
- Hủy đơn hàng

#### 2.1.4. Quản lý thanh toán
- Tính tổng tiền đơn hàng
- Xử lý các hình thức thanh toán
- In hóa đơn

### 2.2. Yêu cầu phi chức năng
- Tốc độ xử lý nhanh
- Giao diện thân thiện
- Bảo mật thông tin
- Khả năng mở rộng

---

## 3. THIẾT KẾ CSDL

### 3.1. Xác định thực thể (Entity)

#### 3.1.1. KHACH_HANG
- Mô tả: Lưu trữ thông tin khách hàng
- Thuộc tính:
  - MaKH (Primary Key): Mã khách hàng
  - TenKH: Tên khách hàng
  - SDT: Số điện thoại
  - DiaChi: Địa chỉ
  - Email: Email khách hàng
  - NgayDangKy: Ngày đăng ký

#### 3.1.2. DANH_MUC
- Mô tả: Phân loại món ăn
- Thuộc tính:
  - MaDM (Primary Key): Mã danh mục
  - TenDM: Tên danh mục
  - MoTa: Mô tả danh mục

#### 3.1.3. MON_AN
- Mô tả: Thông tin các món ăn
- Thuộc tính:
  - MaMon (Primary Key): Mã món ăn
  - TenMon: Tên món ăn
  - MaDM (Foreign Key): Mã danh mục
  - Gia: Giá món ăn
  - MoTa: Mô tả món ăn
  - HinhAnh: Đường dẫn hình ảnh
  - TrangThai: Trạng thái (còn/hết)

#### 3.1.4. DON_HANG
- Mô tả: Thông tin đơn đặt món
- Thuộc tính:
  - MaDH (Primary Key): Mã đơn hàng
  - MaKH (Foreign Key): Mã khách hàng
  - NgayDat: Ngày đặt
  - TongTien: Tổng tiền
  - TrangThai: Trạng thái đơn hàng
  - GhiChu: Ghi chú

#### 3.1.5. CHI_TIET_DON_HANG
- Mô tả: Chi tiết các món trong đơn hàng
- Thuộc tính:
  - MaDH (Foreign Key): Mã đơn hàng
  - MaMon (Foreign Key): Mã món ăn
  - SoLuong: Số lượng
  - DonGia: Đơn giá
  - ThanhTien: Thành tiền

#### 3.1.6. HOA_DON
- Mô tả: Thông tin hóa đơn thanh toán
- Thuộc tính:
  - MaHD (Primary Key): Mã hóa đơn
  - MaDH (Foreign Key): Mã đơn hàng
  - NgayThanhToan: Ngày thanh toán
  - HinhThucTT: Hình thức thanh toán
  - TongTien: Tổng tiền
  - VAT: Thuế VAT

### 3.2. Xác định mối quan hệ (Relationship)

#### 3.2.1. KHACH_HANG - DON_HANG
- Loại quan hệ: 1:N (một khách hàng có thể có nhiều đơn hàng)
- Ràng buộc: Một đơn hàng thuộc về một khách hàng duy nhất

#### 3.2.2. DANH_MUC - MON_AN
- Loại quan hệ: 1:N (một danh mục có nhiều món ăn)
- Ràng buộc: Một món ăn thuộc về một danh mục

#### 3.2.3. DON_HANG - CHI_TIET_DON_HANG
- Loại quan hệ: 1:N (một đơn hàng có nhiều chi tiết)
- Ràng buộc: Mỗi chi tiết thuộc về một đơn hàng

#### 3.2.4. MON_AN - CHI_TIET_DON_HANG
- Loại quan hệ: 1:N (một món ăn có thể trong nhiều chi tiết đơn hàng)
- Ràng buộc: Mỗi chi tiết tham chiếu đến một món ăn

#### 3.2.5. DON_HANG - HOA_DON
- Loại quan hệ: 1:1 (một đơn hàng có một hóa đơn)
- Ràng buộc: Mỗi hóa đơn tương ứng với một đơn hàng

---

## 4. MÔ HÌNH THỰC THỂ LIÊN KẾT (ERD)

```
[KHACH_HANG] ----< [DON_HANG] >---- [HOA_DON]
                        |
                        |
                        v
               [CHI_TIET_DON_HANG]
                        |
                        |
                        v
[DANH_MUC] ----< [MON_AN]
```

### 4.1. Giải thích ERD
- Khách hàng có thể đặt nhiều đơn hàng
- Mỗi đơn hàng bao gồm nhiều chi tiết món ăn
- Mỗi món ăn thuộc về một danh mục
- Mỗi đơn hàng có một hóa đơn tương ứng

---

## 5. THIẾT KẾ LOGIC

### 5.1. Danh sách bảng và thuộc tính

#### Bảng KHACH_HANG
```sql
CREATE TABLE KHACH_HANG (
    MaKH VARCHAR(10) PRIMARY KEY,
    TenKH NVARCHAR(100) NOT NULL,
    SDT VARCHAR(15),
    DiaChi NVARCHAR(200),
    Email VARCHAR(100),
    NgayDangKy DATE DEFAULT GETDATE()
);
```

#### Bảng DANH_MUC
```sql
CREATE TABLE DANH_MUC (
    MaDM VARCHAR(10) PRIMARY KEY,
    TenDM NVARCHAR(50) NOT NULL,
    MoTa NVARCHAR(200)
);
```

#### Bảng MON_AN
```sql
CREATE TABLE MON_AN (
    MaMon VARCHAR(10) PRIMARY KEY,
    TenMon NVARCHAR(100) NOT NULL,
    MaDM VARCHAR(10),
    Gia DECIMAL(10,2) NOT NULL,
    MoTa NVARCHAR(500),
    HinhAnh VARCHAR(200),
    TrangThai BIT DEFAULT 1,
    FOREIGN KEY (MaDM) REFERENCES DANH_MUC(MaDM)
);
```

#### Bảng DON_HANG
```sql
CREATE TABLE DON_HANG (
    MaDH VARCHAR(10) PRIMARY KEY,
    MaKH VARCHAR(10),
    NgayDat DATETIME DEFAULT GETDATE(),
    TongTien DECIMAL(12,2),
    TrangThai NVARCHAR(20) DEFAULT N'Chờ xử lý',
    GhiChu NVARCHAR(500),
    FOREIGN KEY (MaKH) REFERENCES KHACH_HANG(MaKH)
);
```

#### Bảng CHI_TIET_DON_HANG
```sql
CREATE TABLE CHI_TIET_DON_HANG (
    MaDH VARCHAR(10),
    MaMon VARCHAR(10),
    SoLuong INT NOT NULL,
    DonGia DECIMAL(10,2) NOT NULL,
    ThanhTien DECIMAL(12,2),
    PRIMARY KEY (MaDH, MaMon),
    FOREIGN KEY (MaDH) REFERENCES DON_HANG(MaDH),
    FOREIGN KEY (MaMon) REFERENCES MON_AN(MaMon)
);
```

#### Bảng HOA_DON
```sql
CREATE TABLE HOA_DON (
    MaHD VARCHAR(10) PRIMARY KEY,
    MaDH VARCHAR(10) UNIQUE,
    NgayThanhToan DATETIME DEFAULT GETDATE(),
    HinhThucTT NVARCHAR(20),
    TongTien DECIMAL(12,2),
    VAT DECIMAL(12,2),
    FOREIGN KEY (MaDH) REFERENCES DON_HANG(MaDH)
);
```

### 5.2. Ràng buộc toàn vẹn

#### 5.2.1. Ràng buộc thực thể
- Mỗi bảng có khóa chính duy nhất
- Các thuộc tính NOT NULL được xác định rõ ràng

#### 5.2.2. Ràng buộc tham chiếu
- Khóa ngoại phải tham chiếu đến khóa chính tồn tại
- Cascade delete cho các bảng liên quan

#### 5.2.3. Ràng buộc miền giá trị
- Giá món ăn > 0
- Số lượng > 0
- Trạng thái trong danh sách giá trị hợp lệ

---

## 6. THIẾT KẾ VẬT LÝ

### 6.1. Chọn DBMS
- **Hệ quản trị CSDL**: Microsoft SQL Server
- **Lý do chọn**: 
  - Hiệu suất cao
  - Bảo mật tốt
  - Hỗ trợ đầy đủ SQL standard
  - Công cụ quản lý trực quan

### 6.2. Tối ưu hóa

#### 6.2.1. Chỉ mục (Index)
```sql
-- Chỉ mục cho tìm kiếm khách hàng
CREATE INDEX IX_KhachHang_SDT ON KHACH_HANG(SDT);
CREATE INDEX IX_KhachHang_Email ON KHACH_HANG(Email);

-- Chỉ mục cho tìm kiếm đơn hàng
CREATE INDEX IX_DonHang_NgayDat ON DON_HANG(NgayDat);
CREATE INDEX IX_DonHang_TrangThai ON DON_HANG(TrangThai);

-- Chỉ mục cho món ăn
CREATE INDEX IX_MonAn_DanhMuc ON MON_AN(MaDM);
CREATE INDEX IX_MonAn_TrangThai ON MON_AN(TrangThai);
```

#### 6.2.2. Phân trang dữ liệu
- Tách bảng lớn theo thời gian
- Lưu trữ dữ liệu cũ ở partition riêng

### 6.3. Backup và Recovery
- Backup đầy đủ hàng tuần
- Backup incremental hàng ngày
- Backup log transaction mỗi 15 phút

---

## 7. TRIỂN KHAI

### 7.1. Script tạo CSDL
```sql
-- Tạo database
CREATE DATABASE RestaurantDB;
USE RestaurantDB;

-- Tạo các bảng (như đã định nghĩa ở phần 5.1)
-- ...

-- Thêm dữ liệu mẫu
INSERT INTO DANH_MUC VALUES 
('DM001', N'Món chính', N'Các món ăn chính'),
('DM002', N'Khai vị', N'Món khai vị'),
('DM003', N'Tráng miệng', N'Món tráng miệng'),
('DM004', N'Nước uống', N'Các loại nước uống');

-- ...
```

### 7.2. Stored Procedures

#### 7.2.1. Tạo đơn hàng mới
```sql
CREATE PROCEDURE sp_TaoDonHang
    @MaKH VARCHAR(10),
    @GhiChu NVARCHAR(500) = NULL
AS
BEGIN
    DECLARE @MaDH VARCHAR(10)
    SET @MaDH = 'DH' + FORMAT(NEWID(), 'N')[1:8]
    
    INSERT INTO DON_HANG (MaDH, MaKH, GhiChu)
    VALUES (@MaDH, @MaKH, @GhiChu)
    
    SELECT @MaDH AS MaDonHang
END
```

#### 7.2.2. Thêm chi tiết đơn hàng
```sql
CREATE PROCEDURE sp_ThemChiTietDonHang
    @MaDH VARCHAR(10),
    @MaMon VARCHAR(10),
    @SoLuong INT
AS
BEGIN
    DECLARE @DonGia DECIMAL(10,2)
    
    SELECT @DonGia = Gia FROM MON_AN WHERE MaMon = @MaMon
    
    INSERT INTO CHI_TIET_DON_HANG (MaDH, MaMon, SoLuong, DonGia, ThanhTien)
    VALUES (@MaDH, @MaMon, @SoLuong, @DonGia, @SoLuong * @DonGia)
    
    -- Cập nhật tổng tiền đơn hàng
    UPDATE DON_HANG 
    SET TongTien = (SELECT SUM(ThanhTien) FROM CHI_TIET_DON_HANG WHERE MaDH = @MaDH)
    WHERE MaDH = @MaDH
END
```

### 7.3. Views

#### 7.3.1. View chi tiết đơn hàng
```sql
CREATE VIEW vw_ChiTietDonHang AS
SELECT 
    dh.MaDH,
    kh.TenKH,
    dh.NgayDat,
    ma.TenMon,
    ct.SoLuong,
    ct.DonGia,
    ct.ThanhTien,
    dh.TrangThai
FROM DON_HANG dh
JOIN KHACH_HANG kh ON dh.MaKH = kh.MaKH
JOIN CHI_TIET_DON_HANG ct ON dh.MaDH = ct.MaDH
JOIN MON_AN ma ON ct.MaMon = ma.MaMon
```

---

## 8. KẾT LUẬN

### 8.1. Đánh giá
- Hệ thống CSDL được thiết kế đáp ứng đầy đủ yêu cầu
- Cấu trúc linh hoạt, dễ mở rộng
- Đảm bảo tính toàn vẹn dữ liệu

### 8.2. Hướng phát triển
- Tích hợp thanh toán online
- Ứng dụng mobile cho khách hàng
- Hệ thống báo cáo nâng cao
- Tích hợp với hệ thống kho

### 8.3. Kiến nghị
- Đào tạo nhân viên sử dụng hệ thống
- Backup dữ liệu định kỳ
- Cập nhật bảo mật thường xuyên

---

## PHU LUC

### A. Từ điển dữ liệu
### B. Script SQL đầy đủ  
### C. Sơ đồ ERD chi tiết
### D. Giao diện người dùng mẫu

---

**Ngày hoàn thành**: [Điền ngày]  
**Người thực hiện**: [Điền tên]  
**Lớp**: [Điền lớp]  
**Giảng viên hướng dẫn**: [Điền tên GV]
