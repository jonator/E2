/* Cards */

--Returns all cards in DB
CREATE PROCEDURE getAllCards
AS
SELECT C.CardID, C.Title, C.ImageURL, C.Price, C.CostToProduce,
	(
		SELECT CC.Category
		FROM Project.CardCategory CC
		WHERE C.CategoryID = CC.CategoryID
	) AS Category
FROM Project.Card C
ORDER BY C.CardID ASC
GO;

--Adds a new card to the DB
CREATE PROCEDURE createCard @title nvarchar(64), @url nvarchar(64), @price nvarchar(8), @cost nvarchar(8), @category nvarchar(30)
AS
INSERT Project.Card(Title, ImageURL, Price, CostToProduce, CategoryID)
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
	)
GO;

--Updates a card from a specific cardID
CREATE PROCEDURE updateCard @CardID int, @title nvarchar(64), @url nvarchar(64), @price nvarchar(8), @cost nvarchar(8), @category nvarchar(30)
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
WHERE CardID = @CardID

Go;

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
GO;

--Deletes a card from the DB with a specific CardID
CREATE PROCEDURE deleteCard @CardID INT
AS
DELETE Project.Card
WHERE CardID = @CardID
GO;



/* Users */

--Returns UserID of associated email and password are correct
CREATE PROCEDURE authenticateUser @email nvarchar(32), @password nvarchar(32)
AS
SELECT U.UserID
FROM Project.[User] U
WHERE U.Email = @email AND U.Password = @password
GO;

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
GO;

--Removes a specific item from a specific user's cart
CREATE PROCEDURE removeFromCart @UserID INT, @CardID INT
AS
DELETE 
FROM Project.CartItems
WHERE UserID = @UserID AND CardID = @CardID
GO;

--Adds an item to a user's cart
CREATE PROCEDURE addToCart @UserID int, @CardID int, @Quantity int
AS
INSERT Project.CartItems(UserID, CardID, Quantity)
VALUES
	(
		@UserID,
		@CardID,
		@Quantity
	)
GO;

--Updates the quantity of an existsing cart item
CREATE PROCEDURE updateCartItem @UserID int, @CardID int, @Quantity int
AS
UPDATE Project.CartItems
SET Quantity = @Quantity
WHERE UserID = @UserID AND CardID = @CardID
GO;

--Removes all items from a cart
CREATE PROCEDURE removeAllFromCart @UserID INT
AS
DELETE 
FROM Project.CartItems
WHERE UserID = @UserID
GO;

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
	)
GO;



/* Orders */

--Gets all past orders in DB
CREATE PROCEDURE getAllOrders
AS
SELECT O.OrderID, U.UserID, U.FirstName, U.LastName, U.Email, U.IsAdmin, OL.OrderLineID, C.CardID, C.Title, C.ImageURL, C.Price, C.CostToProduce, C.Category, OL.Quantity
FROM Project.[Order] O
	INNER JOIN
	(
		SELECT U.UserID, U.FirstName, U.LastName, U.Email, U.IsAdmin
		FROM Project.[User] U
	) U ON U.UserID = O.UserID
	INNER JOIN Project.OrderLines OL ON OL.OrderID = O.OrderID
	INNER JOIN
	(
		SELECT C.CardID, C.Title, C.ImageURL, C.Price, C.CostToProduce,
			(
				SELECT CC.Category
				FROM Project.CardCategory CC
				WHERE C.CategoryID = CC.CategoryID
			) AS Category
		FROM Project.Card C
	) C ON C.CardID = OL.CardID
ORDER BY O.OrderID ASC
GO;

--Creates a new order from all items in cart items that are associated with specific userID, then removes items from cart
CREATE PROCEDURE createOrder @UserID INT
AS
INSERT Project.[Order](UserID)
VALUES (@UserID);

DECLARE @last int = SCOPE_IDENTITY()  

INSERT Project.OrderLines(OrderID, CardID, Quantity)
SELECT @last, CI.CardID, CI.Quantity
FROM Project.CartItems CI
WHERE CI.UserID = @UserID

EXEC removeAllFromCart @UserID
GO;