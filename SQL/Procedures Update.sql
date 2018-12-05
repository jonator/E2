ALTER PROCEDURE createCard @title nvarchar(64), @url nvarchar(64), @price nvarchar(8), @cost nvarchar(8), @category nvarchar(30)
AS
DECLARE @newCard TABLE (CardID int)
INSERT Project.Card(Title, ImageURL, Price, CostToProduce, CategoryID)
OUTPUT INSERTED.CARDID INTO @newCard
VALUES
    (
        @title,
        @url,
        CAST(@price AS DECIMAL(8,2)),
        CAST(@cost AS DECIMAL(8,2)),
        (
            SELECT CC.CategoryID
            FROM Project.CardCategory CC
            WHERE CC.Category = @category
        )
    );

SELECT C.CardID, C.Title, C.ImageURL, C.Price, C.CostToProduce,
	(
		SELECT CC.Category
		FROM Project.CardCategory CC
		WHERE C.CategoryID = CC.CategoryID
	) AS Category
FROM Project.Card C
WHERE C.CardID = (SELECT CardID from @newCard);
GO

ALTER PROCEDURE updateCard @CardID int, @title nvarchar(64), @url nvarchar(64), @price nvarchar(8), @cost nvarchar(8), @category nvarchar(30)
AS
UPDATE Project.Card
SET Title = @title,
	ImageURL = @url,
	Price = CAST(@price AS DECIMAL(8,2)),
	CostToProduce = CAST(@cost AS DECIMAL(8,2)),
	CategoryID = 
		(
			SELECT CC.CategoryID
			FROM Project.CardCategory CC
			WHERE CC.Category = @category AND CC.CategoryID = CategoryID
		)
WHERE CardID = @CardID;

SELECT C.CardID, C.Title, C.ImageURL, C.Price, C.CostToProduce,
	(
		SELECT CC.Category
		FROM Project.CardCategory CC
		WHERE C.CategoryID = CC.CategoryID
	) AS Category
FROM Project.Card C
WHERE C.CardID = @CardID
GO

--Returns null if card is still in DB after deletion
--Returns CardID of deleted card if card is not found in DB after deletion
ALTER PROCEDURE deleteCard @CardID INT
AS
DELETE Project.Card
WHERE CardID = @CardID;

DECLARE @test INT = 
	(
		SELECT C.CardID
		FROM Project.Card C
		WHERE C.CardID = @CardID
	)

SET @test = CASE WHEN @test > 0 THEN NULL
				ELSE @CardID END

SELECT @test AS CardID
GO

ALTER PROCEDURE removeFromCart @UserID INT, @CardID INT
AS
DELETE 
FROM Project.CartItems
WHERE UserID = @UserID AND CardID = @CardID;

SELECT @CardID AS CardID
GO

ALTER PROCEDURE addToCart @UserID int, @CardID int, @Quantity int
AS
INSERT Project.CartItems(UserID, CardID, Quantity)
VALUES
	(
		@UserID,
		@CardID,
		@Quantity
	);

SELECT CI.UserID, CI.CardID, CI.Quantity
FROM Project.CartItems CI
WHERE CI.CardID = @CardID AND CI.UserID = @UserID
GO

ALTER PROCEDURE updateCartItem @UserID int, @CardID int, @Quantity int
AS
UPDATE Project.CartItems
SET Quantity = @Quantity
WHERE UserID = @UserID AND CardID = @CardID;

SELECT CI.UserID, CI.CardID, CI.Quantity
FROM Project.CartItems CI
WHERE CI.CardID = @CardID AND CI.UserID = @UserID
GO

ALTER PROCEDURE createUser @FN nvarchar(32), @LN nvarchar(32), @Email nvarchar(32), @Password nvarchar(32)
AS
INSERT Project.[User](FirstName, LastName, Email, Password)
VALUES
	(
		@FN,
		@LN,
		@Email,
		@Password
	);

SELECT U.UserID, U.FirstName, U.LastName, U.Email, U.IsAdmin
FROM Project.[User] U
WHERE U.Email = @Email
GO

ALTER PROCEDURE createOrder @UserID INT
AS
INSERT Project.[Order](UserID)
VALUES (@UserID);

DECLARE @last int = SCOPE_IDENTITY();

INSERT Project.OrderLines(OrderID, CardID, Quantity)
SELECT @last, CI.CardID, CI.Quantity
FROM Project.CartItems CI
WHERE CI.UserID = @UserID;

EXEC removeAllFromCart @UserID;

SELECT O.OrderID, U.UserID, U.FirstName, U.LastName, U.Email, U.IsAdmin, OL.OrderLineID, C.CardID, C.Title, C.ImageURL, C.Price, C.CostToProduce, CC.Category, OL.Quantity, O.OrderDate
FROM Project.[Order] O
	INNER JOIN Project.[User] U ON U.UserID = O.UserID
	INNER JOIN Project.OrderLines OL ON OL.OrderID = O.OrderID
	INNER JOIN Project.Card C ON C.CardID = OL.CardID
	INNER JOIN Project.CardCategory CC ON CC.CategoryID = C.CategoryID
WHERE O.OrderID = @last
ORDER BY O.OrderID ASC
GO

ALTER PROCEDURE authenticateUser @email nvarchar(32), @password nvarchar(32)
AS
SELECT U.UserID, U.FirstName, U.LastName, U.Email, U.IsAdmin
FROM Project.[User] U
WHERE U.Email = @email AND U.Password = @password
GO

ALTER PROCEDURE getAllOrders
AS
SELECT O.OrderID, U.UserID, U.FirstName, U.LastName, U.Email, U.IsAdmin, OL.OrderLineID, C.CardID, C.Title, C.ImageURL, C.Price, C.CostToProduce, CC.Category, OL.Quantity, O.OrderDate
FROM Project.[Order] O
	INNER JOIN Project.[User] U ON U.UserID = O.UserID
	INNER JOIN Project.OrderLines OL ON OL.OrderID = O.OrderID
	INNER JOIN Project.Card C ON C.CardID = OL.CardID
	INNER JOIN Project.CardCategory CC ON CC.CategoryID = C.CategoryID
ORDER BY O.OrderID ASC
GO

ALTER PROCEDURE totalSales
AS
DECLARE @Sales INT = 
	(
		SELECT SUM(OL.Quantity * C.Price)
		FROM Project.OrderLines OL
			INNER JOIN Project.Card C ON C.CardID = OL.CardID
	)
SELECT @Sales AS total
GO

--Returns the total profits after the cost to produce each card
ALTER PROCEDURE totalProfit
AS
DECLARE @Sales INT = 
	(
		SELECT SUM(OL.Quantity * C.Price)
		FROM Project.OrderLines OL
			INNER JOIN Project.Card C ON C.CardID = OL.CardID
	)

DECLARE @Cost INT = 
	(
		SELECT SUM(OL.Quantity * C.CostToProduce)
		FROM Project.OrderLines OL
			INNER JOIN Project.Card C ON C.CardID = OL.CardID
	)
SELECT (@Sales - @Cost) AS total
GO
