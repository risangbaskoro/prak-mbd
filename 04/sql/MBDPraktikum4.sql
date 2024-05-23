CREATE OR ALTER TRIGGER MahasiswaAngkatan
    ON mahasiswa
    AFTER INSERT
    AS
BEGIN
    UPDATE mahasiswa
    SET angkatan = 2000 + CAST(SUBSTRING(NIM, 7, 2) AS INT)
    WHERE mahasiswa.angkatan IS NULL
END;
GO

-- Soal 1
CREATE OR ALTER TRIGGER UpdateAngkatanMahasiswa
    ON mahasiswa
    FOR UPDATE
    AS
BEGIN
    UPDATE mahasiswa
    SET angkatan = 2000 + CAST(SUBSTRING(nim, 7, 2) AS INT)
    WHERE angkatan != 2000 + CAST(SUBSTRING(nim, 7, 2) AS INT)
END;
GO


-- Soal 2 dan 3
CREATE OR ALTER TRIGGER InsertAmbilMatkul
    ON irs
    INSTEAD OF INSERT
    AS
BEGIN
    IF EXISTS (SELECT 1
               FROM inserted i
                        JOIN irs ir ON i.nim = ir.nim AND i.kodemk = ir.kodemk)
        BEGIN
            INSERT INTO irs
            SELECT semesterke,
                   idsem,
                   nim,
                   kodemk,
                   nilai,
                   (SELECT MAX(ir.ambilke) + 1
                    FROM inserted i
                             JOIN irs ir ON i.nim = ir.nim AND i.kodemk = ir.kodemk)
            FROM inserted;
        END
    ELSE
        BEGIN
            INSERT INTO irs
            SELECT semesterke, idsem, nim, kodemk, nilai, 1
            FROM inserted;
        END
END;
GO


CREATE OR ALTER TRIGGER UpdateIRSRekap
    ON irs
    AFTER INSERT
    AS
BEGIN
    IF EXISTS(SELECT *
              FROM irsrekap
                       JOIN irs i ON irsrekap.nim = i.nim
                  AND irsrekap.idsem = i.idsem)
        BEGIN
            -- UPDATE
            UPDATE irsrekap
            SET banyakmk = (SELECT COUNT(irs.kodemk) FROM irs),
                bebansks = (SELECT SUM(matkul.sks)
                            FROM irs
                                     JOIN matakuliah matkul on matkul.kodemk = irs.kodemk)
            WHERE idsem = (SELECT idsem FROM irs)
        END
    ELSE
        BEGIN
            -- INSERT
            INSERT INTO irsrekap (semesterke, idsem, nim, banyakmk, bebansks, ip_semester)
            SELECT semesterke,
                   idsem,
                   nim,
                   (SELECT COUNT(irs.kodemk) FROM irs),
                   (SELECT SUM(matkul.sks)
                    FROM irs
                             JOIN matakuliah matkul on matkul.kodemk = irs.kodemk),
                   NULL
            FROM irs
            WHERE idsem = (SELECT idsem FROM irs)
        END
END;
GO

