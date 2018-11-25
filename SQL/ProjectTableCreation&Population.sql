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


INSERT Project.ProductCategory (Description)
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
		('Thinking of You');

SELECT *
FROM Project.ProductCategory

INSERT Project.Product (ProductName, CategoryID, UnitPrice)
VALUES
		('Birthday-Plain',1,3.00),
		('Birthday-Embellished',1,5.00),
		('1st',1,4.00),
		('16th',1,4.00),
		('21st',1,4.00),
		('30th',1,4.00),
		('40th',1,4.00),
		('50th',1,4.00),
		('60th',1,4.00),
		('70th',1,4.00),
		('80th',1,4.00),
		('90th',1,4.00),
		('100th',1,4.00),
		('Graduation-Plain',2,3.00),
		('Graduation-Embellished',2,5.00),
		('Middle School',2,4.00),
		('High School',2,4.00),
		('College',2,4.00),
		('Graduate School',2,4.00),
		('Military Academy',2,4.00),
		('Anniversary-Plain',3,3.00),
		('Anniversary-Embellished',3,5.00),
		('Wedding',3,4.00),
		('Silver',3,4.00),
		('Golden',3,4.00),
		('Thank You-Plain',4,3.00),
		('Thank You-Embellished',4,5.00),
		('Get Well-Plain',5,3.00),
		('Get Well-Embellished',5,5.00),
		('New Baby-Plain',6,3.00),
		('New Baby-Embellished',6,5.00),
		('Christmas-Plain',7,3.00),
		('Christmas-Embellished',7,5.00),
		('Santa',7,4.00),
		('Snowman',7,4.00),
		('Reindeer',7,4.00),
		('Elf',7,4.00),
		('Gingerbread Man',7,4.00),
		('Easter-Plain',8,3.00),
		('Easter-Embellished',8,5.00),
		('Bunny',8,4.00),
		('Eggs',8,4.00),
		('Flowers',8,4.00),
		('Fathers Day-Plain',9,3.00),
		('Fathers Day-Embellished',9,5.00),
		('Grandfather',9,4.00),
		('Mothers Day-Plain',10,3.00),
		('Mothers Day-Embellished',10,5.00),
		('Grandmother',10,4.00),
		('Valentines Day-Plain',11,3.00),
		('Valentines Day-Embellished',11,5.00),
		('Boyfriend',11,4.00),
		('Girlfriend',11,4.00),
		('Husband',11,4.00),
		('Wife',11,4.00),
		('Condolences-Plain',12,3.00),
		('Condolences-Embellished',12,5.00),
		('Thinking of You-Plain',13,3.00),
		('Thinking of You-Embellished',13,5.00);


SELECT *
FROM Project.Product


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
		('Dann','Knaub','dann@gmail.com',0,'NptqR`FUY');

SELECT *
FROM Project.[User]