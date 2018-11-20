CREATE SCHEMA Project;
GO

DROP TABLE IF EXISTS Project.CartItems;
DROP TABLE IF EXISTS Project.OrderLines;
DROP TABLE IF EXISTS Project.[Order];
DROP TABLE IF EXISTS Project.[User];
DROP TABLE IF EXISTS Project.Product;
DROP TABLE IF EXISTS Project.ProductCategory;

CREATE TABLE Project.ProductCategory
(
	CategoryID INT NOT NULL IDENTITY(1, 1) PRIMARY KEY,
	[Description] NVARCHAR(128) NOT NULL
);

CREATE TABLE Project.[User]
(
	UserID INT NOT NULL IDENTITY(1, 1) PRIMARY KEY,
	FirstName NVARCHAR(32) NOT NULL,
	LastName NVARCHAR(32) NOT NULL,
	Email NVARCHAR(128) NOT NULL,
	IsAdmin BIT NOT NULL,
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

CREATE TABLE Project.Product
(
	ProductID INT NOT NULL IDENTITY(1, 1) PRIMARY KEY,
	ProductName NVARCHAR(32) NOT NULL,
	CategoryID INT NOT NULL REFERENCES Project.ProductCategory(CategoryID),
	UnitPrice NVARCHAR(8) NOT NULL,

	UNIQUE(ProductName ASC)
);

CREATE TABLE Project.CartItems
(
	UserID INT NOT NULL REFERENCES Project.[User](UserID),
	ProductID INT NOT NULL REFERENCES Project.Product(ProductID),
	Quantity NVARCHAR(128) NOT NULL,

	PRIMARY KEY(UserID, ProductID)
);

CREATE TABLE Project.OrderLines
(
	OrderLinesID INT NOT NULL IDENTITY(1, 1) PRIMARY KEY,
	OrderID INT NOT NULL REFERENCES Project.[Order](OrderID),
	ProductID INT NOT NULL REFERENCES Project.Product(ProductID),
	Quantity NVARCHAR(8) NOT NULL,

	UNIQUE(OrderID, ProductID ASC)
);