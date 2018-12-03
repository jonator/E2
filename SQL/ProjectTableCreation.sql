--CREATE SCHEMA Project;
GO

DROP TABLE IF EXISTS Project.CartItems;
DROP TABLE IF EXISTS Project.OrderLines;
DROP TABLE IF EXISTS Project.[Order];
DROP TABLE IF EXISTS Project.[User];
DROP TABLE IF EXISTS Project.[Card];
DROP TABLE IF EXISTS Project.CardCategory;

CREATE TABLE Project.CardCategory
(
	CategoryID INT NOT NULL IDENTITY(1, 1) PRIMARY KEY,
	Category NVARCHAR(128) NOT NULL
);

CREATE TABLE Project.[User]
(
	UserID INT NOT NULL IDENTITY(1, 1) PRIMARY KEY,
	FirstName NVARCHAR(32) NOT NULL,
	LastName NVARCHAR(32) NOT NULL,
	Email NVARCHAR(128) NOT NULL,
	IsAdmin BIT NOT NULL DEFAULT 0,
	[Password] NVARCHAR(32) NOT NULL,
	CreatedOn DATETIMEOFFSET NOT NULL DEFAULT(SYSDATETIMEOFFSET()),

	UNIQUE(Email ASC)
);

CREATE TABLE Project.[Order]
(
	OrderID INT NOT NULL IDENTITY(1, 1) PRIMARY KEY,
	UserID INT NOT NULL REFERENCES Project.[User](UserID),
	OrderDate DATETIMEOFFSET NOT NULL DEFAULT(SYSDATETIMEOFFSET())
);

CREATE TABLE Project.Card
(
	CardID INT NOT NULL IDENTITY(1, 1) PRIMARY KEY,
	Title NVARCHAR(32) NOT NULL,
	ImageURL NVARCHAR(64) NOT NULL,
	Price DECIMAL(8,2) NOT NULL,
	CostToProduce DECIMAL(8,2) NOT NULL,
	CategoryID INT NOT NULL REFERENCES Project.CardCategory(CategoryID)

	UNIQUE(Title ASC)
);

CREATE TABLE Project.CartItems
(
	UserID INT NOT NULL REFERENCES Project.[User](UserID),
	CardID INT NOT NULL REFERENCES Project.Card(CardID),
	Quantity INT NOT NULL,

	PRIMARY KEY(UserID, CardID)
);

CREATE TABLE Project.OrderLines
(
	OrderLineID INT NOT NULL IDENTITY(1, 1) PRIMARY KEY,
	OrderID INT NOT NULL REFERENCES Project.[Order](OrderID),
	CardID INT NOT NULL REFERENCES Project.Card(CardID),
	Quantity INT NOT NULL,

	UNIQUE(OrderID, CardID ASC)
);