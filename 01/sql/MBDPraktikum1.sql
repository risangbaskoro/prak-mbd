CREATE VIEW vmatakuliahall AS
	SELECT
	kodemk,
	nama,
	plotsemester,
	sks,
	CASE
		WHEN sifat = 'W' THEN 'Wajib'
		WHEN sifat = 'P' THEN 'Pilihan'
		ELSE sifat	
	END AS sifat
	FROM matakuliah;
GO

CREATE VIEW vmatakuliahwajib AS
	SELECT *
	FROM vmatakuliahall
	WHERE sifat = 'Wajib';
GO

CREATE VIEW vmatakuliahpilihan AS
	SELECT *
	FROM vmatakuliahall
	WHERE sifat = 'Pilihan';
GO

CREATE VIEW vmatakuliahgenap AS
	SELECT *
	FROM vmatakuliahall
	WHERE plotsemester % 2 = 0 AND plotsemester != 0;
GO

CREATE VIEW vmatakuliahgasal AS
	SELECT *
	FROM vmatakuliahall
	WHERE plotsemester % 2 = 1 AND plotsemester != 0;
GO

CREATE VIEW vmatakuliahopen AS
	SELECT *
	FROM vmatakuliahall
	WHERE plotsemester = 0;
GO