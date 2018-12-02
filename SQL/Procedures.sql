CREATE PROCEDURE getAllCards
AS
SELECT * 
FROM Project.Product
GO;

CREATE PROCEDURE getSingleCard @Card nvarchar(30)
AS
SELECT * 
FROM Project.Product
WHERE ProductName = @Card
GO;

CREATE PROCEDURE getCart @User nvarchar(30)
AS
SELECT * 
FROM Project.CartItems
WHERE UserID = @User
GO;

CREATE PROCEDURE removeAllFromCart @User INT
AS
DELETE 
FROM Project.CartItems
WHERE UserID = @User
GO;

CREATE PROCEDURE removeFromCart @User INT, @Product INT
AS
DELETE 
FROM Project.CartItems
WHERE UserID = @User AND ProductID = @Product
GO;

CREATE PROCEDURE getOrders
AS
SELECT * 
FROM Project.[Order]
GO;

