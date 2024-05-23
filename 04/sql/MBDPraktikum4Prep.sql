ALTER TABLE mahasiswa
    ALTER COLUMN angkatan SMALLINT NULL;


DROP TABLE IF EXISTS irsrekap;
CREATE TABLE irsrekap
(
    semesterke  SMALLINT,
    idsem       NVARCHAR(5) FOREIGN KEY (idsem) REFERENCES semester (idsem),
    nim         NVARCHAR(16) FOREIGN KEY (nim) REFERENCES mahasiswa (nim),
    banyakmk   SMALLINT,
    bebansks   SMALLINT,
    ip_semester FLOAT
)
