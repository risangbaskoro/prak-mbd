USE akademikdb;

BEGIN
    DROP PROCEDURE IF EXISTS AllMahasiswaPerwalianNip;
    DROP PROCEDURE IF EXISTS AllMahasiswaPerwalianDosen;
    DROP PROCEDURE IF EXISTS AllDosenWaliAngkatan;
    DROP PROCEDURE IF EXISTS AllMahasiswaAngkatan;
    DROP PROCEDURE IF EXISTS AllMahasiswaPerwalianAngkatan;
END;
GO

CREATE PROCEDURE AllMahasiswaPerwalianNip @nip NVARCHAR(16)
AS
BEGIN
    SELECT M.nama
    FROM mahasiswa M
    WHERE M.nipwali = @nip
END;
GO

CREATE PROCEDURE AllMahasiswaPerwalianDosen @nama_dosen NVARCHAR(50)
AS
BEGIN
    SELECT M.nim, M.nama
    FROM mahasiswa M
    WHERE M.nipwali = (SELECT D.nip FROM dosen D WHERE nama LIKE '%' + @nama_dosen + '%')
END;
GO

CREATE PROCEDURE AllDosenWaliAngkatan @angkatan SMALLINT
AS
BEGIN
    DECLARE @nip NVARCHAR(16)

    SELECT @nip = M.nipwali
    FROM mahasiswa M
    WHERE M.angkatan = @angkatan

    SELECT D.nama AS 'Nama Dosen'
    FROM dosen D
             JOIN dosen ON DOSEN.nip = @nip
END;
GO

CREATE PROCEDURE AllMahasiswaAngkatan @angkatan SMALLINT
AS
BEGIN
    SELECT M.nim, M.nama
    FROM mahasiswa M
    WHERE M.angkatan = @angkatan
END;
GO

CREATE PROCEDURE AllMahasiswaPerwalianAngkatan @nama_dosen NVARCHAR(50),
                                               @angkatan SMALLINT
AS
BEGIN
    SELECT M.nim, M.nama
    FROM mahasiswa M
    WHERE M.nipwali = (SELECT D.nip FROM dosen D WHERE nama LIKE '%' + @nama_dosen + '%')
    AND M.angkatan = @angkatan
END;
GO

IF NOT EXISTS(SELECT 1 FROM semester)
INSERT INTO semester
VALUES (20201, 'Semester gasal 2020/2021'),
       (20202, 'Semester genap 2020/2021'),
       (20211, 'Semester gasal 2021/2022'),
       (20212, 'Semester genap 2021/2022'),
       (20221, 'Semester gasal 2022/2023'),
       (20222, 'Semester genap 2022/2023'),
       (20231, 'Semester gasal 2023/2024'),
       (20232, 'Semester genap 2023/2024')