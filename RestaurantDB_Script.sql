-- =====================================================
-- SCRIPT TẠO CSDL HỆ THỐNG ĐẶT MÓN TRONG NHÀ HÀNG
-- Ngày tạo: 04/10/2025
-- Mô tả: Script tạo database, bảng và dữ liệu mẫu
-- =====================================================

-- Tạo database
CREATE DATABASE RestaurantDB;
GO

-- Sử dụng database vừa tạo
USE RestaurantDB;
GO

-- =====================================================
-- TẠO CÁC BẢNG
-- =====================================================

-- 1. Bảng DANH_MUC (tạo trước vì MON_AN tham chiếu đến)
CREATE TABLE DANH_MUC (
    MaDM VARCHAR(10) PRIMARY KEY,
    TenDM NVARCHAR(50) NOT NULL,
    MoTa NVARCHAR(200)
);
GO

-- 2. Bảng KHACH_HANG
CREATE TABLE KHACH_HANG (
    MaKH VARCHAR(10) PRIMARY KEY,
    TenKH NVARCHAR(100) NOT NULL,
    SDT VARCHAR(15),
    DiaChi NVARCHAR(200),
    Email VARCHAR(100),
    NgayDangKy DATE DEFAULT GETDATE()
);
GO

-- 3. Bảng MON_AN
CREATE TABLE MON_AN (
    MaMon VARCHAR(10) PRIMARY KEY,
    TenMon NVARCHAR(100) NOT NULL,
    MaDM VARCHAR(10) NOT NULL,
    Gia DECIMAL(10,2) NOT NULL CHECK (Gia > 0),
    MoTa NVARCHAR(500),
    HinhAnh VARCHAR(200),
    TrangThai BIT DEFAULT 1, -- 1: Còn, 0: Hết
    FOREIGN KEY (MaDM) REFERENCES DANH_MUC(MaDM)
);
GO

-- 4. Bảng DON_HANG
CREATE TABLE DON_HANG (
    MaDH VARCHAR(10) PRIMARY KEY,
    MaKH VARCHAR(10) NOT NULL,
    NgayDat DATETIME DEFAULT GETDATE(),
    TongTien DECIMAL(12,2) DEFAULT 0,
    TrangThai NVARCHAR(20) DEFAULT N'Chờ xử lý',
    GhiChu NVARCHAR(500),
    FOREIGN KEY (MaKH) REFERENCES KHACH_HANG(MaKH)
);
GO

-- 5. Bảng CHI_TIET_DON_HANG
CREATE TABLE CHI_TIET_DON_HANG (
    MaDH VARCHAR(10),
    MaMon VARCHAR(10),
    SoLuong INT NOT NULL CHECK (SoLuong > 0),
    DonGia DECIMAL(10,2) NOT NULL CHECK (DonGia > 0),
    ThanhTien AS (SoLuong * DonGia) PERSISTED, -- Computed column
    PRIMARY KEY (MaDH, MaMon),
    FOREIGN KEY (MaDH) REFERENCES DON_HANG(MaDH) ON DELETE CASCADE,
    FOREIGN KEY (MaMon) REFERENCES MON_AN(MaMon)
);
GO

-- 6. Bảng HOA_DON
CREATE TABLE HOA_DON (
    MaHD VARCHAR(10) PRIMARY KEY,
    MaDH VARCHAR(10) UNIQUE NOT NULL,
    NgayThanhToan DATETIME DEFAULT GETDATE(),
    HinhThucTT NVARCHAR(20) DEFAULT N'Tiền mặt',
    TongTien DECIMAL(12,2) NOT NULL,
    VAT DECIMAL(12,2) DEFAULT 0,
    ThanhToan AS (TongTien + VAT) PERSISTED, -- Computed column
    FOREIGN KEY (MaDH) REFERENCES DON_HANG(MaDH)
);
GO

-- =====================================================
-- TẠO CHỈ MỤC TỐI ƯU HÓA
-- =====================================================

-- Chỉ mục cho tìm kiếm khách hàng
CREATE INDEX IX_KhachHang_SDT ON KHACH_HANG(SDT);
CREATE INDEX IX_KhachHang_Email ON KHACH_HANG(Email);
GO

-- Chỉ mục cho tìm kiếm đơn hàng
CREATE INDEX IX_DonHang_NgayDat ON DON_HANG(NgayDat);
CREATE INDEX IX_DonHang_TrangThai ON DON_HANG(TrangThai);
GO

-- Chỉ mục cho món ăn
CREATE INDEX IX_MonAn_DanhMuc ON MON_AN(MaDM);
CREATE INDEX IX_MonAn_TrangThai ON MON_AN(TrangThai);
CREATE INDEX IX_MonAn_Gia ON MON_AN(Gia);
GO

-- =====================================================
-- THÊM DỮ LIỆU MẪU
-- =====================================================

-- 1. Dữ liệu mẫu cho DANH_MUC
INSERT INTO DANH_MUC (MaDM, TenDM, MoTa) VALUES
('DM001', N'Món khai vị', N'Các món ăn khai vị, appetizer'),
('DM002', N'Món chính', N'Các món ăn chính, main course'),
('DM003', N'Món tráng miệng', N'Các món tráng miệng, dessert'),
('DM004', N'Nước uống', N'Các loại nước uống, đồ uống'),
('DM005', N'Món lẩu', N'Các loại lẩu cho nhóm'),
('DM006', N'Món nướng', N'Các món nướng BBQ');
GO

-- 2. Dữ liệu mẫu cho KHACH_HANG
INSERT INTO KHACH_HANG (MaKH, TenKH, SDT, DiaChi, Email, NgayDangKy) VALUES
('KH001', N'Nguyễn Văn An', '0901234567', N'123 Nguyễn Trãi, Q.5, TP.HCM', 'nguyenvanan@email.com', '2024-01-15'),
('KH002', N'Trần Thị Bình', '0912345678', N'456 Lê Lợi, Q.1, TP.HCM', 'tranthibinh@email.com', '2024-02-20'),
('KH003', N'Lê Hoàng Cường', '0923456789', N'789 Trần Hưng Đạo, Q.1, TP.HCM', 'lehoangcuong@email.com', '2024-03-10'),
('KH004', N'Phạm Thị Dung', '0934567890', N'321 Hai Bà Trưng, Q.3, TP.HCM', 'phamthidung@email.com', '2024-04-05'),
('KH005', N'Hoàng Văn Em', '0945678901', N'654 Pasteur, Q.3, TP.HCM', 'hoangvanem@email.com', '2024-05-12'),
('KH006', N'Võ Thị Phương', '0956789012', N'987 Cách Mạng Tháng 8, Q.10, TP.HCM', 'vothiphuong@email.com', '2024-06-18');
GO

-- 3. Dữ liệu mẫu cho MON_AN
INSERT INTO MON_AN (MaMon, TenMon, MaDM, Gia, MoTa, HinhAnh, TrangThai) VALUES
-- Món khai vị
('MA001', N'Gỏi cuốn tôm thịt', 'DM001', 35000, N'Gỏi cuốn tươi với tôm và thịt heo', 'goi_cuon.jpg', 1),
('MA002', N'Nem nướng Nha Trang', 'DM001', 45000, N'Nem nướng đặc sản Nha Trang', 'nem_nuong.jpg', 1),
('MA003', N'Chả cá Lã Vọng', 'DM001', 55000, N'Chả cá truyền thống Hà Nội', 'cha_ca.jpg', 1),

-- Món chính
('MA004', N'Cơm tấm sườn bì chả', 'DM002', 65000, N'Cơm tấm truyền thống Sài Gòn', 'com_tam.jpg', 1),
('MA005', N'Phở bò tái', 'DM002', 70000, N'Phở bò tái truyền thống', 'pho_bo.jpg', 1),
('MA006', N'Bún bò Huế', 'DM002', 68000, N'Bún bò Huế cay đậm đà', 'bun_bo_hue.jpg', 1),
('MA007', N'Gà nướng lu', 'DM002', 180000, N'Gà ta nướng lu nguyên con', 'ga_nuong_lu.jpg', 1),
('MA008', N'Cá lóc nướng trui', 'DM002', 220000, N'Cá lóc nướng trui đặc sản miền Tây', 'ca_loc_nuong.jpg', 1),

-- Món lẩu
('MA009', N'Lẩu thái hải sản', 'DM005', 350000, N'Lẩu thái chua cay với hải sản tươi', 'lau_thai.jpg', 1),
('MA010', N'Lẩu gà lá giang', 'DM005', 280000, N'Lẩu gà với lá giang thơm ngon', 'lau_ga.jpg', 1),

-- Món nướng
('MA011', N'Thịt ba chỉ nướng', 'DM006', 120000, N'Thịt ba chỉ nướng BBQ', 'ba_chi_nuong.jpg', 1),
('MA012', N'Tôm nướng muối ớt', 'DM006', 150000, N'Tôm sú nướng muối ớt', 'tom_nuong.jpg', 1),

-- Món tráng miệng
('MA013', N'Chè đậu xanh', 'DM003', 25000, N'Chè đậu xanh truyền thống', 'che_dau_xanh.jpg', 1),
('MA014', N'Bánh flan', 'DM003', 30000, N'Bánh flan caramen', 'banh_flan.jpg', 1),
('MA015', N'Kem dừa', 'DM003', 35000, N'Kem dừa tươi mát', 'kem_dua.jpg', 1),

-- Nước uống
('MA016', N'Nước dừa tươi', 'DM004', 20000, N'Nước dừa tươi nguyên trái', 'nuoc_dua.jpg', 1),
('MA017', N'Trà đá', 'DM004', 5000, N'Trà đá truyền thống', 'tra_da.jpg', 1),
('MA018', N'Nước cam vắt', 'DM004', 25000, N'Nước cam tươi vắt', 'nuoc_cam.jpg', 1),
('MA019', N'Bia Saigon', 'DM004', 18000, N'Bia Saigon lon 330ml', 'bia_saigon.jpg', 1),
('MA020', N'Coca Cola', 'DM004', 15000, N'Coca Cola lon 330ml', 'coca.jpg', 1);
GO

-- 4. Dữ liệu mẫu cho DON_HANG
INSERT INTO DON_HANG (MaDH, MaKH, NgayDat, TrangThai, GhiChu) VALUES
('DH001', 'KH001', '2024-10-01 12:30:00', N'Hoàn thành', N'Giao hàng tận nơi'),
('DH002', 'KH002', '2024-10-02 18:45:00', N'Đang chế biến', N'Không cay'),
('DH003', 'KH003', '2024-10-02 19:15:00', N'Chờ xử lý', N'Bàn số 5'),
('DH004', 'KH004', '2024-10-03 13:20:00', N'Hoàn thành', N'Thanh toán thẻ'),
('DH005', 'KH005', '2024-10-03 20:00:00', N'Đang giao hàng', N'Gọi trước khi giao'),
('DH006', 'KH006', '2024-10-04 11:30:00', N'Chờ xử lý', N'Bàn VIP');
GO

-- 5. Dữ liệu mẫu cho CHI_TIET_DON_HANG
INSERT INTO CHI_TIET_DON_HANG (MaDH, MaMon, SoLuong, DonGia) VALUES
-- Đơn hàng DH001
('DH001', 'MA001', 2, 35000), -- Gỏi cuốn tôm thịt x2
('DH001', 'MA005', 1, 70000), -- Phở bò tái x1
('DH001', 'MA016', 1, 20000), -- Nước dừa tươi x1

-- Đơn hàng DH002
('DH002', 'MA004', 1, 65000), -- Cơm tấm sườn bì chả x1
('DH002', 'MA017', 2, 5000),  -- Trà đá x2
('DH002', 'MA014', 1, 30000), -- Bánh flan x1

-- Đơn hàng DH003
('DH003', 'MA009', 1, 350000), -- Lẩu thái hải sản x1
('DH003', 'MA019', 4, 18000),  -- Bia Saigon x4

-- Đơn hàng DH004
('DH004', 'MA002', 3, 45000), -- Nem nướng Nha Trang x3
('DH004', 'MA006', 2, 68000), -- Bún bò Huế x2
('DH004', 'MA018', 2, 25000), -- Nước cam vắt x2

-- Đơn hàng DH005
('DH005', 'MA007', 1, 180000), -- Gà nướng lu x1
('DH005', 'MA011', 1, 120000), -- Thịt ba chỉ nướng x1
('DH005', 'MA015', 2, 35000),  -- Kem dừa x2

-- Đơn hàng DH006
('DH006', 'MA008', 1, 220000), -- Cá lóc nướng trui x1
('DH006', 'MA012', 1, 150000), -- Tôm nướng muối ớt x1
('DH006', 'MA020', 3, 15000);  -- Coca Cola x3
GO

-- Cập nhật tổng tiền cho các đơn hàng
UPDATE DON_HANG 
SET TongTien = (
    SELECT SUM(ThanhTien) 
    FROM CHI_TIET_DON_HANG 
    WHERE CHI_TIET_DON_HANG.MaDH = DON_HANG.MaDH
);
GO

-- 6. Dữ liệu mẫu cho HOA_DON (chỉ cho các đơn hàng đã hoàn thành)
INSERT INTO HOA_DON (MaHD, MaDH, NgayThanhToan, HinhThucTT, TongTien, VAT) VALUES
('HD001', 'DH001', '2024-10-01 13:00:00', N'Tiền mặt', 125000, 12500),
('HD004', 'DH004', '2024-10-03 14:00:00', N'Thẻ tín dụng', 321000, 32100);
GO

-- =====================================================
-- TẠO STORED PROCEDURES
-- =====================================================

-- Procedure tạo đơn hàng mới
CREATE PROCEDURE sp_TaoDonHang
    @MaKH VARCHAR(10),
    @GhiChu NVARCHAR(500) = NULL
AS
BEGIN
    DECLARE @MaDH VARCHAR(10)
    DECLARE @STT INT
    
    -- Tạo mã đơn hàng tự động
    SELECT @STT = ISNULL(MAX(CAST(SUBSTRING(MaDH, 3, 3) AS INT)), 0) + 1
    FROM DON_HANG
    
    SET @MaDH = 'DH' + RIGHT('000' + CAST(@STT AS VARCHAR(3)), 3)
    
    INSERT INTO DON_HANG (MaDH, MaKH, GhiChu)
    VALUES (@MaDH, @MaKH, @GhiChu)
    
    SELECT @MaDH as MaDonHang
END
GO

-- Procedure thêm chi tiết đơn hàng
CREATE PROCEDURE sp_ThemChiTietDonHang
    @MaDH VARCHAR(10),
    @MaMon VARCHAR(10),
    @SoLuong INT
AS
BEGIN
    DECLARE @DonGia DECIMAL(10,2)
    
    -- Lấy giá món ăn hiện tại
    SELECT @DonGia = Gia FROM MON_AN WHERE MaMon = @MaMon
    
    -- Kiểm tra món ăn có tồn tại và còn bán không
    IF @DonGia IS NULL OR NOT EXISTS(SELECT 1 FROM MON_AN WHERE MaMon = @MaMon AND TrangThai = 1)
    BEGIN
        RAISERROR(N'Món ăn không tồn tại hoặc đã hết!', 16, 1)
        RETURN
    END
    
    -- Thêm hoặc cập nhật chi tiết đơn hàng
    IF EXISTS(SELECT 1 FROM CHI_TIET_DON_HANG WHERE MaDH = @MaDH AND MaMon = @MaMon)
    BEGIN
        UPDATE CHI_TIET_DON_HANG 
        SET SoLuong = SoLuong + @SoLuong
        WHERE MaDH = @MaDH AND MaMon = @MaMon
    END
    ELSE
    BEGIN
        INSERT INTO CHI_TIET_DON_HANG (MaDH, MaMon, SoLuong, DonGia)
        VALUES (@MaDH, @MaMon, @SoLuong, @DonGia)
    END
    
    -- Cập nhật tổng tiền đơn hàng
    UPDATE DON_HANG 
    SET TongTien = (SELECT SUM(ThanhTien) FROM CHI_TIET_DON_HANG WHERE MaDH = @MaDH)
    WHERE MaDH = @MaDH
END
GO

-- Procedure tạo hóa đơn
CREATE PROCEDURE sp_TaoHoaDon
    @MaDH VARCHAR(10),
    @HinhThucTT NVARCHAR(20) = N'Tiền mặt',
    @PhanTramVAT DECIMAL(5,2) = 10
AS
BEGIN
    DECLARE @MaHD VARCHAR(10)
    DECLARE @TongTien DECIMAL(12,2)
    DECLARE @VAT DECIMAL(12,2)
    DECLARE @STT INT
    
    -- Lấy tổng tiền đơn hàng
    SELECT @TongTien = TongTien FROM DON_HANG WHERE MaDH = @MaDH
    
    IF @TongTien IS NULL
    BEGIN
        RAISERROR(N'Đơn hàng không tồn tại!', 16, 1)
        RETURN
    END
    
    -- Tính VAT
    SET @VAT = @TongTien * @PhanTramVAT / 100
    
    -- Tạo mã hóa đơn
    SELECT @STT = ISNULL(MAX(CAST(SUBSTRING(MaHD, 3, 3) AS INT)), 0) + 1
    FROM HOA_DON
    
    SET @MaHD = 'HD' + RIGHT('000' + CAST(@STT AS VARCHAR(3)), 3)
    
    -- Thêm hóa đơn
    INSERT INTO HOA_DON (MaHD, MaDH, HinhThucTT, TongTien, VAT)
    VALUES (@MaHD, @MaDH, @HinhThucTT, @TongTien, @VAT)
    
    -- Cập nhật trạng thái đơn hàng
    UPDATE DON_HANG SET TrangThai = N'Hoàn thành' WHERE MaDH = @MaDH
    
    SELECT @MaHD as MaHoaDon, (@TongTien + @VAT) as TongThanhToan
END
GO

-- =====================================================
-- TẠO VIEWS
-- =====================================================

-- View chi tiết đơn hàng
CREATE VIEW vw_ChiTietDonHang AS
SELECT 
    dh.MaDH,
    kh.TenKH,
    kh.SDT,
    dh.NgayDat,
    ma.TenMon,
    dm.TenDM as DanhMuc,
    ct.SoLuong,
    ct.DonGia,
    ct.ThanhTien,
    dh.TrangThai,
    dh.GhiChu
FROM DON_HANG dh
JOIN KHACH_HANG kh ON dh.MaKH = kh.MaKH
JOIN CHI_TIET_DON_HANG ct ON dh.MaDH = ct.MaDH
JOIN MON_AN ma ON ct.MaMon = ma.MaMon
JOIN DANH_MUC dm ON ma.MaDM = dm.MaDM;
GO

-- View thống kê doanh thu theo ngày
CREATE VIEW vw_DoanhThuTheoNgay AS
SELECT 
    CAST(dh.NgayDat AS DATE) as NgayBan,
    COUNT(DISTINCT dh.MaDH) as SoDonHang,
    COUNT(DISTINCT dh.MaKH) as SoKhachHang,
    SUM(dh.TongTien) as DoanhThu,
    AVG(dh.TongTien) as TrungBinhDonHang
FROM DON_HANG dh
WHERE dh.TrangThai = N'Hoàn thành'
GROUP BY CAST(dh.NgayDat AS DATE);
GO

-- View món ăn bán chạy
CREATE VIEW vw_MonBanChay AS
SELECT 
    ma.MaMon,
    ma.TenMon,
    dm.TenDM as DanhMuc,
    SUM(ct.SoLuong) as TongSoLuongBan,
    SUM(ct.ThanhTien) as TongDoanhThu,
    COUNT(DISTINCT ct.MaDH) as SoDonHang
FROM MON_AN ma
JOIN CHI_TIET_DON_HANG ct ON ma.MaMon = ct.MaMon
JOIN DON_HANG dh ON ct.MaDH = dh.MaDH
JOIN DANH_MUC dm ON ma.MaDM = dm.MaDM
WHERE dh.TrangThai = N'Hoàn thành'
GROUP BY ma.MaMon, ma.TenMon, dm.TenDM;
GO

-- =====================================================
-- TẠO TRIGGERS
-- =====================================================

-- Trigger cập nhật tổng tiền khi thêm/sửa/xóa chi tiết đơn hàng
CREATE TRIGGER tr_CapNhatTongTien
ON CHI_TIET_DON_HANG
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Cập nhật tổng tiền cho các đơn hàng bị ảnh hưởng
    UPDATE DON_HANG 
    SET TongTien = ISNULL((
        SELECT SUM(ThanhTien) 
        FROM CHI_TIET_DON_HANG 
        WHERE CHI_TIET_DON_HANG.MaDH = DON_HANG.MaDH
    ), 0)
    WHERE MaDH IN (
        SELECT DISTINCT MaDH FROM inserted
        UNION
        SELECT DISTINCT MaDH FROM deleted
    );
END
GO

-- =====================================================
-- KIỂM TRA DỮ LIỆU
-- =====================================================

PRINT N'=== KIỂM TRA DỮ LIỆU VỪA TẠO ==='

SELECT N'Số lượng danh mục: ' + CAST(COUNT(*) AS NVARCHAR(10)) FROM DANH_MUC
UNION ALL
SELECT N'Số lượng khách hàng: ' + CAST(COUNT(*) AS NVARCHAR(10)) FROM KHACH_HANG
UNION ALL
SELECT N'Số lượng món ăn: ' + CAST(COUNT(*) AS NVARCHAR(10)) FROM MON_AN
UNION ALL
SELECT N'Số lượng đơn hàng: ' + CAST(COUNT(*) AS NVARCHAR(10)) FROM DON_HANG
UNION ALL
SELECT N'Số lượng hóa đơn: ' + CAST(COUNT(*) AS NVARCHAR(10)) FROM HOA_DON;

PRINT N'=== HOÀN TẤT TẠO CSDL ==='
GO