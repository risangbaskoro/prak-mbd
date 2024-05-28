-- DISABLE TRIGGER MahasiswaAngkatan ON mahasiswa;
-- DISABLE TRIGGER UpdateAngkatanMahasiswa ON mahasiswa;
-- DISABLE TRIGGER InsertAmbilMatkul ON irs;
-- DISABLE TRIGGER UpdateIRSRekap ON irs;


-- SOAL 1
CREATE UNIQUE INDEX nimMahasiswa
    ON mahasiswa (nim);
GO

-- SOAL 2
CREATE UNIQUE INDEX nipDosen
    ON dosen (nip);
GO

-- SOAL 3
CREATE UNIQUE INDEX kodeMataKuliah
    ON matakuliah (kodemk);
GO

-- SOAL 4
CREATE UNIQUE INDEX idSemester
    ON semester (idsem);
GO

-- SOAL 5
CREATE UNIQUE INDEX irsMataKuliahMahasiswa
    ON irs (idsem, nim, kodemk);
GO

-- SOAL 6
-- Query menampilkan informasi kolom kode mata kuliah, nama mata kuliah,
-- sks berdasarkan isian tabel IRS milik mahasiswa dengan idsem dan nim
-- tertentu, menggunakan pointer
EXEC sp_columns mahasiswa;

BEGIN
    DECLARE @kodeMatkul NVARCHAR(16);
    DECLARE @namaMatkul NVARCHAR(100);
    DECLARE @nSks TINYINT;
    DECLARE @nimMahasiswa NVARCHAR(32);
    SET @nimMahasiswa = '24060120130006';

    DECLARE @sumSks TINYINT;
    SET @sumSks = 0;

    DECLARE irsPointer CURSOR
        FOR
        SELECT irs.kodemk,
               matkul.nama,
               matkul.sks
        FROM irs
                 JOIN matakuliah matkul ON matkul.kodemk = irs.kodemk
        WHERE irs.nim = @nimMahasiswa;

    OPEN irsPointer

    WHILE 1 = 1
        BEGIN
            FETCH NEXT FROM irsPointer INTO @kodeMatkul, @namaMatkul, @nSks
            SET @sumSks = @sumSks + @nSks
            PRINT @kodeMatkul + CHAR(9) + @namaMatkul + CHAR(9) + CAST(@nSks AS NVARCHAR) + ' SKS';
            IF @@FETCH_STATUS <> 0
                BREAK; -- Break kalo sudah semua di-fetch
        END

    CLOSE irsPointer;
    DEALLOCATE irsPointer;
END;
GO

-- SOAL 7
-- Query untuk pengisian tabel IRSRekap berdasarkan isian tabel IRS, menggunakan pointer.

BEGIN
    DECLARE @currentNIM NVARCHAR(255);

    DECLARE mahasiswaPointer CURSOR
        FOR
        SELECT DISTINCT nim
        FROM irs;

    OPEN mahasiswaPointer;

    WHILE 1 = 1
        BEGIN
            FETCH NEXT FROM mahasiswaPointer INTO @currentNIM
            IF @@FETCH_STATUS <> 0 BREAK;

            -- BACA TABEL IRS UNTUK NIM MAHASISWA SEKARANG
            DECLARE irsPointer CURSOR
                FOR
                SELECT irs.semesterke,
                       irs.idsem,
                       irs.nim,
                       irs.kodemk,
                       matkul.sks,
                       irs.nilai
                FROM irs
                         JOIN matakuliah matkul ON irs.kodemk = matkul.kodemk
                WHERE irs.nim = @currentNIM;

            DECLARE @ordinalSemester INT;
            DECLARE @idSemester NVARCHAR(255);
            DECLARE @nimMahasiswa NVARCHAR(255);
            DECLARE @kodeMatkul NVARCHAR(255);
            DECLARE @sksMatkul INT;
            DECLARE @gradeMatkul FLOAT;

            DECLARE @nMatkul INT;
            DECLARE @nSks INT;
            DECLARE @sumBobotMatkul FLOAT;
            DECLARE @ipSemester FLOAT;
            SET @nMatkul = 0;
            SET @nSks = 0;
            SET @sumBobotMatkul = 0;
            SET @ipSemester = 0;

            OPEN irsPointer;

            WHILE 1 = 1
                BEGIN
                    -- REKAP JUMLAH MATKUL DAN TOTAL SKS UNTUK TIAP MAHASISWA
                    -- irsrekap (semesterke, idsem, nim, banyakmk, bebansks, ip_semester)
                    FETCH NEXT FROM irsPointer
                        INTO @ordinalSemester, @idSemester, @nimMahasiswa, @kodeMatkul, @sksMatkul, @gradeMatkul

                    -- AGGREGATE BANYAK MATKUL
                    SET @nMatkul = @nMatkul + 1;
                    -- AGGREGATE SKS
                    SET @nSks = @nSks + @sksMatkul;

                    -- HITUNG BOBOT MATKUL
                    SET @sumBobotMatkul = @sumBobotMatkul + (@gradeMatkul * @sksMatkul)

                    -- MASUKKAN KE TABLE IRSREKAP
                    IF @@FETCH_STATUS <> 0
                        BEGIN
                            -- HITUNG IP SEMESTER
                            SELECT @ipSemester = ROUND(@sumBobotMatkul / @nSks, 2);

                            INSERT INTO irsrekap (semesterke, idsem, nim, banyakmk, bebansks, ip_semester)
                            VALUES (@ordinalSemester, @idSemester, @currentNIM, @nMatkul, @nSks, @ipSemester);
                            BREAK;
                        END;
                END;

            CLOSE irsPointer;
            DEALLOCATE irsPointer;
        END;

    CLOSE mahasiswaPointer;
    DEALLOCATE mahasiswaPointer;
END;