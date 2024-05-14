USE akademikdb;

-- BEGIN
--     DROP TABLE irs;
--     DROP TABLE mahasiswa;
--     DROP TABLE semester;
--     DROP TABLE dosen;
-- END;

CREATE TABLE dosen
(
    nip  NVARCHAR(16) PRIMARY KEY,
    nama NVARCHAR(50) NOT NULL,
)

CREATE TABLE mahasiswa
(
    nim      NVARCHAR(16) PRIMARY KEY,
    nama     NVARCHAR(50) NOT NULL,
    angkatan SMALLINT     NOT NULL CHECK (angkatan > 0),
    nipwali  NVARCHAR(16) NOT NULL FOREIGN KEY (nipwali) REFERENCES dosen (nip)
)

CREATE TABLE semester
(
    idsem  NVARCHAR(5) PRIMARY KEY,
    posisi NVARCHAR(30)
)

CREATE TABLE irs
(
    semesterke SMALLINT     NOT NULL,
    idsem      NVARCHAR(5)  NOT NULL FOREIGN KEY (idsem) REFERENCES semester (idsem),
    nim        NVARCHAR(16) NOT NULL FOREIGN KEY (nim) REFERENCES mahasiswa (nim),
    kodemk     NVARCHAR(8)  NOT NULL FOREIGN KEY (kodemk) REFERENCES matakuliah (kodemk),
    nilai      NCHAR(1),
    ambilke    TINYINT
)

INSERT INTO dosen
VALUES ('0000000000000001', 'Dr. Andika Mahardika, S.Si, M.Kom'),
       ('0000000000000002', 'Dr. Budi Budiman, S.Kom, M.Kom'),
       ('0000000000000003', 'Prof. Chandra Satya, S.Kom, M.Kom')

INSERT INTO mahasiswa
VALUES ('24060119130119', 'Risang Baskoro', 2019, '0000000000000001'),
       ('24060120120122', 'Ahmad Mulawarman', 2020, '0000000000000001'),
       ('24060120120123', 'Alisya Banjarsari', 2020, '0000000000000001'),
       ('24060120130006', 'Budi Timoho', 2020, '0000000000000002'),
       ('24060120130007', 'Bella Padangsari', 2020, '0000000000000002'),
       ('24060120130008', 'Brianna Tembalang', 2020, '0000000000000002'),
       ('24060120140112', 'Cikal Sumurboto', 2020, '0000000000000003'),
       ('24060120140114', 'Cella Sambiroto', 2020, '0000000000000003'),
       ('24060120140113', 'Chantal Gondang', 2020, '0000000000000003');

INSERT INTO semester
VALUES (20201, 'Semester gasal 2020/2021'),
       (20202, 'Semester genap 2020/2021'),
       (20211, 'Semester gasal 2021/2022'),
       (20212, 'Semester genap 2021/2022'),
       (20221, 'Semester gasal 2022/2023'),
       (20222, 'Semester genap 2022/2023'),
       (20231, 'Semester gasal 2023/2024'),
       (20232, 'Semester genap 2023/2024')
