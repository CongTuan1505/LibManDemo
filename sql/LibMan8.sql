-- LibMan8 - script MySQL 8 (khop muc C.II "Thiet ke co so du lieu" cua file A)
CREATE DATABASE IF NOT EXISTS libman8 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE libman8;

DROP TABLE IF EXISTS tblLoanDetail8, tblLoanReceipt8, tblLibraryCard8,
    tblDocumentCopy8, tblDocument8, tblDocumentType8,
    tblLibrarian8, tblReader8, tblUser8;

CREATE TABLE tblUser8 (
    userId   INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,            -- SHA-256 (hex)
    role     VARCHAR(255) NOT NULL             -- READER | LIBRARIAN
);

-- 2 bang ke thua tblUser8: userId vua la PK vua la FK
CREATE TABLE tblReader8 (
    userId     INT PRIMARY KEY,
    readerCode VARCHAR(255) NOT NULL UNIQUE,
    fullName   VARCHAR(255) NOT NULL,
    email      VARCHAR(255),
    phone      VARCHAR(255),
    FOREIGN KEY (userId) REFERENCES tblUser8(userId)
);
CREATE TABLE tblLibrarian8 (
    userId    INT PRIMARY KEY,
    staffCode VARCHAR(255) NOT NULL UNIQUE,
    fullName  VARCHAR(255) NOT NULL,
    FOREIGN KEY (userId) REFERENCES tblUser8(userId)
);

CREATE TABLE tblDocumentType8 (
    typeId      INT AUTO_INCREMENT PRIMARY KEY,
    typeName    VARCHAR(255) NOT NULL,
    description TEXT
);
CREATE TABLE tblDocument8 (
    documentId  VARCHAR(255) PRIMARY KEY,
    title       VARCHAR(255) NOT NULL,
    author      VARCHAR(255),
    publisher   VARCHAR(255),
    publishYear INT,                            -- bo sung: wireframe/dac ta co "Nam xuat ban"
    description TEXT,                           -- bo sung: kich ban chinh co "Mo ta"
    typeId      INT NOT NULL,
    FOREIGN KEY (typeId) REFERENCES tblDocumentType8(typeId)
);
CREATE TABLE tblDocumentCopy8 (
    copyId     VARCHAR(255) PRIMARY KEY,
    documentId VARCHAR(255) NOT NULL,
    status     VARCHAR(255) NOT NULL DEFAULT 'AVAILABLE',   -- AVAILABLE | BORROWED
    FOREIGN KEY (documentId) REFERENCES tblDocument8(documentId)
);
CREATE TABLE tblLibraryCard8 (
    cardId       VARCHAR(255) PRIMARY KEY,
    readerUserId INT NOT NULL,
    issueDate    DATE,
    status       VARCHAR(255) NOT NULL,                      -- ACTIVE | ...
    FOREIGN KEY (readerUserId) REFERENCES tblReader8(userId)
);

CREATE TABLE tblLoanReceipt8 (
    loanId       INT AUTO_INCREMENT PRIMARY KEY,
    readerUserId INT NOT NULL,
    staffUserId  INT NOT NULL,
    loanDate     DATE NOT NULL,
    status       VARCHAR(255) NOT NULL,
    FOREIGN KEY (readerUserId) REFERENCES tblReader8(userId),
    FOREIGN KEY (staffUserId)  REFERENCES tblLibrarian8(userId)
);
CREATE TABLE tblLoanDetail8 (
    loanDetailId INT AUTO_INCREMENT PRIMARY KEY,
    loanId       INT NOT NULL,
    copyId       VARCHAR(255) NOT NULL,
    returnDate   DATE NULL,
    FOREIGN KEY (loanId) REFERENCES tblLoanReceipt8(loanId),
    FOREIGN KEY (copyId) REFERENCES tblDocumentCopy8(copyId)
);
-- ===================== DU LIEU MAU (mat khau tat ca: 123456) =====================
INSERT INTO tblUser8 (userId, username, password, role) VALUES
 (1, 'reader1',    SHA2('123456', 256), 'READER'),
 (2, 'librarian1', SHA2('123456', 256), 'LIBRARIAN');
INSERT INTO tblReader8    VALUES (1, 'BD001', 'Nguyễn Văn A', 'a@example.com', '0900000001');
INSERT INTO tblLibrarian8 VALUES (2, 'NV001', 'Trần Thị B');
INSERT INTO tblLibraryCard8 VALUES ('THE001', 1, '2026-01-10', 'ACTIVE');

INSERT INTO tblDocumentType8 (typeId, typeName, description) VALUES
 (1, 'Giáo trình', 'Tài liệu giảng dạy theo môn học'),
 (2, 'Sách', 'Sách tham khảo');
INSERT INTO tblDocument8 VALUES
 ('TL001', 'Cơ sở dữ liệu',                  'Nguyễn Văn A', 'Nhà xuất bản Giáo dục', 2020, 'Giáo trình cung cấp kiến thức cơ bản về cơ sở dữ liệu và hệ quản trị cơ sở dữ liệu.', 1),
 ('TL002', 'Toán rời rạc',                   'Trần Văn D',   'Nhà xuất bản Khoa học', 2019, 'Sách về toán rời rạc.', 2),
 ('TL003', 'Lập trình Python',               'Lê Thị E',     'Nhà xuất bản Giáo dục', 2022, 'Giáo trình lập trình Python cơ bản.', 1),
 ('TL004', 'Lập trình Java',                 'Phạm Văn F',   'Nhà xuất bản Giáo dục', 2021, 'Giáo trình lập trình Java.', 1),
 ('TL005', 'Cấu trúc dữ liệu và giải thuật', 'Hoàng Văn G',  'Nhà xuất bản Khoa học', 2018, 'Giáo trình cấu trúc dữ liệu và giải thuật.', 1);
INSERT INTO tblDocumentCopy8 VALUES
 ('BS001', 'TL001', 'AVAILABLE'),
 ('BS002', 'TL004', 'AVAILABLE'),
 ('BS003', 'TL005', 'AVAILABLE'),
 ('BS004', 'TL001', 'AVAILABLE'),
 ('BS005', 'TL002', 'AVAILABLE'),
 ('BS006', 'TL003', 'AVAILABLE'),
 ('BS007', 'TL001', 'BORROWED');
