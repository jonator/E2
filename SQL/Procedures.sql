CREATE PROCEDURE getAllCards
AS
SELECT * 
FROM Project.Card
GO;

CREATE PROCEDURE getSingleCard @Card nvarchar(30)
AS
SELECT * 
FROM Project.Card
WHERE Title = @Card
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

CREATE PROCEDURE removeFromCart @User INT, @Card INT
AS
DELETE 
FROM Project.CartItems
WHERE UserID = @User AND CardID = @Card
GO;

CREATE PROCEDURE getOrders
AS
SELECT * 
FROM Project.[Order]
GO;