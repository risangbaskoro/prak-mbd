USE akademikdb;

CREATE TABLE matakuliah (
	kodemk NVARCHAR(8) PRIMARY KEY,
	nama NVARCHAR(50) NOT NULL,
	plotsemester TINYINT NOT NULL CHECK(plotsemester >=0 AND plotsemester <= 8),
	sks TINYINT NOT NULL CHECK(sks >= 1 AND sks <= 6 AND sks != 5),
	sifat CHAR(1) NOT NULL CHECK(sifat = 'W' OR sifat = 'P'),
)