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
	)
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

--Returns all lines associated with specific userID
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