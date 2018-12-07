/* Cards */

--Returns all cards in DB that are not marked as deleted
CREATE PROCEDURE getAllCards
AS
SELECT C.CardID, C.Title, C.ImageURL, C.Price, C.CostToProduce,
	(
		SELECT CC.Category
		FROM Project.CardCategory CC
		WHERE C.CategoryID = CC.CategoryID
	) AS Category
FROM Project.Card C
WHERE C.IsDeleted = 0
ORDER BY C.CardID ASC
GO

--Adds a new card to the DB
CREATE PROCEDURE createCard @title nvarchar(64), @url nvarchar(128), @price nvarchar(8), @cost nvarchar(8), @category nvarchar(30)
AS
DECLARE @newCard TABLE (CardID int)
INSERT Project.Card(Title, ImageURL, Price, CostToProduce, CategoryID)
OUTPUT INSERTED.CARDID INTO @newCard
VALUES
    (
        @title,
        @url,
        CAST(@price AS INT),
        CAST(@cost AS INT),
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

--Updates a card from a specific cardID
CREATE PROCEDURE updateCard @CardID int, @title nvarchar(64), @url nvarchar(128), @price nvarchar(8), @cost nvarchar(8), @category nvarchar(30)
AS
UPDATE Project.Card
SET Title = @title,
	ImageURL = @url,
	Price = CAST(@price AS INT),
	CostToProduce = CAST(@cost AS INT),
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

--Returns a card from a specific ID
CREATE PROCEDURE getSingleCard @CardID INT
AS
SELECT C.CardID, C.Title, C.ImageURL, C.Price, C.CostToProduce,
	(
		SELECT CC.Category
		FROM Project.CardCategory CC
		WHERE C.CategoryID = CC.CategoryID
	) AS Category
FROM Project.Card C
WHERE C.CardID = @CardID
GO

--Deletes a card from the DB with a specific CardID
--Returns null if card is still in DB after deletion
--Returns CardID of deleted card if card is not found in DB after deletion
CREATE PROCEDURE deleteCard @CardID INT
AS
UPDATE Project.Card
SET IsDeleted = 1
WHERE CardID = @CardID;

DECLARE @test INT = 
	(
		SELECT C.IsDeleted
		FROM Project.Card C
		WHERE C.CardID = @CardID
	)

SET @test = CASE WHEN @test = 1 THEN @CardID
				ELSE NULL END

SELECT @test AS CardID
GO



/* Users */

--Returns UserID of associated email and password are correct
CREATE PROCEDURE authenticateUser @email nvarchar(32), @password nvarchar(32)
AS
SELECT U.UserID, U.FirstName, U.LastName, U.Email, U.IsAdmin
FROM Project.[User] U
WHERE U.Email = @email AND U.Password = @password
GO

--Returns all cart lines associated with specific userID
CREATE PROCEDURE getCart @UserID nvarchar(30)
AS
SELECT A.CardID, A.Title, A.ImageURL, A.Price, A.CostToProduce, A.Category, CI.Quantity
FROM Project.CartItems CI
	INNER JOIN
	(
		SELECT C.CardID, C.Title, C.ImageURL, C.Price, C.CostToProduce,
		(
			SELECT CC.Category
			FROM Project.CardCategory CC
			WHERE C.CategoryID = CC.CategoryID
		) AS Category
		FROM Project.Card C
	) A ON A.CardID = CI.CardID
WHERE UserID = @UserID
GO

--Removes a specific item from a specific user's cart
CREATE PROCEDURE removeFromCart @UserID INT, @CardID INT
AS
DELETE 
FROM Project.CartItems
WHERE UserID = @UserID AND CardID = @CardID;

SELECT @CardID AS CardID
GO

--Adds an item to a user's cart
CREATE PROCEDURE addToCart @UserID int, @CardID int, @Quantity int
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

--Updates the quantity of an existsing cart item
CREATE PROCEDURE updateCartItem @UserID int, @CardID int, @Quantity int
AS
UPDATE Project.CartItems
SET Quantity = @Quantity
WHERE UserID = @UserID AND CardID = @CardID;

SELECT CI.UserID, CI.CardID, CI.Quantity
FROM Project.CartItems CI
WHERE CI.CardID = @CardID AND CI.UserID = @UserID
GO

--Removes all items from a cart
CREATE PROCEDURE removeAllFromCart @UserID INT
AS
DELETE 
FROM Project.CartItems
WHERE UserID = @UserID
GO

--Creates a User in the DB
CREATE PROCEDURE createUser @FN nvarchar(32), @LN nvarchar(32), @Email nvarchar(32), @Password nvarchar(32)
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



/* Orders */

--Gets all past orders in DB
CREATE PROCEDURE getAllOrders
AS
SELECT O.OrderID, U.UserID, U.FirstName, U.LastName, U.Email, U.IsAdmin, OL.OrderLineID, C.CardID, C.Title, C.ImageURL, C.Price, C.CostToProduce, CC.Category, OL.Quantity, O.OrderDate
FROM Project.[Order] O
	INNER JOIN Project.[User] U ON U.UserID = O.UserID
	INNER JOIN Project.OrderLines OL ON OL.OrderID = O.OrderID
	INNER JOIN Project.Card C ON C.CardID = OL.CardID
	INNER JOIN Project.CardCategory CC ON CC.CategoryID = C.CategoryID
ORDER BY O.OrderID ASC
GO

--Creates a new order from all items in cart items that are associated with specific userID, then removes items from cart
CREATE PROCEDURE createOrder @UserID INT
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

--Returns the total sales in $, does not account for cost to produce
CREATE PROCEDURE totalSales
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
CREATE PROCEDURE totalProfit
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

--Returns the number of cards sold in each category
CREATE PROCEDURE cardsSoldByCategory
AS
	SELECT CC.Category, ISNULL(SUM(OL.Quantity), 0) AS Quantity
	FROM Project.OrderLines OL
		INNER JOIN Project.Card C ON C.CardID = OL.CardID
		RIGHT OUTER JOIN Project.CardCategory CC ON CC.CategoryID = C.CategoryID
	GROUP BY CC.CategoryID, CC.Category
	Order BY CC.CategoryID ASC
GO

CREATE PROCEDURE currentCategories
AS
	SELECT CC.Category
	FROM Project.CardCategory CC
	Order BY CC.CategoryID ASC
GO