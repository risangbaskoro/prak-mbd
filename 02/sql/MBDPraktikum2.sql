USE akademikdb;
GO;

CREATE FUNCTION fmatakuliahall()
    RETURNS INT AS
BEGIN
    DECLARE @result INT
    SELECT @result = COUNT(*) FROM matakuliah;
    RETURN @result
END;
GO;


CREATE FUNCTION fmatakuliahwajib()
    RETURNS INT AS
BEGIN
    DECLARE @result INT
    SELECT @result = COUNT(*) FROM matakuliah WHERE sifat = 'W';
    RETURN @result
END;
GO;


CREATE FUNCTION fmatakuliahpilihan()
    RETURNS INT AS
BEGIN
    DECLARE @result INT
    SELECT @result = COUNT(*) FROM matakuliah WHERE sifat = 'P';
    RETURN @result
END;
GO;


CREATE FUNCTION fmatakuliahgenap()
    RETURNS INT AS
BEGIN
    DECLARE @result INT
    SELECT @result = COUNT(*)
    FROM matakuliah
    WHERE plotsemester % 2 = 0
      AND plotsemester != 0;
    RETURN @result
END;
GO;


CREATE FUNCTION fmatakuliahgasal()
    RETURNS INT AS
BEGIN
    DECLARE @result INT
    SELECT @result = COUNT(*)
    FROM matakuliah
    WHERE plotsemester % 2 = 1
      AND plotsemester != 0;
    RETURN @result
END;
GO;


CREATE FUNCTION fmatakuliahopen()
    RETURNS INT AS
BEGIN
    DECLARE @result INT
    SELECT @result = COUNT(*)
    FROM matakuliah
    WHERE plotsemester = 0;
    RETURN @result
END;
GO;


CREATE FUNCTION fmatakuliah(@semester int)
    RETURNS INT AS
BEGIN
    DECLARE @result INT
    SELECT @result = COUNT(*)
    FROM matakuliah
    WHERE plotsemester = @semester;
    RETURN @result
END;
GO;


CREATE FUNCTION fbeban(@semester int)
    RETURNS INT AS
BEGIN
    DECLARE @result INT
    SELECT @result = SUM(sks)
    FROM matakuliah
    WHERE plotsemester = @semester;
    RETURN @result
END;