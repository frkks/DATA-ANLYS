
 ------ WH�LE DECLARE DENEME---

DECLARE @ix int,  @Number int

 set @Number = 5

while @Number <= 1
        SET @ix = 1
        SET @ix = @Number * ( @Number - 1 )
print (@ix)



-------WH�LE FACTOR�AL FUNCTION--------

CREATE FUNCTION while_factorial (@Number int)
RETURNS INT
AS
BEGIN
DECLARE @ix int

while @Number <= 1
        SET @ix = 1
        SET @ix = @Number * ( @Number - 1 )
RETURN (@ix)
END

select dbo.while_factorial(7)


 
 ------IF ELSE DECLARE DENEME---

DECLARE @ix int,  @Number int

 set @Number = 5

    IF @Number <= 1
        SET @ix = 1
    ELSE
        SET @ix = @Number * ( @Number - 1 )
print (@ix)



-------IF ELSE FUNCT�ON DENEME-------

CREATE FUNCTION factorial (@Number int)
RETURNS INT
AS
BEGIN
DECLARE @ix int

    IF @Number <= 1
        SET @ix = 1
    ELSE
        SET @ix = @Number * ( @Number - 1 )
RETURN (@ix)
END

-------FACTOR�AL FUNCTION--------

select dbo.factorial(7)



