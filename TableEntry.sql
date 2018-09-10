CREATE TABLE Entry (
    ID int NOT NULL AUTO_INCREMENT,
    Lastname varchar(30) NOT NULL,
    Firstname varchar(30) NOT NULL,
	Phone varchar(15) NOT NULL,
    Address1 varchar(30) NOT NULL,
    Address2 varchar(30),
    City varchar(30),
    State varchar(2),
    Zip varchar(10),
    Notes varchar(100),
    PRIMARY KEY (ID)
);