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
	CreatedOn DATETIMEOFFSET NOT NULL DEFAULT(TODATETIMEOFFSET(SYSDATETIME(), '-06:00')),

	UNIQUE(Email ASC)
);

CREATE TABLE Project.[Order]
(
	OrderID INT NOT NULL IDENTITY(1, 1) PRIMARY KEY,
	UserID INT NOT NULL REFERENCES Project.[User](UserID),
	OrderDate DATETIMEOFFSET NOT NULL DEFAULT(TODATETIMEOFFSET(SYSDATETIME(), '-06:00')
)
);

CREATE TABLE Project.Card
(
	CardID INT NOT NULL IDENTITY(1, 1) PRIMARY KEY,
	Title NVARCHAR(32) NOT NULL,
	ImageURL NVARCHAR(128) NOT NULL DEFAULT N'https://cdn.shopify.com/s/files/1/0558/4569/products/ALWAYS-FOREVER3_400x.jpg?v=1404230274',
	Price INT NOT NULL,
	CostToProduce INT NOT NULL,
	IsDeleted BIT NOT NULL DEFAULT 0,
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


INSERT Project.CardCategory (Category)
VALUES
		('Birthday'),
		('Graduation'),
		('Anniversary'),
		('Thank You'),
		('Get Well'),
		('New Baby'),
		('Christmas'),
		('Easter'),
		('Fathers Day'),
		('Mothers Day'),
		('Valentines Day'),
		('Condolences'),
		('Thinking of You'),
		('Saturnalia');

SELECT *
FROM Project.CardCategory

INSERT Project.Card (Title, CategoryID, Price, CostToProduce, ImageURL)
VALUES
		('Birthday-Plain',1,300,50,'https://cdn.shopify.com/s/files/1/0558/4569/products/BDAY-STRETCH1_400x.jpg?v=1404160766'),
		('Birthday-Embellished',1,500,50,'https://cdn.shopify.com/s/files/1/0558/4569/products/BDAY-STRETCH1_400x.jpg?v=1404160766'),
		('1st',1,400,50,'https://cdn.shopify.com/s/files/1/0558/4569/products/BDAY-STRETCH1_400x.jpg?v=1404160766'),
		('16th',1,400,50,'https://cdn.shopify.com/s/files/1/0558/4569/products/BDAY-STRETCH1_400x.jpg?v=1404160766'),
		('21st',1,400,50,'https://cdn.shopify.com/s/files/1/0558/4569/products/BDAY-STRETCH1_400x.jpg?v=1404160766'),
		('30th',1,400,50,'https://cdn.shopify.com/s/files/1/0558/4569/products/BDAY-STRETCH1_400x.jpg?v=1404160766'),
		('40th',1,400,50,'https://cdn.shopify.com/s/files/1/0558/4569/products/BDAY-STRETCH1_400x.jpg?v=1404160766'),
		('50th',1,400,50,'https://cdn.shopify.com/s/files/1/0558/4569/products/BDAY-STRETCH1_400x.jpg?v=1404160766'),
		('60th',1,400,50,'https://cdn.shopify.com/s/files/1/0558/4569/products/BDAY-STRETCH1_400x.jpg?v=1404160766'),
		('70th',1,400,50,'https://cdn.shopify.com/s/files/1/0558/4569/products/BDAY-STRETCH1_400x.jpg?v=1404160766'),
		('80th',1,400,50,'https://cdn.shopify.com/s/files/1/0558/4569/products/BDAY-STRETCH1_400x.jpg?v=1404160766'),
		('90th',1,400,50,'https://cdn.shopify.com/s/files/1/0558/4569/products/BDAY-STRETCH1_400x.jpg?v=1404160766'),
		('100th',1,400,50,'https://cdn.shopify.com/s/files/1/0558/4569/products/BDAY-STRETCH1_400x.jpg?v=1404160766'),
		('Graduation-Plain',2,300,50,'https://cdn.shopify.com/s/files/1/0558/4569/products/PC203-BIGSTAR_400x.jpg?v=1422897871'),
		('Graduation-Embellished',2,500,50,'https://cdn.shopify.com/s/files/1/0558/4569/products/PC203-BIGSTAR_400x.jpg?v=1422897871'),
		('Middle School',2,400,50,'https://cdn.shopify.com/s/files/1/0558/4569/products/PC203-BIGSTAR_400x.jpg?v=1422897871'),
		('High School',2,400,50,'https://cdn.shopify.com/s/files/1/0558/4569/products/PC203-BIGSTAR_400x.jpg?v=1422897871'),
		('College',2,400,50,'https://cdn.shopify.com/s/files/1/0558/4569/products/PC203-BIGSTAR_400x.jpg?v=1422897871'),
		('Graduate School',2,400,50,'https://cdn.shopify.com/s/files/1/0558/4569/products/PC203-BIGSTAR_400x.jpg?v=1422897871'),
		('Military Academy',2,400,50,'https://cdn.shopify.com/s/files/1/0558/4569/products/PC203-BIGSTAR_400x.jpg?v=1422897871'),
		('Anniversary-Plain',3,300,50,'https://cdn.shopify.com/s/files/1/0558/4569/products/PC203-BIGSTAR_400x.jpg?v=1422897871'),
		('Anniversary-Embellished',3,500,50,'https://cdn.shopify.com/s/files/1/0558/4569/products/PC203-BIGSTAR_400x.jpg?v=1422897871'),
		('Wedding',3,400,50,'https://cdn.shopify.com/s/files/1/0558/4569/products/PC203-BIGSTAR_400x.jpg?v=1422897871'),
		('Silver',3,400,50,'https://cdn.shopify.com/s/files/1/0558/4569/products/PC203-BIGSTAR_400x.jpg?v=1422897871'),
		('Golden',3,400,50,'https://cdn.shopify.com/s/files/1/0558/4569/products/PC203-BIGSTAR_400x.jpg?v=1422897871'),
		('Thank You-Plain',4,300,50,'https://cdn.shopify.com/s/files/1/0558/4569/products/DOBS-THANKS2_400x.jpg?v=1404225912'),
		('Thank You-Embellished',4,500,50,'https://cdn.shopify.com/s/files/1/0558/4569/products/DOBS-THANKS2_400x.jpg?v=1404225912'),
		('Get Well-Plain',5,300,50,'https://cdn.shopify.com/s/files/1/0558/4569/products/HEART-GOLD-WIDE_400x.jpg?v=1438884573'),
		('Get Well-Embellished',5,500,50,'https://cdn.shopify.com/s/files/1/0558/4569/products/HEART-GOLD-WIDE_400x.jpg?v=1438884573'),
		('New Baby-Plain',6,300,50,'https://cdn.shopify.com/s/files/1/0558/4569/products/HEART-GOLD-WIDE_400x.jpg?v=1438884573'),
		('New Baby-Embellished',6,500,50,'https://cdn.shopify.com/s/files/1/0558/4569/products/HEART-GOLD-WIDE_400x.jpg?v=1438884573'),
		('Christmas-Plain',7,300,50,'https://cdn.shopify.com/s/files/1/0558/4569/products/CAT-ANGEL_400x.jpg?v=1404246149'),
		('Christmas-Embellished',7,500,50,'https://cdn.shopify.com/s/files/1/0558/4569/products/CAT-ANGEL_400x.jpg?v=1404246149'),
		('Santa',7,400,50,'https://cdn.shopify.com/s/files/1/0558/4569/products/CAT-ANGEL_400x.jpg?v=1404246149'),
		('Snowman',7,400,50,'https://cdn.shopify.com/s/files/1/0558/4569/products/CAT-ANGEL_400x.jpg?v=1404246149'),
		('Reindeer',7,400,50,'https://cdn.shopify.com/s/files/1/0558/4569/products/CAT-ANGEL_400x.jpg?v=1404246149'),
		('Elf',7,400,50,'https://cdn.shopify.com/s/files/1/0558/4569/products/CAT-ANGEL_400x.jpg?v=1404246149'),
		('Gingerbread Man',7,400,50,'https://cdn.shopify.com/s/files/1/0558/4569/products/CAT-ANGEL_400x.jpg?v=1404246149'),
		('Easter-Plain',8,300,50,'https://cdn.shopify.com/s/files/1/0558/4569/products/JOY1_400x.jpg?v=1446490387'),
		('Easter-Embellished',8,500,50,'https://cdn.shopify.com/s/files/1/0558/4569/products/JOY1_400x.jpg?v=1446490387'),
		('Bunny',8,400,50,'https://cdn.shopify.com/s/files/1/0558/4569/products/JOY1_400x.jpg?v=1446490387'),
		('Eggs',8,400,50,'https://cdn.shopify.com/s/files/1/0558/4569/products/JOY1_400x.jpg?v=1446490387'),
		('Flowers',8,400,50,'https://cdn.shopify.com/s/files/1/0558/4569/products/JOY1_400x.jpg?v=1446490387'),
		('Fathers Day-Plain',9,300,50,'https://cdn.shopify.com/s/files/1/0558/4569/products/JOY1_400x.jpg?v=1446490387'),
		('Fathers Day-Embellished',9,500,50,'https://cdn.shopify.com/s/files/1/0558/4569/products/CHEERS-WHT_400x.jpg?v=1416259320'),
		('Grandfather',9,400,50,'https://cdn.shopify.com/s/files/1/0558/4569/products/CHEERS-WHT_400x.jpg?v=1416259320'),
		('Mothers Day-Plain',10,300,50,'https://cdn.shopify.com/s/files/1/0558/4569/products/CHEERS-WHT_400x.jpg?v=1416259320'),
		('Mothers Day-Embellished',10,500,50,'https://cdn.shopify.com/s/files/1/0558/4569/products/CHEERS-WHT_400x.jpg?v=1416259320'),
		('Grandmother',10,400,50,'https://cdn.shopify.com/s/files/1/0558/4569/products/CHEERS-WHT_400x.jpg?v=1416259320'),
		('Valentines Day-Plain',11,300,50,'https://cdn.shopify.com/s/files/1/0558/4569/products/CHEERS-WHT_400x.jpg?v=1416259320'),
		('Valentines Day-Embellished',11,500,50,'https://cdn.shopify.com/s/files/1/0558/4569/products/CHEERS-WHT_400x.jpg?v=1416259320'),
		('Boyfriend',11,400,50,'https://cdn.shopify.com/s/files/1/0558/4569/products/CHEERS-WHT_400x.jpg?v=1416259320'),
		('Girlfriend',11,400,50,'https://cdn.shopify.com/s/files/1/0558/4569/products/CHEERS-WHT_400x.jpg?v=1416259320'),
		('Husband',11,400,50,'https://cdn.shopify.com/s/files/1/0558/4569/products/ALPHA-BLK-WIDE_400x.jpg?v=1438884418'),
		('Wife',11,400,50,'https://cdn.shopify.com/s/files/1/0558/4569/products/ALPHA-BLK-WIDE_400x.jpg?v=1438884418'),
		('Condolences-Plain',12,300,50,'https://cdn.shopify.com/s/files/1/0558/4569/products/ALPHA-BLK-WIDE_400x.jpg?v=1438884418'),
		('Condolences-Embellished',12,500,50,'https://cdn.shopify.com/s/files/1/0558/4569/products/ALPHA-BLK-WIDE_400x.jpg?v=1438884418'),
		('Thinking of You-Plain',13,300,50,'https://cdn.shopify.com/s/files/1/0558/4569/products/PC210-ABSTRACTTHINKING_400x.jpg?v=1422898512'),
		('Thinking of You-Embellished',13,500,50,'https://cdn.shopify.com/s/files/1/0558/4569/products/PC210-ABSTRACTTHINKING_400x.jpg?v=1422898512'),
		('Happy Saturnalia',14,600,50,'https://cdn.shopify.com/s/files/1/0558/4569/products/CARPE-DIEM-WIDE_400x.jpg?v=1438884451');


SELECT *
FROM Project.Card


INSERT Project.[User] (FirstName, LastName, Email, IsAdmin, [Password])
VALUES
		('Beau','Polansky','beau@gmail.com',0,'tpvFYeYv['),
		('Arron','North','arron@gmail.com',0,'BVPbiogoL'),
		('Bennie','Rencher','bennie@gmail.com',0,'TNuVF]C\v'),
		('Eldridge','Michel','eldridge@gmail.com',0,'AbcaSBoAv'),
		('Rigoberto','Liming','rigoberto@gmail.com',0,'Ebbuvf[dW'),
		('Octavio','Rielly','octavio@gmail.com',0,'IsoKzQQDZ'),
		('Merrill','Prine','merrill@gmail.com',0,']oqjMnh\W'),
		('Orlando','Galusha','orlando@gmail.com',0,'ajDmljAlO'),
		('Mac','Brenner','mac@gmail.com',0,'VtPEAlAIC'),
		('Bertram','Poland','bertram@gmail.com',0,'SeXCYGF]L'),
		('Jacques','Dallas','jacques@gmail.com',0,'jtT\TGGe`'),
		('Ashley','Sanford','ashley@gmail.com',0,'E^ButmkhW'),
		('Kory','Hageman','kory@gmail.com',0,'oAitcgkQa'),
		('Isaac','Turcios','isaac@gmail.com',0,'H`_[C`[AH'),
		('Domenic','Parm','domenic@gmail.com',0,'oj`iZtia_'),
		('Mario','Nicks','mario@gmail.com',0,'dQqpIsPQh'),
		('German','Mejia','german@gmail.com',0,'Vkx`vwgXS'),
		('Raymond','Loden','raymond@gmail.com',0,'AgUFkIEdp'),
		('Eduardo','Deweese','eduardo@gmail.com',0,'NNzTBvjAT'),
		('Neil','Mitchell','neil@gmail.com',0,'tPUYX_EPD'),
		('Kendrick','Leandro','kendrick@gmail.com',0,'WB`fCVIg_'),
		('August','Ammons','august@gmail.com',0,'RkqOtYbdv'),
		('Blaine','Longfellow','blaine@gmail.com',0,'nqIgwcwgL'),
		('Hobert','Sponsler','hobert@gmail.com',0,'NGc_y_]Jq'),
		('Rolf','Mantyla','rolf@gmail.com',0,'cBZ^G^qXe'),
		('Leo','Vandoren','leo@gmail.com',0,'rJbbJlbmC'),
		('Dewitt','Neisler','dewitt@gmail.com',0,'zQdDNHSgG'),
		('Anthony','Utterback','anthony@gmail.com',0,'PmdXeE^AS'),
		('Antony','Billups','antony@gmail.com',0,'lwpEU^YC]'),
		('Sydney','Dockery','sydney@gmail.com',0,'EHQeQvtkG'),
		('Brett','Overfelt','brett@gmail.com',0,'xRgiQdzXn'),
		('Wilton','Lish','wilton@gmail.com',0,'paJBHMuUq'),
		('Keenan','Schauwecker','keenan@gmail.com',0,'WEjMlAdIN'),
		('Millard','Martinek','millard@gmail.com',0,'fYbXrQW[x'),
		('Bernie','Mauck','bernie@gmail.com',0,'eQPN[hiBU'),
		('Ryan','Rushin','ryan@gmail.com',0,'KAjMjLySx'),
		('Lacy','Castello','lacy@gmail.com',0,'KLOdMj[ft'),
		('Rhett','Tague','rhett@gmail.com',0,'uZnAGM_OS'),
		('Alfred','Bucholtz','alfred@gmail.com',0,'mffoKZXvR'),
		('Kerry','Sellars','kerry@gmail.com',0,'NdGyVUmuc'),
		('Vance','Roper','vance@gmail.com',0,'_Rll\zu\R'),
		('Jose','Salser','jose@gmail.com',0,'L\CeBnj`d'),
		('Irwin','Gathers','irwin@gmail.com',0,']UoE\MZjr'),
		('Lucius','Zachery','lucius@gmail.com',0,'GWwOYJ[Uj'),
		('Emory','Waltz','emory@gmail.com',0,'rUJRxbD`T'),
		('Clark','Walrath','clark@gmail.com',0,'[vPzkmtLM'),
		('Jeffry','Cloyd','jeffry@gmail.com',0,'ra\aE]bjl'),
		('Glen','Stecker','glen@gmail.com',0,'hTPOrCRW]'),
		('Lesley','Clara','lesley@gmail.com',0,'tA_XMMeKF'),
		('Gaston','Shoffner','gaston@gmail.com',0,'Ui\btZGsS'),
		('Tanya','Bing','tanya@gmail.com',0,'Sz[Hp`Zfu'),
		('Jaleesa','Lovelace','jaleesa@gmail.com',0,'eXPErjM[V'),
		('Nydia','Bustamante','nydia@gmail.com',0,'lRSUHUfHJ'),
		('Juliane','Donner','juliane@gmail.com',0,'^dtqLu`IV'),
		('Cleopatra','Cho','cleopatra@gmail.com',0,'SpECagKFE'),
		('Emily','Romans','emily@gmail.com',0,'\RPWP^_B['),
		('Eloisa','Weissinger','eloisa@gmail.com',0,'mYSxOK\L['),
		('Estelle','Mcmurry','estelle@gmail.com',0,'H`EA\OLLr'),
		('Miriam','Heard','miriam@gmail.com',0,'jorJr^Tyf'),
		('Eleonore','Cappel','eleonore@gmail.com',0,'Q]WpAueny'),
		('Geraldine','Esquer','geraldine@gmail.com',0,'OGWIJYhNK'),
		('Malorie','Bonhomme','malorie@gmail.com',0,'CqkuMdVvI'),
		('Leora','Button','leora@gmail.com',0,'e_UXnQfoR'),
		('Wendy','Natera','wendy@gmail.com',0,'hEQqH`nYK'),
		('Genny','Loch','genny@gmail.com',0,'jSpCQkQqm'),
		('Jeneva','Lasiter','jeneva@gmail.com',0,'rkuuyTwdO'),
		('Jolanda','Macy','jolanda@gmail.com',0,'BEbEtJtkL'),
		('Jane','Lamson','jane@gmail.com',0,'BaCVNJ\Ct'),
		('Ayako','Lowrey','ayako@gmail.com',0,'j]SMyloTp'),
		('Claris','Lemus','claris@gmail.com',0,'e^HksMBAN'),
		('Carri','Giannini','carri@gmail.com',0,'fLz^ErFhY'),
		('Sigrid','Yamashita','sigrid@gmail.com',0,'k[TQzLASd'),
		('Nellie','Karcher','nellie@gmail.com',0,'ZxgQCKD^X'),
		('Tracee','Enderle','tracee@gmail.com',0,'DFd^u_qKf'),
		('Deana','Sickels','deana@gmail.com',0,']ojF]tgw`'),
		('Kia','Valiente','kia@gmail.com',0,'VfqQFXNPv'),
		('Marylouise','Reddish','marylouise@gmail.com',0,'ftrEngZ\`'),
		('Emmy','Hennen','emmy@gmail.com',0,'enPfyIk^i'),
		('Debbra','Ishibashi','debbra@gmail.com',0,'kERetsPVx'),
		('Salley','Welles','salley@gmail.com',0,'tXdzmHDzP'),
		('Mercedez','Vale','mercedez@gmail.com',0,'U\yxJkUte'),
		('Xuan','Guttman','xuan@gmail.com',0,'UqM\yC^gD'),
		('Corrina','Games','corrina@gmail.com',0,'VB[BPxvxE'),
		('Shakita','Mckoy','shakita@gmail.com',0,'zT[BWGcQX'),
		('Melonie','Strayhorn','melonie@gmail.com',0,'zqV`pvsqO'),
		('Kizzy','Birney','kizzy@gmail.com',0,'AcRoG`Kp\'),
		('Lesli','Pugsley','lesli@gmail.com',0,'VjFvCrhkp'),
		('Machelle','Mormon','machelle@gmail.com',0,'WvbhcDHjV'),
		('Kisha','Ram','kisha@gmail.com',0,'tgYPQ^d`O'),
		('Susie','Marple','susie@gmail.com',0,'xzQybUJMz'),
		('Patria','Sparkman','patria@gmail.com',0,'UTIOaLEqt'),
		('Hermelinda','Misiewicz','hermelinda@gmail.com',0,'RgvUWfKld'),
		('Alexa','Wiers','alexa@gmail.com',0,'RAzJJtSQj'),
		('Merry','Hynek','merry@gmail.com',0,'hhiRGifyl'),
		('Beata','Keplinger','beata@gmail.com',0,'VUfEjeTCL'),
		('Erma','Vero','erma@gmail.com',0,'pvnDZqt^u'),
		('Janet','Kehr','janet@gmail.com',0,'lE`QpsIHe'),
		('Cher','Benfield','cher@gmail.com',0,'acxtwHMsa'),
		('Kimberley','Koenig','kimberley@gmail.com',0,'bI_XcTzvk'),
		('Dann','Knaub','dann@gmail.com',0,'NptqR`FUY'),
		('admin','super','a',1,'a');

SELECT *
FROM Project.[User]

DECLARE @orderCount INT = 300;

WHILE(SELECT COUNT(*) FROM Project.[Order]) < @orderCount
BEGIN
INSERT Project.[Order] (UserID, OrderDate)
VALUES

	(
		(
			SELECT UserID FROM (
			SELECT ROW_NUMBER() OVER(ORDER BY UserID) [row], UserID
			FROM Project.[User]
			) t 
			WHERE t.row = 1 + (SELECT CAST(RAND() * COUNT(*) as INT) FROM Project.[User])
		)
	
	,GETDATE() - (365 * (5 * RAND())));
END

SELECT *
FROM Project.[Order]
ORDER BY UserID

DECLARE @orderLineCount INT = 1;

WHILE(SELECT COUNT(*) FROM Project.OrderLines) < @orderCount
BEGIN
INSERT Project.OrderLines (OrderID, CardID, Quantity)
VALUES
	(
		
		@orderLineCount,

		(
			SELECT CardID FROM (
			SELECT ROW_NUMBER() OVER(ORDER BY CardID) [row], CardID
			FROM Project.Card
			) t 
			WHERE t.row = 1 + (SELECT CAST(RAND() * COUNT(*) as INT) FROM Project.Card)
		),
		CAST(RAND()*10 as INT)+1
	)

	SET @orderLineCount = @orderLineCount+1;
END

WHILE(SELECT COUNT(*) FROM Project.OrderLines) < 800
BEGIN
INSERT Project.OrderLines (OrderID, CardID, Quantity)
VALUES
	(
		(
			SELECT OrderID FROM (
			SELECT ROW_NUMBER() OVER(ORDER BY OrderID) [row], OrderID
			FROM Project.[Order]
			) t 
			WHERE t.row = 1 + (SELECT CAST(RAND() * COUNT(*) as INT) FROM Project.[Order])
		),

		(
			SELECT CardID FROM (
			SELECT ROW_NUMBER() OVER(ORDER BY CardID) [row], CardID
			FROM Project.Card
			) t 
			WHERE t.row = 1 + (SELECT CAST(RAND() * COUNT(*) as INT) FROM Project.Card)
		),
		CAST(RAND()*10 as INT)+1
	)
END


SELECT *
FROM Project.OrderLines
ORDER BY OrderID


INSERT Project.CartItems (UserID, CardID, Quantity)
VALUES
		(20, 12, 3),
		(20, 5, 2),
		(20, 30, 4);

SELECT *
FROM Project.CartItems