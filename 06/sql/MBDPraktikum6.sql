-- PREPARATION
CREATE TABLE irsriwayat
(
    semesterke  SMALLINT     NOT NULL,
    idsem       NVARCHAR(5)  NOT NULL FOREIGN KEY (idsem) REFERENCES semester (idsem),
    nim         NVARCHAR(16) NOT NULL FOREIGN KEY (nim) REFERENCES mahasiswa (nim),
    kodemk      NVARCHAR(8)  NOT NULL FOREIGN KEY (kodemk) REFERENCES matakuliah (kodemk),
    nilai       NCHAR(1),
    ambilke     TINYINT,
    waktuupdate DATE         NOT NULL DEFAULT SYSDATETIME()
)


-- SOAL 1
CREATE OR ALTER TRIGGER MoveIRSToRiwayat
    ON irs
    AFTER UPDATE
    AS
BEGIN
    INSERT INTO irsriwayat (semesterke, idsem, nim, kodemk, nilai, ambilke)
    SELECT *
    FROM deleted;
END;
GO

ENABLE TRIGGER MoveIRSToRiwayat ON irs;


-- SOAL 2
CREATE VIEW RiwayatIRS AS
SELECT semesterke, idsem, nim, kodemk, nilai, ambilke, NULL AS 'waktuupdate'
FROM irs
UNION ALL
SELECT semesterke, idsem, nim, kodemk, nilai, ambilke, waktuupdate
FROM irsriwayat;

SELECT *
FROM RiwayatIRS;


-- SOAL 3
CREATE OR ALTER PROCEDURE RiwayatIRSMhs @nim NVARCHAR(16)
AS
BEGIN
    SELECT *
    FROM RiwayatIRS
    WHERE nim = @nim;
END;
GO

EXEC RiwayatIRSMhs '24060120130006';


-- SOAL 4
CREATE OR ALTER PROCEDURE RiwayatIRSRekapMhs @nim NVARCHAR(16)
AS
BEGIN
    SELECT *
    FROM irsrekap
    WHERE nim = @nim;
END;
GO


-- SOAL 5
CREATE OR ALTER PROCEDURE KHSterbaik @nim NVARCHAR(16)
AS
BEGIN
    SELECT matkul.kodemk, matkul.nama, matkul.sks, MAX(irs.nilai), irs.semesterke
    FROM irs
             JOIN matakuliah matkul on matkul.kodemk = irs.kodemk
    WHERE irs.nim = @nim
    GROUP BY matkul.kodemk, matkul.nama, matkul.sks, irs.semesterke;
END;
GO

EXEC KHSterbaik '24060120130006'