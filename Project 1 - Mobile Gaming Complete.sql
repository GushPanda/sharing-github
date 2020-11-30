--1. User Table (Dimension) - Country, Platform (Android/IOS), Device
--2. Games table (including install date)
--3. Games Installs Tables - Information about a User installing a specific game
--4. Sessions - SessionID = started playing until he stopped playing is 1 sessions
--5. Events - User events Balance Increase/Decrease as a specific Column - the rest as main Description set in Subjects
--6. Purchases - BasicPurchase as the Basic game purchase, all the rest as PurchaseDesc(ription)
--7. Campaigns - where did the user ID come from
CREATE Database Mobile_Games
GO

USE Mobile_games
GO
--7. Campaigns - where did the userID come from
CREATE TABLE Campaigns
(
CampaignID INT, -- PK
CampaignName VARCHAR(50),
CampaignStart DATETIME CONSTRAINT Campaign_strt_nn NOT NULL,
CampaignEnd DATETIME,
CampaignPlatform VARCHAR(20) CONSTRAINT Campaign_Plt_nn NOT NULL
 CONSTRAINT Campaigns_ID_pk PRIMARY KEY (CampaignID),
)
GO

--1. User Table (Dimension) - Country, Platform (Android/IOS), Device
CREATE TABLE Users
(
UserID INT,
FirstName VARCHAR(30),
LastName VARCHAR(30),
Email VARCHAR(40),
Country VARCHAR(30) CONSTRAINT Users_cn_nn NOT NULL,
City VARCHAR(25) CONSTRAINT Users_ct_nn NOT NULL,
BirthDate DATE,
Phone VARCHAR(25),
RegDate DATETIME DEFAULT GETDATE(),
DeviceName VARCHAR(20) CONSTRAINT Users_dn_nn NOT NULL,
CampaignID INT, -- FK in Campaigns
Platform VARCHAR(20) CONSTRAINT Users_pf_nn NOT NULL,
FTD DATETIME, -- = The first time the UserID made a Purchase
 CONSTRAINT Users_ID_pk PRIMARY KEY (UserID),
 CONSTRAINT Users_campID_fk FOREIGN KEY (CampaignID) REFERENCES Campaigns(CampaignID)
)
GO

--2. Games table - Basic Games list table
CREATE TABLE Games
(
GameID INT,
GameName VARCHAR(30),
GameSize INT,
DatePublished DATE,
Active VARCHAR(3) CONSTRAINT Games_actv_nn NOT NULL DEFAULT 'Yes',
Creator VARCHAR(25), 
Cost NUMERIC(8,2),
 CONSTRAINT Games_ID_pk PRIMARY KEY (GameID),
 CONSTRAINT Games_gn_uq UNIQUE(GameName)
)
GO

--3. Games Installs Tables - Information about a User installing a specific game
CREATE TABLE Games_Installs
(
InstallID INT, -- PK
UserID INT, -- FK in Users
GameID INT, -- FK in Games
GameName VARCHAR(30),
DateInstalled DATETIME,
 CONSTRAINT Gamesins_InstID_pk PRIMARY KEY (InstallID),
 CONSTRAINT Gamesins_ID_fk FOREIGN KEY (GameID) REFERENCES Games(GameID),
 CONSTRAINT Gamesins_usrID_fk FOREIGN KEY (UserID) REFERENCES Users(UserID),
)
GO

--4. Sessions - SessionID = started playing until he stopped playing is 1 sessions
CREATE TABLE Sessions
(
SessionID INT, -- PK
GameID INT, --FK in Games
UserID INT, -- FK in Users
SessionStart DATETIME CONSTRAINT Sessions_strt_nn NOT NULL,
SessionEnd DATETIME,
SessionDuration INT,
 CONSTRAINT Sessions_ID_pk PRIMARY KEY (SessionID),
 CONSTRAINT Sessions_gmeID_fk FOREIGN KEY (GameID) REFERENCES Games(GameID),
 CONSTRAINT Sessions_usrID_fk FOREIGN KEY (UserID) REFERENCES Users(UserID),
)
GO

--5. Events - User events Balance Increase/Decrease as a specific Column 
CREATE TABLE Events
(
EventID INT, --PK
UserID INT, -- FK in Users
EventDes VARCHAR(50),
EventDate DATETIME,
GameID INT, --FK in Games
PlayerLevel INT,
SessionID INT, -- FK in Sessions
Balance NUMERIC(15,2),
BalanceIncrease NUMERIC(15,2),
BalanceDecrease NUMERIC(15,2),
 CONSTRAINT Events_ID_pk PRIMARY KEY (EventID),
 CONSTRAINT Events_usrID_fk FOREIGN KEY (UserID) REFERENCES Users(UserID),
 CONSTRAINT Events_Gameid_fk FOREIGN KEY (GameID) REFERENCES Games(GameID),
 CONSTRAINT Events_SesID_fk FOREIGN KEY (SessionID) REFERENCES Sessions(SessionID)
)
GO

--6. Purchases - PurchaseDesc - Purchase Description
CREATE TABLE Purchases
(
PurchaseID INT PRIMARY KEY, -- PK 
GameID INT, --FK in Games
UserID INT , -- FK in Users
EventID INT, -- FK in Events
EventDate DATETIME CONSTRAINT Purchases_strt_nn NOT NULL,
PurchaseAmount NUMERIC(8,2) CONSTRAINT Purchases_end_nn NOT NULL,
PurchaseDesc VARCHAR(100), -- Game Purchase? Inside-game Purchase?
 CONSTRAINT Purchases_ID_fk FOREIGN KEY (GameID) REFERENCES Games(GameID),
 CONSTRAINT Purchases_usrID_fk FOREIGN KEY (UserID) REFERENCES Users(UserID),
 CONSTRAINT Purchases_EID_fk FOREIGN KEY (EventID) REFERENCES Events(EventID)
 )
 GO

-- Inputting date into Campaigns table 
INSERT INTO Campaigns VALUES (1, 'Facebook_Jan_2020', '2020-01-01', '2020-01-31', 'Facebook')
INSERT INTO Campaigns VALUES (2, 'Google_Q1_2020', '2020-01-01', '2020-03-31', 'Google')
INSERT INTO Campaigns VALUES (3, 'Insta_2020_Yearly', '2020-01-01', NULL, 'Instagram')
INSERT INTO Campaigns VALUES (4, 'Facebook_Feb_2020', '2020-02-01', '2020-02-28', 'Facebook')
INSERT INTO Campaigns VALUES (5, 'Facebook_March_2020', '2020-03-01', '2020-03-31', 'Facebook')
INSERT INTO Campaigns VALUES (6, 'Facebook_April_2020', '2020-04-01', '2020-04-30', 'Facebook')
INSERT INTO Campaigns VALUES (7, 'Facebook_May_2020', '2020-05-01', '2020-05-30', 'Facebook')
INSERT INTO Campaigns VALUES (8, 'Facebook_June_2020', '2020-06-01', '2020-06-30', 'Facebook')
INSERT INTO Campaigns VALUES (9, 'Facebook_July_2020', '2020-07-01', '2020-07-31', 'Facebook')
INSERT INTO Campaigns VALUES (10, 'Facebook_August_2020', '2020-08-01', NULL, 'Facebook')
INSERT INTO Campaigns VALUES (11, 'Google_Q2_2020', '2020-04-01', '2020-07-31', 'Google')
INSERT INTO Campaigns VALUES (12, 'Google_Q3_2020', '2020-08-01', NULL, 'Google')
INSERT INTO Campaigns VALUES (13, 'Insta_February_W1', '2020-02-01', '2020-02-08', 'Instagram')
INSERT INTO Campaigns VALUES (14, 'Insta_April_W3', '2020-04-12', '2020-04-18', 'Instagram')
GO


-- Inputting date into Games table 
INSERT INTO Games VALUES (1, 'Donky Kong', '151211', '2020-01-02', 'Yes', 'Daniel Red', 9.99)
INSERT INTO Games VALUES (2, 'Donky Kong 2', '181445', '2020-05-05', 'Yes', 'Daniel Red', 11.5)
INSERT INTO Games VALUES (3, 'Roll It', '1242201', '2018-04-13', 'Yes', 'Daniel Red', NULL)
INSERT INTO Games VALUES (4, 'Free to Win', '7548885', '2010-01-05', 'No', 'Ted Goner', NULL)
INSERT INTO Games VALUES (5, 'Tables', '6247758', '2019-08-04', 'Yes', 'Daniel Red', 1.72)
INSERT INTO Games VALUES (6, 'Free to Clash', '4572251', '2012-01-09', 'Yes', 'Ted Goner', NULL)
INSERT INTO Games VALUES (7, 'Free to Rule', '21542241', '2017-03-01', 'Yes', 'Ted Goner', NULL)
INSERT INTO Games VALUES (8, 'Ruling the Freedom', '3544111', '2016-06-23', 'No', 'Ted Goner', NULL)
INSERT INTO Games VALUES (9, 'BlackJack Rebuilt', '6547888', '2013-01-01', 'Yes', 'Donny Spender', NULL)
INSERT INTO Games VALUES (10, 'Poker Rebuilt', '65477777', '2014-05-17', 'Yes', 'Donny Spender', NULL)
INSERT INTO Games VALUES (11, 'Ruling the World', '33332251', '2019-02-12', 'Yes', 'Donny Spender', 19.90)
INSERT INTO Games VALUES (12, 'Dying in-Game', '33332251', '2020-04-29', 'Yes', 'Donny Spender', 10.5)
INSERT INTO Games VALUES (13, 'Vacation Time', '45454111', '2019-01-17', 'Yes', 'Donny Spender', NULL)
INSERT INTO Games VALUES (14, 'Eating it', '999548444', '2019-07-03', 'Yes', 'Donny Spender', NULL)
INSERT INTO Games VALUES (15, 'Shoot It', '999548444', '2010-11-20', 'Yes', 'Saul Cohen', NULL)
INSERT INTO Games VALUES (16, 'Win It', '999548444', '2011-12-21', 'Yes', 'Saul Cohen', NULL)
GO

-- Inputting date into Users table 
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (1, 'Garret', 'McCartney', 'gmccartney0@icio.us', 'Ukraine', 'Mizhhir’ya', '1983-04-25', '(436) 5986746', '2019-05-11', 'Huawei Mate 20 Pro', 11, 'Android 10');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (2, 'Emmalyn', 'Dane', 'edane1@symantec.com', 'Colombia', 'Campamento', '2005-09-09', '(565) 4604030', '2019-08-16', 'iPhone 6', 11, 'iOS 9.3.5');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (3, 'Alick', 'Chauvey', 'achauvey2@networksolutions.com', 'Portugal', 'Vale Mourão', '1920-09-20', '(165) 4023025', '2018-03-30', 'Huawei Mate 10 Pro', 8, 'iOS 9.3.5');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (4, 'Fredelia', 'Earland', 'fearland3@pinterest.com', 'Indonesia', 'Lewograran', '1998-09-02', '(329) 3586630', '2012-04-04', 'iPhone 6s', 3, 'Android Oreo');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (5, 'Karel', 'Wellbeloved', 'kwellbeloved4@answers.com', 'Sweden', 'Trelleborg', '1967-02-18', '(494) 1448919', '2013-05-04', 'Huawei P20', 9, 'iOS 10.3.4');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (6, 'Alica', 'Everil', 'aeveril5@forbes.com', 'Afghanistan', 'Jurm', '1989-09-12', '(669) 5478307', '2019-02-13', 'Huawei P20', 13, 'Android 10');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (7, 'Horacio', 'Heatly', 'hheatly6@istockphoto.com', 'Czech Republic', 'Bílovec', '1970-02-03', '(470) 2629329', '2020-04-03', 'iPhone 7s', 13, 'Android Lollipop');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (8, 'Perceval', 'Pottell', 'ppottell7@posterous.com', 'Honduras', 'Sabá', '1985-05-25', '(585) 7744107', '2018-06-23', 'Huawei Mate 10', 3, 'iOS 9.3.5');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (9, 'Maude', 'Peggrem', 'mpeggrem8@si.edu', 'China', 'Leiling', '2019-11-13', '(441) 7333169', '2018-02-03', 'iPhone 6', 4, 'Android KitKat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (10, 'Garvey', 'Goddert.sf', 'ggoddertsf9@t-online.de', 'Russia', 'Tashla', '1944-01-10', '(122) 9270339', '2020-01-18', 'Huawei Mate 20', 3, 'Android KitKat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (11, 'Carney', 'Prene', 'cprenea@mediafire.com', 'Spain', 'Salamanca', '1936-09-17', '(854) 6833330', '2010-02-16', 'iPhone 7s', 5, 'Android 10');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (12, 'Sherman', 'Dulany', 'sdulanyb@ning.com', 'Indonesia', 'Ngluwuk', '1992-03-31', '(288) 1734312', '2018-10-28', 'Huawei P20', 10, 'Android 10');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (13, 'Vasili', 'Northin', 'vnorthinc@dmoz.org', 'Venezuela', 'Barbacoas', '1966-07-20', '(787) 9022071', '2014-05-01', 'Huawei Mate 20 Pro', 8, 'Android Pie');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (14, 'Ted', 'Trammel', 'ttrammeld@twitpic.com', 'Japan', 'Yugawara', '1990-06-12', '(547) 6606079', '2012-04-06', 'iPhone 7s', 12, 'iOS 10.3.3');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (15, 'Jordain', 'Doornbos', 'jdoornbose@cbsnews.com', 'Afghanistan', 'Mehtar Lām', '1977-01-24', '(134) 7363252', '2012-02-06', 'Huawei P30 Pro', 14, 'iOS 13.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (16, 'Clovis', 'Waywell', 'cwaywellf@ucoz.com', 'Brazil', 'Lavras', '1934-05-20', '(477) 5162409', '2020-07-23', 'iPhone 8s', 7, 'Android Marshmallow');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (17, 'Suzy', 'Djuricic', 'sdjuricicg@latimes.com', 'Canada', 'Beaconsfield', '1921-12-20', '(860) 2559963', '2018-02-11', 'iPhone 7', 12, 'Android Marshmallow');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (18, 'Welbie', 'Fillimore', 'wfillimoreh@google.co.jp', 'China', 'Wenqiao', '1941-05-01', '(338) 8367845', '2015-10-26', 'Galaxy S8', 1, 'iOS 13.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (19, 'Vivi', 'Tiery', 'vtieryi@mashable.com', 'Cuba', 'Banes', '1935-02-12', '(212) 7369322', '2015-03-01', 'iPhone 8', 8, 'iOS 12.4.8');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (20, 'Eudora', 'Rattray', 'erattrayj@tripod.com', 'Russia', 'Troitsk', '1960-12-07', '(439) 7934150', '2016-05-29', 'iPhone 7s', 14, 'Android Jelly Bean');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (21, 'Garvin', 'Troppmann', 'gtroppmannk@chron.com', 'Russia', 'Ust’-Katav', '1931-09-29', '(119) 6866305', '2019-03-04', 'Huawei P20 Pro', 1, 'Android KitKat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (22, 'Lowell', 'Pascall', 'lpascalll@scientificamerican.com', 'United States', 'Spartanburg', '2008-02-23', '(864) 5932972', '2017-06-25', 'iPhone 7s', 1, 'Android 10');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (23, 'Odette', 'Crunkhorn', 'ocrunkhornm@webs.com', 'Russia', 'Dukhovnitskoye', '1991-08-05', '(983) 1422521', '2012-03-02', 'Huawei Mate 10 Pro', 3, 'Android Lollipop');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (24, 'Kelcy', 'Torregiani', 'ktorregianin@statcounter.com', 'Pakistan', 'Sobhādero', '1975-07-14', '(624) 6018643', '2014-01-20', 'Huawei P20', 8, 'iOS 9.3.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (25, 'Angelica', 'Francke', 'afranckeo@go.com', 'Poland', 'Błażowa', '1934-05-17', '(147) 9926658', '2013-01-27', 'Huawei P9 Pro', 7, 'iOS 10.3.3');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (26, 'Boy', 'Turmel', 'bturmelp@gnu.org', 'Kosovo', 'Suva Reka', '2001-05-09', '(155) 2884471', '2017-07-20', 'iPhone X', 12, 'iOS 10.3.4');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (27, 'Blanch', 'Woodroffe', 'bwoodroffeq@hhs.gov', 'China', 'Gangba', '1965-05-03', '(579) 7611821', '2013-09-18', 'Huawei Mate 10', 13, 'iOS 10.3.4');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (28, 'Luca', 'Tottem', 'ltottemr@irs.gov', 'China', 'Rudong', '2005-03-31', '(283) 6045225', '2018-10-15', 'iPhone 7', 1, 'iOS 9.3.5');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (29, 'Michaela', 'Thorneley', 'mthorneleys@mac.com', 'Poland', 'Opatów', '1955-05-02', '(587) 9507826', '2010-10-13', 'Galaxy S8', 3, 'Android KitKat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (30, 'Levi', 'Lamar', 'llamart@amazon.co.uk', 'Honduras', 'Vallecillo', '1938-08-10', '(644) 5086156', '2017-07-07', 'Huawei Mate 20 Pro', 3, 'Android 10');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (31, 'Candide', 'Lande', 'clandeu@apache.org', 'Kenya', 'Nanyuki', '2016-11-19', '(689) 2390325', '2017-12-07', 'Huawei P9 Pro', 14, 'iOS 9.3.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (32, 'Dela', 'Winley', 'dwinleyv@independent.co.uk', 'Indonesia', 'Ciusul', '1927-02-16', '(606) 9360688', '2015-09-16', 'Huawei P9 Pro', 10, 'Android Jelly Bean');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (33, 'Aldrich', 'Tilbury', 'atilburyw@ftc.gov', 'Tajikistan', 'Boshkengash', '1976-08-31', '(692) 7394658', '2013-07-29', 'iPhone 6s', 6, 'Android Oreo');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (34, 'Odella', 'Linley', 'olinleyx@amazon.co.uk', 'Czech Republic', 'Brodek u Přerova', '1979-11-29', '(348) 9919290', '2012-05-30', 'Huawei Mate 10', 13, 'Android Marshmallow');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (35, 'Loria', 'Spurr', 'lspurry@flickr.com', 'Moldova', 'Cahul', '1921-09-06', '(777) 5776333', '2012-01-23', 'Huawei P9', 11, 'Android KitKat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (36, 'Dalli', 'Lewsey', 'dlewseyz@nyu.edu', 'China', 'Aoqian', '1920-04-13', '(880) 8757257', '2015-10-17', 'Huawei P9', 1, 'iOS 12.4.8');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (37, 'Toddie', 'Baldassi', 'tbaldassi10@w3.org', 'Brazil', 'Estância Velha', '1925-03-25', '(237) 9746861', '2017-08-28', 'Huawei Mate 10 Pro', 7, 'Android KitKat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (38, 'Rene', 'Ney', 'rney11@lulu.com', 'Indonesia', 'Plandi', '2019-09-15', '(913) 3132328', '2016-08-13', 'iPhone 7s', 12, 'iOS 12.4.8');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (39, 'Gabbie', 'Domeney', 'gdomeney12@linkedin.com', 'Belarus', 'Kokhanava', '1924-05-26', '(133) 7518599', '2019-10-08', 'iPhone 6', 4, 'iOS 12.4.8');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (40, 'Merla', 'Frankcombe', 'mfrankcombe13@usgs.gov', 'China', 'Maojiagang', '1924-01-31', '(232) 2750890', '2016-01-21', 'Huawei P9', 12, 'iOS 13.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (41, 'Katharyn', 'McNulty', 'kmcnulty14@barnesandnoble.com', 'Indonesia', 'Cimuncang', '1951-08-16', '(662) 5569484', '2011-07-25', 'iPhone X', 11, 'Android Jelly Bean');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (42, 'Hammad', 'Storey', 'hstorey15@topsy.com', 'China', 'Yinjiang', '1992-06-27', '(192) 2597780', '2012-03-11', 'iPhone 8s', 14, 'Android Lollipop');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (43, 'Kanya', 'Catlin', 'kcatlin16@weibo.com', 'Portugal', 'Verdizela', '1969-07-08', '(322) 9159232', '2010-01-04', 'Huawei P9 Pro', 5, 'Android KitKat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (44, 'Rosabel', 'Matej', 'rmatej17@symantec.com', 'Greece', 'Lianokládhion', '1959-11-18', '(143) 5771985', '2010-01-27', 'iPhone 6s', 9, 'Android Marshmallow');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (45, 'Neron', 'Bale', 'nbale18@weibo.com', 'Qatar', 'Fuwayriţ', '1977-02-03', '(314) 3978127', '2017-09-01', 'Huawei Mate 10', 10, 'Android Oreo');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (46, 'Lowell', 'Massow', 'lmassow19@chronoengine.com', 'Micronesia', 'Pisaras', '1921-06-25', '(909) 7911608', '2014-03-27', 'Galaxy S10', 13, 'iOS 9.3.5');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (47, 'Starlin', 'Meineck', 'smeineck1a@prlog.org', 'Russia', 'Novosmolinskiy', '1964-11-29', '(223) 4294170', '2010-11-01', 'Huawei P10 Pro', 10, 'Android Oreo');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (48, 'Victoir', 'Vannuccinii', 'vvannuccinii1b@cbc.ca', 'United States', 'Seattle', '1977-11-11', '(206) 1542011', '2019-06-14', 'Huawei Mate 10', 11, 'Android Nougat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (49, 'Henderson', 'Brantl', 'hbrantl1c@sciencedirect.com', 'Somalia', 'Dujuuma', '1931-11-09', '(238) 3733386', '2015-10-05', 'Huawei P30 Pro', 6, 'Android Marshmallow');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (50, 'Ignazio', 'Tomowicz', 'itomowicz1d@twitter.com', 'Poland', 'Czarków', '1998-02-20', '(229) 2265836', '2010-09-13', 'Huawei P20 Pro', 10, 'iOS 12.4.8');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (51, 'Casey', 'Warcop', 'cwarcop1e@dailymotion.com', 'Peru', 'Longuita', '1996-06-15', '(260) 8140478', '2015-05-31', 'Huawei P9', 6, 'iOS 13.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (52, 'Trescha', 'Huelin', 'thuelin1f@smugmug.com', 'Indonesia', 'Ikar', '1974-12-09', '(845) 3102412', '2015-03-19', 'iPhone 8s', 10, 'Android Lollipop');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (53, 'Thurston', 'Domb', 'tdomb1g@diigo.com', 'France', 'Pau', '1996-10-28', '(764) 5598121', '2017-10-31', 'Huawei P30 Pro', 8, 'Android KitKat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (54, 'Kath', 'Pflieger', 'kpflieger1h@cbslocal.com', 'Russia', 'Novosheshminsk', '1920-02-10', '(953) 6761698', '2013-12-27', 'Huawei P10 Pro', 12, 'Android Marshmallow');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (55, 'Hagan', 'Johanning', 'hjohanning1i@nhs.uk', 'Sweden', 'Helsingborg', '1999-02-21', '(595) 1233876', '2015-09-04', 'Huawei P10', 14, 'iOS 9.3.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (56, 'Bethany', 'Duckinfield', 'bduckinfield1j@rediff.com', 'Russia', 'Palana', '1965-12-18', '(337) 2609286', '2010-05-22', 'Huawei P9', 2, 'Android Nougat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (57, 'Zoe', 'Heaney`', 'zheaney1k@netlog.com', 'United Arab Emirates', 'Umm al Qaywayn', '1943-01-19', '(446) 8037049', '2013-04-28', 'Galaxy S9', 7, 'iOS 13.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (58, 'Jabez', 'Kupisz', 'jkupisz1l@cnet.com', 'Brazil', 'Arroio Grande', '1954-07-04', '(937) 3596731', '2018-08-21', 'Huawei P20 Pro', 14, 'iOS 12.4.8');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (59, 'Nola', 'Jansens', 'njansens1m@discuz.net', 'Russia', 'Vostochnyy', '1957-12-29', '(760) 9663662', '2017-12-29', 'Huawei P10 Pro', 6, 'Android 10');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (60, 'Darcey', 'Goodee', 'dgoodee1n@xrea.com', 'China', 'Zhuji', '2010-06-28', '(392) 9899246', '2019-05-21', 'Huawei P10 Pro', 8, 'iOS 9.3.5');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (61, 'Johnette', 'Uppett', 'juppett1o@reference.com', 'Peru', 'Conchamarca', '1949-05-28', '(625) 9826205', '2019-02-13', 'Galaxy S8', 5, 'iOS 9.3.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (62, 'Ivan', 'Berfoot', 'iberfoot1p@census.gov', 'Sweden', 'Karlskrona', '1970-01-07', '(450) 6154402', '2018-02-02', 'iPhone 6s', 8, 'Android Nougat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (63, 'Paquito', 'Cay', 'pcay1q@lulu.com', 'Poland', 'Bałtów', '1966-01-15', '(532) 5314717', '2010-11-14', 'Huawei P20', 4, 'Android Lollipop');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (64, 'Phil', 'Adamovitch', 'padamovitch1r@github.com', 'China', 'Hongshi', '1985-02-17', '(157) 4079817', '2017-06-22', 'iPhone 8', 10, 'iOS 10.3.3');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (65, 'Rachele', 'Chittem', 'rchittem1s@meetup.com', 'Greece', 'Filiatrá', '1936-11-04', '(592) 3520854', '2019-11-01', 'iPhone 7', 9, 'Android Pie');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (66, 'Amye', 'Kirkbright', 'akirkbright1t@nih.gov', 'Indonesia', 'Wonorejo', '2017-01-27', '(561) 1451451', '2016-09-02', 'iPhone 7', 8, 'Android Oreo');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (67, 'Reggie', 'Guilbert', 'rguilbert1u@shinystat.com', 'China', 'Bantian', '2001-03-04', '(524) 5075405', '2014-10-01', 'Huawei P10', 13, 'iOS 12.4.8');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (68, 'Rayshell', 'Mabbitt', 'rmabbitt1v@posterous.com', 'Thailand', 'Sirindhorn', '1944-10-13', '(708) 2480040', '2011-02-01', 'Huawei P20', 2, 'iOS 10.3.4');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (69, 'Cosetta', 'Vincent', 'cvincent1w@youku.com', 'Philippines', 'Bakulong', '2013-06-08', '(668) 7944372', '2015-09-08', 'Huawei P30 Pro', 3, 'Android Pie');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (70, 'Thorsten', 'Fitchew', 'tfitchew1x@ovh.net', 'Brazil', 'São José do Rio Preto', '2001-05-11', '(484) 6577656', '2016-03-22', 'Huawei Mate 10 Pro', 1, 'Android Marshmallow');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (71, 'Tomasina', 'Yesinin', 'tyesinin1y@blogs.com', 'South Korea', 'Jeonju', '1954-05-20', '(285) 9413128', '2018-03-19', 'iPhone X', 1, 'Android Pie');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (72, 'Norris', 'Honisch', 'nhonisch1z@shop-pro.jp', 'China', 'Yanglinqiao', '1981-12-13', '(317) 4199739', '2014-11-16', 'Huawei P10 Pro', 11, 'Android Oreo');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (73, 'Matias', 'Jablonski', 'mjablonski20@dailymail.co.uk', 'Gabon', 'Lékoni', '2016-06-08', '(362) 5236965', '2019-10-30', 'iPhone 6', 12, 'iOS 12.4.8');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (74, 'Gregg', 'Evitt', 'gevitt21@discuz.net', 'Denmark', 'København', '1967-02-16', '(944) 9248713', '2012-08-24', 'Galaxy S8', 10, 'iOS 9.3.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (75, 'Curtis', 'Foddy', 'cfoddy22@yahoo.co.jp', 'Portugal', 'Monte Agudo', '1950-10-28', '(162) 9639379', '2012-01-31', 'Huawei P9 Pro', 12, 'Android Jelly Bean');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (76, 'Harriett', 'Konmann', 'hkonmann23@addthis.com', 'Indonesia', 'Binangun', '1936-11-16', '(691) 5599101', '2010-03-16', 'iPhone 6', 10, 'iOS 9.3.5');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (77, 'Kippie', 'Coaten', 'kcoaten24@google.pl', 'Indonesia', 'Tetebatu', '1966-02-09', '(335) 4585582', '2017-08-10', 'iPhone 7s', 5, 'Android Pie');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (78, 'Susannah', 'Penrose', 'spenrose25@hc360.com', 'Morocco', 'Oued Zem', '1995-06-01', '(126) 6748792', '2017-04-10', 'iPhone XS', 3, 'iOS 9.3.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (79, 'Verney', 'Prugel', 'vprugel26@vkontakte.ru', 'France', 'Paris 17', '2015-08-01', '(795) 1602144', '2017-04-25', 'Huawei P10 Pro', 6, 'iOS 12.4.8');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (80, 'Ase', 'Do', 'ado27@slate.com', 'South Africa', 'Barberton', '1936-08-31', '(674) 8109305', '2020-02-01', 'Huawei P9 Pro', 5, 'Android Marshmallow');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (81, 'Holt', 'Mawtus', 'hmawtus28@free.fr', 'China', 'Jingchuan', '2008-04-20', '(615) 5490156', '2010-09-13', 'Galaxy S8', 8, 'iOS 13.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (82, 'Noah', 'Fairley', 'nfairley29@is.gd', 'Estonia', 'Narva', '2004-11-15', '(599) 8620131', '2019-02-26', 'Galaxy S10', 10, 'iOS 9.3.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (83, 'Thedric', 'Vannuccini', 'tvannuccini2a@utexas.edu', 'Philippines', 'Santo Tomas', '1970-08-24', '(850) 8779801', '2015-11-04', 'Huawei Mate 20 Pro', 7, 'iOS 9.3.5');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (84, 'Idalina', 'Ohlsen', 'iohlsen2b@jimdo.com', 'China', 'Taiping', '1947-09-20', '(131) 1941486', '2014-03-05', 'iPhone 7', 14, 'iOS 13.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (85, 'Darbie', 'Boydle', 'dboydle2c@oracle.com', 'Russia', 'Karpogory', '2017-10-27', '(751) 7684734', '2019-11-23', 'iPhone 6s', 1, 'Android Marshmallow');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (86, 'Cami', 'Torri', 'ctorri2d@github.io', 'Indonesia', 'Tegalagung', '1923-11-26', '(324) 8240234', '2012-03-21', 'Huawei P9 Pro', 5, 'iOS 12.4.8');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (87, 'Rriocard', 'Curphey', 'rcurphey2e@mysql.com', 'Philippines', 'Balucawi', '1994-07-04', '(420) 1966362', '2015-10-02', 'Huawei P20 Pro', 6, 'Android Marshmallow');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (88, 'Abel', 'Oddy', 'aoddy2f@wordpress.org', 'Estonia', 'Narva', '1949-09-05', '(918) 7940844', '2015-12-06', 'Galaxy S10', 13, 'iOS 10.3.4');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (89, 'Ker', 'Faulconer', 'kfaulconer2g@home.pl', 'Portugal', 'Landim', '2015-04-28', '(453) 4079046', '2013-07-23', 'iPhone 6s', 1, 'iOS 9.3.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (90, 'Davidde', 'Simons', 'dsimons2h@amazon.de', 'Philippines', 'Alabat', '1949-05-12', '(373) 7447279', '2019-03-01', 'Huawei Mate 20', 2, 'Android 10');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (91, 'Sorcha', 'Caunt', 'scaunt2i@vinaora.com', 'Indonesia', 'Kerbuyan', '1983-07-28', '(503) 8932093', '2015-11-10', 'Huawei Mate 10', 6, 'iOS 12.4.8');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (92, 'Nan', 'Brignall', 'nbrignall2j@sciencedirect.com', 'Brazil', 'Monte Aprazível', '2002-01-01', '(294) 8795851', '2019-04-26', 'Huawei P20', 5, 'Android Lollipop');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (93, 'Valeria', 'Breadon', 'vbreadon2k@mapy.cz', 'China', 'Zhangcun', '1989-11-25', '(400) 7126521', '2019-06-15', 'Huawei Mate 20', 12, 'Android 10');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (94, 'Agnella', 'McIlriach', 'amcilriach2l@narod.ru', 'Serbia', 'Sombor', '1929-01-17', '(498) 8464908', '2011-01-05', 'Galaxy S10', 8, 'Android Oreo');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (95, 'Woodrow', 'Cisneros', 'wcisneros2m@smugmug.com', 'Thailand', 'Lap Lae', '1976-11-15', '(792) 6529159', '2016-07-19', 'Huawei P20 Pro', 12, 'Android Nougat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (96, 'Abbott', 'McKinnell', 'amckinnell2n@mlb.com', 'Indonesia', 'Jombang', '2018-02-26', '(868) 1155042', '2018-02-09', 'iPhone 7s', 6, 'iOS 12.4.8');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (97, 'Glenn', 'Getley', 'ggetley2o@alexa.com', 'Paraguay', 'Fram', '1964-02-23', '(201) 3984826', '2010-09-28', 'Huawei P30', 8, 'Android Nougat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (98, 'Jaquenetta', 'Glasner', 'jglasner2p@timesonline.co.uk', 'Argentina', 'Venado Tuerto', '1981-02-14', '(511) 9924472', '2017-10-03', 'Huawei P10 Pro', 12, 'Android Lollipop');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (99, 'Goldia', 'Pavlasek', 'gpavlasek2q@wordpress.org', 'United States', 'Newark', '1958-05-04', '(862) 2972749', '2016-03-14', 'Huawei Mate 20 Pro', 14, 'Android 10');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (100, 'Ebenezer', 'Nesbit', 'enesbit2r@studiopress.com', 'Croatia', 'Opuzen', '1923-02-20', '(162) 5107203', '2010-07-31', 'iPhone X', 5, 'Android Marshmallow');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (101, 'Colby', 'Pingston', 'cpingston2s@mlb.com', 'Mexico', 'Plan de Ayala', '1932-03-03', '(399) 2228009', '2015-02-24', 'Huawei Mate 10', 10, 'Android 10');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (102, 'Alard', 'Minshull', 'aminshull2t@youku.com', 'China', 'Heshe', '1951-08-14', '(212) 7994199', '2020-02-24', 'iPhone 8', 7, 'Android KitKat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (103, 'Xever', 'Stucksbury', 'xstucksbury2u@lulu.com', 'Argentina', 'Villa de Soto', '1997-06-04', '(654) 7179744', '2013-08-02', 'Huawei Mate 10 Pro', 13, 'Android Pie');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (104, 'Kelly', 'Clutterham', 'kclutterham2v@qq.com', 'Indonesia', 'Pacarkeling', '1993-07-24', '(945) 6125495', '2010-12-31', 'Galaxy S10', 8, 'Android KitKat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (105, 'Kennan', 'Goranov', 'kgoranov2w@pbs.org', 'Nigeria', 'Elele', '1958-09-05', '(595) 1027105', '2010-03-09', 'iPhone X', 4, 'Android Oreo');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (106, 'Carlee', 'Tooley', 'ctooley2x@google.es', 'Chile', 'Chiguayante', '1985-12-30', '(414) 4599241', '2018-05-20', 'Huawei Mate 10 Pro', 7, 'Android KitKat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (107, 'Sammy', 'Halleday', 'shalleday2y@sitemeter.com', 'Indonesia', 'Tutul', '1921-01-07', '(562) 8666057', '2018-10-17', 'Huawei P9 Pro', 9, 'Android Nougat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (108, 'Averell', 'Anfrey', 'aanfrey2z@surveymonkey.com', 'Sweden', 'Täby', '1955-02-06', '(641) 4410739', '2019-06-01', 'Huawei Mate 20 Pro', 13, 'Android Oreo');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (109, 'Terrell', 'Bankhurst', 'tbankhurst30@ameblo.jp', 'Philippines', 'Takub', '1995-08-05', '(756) 2421422', '2013-06-04', 'iPhone 8s', 6, 'Android Pie');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (110, 'Erek', 'Sculpher', 'esculpher31@godaddy.com', 'Thailand', 'Nakhon Phanom', '2020-09-25', '(984) 1199946', '2018-11-09', 'Huawei Mate 10 Pro', 14, 'Android Lollipop');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (111, 'Giuseppe', 'Lehenmann', 'glehenmann32@sourceforge.net', 'Palestinian Territory', 'Banī Suhaylā', '1933-03-26', '(587) 6442923', '2018-11-09', 'iPhone X', 14, 'iOS 9.3.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (112, 'Alexandrina', 'Beverstock', 'abeverstock33@nationalgeographic.com', 'China', 'Mabai', '1971-03-25', '(228) 1209823', '2011-04-05', 'iPhone X', 14, 'iOS 9.3.5');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (113, 'Inger', 'Goaley', 'igoaley34@mapy.cz', 'United States', 'Brooklyn', '1958-01-06', '(646) 8991639', '2018-05-06', 'Huawei P20 Pro', 10, 'iOS 12.4.8');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (114, 'Johann', 'Banthorpe', 'jbanthorpe35@geocities.jp', 'France', 'Épinal', '1992-09-10', '(990) 5089449', '2020-06-10', 'iPhone 7', 1, 'iOS 9.3.5');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (115, 'Chickie', 'Bonett', 'cbonett36@sohu.com', 'Poland', 'Korsze', '1987-06-09', '(112) 3527688', '2017-04-02', 'iPhone X', 11, 'Android Lollipop');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (116, 'Ashlee', 'Pett', 'apett37@youtube.com', 'China', 'Qiaobian', '1942-01-22', '(578) 7658750', '2018-05-01', 'Huawei P9 Pro', 14, 'Android Nougat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (117, 'Rafi', 'Till', 'rtill38@wunderground.com', 'China', 'Gucheng', '1952-12-13', '(325) 9178349', '2018-08-31', 'iPhone 7s', 8, 'Android Jelly Bean');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (118, 'Ric', 'Covil', 'rcovil39@lycos.com', 'Greece', 'Makrýgialos', '2013-03-10', '(663) 5697730', '2019-08-04', 'iPhone 8s', 2, 'iOS 9.3.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (119, 'Lark', 'Bishell', 'lbishell3a@youtube.com', 'Philippines', 'Santa Barbara', '1998-11-27', '(461) 2570060', '2014-08-17', 'Huawei Mate 20', 12, 'Android Oreo');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (120, 'Den', 'McLarens', 'dmclarens3b@jiathis.com', 'Russia', 'Svetlanovskiy', '2009-06-10', '(505) 8176652', '2013-09-25', 'Huawei Mate 10', 10, 'Android KitKat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (121, 'Giorgia', 'Izakov', 'gizakov3c@dmoz.org', 'Indonesia', 'Cidadap', '1931-12-16', '(982) 6679037', '2015-11-12', 'Huawei P9 Pro', 2, 'Android 10');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (122, 'Selene', 'Harkins', 'sharkins3d@shutterfly.com', 'Sweden', 'Helsingborg', '1983-04-19', '(286) 4496520', '2013-09-06', 'Huawei P30', 14, 'iOS 13.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (123, 'Jan', 'Gooley', 'jgooley3e@springer.com', 'Greece', 'Agrínio', '1952-06-26', '(704) 6670752', '2017-08-07', 'Galaxy S10', 6, 'iOS 10.3.4');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (124, 'Aeriela', 'Jurasz', 'ajurasz3f@stumbleupon.com', 'China', 'Huji', '1994-06-02', '(781) 3966436', '2012-02-27', 'iPhone XS', 14, 'iOS 13.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (125, 'Myrtice', 'Hughill', 'mhughill3g@pcworld.com', 'China', 'Hongqiao', '2011-01-14', '(288) 4363681', '2011-03-05', 'Galaxy S8', 2, 'Android Oreo');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (126, 'Rowen', 'Bearcock', 'rbearcock3h@twitter.com', 'Indonesia', 'Pucangkrajan', '1929-10-30', '(714) 6098166', '2017-10-13', 'Huawei P10', 5, 'Android Lollipop');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (127, 'Melanie', 'Fitzsimons', 'mfitzsimons3i@cbsnews.com', 'Philippines', 'Margen', '1984-03-06', '(940) 4727184', '2013-03-31', 'Huawei P30', 2, 'iOS 9.3.5');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (128, 'Jasper', 'Daynter', 'jdaynter3j@last.fm', 'South Africa', 'Kraaifontein', '1953-12-26', '(878) 6938687', '2018-10-19', 'Huawei Mate 20 Pro', 3, 'iOS 10.3.4');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (129, 'Farah', 'Pepi', 'fpepi3k@opensource.org', 'Sierra Leone', 'Konakridee', '2003-11-30', '(282) 1388588', '2013-10-23', 'iPhone 8s', 7, 'iOS 10.3.3');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (130, 'Maxy', 'Deery', 'mdeery3l@hp.com', 'Argentina', 'Cerro Azul', '1935-07-02', '(487) 3169857', '2016-08-12', 'Galaxy S8', 5, 'Android Oreo');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (131, 'Fairlie', 'Joist', 'fjoist3m@1und1.de', 'China', 'Chencai', '1956-01-16', '(457) 6750943', '2013-02-23', 'iPhone 7s', 1, 'Android Oreo');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (132, 'Toiboid', 'Fairlie', 'tfairlie3n@hc360.com', 'China', 'Shiyan', '1925-09-17', '(275) 9486324', '2014-02-02', 'iPhone 6', 14, 'Android Nougat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (133, 'Babara', 'Ailmer', 'bailmer3o@nytimes.com', 'Canada', 'Port Moody', '1947-09-01', '(752) 6194568', '2015-03-12', 'Huawei P30', 4, 'Android Lollipop');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (134, 'Thedric', 'Boshard', 'tboshard3p@xing.com', 'Portugal', 'Rios Frios', '1995-04-05', '(898) 2855641', '2010-05-06', 'Huawei P10', 2, 'iOS 9.3.5');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (135, 'Lorrie', 'Merveille', 'lmerveille3q@purevolume.com', 'China', 'Menggusi', '1971-04-14', '(337) 9328969', '2015-09-13', 'Huawei P9', 5, 'Android Oreo');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (136, 'Darnell', 'Hagwood', 'dhagwood3r@springer.com', 'Indonesia', 'Jetis', '1949-05-04', '(505) 4336366', '2018-11-06', 'Huawei P9 Pro', 2, 'iOS 12.4.8');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (137, 'Rena', 'Rowsel', 'rrowsel3s@fda.gov', 'United States', 'Paterson', '1975-11-23', '(862) 9457207', '2010-04-14', 'iPhone 7s', 10, 'iOS 9.3.5');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (138, 'Rodrick', 'Tuffield', 'rtuffield3t@friendfeed.com', 'Sweden', 'Skogås', '2008-08-22', '(230) 8759373', '2010-05-01', 'Huawei P20 Pro', 2, 'iOS 10.3.3');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (139, 'Collette', 'Valett', 'cvalett3u@discovery.com', 'Indonesia', 'Sumuragung', '2017-10-02', '(460) 4235220', '2019-07-28', 'Huawei Mate 10 Pro', 9, 'Android Pie');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (140, 'Ric', 'Alliban', 'ralliban3v@opensource.org', 'Ukraine', 'Medenychi', '1944-12-10', '(272) 8040544', '2017-04-09', 'Huawei P9 Pro', 13, 'iOS 10.3.4');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (141, 'Maryl', 'Pedrazzi', 'mpedrazzi3w@printfriendly.com', 'Nigeria', 'Madala', '1984-09-13', '(516) 5282791', '2020-02-17', 'Huawei Mate 10', 1, 'Android KitKat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (142, 'Percy', 'Lille', 'plille3x@artisteer.com', 'Qatar', 'Umm Sa‘īd', '1922-07-14', '(859) 3374838', '2015-04-28', 'iPhone 7s', 7, 'Android Nougat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (143, 'Garret', 'Toe', 'gtoe3y@xrea.com', 'Uganda', 'Bukomansimbi', '1958-10-06', '(913) 4077136', '2015-04-12', 'Huawei Mate 10', 4, 'Android Jelly Bean');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (144, 'Ker', 'McShirie', 'kmcshirie3z@oracle.com', 'China', 'Yilongyong', '1963-08-08', '(339) 3367830', '2017-09-05', 'Huawei P20', 9, 'iOS 10.3.4');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (145, 'Shayne', 'Birden', 'sbirden40@comcast.net', 'China', 'Benniu', '1966-04-27', '(979) 8562067', '2011-10-31', 'Huawei P9', 11, 'Android Lollipop');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (146, 'Shane', 'Twidell', 'stwidell41@geocities.jp', 'Syria', 'Al Mālikīyah', '1921-11-07', '(644) 5602131', '2017-06-03', 'Huawei P20 Pro', 13, 'iOS 9.3.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (147, 'Nikola', 'Reubel', 'nreubel42@example.com', 'Poland', 'Wiśniewo', '2012-08-06', '(805) 5477517', '2010-05-31', 'iPhone 8s', 3, 'Android Pie');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (148, 'Rona', 'Abbotson', 'rabbotson43@bbb.org', 'Russia', 'Rybnaya Sloboda', '1989-08-19', '(225) 7476509', '2012-11-12', 'iPhone 7s', 2, 'iOS 9.3.5');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (149, 'Maddy', 'Safe', 'msafe44@4shared.com', 'Canada', 'Forestville', '1943-09-29', '(959) 1477297', '2017-01-23', 'iPhone 6s', 9, 'iOS 10.3.3');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (150, 'Ginnifer', 'Comi', 'gcomi45@patch.com', 'Indonesia', 'Enrekang', '1925-04-04', '(830) 5043713', '2019-08-08', 'Galaxy S9', 9, 'iOS 13.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (151, 'Edgardo', 'Knightsbridge', 'eknightsbridge46@purevolume.com', 'Cameroon', 'Tiko', '1960-12-30', '(554) 5848920', '2017-08-19', 'iPhone X', 6, 'Android 10');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (152, 'Jsandye', 'Crockett', 'jcrockett47@elpais.com', 'Russia', 'Brodokalmak', '1987-10-07', '(495) 5142893', '2014-02-06', 'Huawei P20 Pro', 5, 'Android Pie');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (153, 'Rebecka', 'Filipputti', 'rfilipputti48@comcast.net', 'China', 'Huangjin', '2011-07-12', '(257) 6837495', '2019-09-09', 'Huawei Mate 10 Pro', 14, 'iOS 10.3.3');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (154, 'Randolf', 'Hollerin', 'rhollerin49@nature.com', 'Indonesia', 'Sriwing', '2020-03-02', '(532) 4116165', '2012-10-04', 'Huawei P30 Pro', 5, 'iOS 10.3.3');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (155, 'Kalina', 'Bowcock', 'kbowcock4a@goodreads.com', 'Netherlands', 'Delft', '2013-02-06', '(498) 3289607', '2012-10-19', 'Huawei Mate 20', 9, 'iOS 13.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (156, 'Lorianne', 'Lill', 'llill4b@github.com', 'Sint Maarten', 'Philipsburg', '1966-03-08', '(253) 5487080', '2010-02-14', 'iPhone X', 2, 'Android Marshmallow');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (157, 'Nicolette', 'Midford', 'nmidford4c@mtv.com', 'Netherlands', 'Dordrecht', '1966-04-29', '(952) 1451835', '2017-05-27', 'Huawei P10 Pro', 2, 'iOS 9.3.5');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (158, 'Cordelie', 'Bogart', 'cbogart4d@cornell.edu', 'Colombia', 'Guamal', '1994-01-16', '(166) 5438273', '2019-08-10', 'Huawei P20 Pro', 9, 'iOS 10.3.4');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (159, 'Maurizio', 'Etherington', 'metherington4e@europa.eu', 'China', 'Tost', '1960-02-27', '(539) 9770783', '2015-07-15', 'Galaxy S10', 5, 'Android Nougat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (160, 'Kaia', 'Asplen', 'kasplen4f@addtoany.com', 'Thailand', 'Ban Talat Yai', '1933-01-24', '(863) 8486121', '2019-06-07', 'Huawei P20 Pro', 5, 'iOS 9.3.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (161, 'Osbourn', 'Brighty', 'obrighty4g@hhs.gov', 'Indonesia', 'Sayang Lauq', '1990-07-20', '(634) 3157738', '2013-09-13', 'Huawei P20', 12, 'Android Nougat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (162, 'Abbott', 'Lorkins', 'alorkins4h@mediafire.com', 'Australia', 'Sydney', '1930-01-23', '(569) 2869857', '2010-01-07', 'iPhone 6', 14, 'Android Jelly Bean');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (163, 'Ranique', 'Gabriel', 'rgabriel4i@theglobeandmail.com', 'Czech Republic', 'Příbram', '1950-05-15', '(899) 2473638', '2017-03-22', 'iPhone 7s', 12, 'Android Pie');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (164, 'Fred', 'Fontenot', 'ffontenot4j@spotify.com', 'Costa Rica', 'Ángeles', '1959-10-03', '(173) 8023035', '2013-03-23', 'Huawei P20', 11, 'Android Lollipop');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (165, 'Minnnie', 'Fagge', 'mfagge4k@loc.gov', 'China', 'Kesheng', '1975-11-28', '(590) 9889039', '2014-10-09', 'Galaxy S8', 9, 'Android Nougat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (166, 'Bevvy', 'Preshous', 'bpreshous4l@hibu.com', 'Philippines', 'Basud', '1971-03-23', '(557) 1602722', '2011-08-03', 'Huawei P10 Pro', 2, 'Android Jelly Bean');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (167, 'Dannel', 'Rumin', 'drumin4m@paginegialle.it', 'Thailand', 'Sam Ngam', '1974-02-22', '(369) 5594227', '2015-11-06', 'Galaxy S9', 1, 'iOS 9.3.5');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (168, 'Kennett', 'Najera', 'knajera4n@digg.com', 'Uzbekistan', 'Shahrisabz Shahri', '1984-10-26', '(283) 5090798', '2011-02-10', 'Galaxy S8', 12, 'iOS 10.3.3');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (169, 'Charisse', 'Ledamun', 'cledamun4o@newyorker.com', 'Russia', 'Staritsa', '2008-12-29', '(181) 3245735', '2016-11-10', 'Huawei P9 Pro', 8, 'Android Nougat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (170, 'Jack', 'Lidgate', 'jlidgate4p@auda.org.au', 'Sweden', 'Brämhult', '1944-06-26', '(458) 8698052', '2020-05-18', 'Huawei P9 Pro', 9, 'Android 10');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (171, 'Blakelee', 'Simeon', 'bsimeon4q@google.com.hk', 'Sweden', 'Arboga', '1967-06-06', '(377) 4762019', '2013-11-19', 'Huawei Mate 20 Pro', 12, 'Android Marshmallow');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (172, 'Jemmie', 'Izzatt', 'jizzatt4r@answers.com', 'France', 'Toulouse', '2013-06-16', '(499) 5842994', '2011-04-09', 'Huawei P9 Pro', 13, 'iOS 9.3.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (173, 'Myrwyn', 'Oldam', 'moldam4s@biblegateway.com', 'Indonesia', 'Lupak', '1924-11-12', '(494) 3565755', '2010-03-07', 'iPhone X', 9, 'Android Lollipop');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (174, 'Drucill', 'Elcum', 'delcum4t@yale.edu', 'Mauritius', 'Flic en Flac', '1945-01-18', '(780) 9626399', '2016-04-24', 'Huawei Mate 10', 6, 'iOS 10.3.4');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (175, 'Merrili', 'Bostock', 'mbostock4u@princeton.edu', 'China', 'Yancheng', '1969-11-25', '(766) 5215226', '2016-02-11', 'iPhone 6', 3, 'Android Nougat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (176, 'Gail', 'Ruffle', 'gruffle4v@google.it', 'Sweden', 'Särö', '1975-05-21', '(887) 3983719', '2012-08-17', 'iPhone 7', 13, 'Android Lollipop');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (177, 'Fraser', 'Gawthorpe', 'fgawthorpe4w@bizjournals.com', 'Poland', 'Sławatycze', '1945-03-06', '(745) 5413426', '2019-07-20', 'Huawei Mate 20 Pro', 6, 'Android Jelly Bean');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (178, 'Valentia', 'Zuanelli', 'vzuanelli4x@gmpg.org', 'China', 'Qincheng', '2017-02-16', '(860) 7042686', '2014-01-05', 'iPhone X', 4, 'Android Pie');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (179, 'Mercedes', 'Drohun', 'mdrohun4y@opensource.org', 'Thailand', 'Nong Bua', '1991-07-24', '(231) 4779309', '2010-06-19', 'Huawei P9', 4, 'iOS 9.3.5');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (180, 'Bendicty', 'Dearle', 'bdearle4z@ft.com', 'Japan', 'Okunoya', '1975-02-07', '(230) 9956463', '2020-07-28', 'iPhone 7', 11, 'iOS 10.3.3');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (181, 'Bea', 'Christene', 'bchristene50@usnews.com', 'China', 'Wanfu', '1942-03-20', '(367) 1561642', '2014-06-04', 'Huawei P30', 9, 'Android KitKat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (182, 'Leontine', 'Bissill', 'lbissill51@soundcloud.com', 'Argentina', 'Jacinto Arauz', '1983-07-10', '(859) 4025977', '2017-06-01', 'iPhone 6s', 10, 'iOS 12.4.8');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (183, 'Guillema', 'Adamo', 'gadamo52@statcounter.com', 'Rwanda', 'Nyanza', '2010-05-17', '(789) 1122957', '2017-07-04', 'Huawei P10 Pro', 6, 'Android Oreo');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (184, 'Annette', 'Fitchet', 'afitchet53@narod.ru', 'Sweden', 'Saltsjöbaden', '1976-12-24', '(862) 1983812', '2012-05-19', 'Huawei P30', 4, 'Android 10');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (185, 'Devlen', 'Munnery', 'dmunnery54@e-recht24.de', 'Philippines', 'Sigay', '1932-01-02', '(308) 6644920', '2019-03-02', 'Galaxy S10', 4, 'Android Lollipop');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (186, 'Peter', 'Lucy', 'plucy55@un.org', 'Ukraine', 'Pervomays’k', '1933-07-05', '(549) 4101940', '2019-04-10', 'Huawei Mate 10', 14, 'Android 10');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (187, 'Gregg', 'Noriega', 'gnoriega56@europa.eu', 'Japan', 'Iizuka', '1978-04-06', '(320) 7457811', '2014-01-02', 'iPhone XS', 14, 'Android Lollipop');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (188, 'Ferne', 'Pepall', 'fpepall57@com.com', 'Brazil', 'Arari', '1964-02-22', '(791) 6378431', '2011-04-03', 'iPhone 6', 11, 'iOS 12.4.8');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (189, 'Zeke', 'Jedrychowski', 'zjedrychowski58@paypal.com', 'Saint Lucia', 'Soufrière', '1928-01-06', '(698) 3602067', '2014-10-22', 'Huawei Mate 20 Pro', 4, 'Android Lollipop');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (190, 'Travers', 'Allain', 'tallain59@ucsd.edu', 'South Africa', 'Burgersdorp', '1953-07-20', '(497) 5875424', '2010-03-18', 'Huawei Mate 10', 6, 'iOS 9.3.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (191, 'Alys', 'Jakubovski', 'ajakubovski5a@over-blog.com', 'Indonesia', 'Dukuhpicung', '1954-04-13', '(590) 2043890', '2010-07-28', 'iPhone 7', 7, 'Android Nougat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (192, 'Suzy', 'Dye', 'sdye5b@linkedin.com', 'Portugal', 'Santiago dos Velhos', '1968-06-29', '(426) 3918804', '2010-04-05', 'iPhone X', 10, 'iOS 9.3.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (193, 'Gonzalo', 'Fancett', 'gfancett5c@digg.com', 'Indonesia', 'Bodeh', '1935-10-03', '(431) 8647089', '2014-01-27', 'Huawei P9 Pro', 8, 'Android KitKat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (194, 'Abeu', 'Haskey', 'ahaskey5d@columbia.edu', 'Moldova', 'Cahul', '1958-09-20', '(512) 5408887', '2016-03-25', 'iPhone 8', 13, 'iOS 10.3.3');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (195, 'Clemente', 'Runsey', 'crunsey5e@ehow.com', 'France', 'Périgueux', '1923-07-04', '(120) 3254360', '2012-07-23', 'Huawei P30', 3, 'iOS 10.3.4');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (196, 'Hammad', 'Ower', 'hower5f@dmoz.org', 'China', 'Hanlin', '2002-06-02', '(112) 1478316', '2014-08-12', 'Huawei P20', 11, 'Android Nougat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (197, 'Mead', 'Celier', 'mcelier5g@unicef.org', 'Indonesia', 'Sidamukti', '1941-08-05', '(833) 4895312', '2018-11-18', 'Galaxy S9', 12, 'Android Jelly Bean');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (198, 'Nanci', 'Leffek', 'nleffek5h@myspace.com', 'Ukraine', 'Yelyzavethradka', '1939-07-23', '(128) 7898320', '2011-08-17', 'Huawei P30', 9, 'iOS 10.3.4');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (199, 'Vinnie', 'Schruyer', 'vschruyer5i@mtv.com', 'Russia', 'Argayash', '1968-03-19', '(759) 2917952', '2015-02-04', 'iPhone 8s', 12, 'iOS 13.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (200, 'Aubrey', 'Dmiterko', 'admiterko5j@accuweather.com', 'Brazil', 'Poá', '1968-12-10', '(888) 9146123', '2013-10-31', 'Huawei P10', 14, 'Android KitKat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (201, 'Sibeal', 'Dufaire', 'sdufaire5k@desdev.cn', 'Fiji', 'Nadi', '1956-01-25', '(263) 4122036', '2016-04-02', 'Huawei Mate 10', 7, 'iOS 9.3.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (202, 'Alf', 'Arsmith', 'aarsmith5l@virginia.edu', 'China', 'Longjing', '1943-12-15', '(468) 1142862', '2019-07-25', 'Huawei Mate 10 Pro', 9, 'iOS 9.3.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (203, 'Marty', 'Orum', 'morum5m@archive.org', 'Guatemala', 'Cunén', '1962-02-16', '(283) 5231197', '2020-05-12', 'Huawei P9 Pro', 7, 'iOS 12.4.8');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (204, 'Deva', 'Allwright', 'dallwright5n@facebook.com', 'Canada', 'Burns Lake', '1961-07-13', '(673) 2670058', '2013-12-20', 'Galaxy S10', 9, 'Android 10');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (205, 'Dorris', 'Drinkwater', 'ddrinkwater5o@ezinearticles.com', 'Brazil', 'Mandaguari', '2011-04-10', '(386) 4845103', '2015-09-21', 'iPhone XS', 9, 'Android KitKat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (206, 'Rennie', 'Scandroot', 'rscandroot5p@twitpic.com', 'China', 'Shimen', '2018-12-26', '(402) 2408469', '2019-11-13', 'Huawei Mate 20', 3, 'Android Jelly Bean');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (207, 'Perrine', 'Redwood', 'predwood5q@xinhuanet.com', 'Albania', 'Lazarat', '1934-05-12', '(991) 7228873', '2011-04-30', 'Huawei P30', 14, 'iOS 10.3.3');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (208, 'Vidovik', 'Daventry', 'vdaventry5r@marriott.com', 'China', 'Lanxi', '1950-03-17', '(758) 4216492', '2020-03-06', 'Huawei P30', 2, 'iOS 13.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (209, 'Bryana', 'Kaasman', 'bkaasman5s@posterous.com', 'Poland', 'Gwoźnica Górna', '2013-07-18', '(467) 4327403', '2012-04-05', 'Huawei P30 Pro', 2, 'iOS 10.3.4');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (210, 'Jami', 'Riddich', 'jriddich5t@desdev.cn', 'Portugal', 'Lugar Novo', '1969-05-01', '(708) 6338839', '2010-10-19', 'Huawei P9', 7, 'Android Lollipop');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (211, 'Alayne', 'MacLeese', 'amacleese5u@jimdo.com', 'Indonesia', 'Karangtengah', '1950-05-16', '(690) 9771260', '2014-08-13', 'Galaxy S10', 11, 'Android Pie');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (212, 'Bo', 'Veregan', 'bveregan5v@google.cn', 'Russia', 'Bolgar', '1998-04-27', '(177) 1780560', '2010-12-01', 'Galaxy S8', 7, 'Android 10');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (213, 'Shalna', 'Ruprechter', 'sruprechter5w@prweb.com', 'Indonesia', 'Lewodoli', '1982-01-16', '(595) 5707406', '2020-01-07', 'iPhone 7', 5, 'Android Oreo');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (214, 'Geoff', 'Hobgen', 'ghobgen5x@forbes.com', 'China', 'Heimahe', '1986-01-29', '(418) 7132502', '2011-07-14', 'Huawei P20 Pro', 13, 'iOS 13.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (215, 'Enid', 'Chesterman', 'echesterman5y@taobao.com', 'Vietnam', 'Thị Trấn Kim Tân', '1934-10-22', '(184) 9007339', '2018-11-22', 'Huawei P30 Pro', 7, 'Android 10');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (216, 'Tamarra', 'Tilburn', 'ttilburn5z@senate.gov', 'Japan', 'Hakodate', '1981-11-17', '(443) 2491035', '2013-07-07', 'Huawei P30', 7, 'Android Nougat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (217, 'Saleem', 'Johnston', 'sjohnston60@wiley.com', 'Greece', 'Néos Skopós', '2002-11-20', '(891) 6379560', '2010-03-09', 'Huawei Mate 20 Pro', 6, 'Android Oreo');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (218, 'Maddalena', 'Hamlen', 'mhamlen61@mac.com', 'Mexico', 'Los Pinos', '1956-04-02', '(587) 6945597', '2012-08-02', 'iPhone 8', 2, 'Android Lollipop');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (219, 'Cornelius', 'Conybear', 'cconybear62@walmart.com', 'Russia', 'Izmaylovo', '1968-09-17', '(395) 6525548', '2011-01-22', 'iPhone X', 8, 'iOS 12.4.8');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (220, 'Raf', 'Closs', 'rcloss63@ebay.co.uk', 'Ukraine', 'Koloniya Zastav’ye', '2017-01-15', '(630) 6657656', '2020-05-18', 'Huawei P20 Pro', 7, 'Android Nougat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (221, 'Wells', 'McEnteggart', 'wmcenteggart64@reverbnation.com', 'Indonesia', 'Paya Dapur', '1928-01-08', '(204) 2943031', '2018-08-26', 'Huawei Mate 20', 14, 'iOS 10.3.4');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (222, 'Deane', 'Waddams', 'dwaddams65@wikispaces.com', 'Mongolia', 'Sujji', '1923-03-31', '(868) 5589458', '2011-08-09', 'Huawei P30 Pro', 3, 'iOS 12.4.8');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (223, 'Hashim', 'Dmtrovic', 'hdmtrovic66@stumbleupon.com', 'Nigeria', 'Kibiya', '2009-10-23', '(798) 1948814', '2017-01-23', 'Huawei Mate 10', 11, 'Android Oreo');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (224, 'Ardys', 'Bulman', 'abulman67@exblog.jp', 'Philippines', 'Koronadal', '1981-11-07', '(650) 6011313', '2013-11-06', 'Huawei P30 Pro', 5, 'iOS 9.3.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (225, 'Gabie', 'Cahalin', 'gcahalin68@forbes.com', 'Ukraine', 'Lyuboml’', '2001-06-19', '(486) 3621651', '2010-03-25', 'Huawei Mate 10 Pro', 7, 'Android 10');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (226, 'Emmy', 'Jouhan', 'ejouhan69@rambler.ru', 'Switzerland', 'Genève', '1936-12-15', '(551) 9238772', '2015-10-17', 'Huawei P20', 5, 'iOS 10.3.3');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (227, 'Shela', 'Maffiotti', 'smaffiotti6a@cloudflare.com', 'Thailand', 'Don Mueang', '1964-07-29', '(562) 7487953', '2018-10-05', 'Huawei P30', 9, 'Android Marshmallow');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (228, 'Shirlene', 'Cartmill', 'scartmill6b@mediafire.com', 'Philippines', 'Diadi', '1968-11-03', '(588) 2582470', '2018-10-25', 'Huawei P9 Pro', 10, 'Android KitKat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (229, 'Merrielle', 'Liddel', 'mliddel6c@paypal.com', 'Indonesia', 'Pandat', '1997-03-19', '(110) 7729795', '2018-06-23', 'Galaxy S10', 10, 'iOS 10.3.4');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (230, 'Roarke', 'Seaborne', 'rseaborne6d@elpais.com', 'Sweden', 'Söderköping', '1968-03-31', '(115) 7061304', '2010-05-29', 'iPhone X', 9, 'iOS 9.3.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (231, 'Arnold', 'Brittian', 'abrittian6e@cnet.com', 'Thailand', 'Wang Yang', '1937-08-19', '(331) 4148201', '2010-03-21', 'Galaxy S10', 2, 'Android Pie');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (232, 'George', 'Utting', 'gutting6f@stanford.edu', 'China', 'Chendong', '1971-05-11', '(126) 1267000', '2013-10-15', 'iPhone 8', 2, 'iOS 10.3.4');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (233, 'Jacquelin', 'Dzenisenka', 'jdzenisenka6g@springer.com', 'China', 'Xubu', '1977-10-31', '(973) 4524977', '2017-12-15', 'iPhone X', 11, 'iOS 12.4.8');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (234, 'Aland', 'Cathro', 'acathro6h@macromedia.com', 'Bolivia', 'Coripata', '1927-07-28', '(158) 4503557', '2012-09-17', 'Huawei Mate 20', 4, 'iOS 9.3.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (235, 'Kellie', 'Masserel', 'kmasserel6i@arstechnica.com', 'Tanzania', 'Kondoa', '1927-01-09', '(335) 9574195', '2010-03-31', 'iPhone 6s', 3, 'iOS 13.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (236, 'Emelita', 'Croydon', 'ecroydon6j@springer.com', 'Tajikistan', 'Khŭjand', '1972-09-20', '(773) 9356094', '2016-03-12', 'iPhone XS', 6, 'iOS 9.3.5');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (237, 'Stacey', 'McSkeagan', 'smcskeagan6k@phpbb.com', 'China', 'Xiaoqi', '1925-04-05', '(697) 5798349', '2011-01-01', 'Huawei Mate 10', 9, 'Android Marshmallow');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (238, 'Zak', 'Erdes', 'zerdes6l@myspace.com', 'Peru', 'Barranca', '1950-10-29', '(515) 1608125', '2011-11-29', 'iPhone 6', 8, 'Android Jelly Bean');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (239, 'Alanah', 'Yantsurev', 'ayantsurev6m@columbia.edu', 'Philippines', 'Kambing', '1998-05-10', '(465) 2034043', '2019-01-02', 'Huawei Mate 10 Pro', 2, 'Android Lollipop');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (240, 'Sharity', 'Celle', 'scelle6n@blog.com', 'China', 'Badai', '1986-04-20', '(195) 2598014', '2015-05-13', 'Huawei P20 Pro', 5, 'Android Jelly Bean');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (241, 'Towny', 'Pavitt', 'tpavitt6o@people.com.cn', 'China', 'Machang', '1946-06-28', '(900) 2148347', '2012-03-25', 'Huawei P9 Pro', 14, 'Android Oreo');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (242, 'Cherise', 'Hegg', 'chegg6p@house.gov', 'Mongolia', 'Bayan-Ovoo', '2015-12-08', '(300) 6846665', '2016-08-02', 'Galaxy S9', 7, 'iOS 10.3.3');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (243, 'Anastasia', 'Toderbrugge', 'atoderbrugge6q@bing.com', 'China', 'Lukou', '1958-06-20', '(520) 3246954', '2019-12-24', 'Huawei P10 Pro', 11, 'iOS 10.3.3');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (244, 'Maddalena', 'Whal', 'mwhal6r@hp.com', 'Cuba', 'Centro Habana', '2011-07-04', '(631) 1362435', '2013-06-05', 'iPhone X', 11, 'Android KitKat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (245, 'Judye', 'Suart', 'jsuart6s@google.fr', 'Sweden', 'Tyresö', '1947-05-08', '(112) 9900748', '2011-08-25', 'iPhone 6s', 4, 'iOS 9.3.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (246, 'Consalve', 'MacKibbon', 'cmackibbon6t@ed.gov', 'France', 'Nîmes', '1970-02-12', '(736) 8322454', '2012-03-26', 'Huawei Mate 10 Pro', 4, 'Android Marshmallow');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (247, 'Arte', 'Leeb', 'aleeb6u@uol.com.br', 'Canada', 'Oliver', '1929-10-31', '(206) 7980284', '2019-12-30', 'Huawei P10', 6, 'iOS 9.3.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (248, 'Marketa', 'Gudd', 'mgudd6v@1688.com', 'Russia', 'Burtunay', '1956-02-26', '(513) 6474013', '2014-12-28', 'Huawei Mate 20', 9, 'Android Jelly Bean');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (249, 'Gusta', 'Ranscome', 'granscome6w@msn.com', 'Sweden', 'Övertorneå', '1987-06-08', '(158) 6736229', '2013-07-12', 'Huawei P10 Pro', 8, 'Android Oreo');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (250, 'Pietrek', 'Tinwell', 'ptinwell6x@patch.com', 'Russia', 'Kalashnikovo', '1926-11-30', '(630) 5119656', '2012-04-13', 'Huawei Mate 10', 2, 'Android KitKat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (251, 'Falito', 'Keme', 'fkeme6y@list-manage.com', 'Morocco', 'Taouima', '2004-02-27', '(948) 5238113', '2017-02-23', 'Huawei P9 Pro', 6, 'iOS 13.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (252, 'Belvia', 'Tackley', 'btackley6z@squidoo.com', 'China', 'Shuiyin', '1974-11-14', '(703) 8841538', '2017-12-01', 'Huawei P10', 13, 'Android Nougat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (253, 'Marnia', 'Espadas', 'mespadas70@artisteer.com', 'China', 'Huaqiao', '1960-09-18', '(397) 6160558', '2018-04-17', 'Huawei Mate 20', 1, 'Android 10');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (254, 'Erminie', 'Caldera', 'ecaldera71@acquirethisname.com', 'Russia', 'Sudislavl’', '1979-05-19', '(912) 8140113', '2010-04-30', 'iPhone XS', 7, 'Android KitKat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (255, 'Guendolen', 'Ragsdall', 'gragsdall72@wp.com', 'Indonesia', 'Karanggintung', '1975-01-09', '(722) 1652031', '2012-12-17', 'Huawei P10 Pro', 1, 'Android Marshmallow');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (256, 'Rick', 'Bedbury', 'rbedbury73@ifeng.com', 'Peru', 'Nueva Arica', '1935-08-01', '(864) 8696098', '2014-06-11', 'iPhone 7', 8, 'Android Nougat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (257, 'Danna', 'Goozee', 'dgoozee74@hostgator.com', 'Brazil', 'Piuí', '2016-03-24', '(971) 7851860', '2010-10-20', 'iPhone 7s', 6, 'Android Lollipop');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (258, 'Dorisa', 'Jewiss', 'djewiss75@fastcompany.com', 'Russia', 'Severo-Zadonsk', '1976-01-14', '(894) 2412417', '2018-04-29', 'Galaxy S10', 5, 'Android Marshmallow');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (259, 'Brear', 'Kiebes', 'bkiebes76@zimbio.com', 'Japan', 'Ibaraki', '1921-11-10', '(178) 5472655', '2013-06-19', 'Galaxy S8', 9, 'Android Marshmallow');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (260, 'Betsy', 'Borborough', 'bborborough77@army.mil', 'Ukraine', 'Urzuf', '1978-10-24', '(907) 7606896', '2012-10-07', 'Galaxy S9', 4, 'iOS 13.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (261, 'Ammamaria', 'Cramer', 'acramer78@utexas.edu', 'Russia', 'Yessentuki', '1928-12-16', '(717) 5577740', '2020-04-11', 'Galaxy S10', 1, 'Android Nougat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (262, 'Hagan', 'Hainning', 'hhainning79@yandex.ru', 'United Kingdom', 'Belfast', '1956-10-23', '(939) 8128437', '2018-01-03', 'Galaxy S10', 5, 'iOS 13.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (263, 'Casie', 'Tomadoni', 'ctomadoni7a@about.com', 'Sweden', 'Gustavsberg', '1985-12-21', '(891) 2671159', '2012-12-10', 'Huawei Mate 10 Pro', 8, 'Android KitKat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (264, 'Terry', 'Conradsen', 'tconradsen7b@unicef.org', 'Philippines', 'Lapuyan', '2020-05-04', '(188) 3776585', '2018-12-25', 'Huawei Mate 20', 11, 'iOS 10.3.4');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (265, 'Oren', 'Zarfati', 'ozarfati7c@auda.org.au', 'United Kingdom', 'Norton', '1973-01-02', '(163) 5222999', '2010-06-19', 'iPhone 7s', 5, 'Android 10');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (266, 'Raina', 'Pegler', 'rpegler7d@digg.com', 'Albania', 'Elbasan', '1963-04-27', '(632) 7687422', '2019-04-13', 'Huawei P9', 6, 'iOS 12.4.8');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (267, 'Hollyanne', 'Jeandel', 'hjeandel7e@columbia.edu', 'Russia', 'Mundybash', '1952-06-02', '(505) 9204363', '2012-01-12', 'Huawei P9', 5, 'Android Nougat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (268, 'Spike', 'Stoney', 'sstoney7f@mapquest.com', 'Germany', 'Düsseldorf', '1997-03-24', '(511) 6647607', '2013-09-18', 'iPhone 8', 13, 'Android Oreo');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (269, 'Julianna', 'Carine', 'jcarine7g@seattletimes.com', 'Tajikistan', 'Norak', '1965-07-14', '(177) 3842241', '2017-10-21', 'iPhone 7s', 8, 'iOS 9.3.5');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (270, 'Ethel', 'Haughin', 'ehaughin7h@earthlink.net', 'Poland', 'Godziszów Pierwszy', '1923-03-24', '(705) 6495076', '2011-08-30', 'iPhone 7', 10, 'iOS 10.3.3');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (271, 'Thekla', 'Menendes', 'tmenendes7i@google.es', 'Israel', 'Petaẖ Tiqwa', '1961-11-14', '(223) 3951659', '2013-12-11', 'iPhone 8', 7, 'Android Marshmallow');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (272, 'Karalee', 'Straun', 'kstraun7j@wunderground.com', 'France', 'Paris 19', '1984-01-08', '(581) 5212201', '2020-07-25', 'iPhone 6', 5, 'Android Marshmallow');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (273, 'Robinia', 'Aaronsohn', 'raaronsohn7k@wsj.com', 'Indonesia', 'Pericik', '1977-05-09', '(112) 2908208', '2018-01-04', 'iPhone 7', 12, 'iOS 9.3.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (274, 'Karalee', 'Munton', 'kmunton7l@naver.com', 'Philippines', 'Pigcawayan', '1999-01-02', '(797) 4376613', '2019-03-31', 'iPhone 7', 2, 'Android Lollipop');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (275, 'Elisabet', 'Goare', 'egoare7m@constantcontact.com', 'Serbia', 'Valjevo', '2014-11-08', '(251) 1340914', '2016-01-23', 'Huawei P20 Pro', 6, 'Android KitKat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (276, 'Marjory', 'Stainer', 'mstainer7n@sakura.ne.jp', 'France', 'La Rochelle', '1975-08-10', '(847) 6557855', '2018-09-12', 'Galaxy S8', 3, 'iOS 10.3.3');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (277, 'Roberto', 'Sutworth', 'rsutworth7o@java.com', 'Ireland', 'Fairview', '1993-03-12', '(342) 9081180', '2018-07-07', 'iPhone 8s', 10, 'iOS 9.3.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (278, 'Kath', 'Hacquard', 'khacquard7p@mlb.com', 'Russia', 'Lyaskelya', '1999-06-07', '(267) 5290485', '2018-12-20', 'Huawei P10', 8, 'Android Nougat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (279, 'Rheba', 'Mosson', 'rmosson7q@bing.com', 'Brazil', 'Rio Grande da Serra', '2012-12-29', '(234) 7386585', '2015-12-11', 'iPhone XS', 3, 'Android Marshmallow');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (280, 'Betsy', 'Checci', 'bchecci7r@weibo.com', 'China', 'Jianshe', '1922-02-16', '(716) 3722967', '2015-02-05', 'iPhone 8s', 4, 'iOS 10.3.3');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (281, 'Sharron', 'Korbmaker', 'skorbmaker7s@51.la', 'United States', 'Portland', '1984-02-04', '(503) 2965275', '2010-09-13', 'iPhone 8', 12, 'Android Lollipop');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (282, 'Freeland', 'Mozzetti', 'fmozzetti7t@bravesites.com', 'Russia', 'Sychëvo', '2012-01-20', '(234) 1895881', '2013-12-10', 'Galaxy S10', 9, 'Android 10');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (283, 'Udale', 'Brockest', 'ubrockest7u@bizjournals.com', 'China', 'Jiangdong', '1987-12-03', '(657) 8100389', '2013-03-05', 'iPhone 8s', 3, 'Android Marshmallow');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (284, 'Lacee', 'Gosland', 'lgosland7v@xing.com', 'United States', 'Seattle', '1957-06-26', '(206) 8771973', '2010-03-06', 'Galaxy S8', 5, 'Android Marshmallow');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (285, 'Camille', 'Kellington', 'ckellington7w@dmoz.org', 'Serbia', 'Debeljača', '1929-08-13', '(785) 4791299', '2019-05-29', 'Huawei P9', 6, 'iOS 9.3.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (286, 'Roddie', 'Michelin', 'rmichelin7x@weibo.com', 'Norway', 'Bergen', '2017-02-07', '(904) 9595090', '2011-02-22', 'Galaxy S10', 2, 'Android Nougat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (287, 'Eunice', 'McAw', 'emcaw7y@indiatimes.com', 'China', 'Kizil', '2019-01-21', '(548) 2190766', '2013-05-27', 'Huawei P9', 2, 'iOS 10.3.4');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (288, 'Curr', 'Heaton', 'cheaton7z@blogspot.com', 'Argentina', 'Espinillo', '1934-11-25', '(450) 9812584', '2011-03-14', 'Huawei P20 Pro', 5, 'Android Lollipop');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (289, 'Shannan', 'Grinsted', 'sgrinsted80@wufoo.com', 'China', 'Liucheng', '1979-06-27', '(548) 8718541', '2020-02-04', 'Huawei Mate 10', 2, 'Android Nougat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (290, 'Frasco', 'Clyne', 'fclyne81@bizjournals.com', 'Tajikistan', 'Chkalov', '2010-07-15', '(386) 2493350', '2010-05-25', 'Huawei Mate 10 Pro', 12, 'iOS 12.4.8');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (291, 'Brynne', 'Derobert', 'bderobert82@sfgate.com', 'El Salvador', 'San Agustín', '1983-02-13', '(784) 9850582', '2017-09-17', 'iPhone XS', 8, 'iOS 9.3.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (292, 'Hyman', 'Mac Giany', 'hmacgiany83@phoca.cz', 'Russia', 'Nevel’', '2003-12-26', '(283) 5607091', '2014-10-01', 'iPhone 7', 14, 'Android Marshmallow');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (293, 'Janelle', 'Terrey', 'jterrey84@home.pl', 'Canada', 'Port Hawkesbury', '1933-02-06', '(280) 6318198', '2011-05-08', 'Huawei P10', 2, 'Android 10');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (294, 'Kaja', 'Godfree', 'kgodfree85@t.co', 'China', 'Paingar', '1974-11-04', '(614) 1236648', '2012-12-23', 'Huawei Mate 20 Pro', 4, 'iOS 13.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (295, 'Alice', 'Dottridge', 'adottridge86@mac.com', 'Mauritania', 'Aleg', '1990-09-23', '(366) 7441087', '2017-05-22', 'Galaxy S8', 8, 'iOS 9.3.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (296, 'Tanner', 'Derye-Barrett', 'tderyebarrett87@google.com.hk', 'Indonesia', 'Sintung Timur', '1987-03-29', '(166) 6873670', '2018-05-22', 'Huawei P30 Pro', 2, 'Android Nougat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (297, 'Miranda', 'Fierro', 'mfierro88@altervista.org', 'Japan', 'Sumoto', '2006-12-29', '(237) 8517476', '2013-06-29', 'Huawei P9', 8, 'Android 10');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (298, 'Karita', 'Pedlar', 'kpedlar89@hatena.ne.jp', 'China', 'Songdong', '2019-12-31', '(411) 2900926', '2014-11-02', 'Huawei P30 Pro', 11, 'iOS 10.3.3');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (299, 'Karita', 'Henrichs', 'khenrichs8a@list-manage.com', 'Myanmar', 'Kyaiklat', '1998-10-06', '(714) 8963510', '2011-08-02', 'Huawei Mate 10', 6, 'Android Marshmallow');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (300, 'Cassandre', 'Newborn', 'cnewborn8b@amazon.com', 'Peru', 'Llusco', '1979-05-18', '(185) 3868385', '2019-08-27', 'Huawei Mate 10', 2, 'Android 10');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (301, 'Tris', 'Hiscoe', 'thiscoe8c@ameblo.jp', 'Indonesia', 'Kawangkoan', '2020-12-11', '(970) 8243161', '2011-06-13', 'Huawei Mate 20 Pro', 14, 'Android Marshmallow');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (302, 'Mureil', 'Cordobes', 'mcordobes8d@ftc.gov', 'Indonesia', 'Wolowiro', '1973-11-30', '(741) 1356017', '2016-05-26', 'iPhone 7', 7, 'Android Oreo');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (303, 'Neile', 'Blewett', 'nblewett8e@google.ca', 'Poland', 'Orzesze', '1982-04-24', '(363) 4965437', '2016-03-08', 'iPhone 7s', 3, 'Android Lollipop');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (304, 'Ronny', 'Bockmann', 'rbockmann8f@ca.gov', 'Benin', 'Bassila', '2007-06-11', '(371) 7880159', '2019-09-26', 'Huawei Mate 10 Pro', 14, 'Android Lollipop');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (305, 'Malynda', 'Ireland', 'mireland8g@fema.gov', 'China', 'Huangdao', '1965-12-23', '(230) 2694085', '2010-09-16', 'Huawei P30', 11, 'iOS 10.3.4');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (306, 'Constancy', 'Keetley', 'ckeetley8h@creativecommons.org', 'North Korea', 'Sinmak', '1943-12-13', '(501) 9212494', '2013-07-13', 'iPhone 6', 9, 'iOS 12.4.8');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (307, 'Ebony', 'Knappitt', 'eknappitt8i@oakley.com', 'Russia', 'Megion', '1952-04-10', '(605) 2145046', '2012-12-10', 'iPhone 7s', 9, 'iOS 13.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (308, 'Gilbertine', 'Issard', 'gissard8j@mayoclinic.com', 'Ireland', 'Cherryville', '2009-10-16', '(192) 7228751', '2018-05-22', 'Huawei P9', 9, 'iOS 13.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (309, 'Lorianne', 'Rowthorne', 'lrowthorne8k@privacy.gov.au', 'Netherlands', 'Heemskerk', '2012-08-11', '(418) 8629363', '2014-05-19', 'iPhone 8', 5, 'iOS 9.3.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (310, 'Tiphani', 'Flegg', 'tflegg8l@github.io', 'France', 'Amiens', '1922-05-31', '(330) 7988072', '2019-02-10', 'iPhone X', 8, 'iOS 10.3.3');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (311, 'Clovis', 'Fivey', 'cfivey8m@un.org', 'Honduras', 'Talanga', '1988-03-18', '(773) 1309480', '2019-03-17', 'Galaxy S8', 7, 'Android Oreo');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (312, 'Kylie', 'Frankton', 'kfrankton8n@timesonline.co.uk', 'China', 'Kanshi', '1954-03-24', '(497) 9034005', '2012-02-14', 'iPhone X', 4, 'iOS 13.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (313, 'Charla', 'Healy', 'chealy8o@bluehost.com', 'Russia', 'Taldan', '1987-04-08', '(836) 1446309', '2015-08-07', 'Huawei Mate 20 Pro', 7, 'iOS 12.4.8');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (314, 'Ardyth', 'Orr', 'aorr8p@nature.com', 'Portugal', 'Marisol', '1982-12-10', '(326) 9077886', '2018-04-01', 'Galaxy S9', 9, 'iOS 10.3.3');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (315, 'Mommy', 'Mackinder', 'mmackinder8q@gnu.org', 'Cuba', 'Perico', '2005-08-08', '(697) 3593424', '2012-04-07', 'Huawei P20 Pro', 8, 'iOS 12.4.8');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (316, 'Estrella', 'Cowlard', 'ecowlard8r@vistaprint.com', 'Indonesia', 'Pangalangan', '2005-11-24', '(762) 2478760', '2018-11-18', 'Huawei P30', 8, 'Android Jelly Bean');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (317, 'Opaline', 'Gunthorpe', 'ogunthorpe8s@google.ru', 'Russia', 'Zakamensk', '1943-11-04', '(575) 8193096', '2012-12-15', 'iPhone 7', 4, 'iOS 9.3.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (318, 'Cheri', 'Teulier', 'cteulier8t@sciencedaily.com', 'France', 'Tourcoing', '2014-12-19', '(862) 6291858', '2019-07-20', 'iPhone X', 14, 'Android KitKat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (319, 'Gearalt', 'Elstone', 'gelstone8u@patch.com', 'Philippines', 'Tagbacan Ibaba', '1983-04-06', '(820) 3207765', '2015-06-10', 'iPhone XS', 1, 'Android Lollipop');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (320, 'Ofella', 'Abercromby', 'oabercromby8v@ameblo.jp', 'China', 'Dongjiang Matoukou', '1999-01-26', '(716) 1505387', '2011-11-29', 'Galaxy S10', 11, 'Android 10');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (321, 'Flory', 'Habble', 'fhabble8w@elpais.com', 'Portugal', 'Estarreja', '1987-05-04', '(315) 1786576', '2019-04-30', 'iPhone 7', 8, 'Android Lollipop');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (322, 'Bartholomeus', 'Goodhall', 'bgoodhall8x@people.com.cn', 'Afghanistan', 'Kalān Deh', '1961-06-25', '(172) 5963125', '2012-03-17', 'iPhone 7s', 7, 'Android Marshmallow');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (323, 'Janot', 'Gabbidon', 'jgabbidon8y@so-net.ne.jp', 'Greece', 'Kallithéa', '2019-01-28', '(650) 4488561', '2019-10-15', 'Huawei P20 Pro', 11, 'iOS 9.3.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (324, 'Ardelia', 'Atlay', 'aatlay8z@sitemeter.com', 'Philippines', 'Morong', '1952-03-27', '(245) 9577500', '2014-05-27', 'iPhone 7s', 12, 'Android Lollipop');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (325, 'Christiano', 'Zamorano', 'czamorano90@sourceforge.net', 'China', 'Liangzeng', '1939-06-02', '(271) 7767375', '2019-04-19', 'Huawei P30 Pro', 9, 'Android Oreo');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (326, 'Sharia', 'Shearsby', 'sshearsby91@live.com', 'China', 'Taiping', '2008-12-22', '(830) 6299591', '2010-05-21', 'Galaxy S8', 2, 'Android Jelly Bean');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (327, 'Hilton', 'McLaine', 'hmclaine92@blogs.com', 'Indonesia', 'Cihurip Satu', '1957-12-02', '(370) 3794281', '2020-01-31', 'Huawei P9 Pro', 14, 'iOS 9.3.5');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (328, 'Blanca', 'Youngman', 'byoungman93@thetimes.co.uk', 'Bahamas', 'San Andros', '2020-09-19', '(828) 9323846', '2015-04-22', 'Huawei Mate 20 Pro', 3, 'iOS 9.3.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (329, 'Adelheid', 'Prestage', 'aprestage94@drupal.org', 'Sweden', 'Robertsfors', '2020-02-13', '(110) 1200581', '2016-11-20', 'Huawei P20', 4, 'Android Nougat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (330, 'Adoree', 'Sheehy', 'asheehy95@indiatimes.com', 'Indonesia', 'Pule', '1952-03-28', '(412) 1916118', '2014-03-01', 'Huawei P10 Pro', 14, 'Android Oreo');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (331, 'Randee', 'Von Helmholtz', 'rvonhelmholtz96@amazonaws.com', 'Cyprus', 'Léfka', '2000-08-19', '(117) 6590410', '2014-09-24', 'Huawei P30', 2, 'Android Jelly Bean');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (332, 'Lewiss', 'Redwing', 'lredwing97@themeforest.net', 'Canada', 'New Glasgow', '2008-03-12', '(518) 8750813', '2017-05-02', 'Huawei P9', 14, 'Android KitKat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (333, 'Nigel', 'Crafts', 'ncrafts98@jugem.jp', 'Russia', 'Saint Petersburg', '1999-04-26', '(752) 3124250', '2014-08-12', 'Huawei P30', 9, 'Android Marshmallow');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (334, 'Lorilee', 'Winnett', 'lwinnett99@desdev.cn', 'Indonesia', 'Rancapeundey', '1976-07-27', '(850) 2199480', '2014-09-29', 'iPhone 8s', 2, 'Android Pie');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (335, 'Corilla', 'Tewnion', 'ctewnion9a@narod.ru', 'China', 'Bilian', '1950-11-05', '(235) 8150363', '2013-08-10', 'Huawei P9 Pro', 11, 'Android Marshmallow');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (336, 'Leese', 'Tambling', 'ltambling9b@ox.ac.uk', 'Brazil', 'Boa Vista', '1920-08-29', '(634) 7923029', '2016-05-03', 'Huawei P9 Pro', 9, 'Android Marshmallow');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (337, 'Marjory', 'Goor', 'mgoor9c@theatlantic.com', 'Russia', 'Ust’-Ulagan', '2002-05-20', '(339) 5331320', '2014-05-19', 'Huawei P9', 8, 'Android Marshmallow');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (338, 'Sheena', 'Redemile', 'sredemile9d@barnesandnoble.com', 'Philippines', 'Bungabon', '1975-12-13', '(516) 6541675', '2013-01-01', 'iPhone 8s', 7, 'Android Marshmallow');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (339, 'Vyky', 'Mecozzi', 'vmecozzi9e@ed.gov', 'Portugal', 'Louriceira', '1920-10-08', '(799) 9137820', '2011-04-28', 'Galaxy S10', 11, 'Android Nougat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (340, 'Allen', 'Campione', 'acampione9f@netscape.com', 'Serbia', 'Rekovac', '1963-09-09', '(486) 8409008', '2012-05-28', 'Galaxy S8', 8, 'Android Lollipop');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (341, 'Deana', 'Strauss', 'dstrauss9g@joomla.org', 'France', 'Poissy', '1954-06-09', '(505) 4260223', '2014-07-30', 'Huawei P9 Pro', 6, 'iOS 9.3.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (342, 'Dee', 'Wogdon', 'dwogdon9h@uiuc.edu', 'Philippines', 'Siruma', '1981-03-31', '(172) 9340670', '2018-01-23', 'Galaxy S8', 6, 'iOS 9.3.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (343, 'Nelia', 'Patzelt', 'npatzelt9i@weather.com', 'Canada', 'High Prairie', '1999-04-12', '(537) 2800748', '2020-02-12', 'Huawei Mate 20 Pro', 13, 'Android Nougat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (344, 'Ilysa', 'Peterson', 'ipeterson9j@bandcamp.com', 'Russia', 'Nakhodka', '1921-04-13', '(477) 4438787', '2018-12-20', 'Huawei P20', 10, 'Android 10');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (345, 'Guy', 'McCleary', 'gmccleary9k@nba.com', 'Czech Republic', 'Blansko', '2000-04-12', '(663) 6127159', '2015-03-09', 'Huawei Mate 20', 14, 'Android Nougat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (346, 'Joey', 'Brummitt', 'jbrummitt9l@dmoz.org', 'Czech Republic', 'Chlumec', '1931-07-12', '(905) 7223987', '2018-04-05', 'iPhone 6s', 10, 'Android Oreo');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (347, 'Shaine', 'Lloyd', 'slloyd9m@sun.com', 'Indonesia', 'Guder Lao', '1928-08-30', '(212) 9178756', '2013-06-05', 'Huawei Mate 20 Pro', 6, 'Android Nougat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (348, 'Ham', 'Lothean', 'hlothean9n@fastcompany.com', 'China', 'Fengkou', '1937-01-15', '(311) 8586327', '2013-04-13', 'Huawei P10 Pro', 3, 'iOS 12.4.8');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (349, 'Arthur', 'Beggan', 'abeggan9o@baidu.com', 'Thailand', 'Sattahip', '1977-07-11', '(213) 9457180', '2015-12-14', 'Galaxy S9', 1, 'Android Lollipop');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (350, 'Siegfried', 'Caurah', 'scaurah9p@amazon.com', 'Mauritius', 'Calebasses', '1965-08-19', '(811) 1296093', '2015-07-16', 'iPhone XS', 3, 'Android Nougat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (351, 'Vick', 'Brant', 'vbrant9q@friendfeed.com', 'Sweden', 'Svalöv', '2019-03-14', '(755) 6021666', '2014-05-13', 'iPhone XS', 11, 'iOS 13.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (352, 'Gabriellia', 'Lemar', 'glemar9r@census.gov', 'Indonesia', 'Karangsonojabon', '2017-11-09', '(493) 6784395', '2015-12-10', 'Galaxy S8', 3, 'Android 10');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (353, 'Danyette', 'Hember', 'dhember9s@xinhuanet.com', 'Russia', 'Golovchino', '1963-12-19', '(763) 9175566', '2014-11-14', 'Galaxy S10', 7, 'iOS 9.3.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (354, 'Bendite', 'Ceresa', 'bceresa9t@gravatar.com', 'China', 'Mugan', '1941-08-15', '(999) 6575378', '2020-07-24', 'iPhone 6s', 11, 'iOS 13.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (355, 'Bearnard', 'Phillins', 'bphillins9u@tripadvisor.com', 'Nigeria', 'Madagali', '1949-05-04', '(449) 4634974', '2010-06-08', 'Huawei P20 Pro', 5, 'iOS 10.3.4');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (356, 'Betsy', 'Clemintoni', 'bclemintoni9v@is.gd', 'Czech Republic', 'Vrdy', '1973-12-16', '(599) 1103800', '2016-05-23', 'iPhone 6s', 3, 'Android 10');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (357, 'Kathi', 'Parchment', 'kparchment9w@tripod.com', 'Russia', 'Zamoskvorech’ye', '1990-01-24', '(951) 3866845', '2012-06-05', 'iPhone 6s', 2, 'Android KitKat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (358, 'Kerry', 'Harpur', 'kharpur9x@desdev.cn', 'Japan', 'Ōkuchi', '1959-01-14', '(729) 4402422', '2012-01-29', 'iPhone XS', 11, 'Android Nougat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (359, 'Fidelity', 'Sansum', 'fsansum9y@sun.com', 'Greece', 'Nisí', '1924-08-01', '(564) 9321186', '2019-07-11', 'iPhone 7', 10, 'Android 10');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (360, 'Krishna', 'Frapwell', 'kfrapwell9z@hhs.gov', 'China', 'Gulai', '1935-07-06', '(684) 7879706', '2011-03-10', 'iPhone 7', 8, 'Android KitKat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (361, 'Dal', 'Dimbleby', 'ddimblebya0@dagondesign.com', 'China', 'Leiyang', '1985-05-14', '(965) 9385968', '2010-02-15', 'Huawei P30 Pro', 13, 'Android Pie');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (362, 'Putnem', 'Whittick', 'pwhitticka1@kickstarter.com', 'Russia', 'Petukhovo', '1998-05-29', '(853) 6128301', '2017-11-19', 'Huawei P30 Pro', 3, 'Android Nougat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (363, 'Schuyler', 'Hildrew', 'shildrewa2@utexas.edu', 'China', 'Douba', '2017-12-02', '(386) 5173274', '2015-09-24', 'Galaxy S8', 3, 'iOS 9.3.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (364, 'Jenny', 'Mundford', 'jmundforda3@cnet.com', 'Sierra Leone', 'Kukuna', '2009-05-17', '(600) 8152435', '2013-01-10', 'Galaxy S10', 6, 'Android Nougat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (365, 'Trevar', 'Bossingham', 'tbossinghama4@amazon.com', 'China', 'Changfa', '2012-05-14', '(625) 5022490', '2010-01-27', 'Galaxy S9', 6, 'Android KitKat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (366, 'Onfre', 'Duddell', 'oduddella5@behance.net', 'Mexico', 'Vicente Guerrero', '2016-06-16', '(621) 7875376', '2019-01-11', 'iPhone XS', 4, 'Android Lollipop');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (367, 'Byrann', 'Cowlas', 'bcowlasa6@tamu.edu', 'China', 'Jitian', '1987-05-10', '(105) 3099514', '2013-03-23', 'Huawei P20', 11, 'iOS 10.3.4');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (368, 'Vicki', 'Dagnall', 'vdagnalla7@people.com.cn', 'China', 'Jiaohu', '1970-07-16', '(549) 4022858', '2010-10-21', 'iPhone 8s', 8, 'Android KitKat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (369, 'Harp', 'Knapman', 'hknapmana8@wufoo.com', 'Russia', 'Sosnovoborsk', '1947-10-09', '(344) 8118575', '2011-12-05', 'Huawei P30 Pro', 1, 'Android KitKat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (370, 'Eberto', 'Michael', 'emichaela9@is.gd', 'Indonesia', 'Sumberbening', '1936-07-21', '(836) 4124534', '2016-08-22', 'Galaxy S8', 4, 'Android Nougat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (371, 'Katharina', 'Ezzell', 'kezzellaa@samsung.com', 'Mexico', '5 de Mayo', '1983-06-24', '(839) 9211807', '2010-09-28', 'iPhone 7', 6, 'iOS 9.3.5');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (372, 'Sascha', 'Branford', 'sbranfordab@mac.com', 'Dominican Republic', 'Las Terrenas', '1999-03-13', '(994) 5993297', '2018-08-27', 'Huawei P10 Pro', 7, 'Android Oreo');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (373, 'Roderick', 'Fache', 'rfacheac@live.com', 'China', 'Wantan', '1988-09-18', '(585) 4984506', '2012-08-18', 'iPhone 8s', 7, 'Android Oreo');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (374, 'Angelo', 'Hiscoe', 'ahiscoead@dropbox.com', 'United States', 'Tulsa', '1952-11-02', '(918) 5311501', '2012-02-15', 'iPhone 7s', 9, 'Android Marshmallow');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (375, 'Richy', 'Yakovl', 'ryakovlae@imageshack.us', 'Tanzania', 'Kibiti', '1941-12-13', '(184) 8675696', '2013-09-26', 'Galaxy S10', 13, 'Android Lollipop');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (376, 'Shermy', 'Crust', 'scrustaf@exblog.jp', 'China', 'Xinhui', '1963-01-25', '(540) 1449892', '2011-01-28', 'iPhone 6s', 9, 'Android Nougat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (377, 'Marcus', 'Striker', 'mstrikerag@answers.com', 'China', 'Shengli', '1963-01-04', '(478) 8171606', '2010-12-29', 'iPhone 8s', 5, 'Android Marshmallow');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (378, 'Amalie', 'Gehringer', 'agehringerah@opensource.org', 'Thailand', 'Sam Roi Yot', '1955-05-01', '(866) 8538846', '2017-09-03', 'iPhone 6s', 9, 'Android Marshmallow');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (379, 'Franni', 'Murrells', 'fmurrellsai@hc360.com', 'Indonesia', 'Manggissari', '1921-12-27', '(636) 3143062', '2013-11-23', 'Huawei P9', 3, 'Android KitKat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (380, 'Fifi', 'Ivanonko', 'fivanonkoaj@economist.com', 'Tanzania', 'Igurubi', '2020-03-06', '(822) 1924066', '2013-05-19', 'Huawei P9', 2, 'iOS 10.3.3');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (381, 'Ewell', 'Prott', 'eprottak@google.it', 'Sweden', 'Västervik', '1995-06-30', '(769) 5076530', '2013-11-06', 'iPhone XS', 9, 'iOS 12.4.8');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (382, 'Ania', 'Niblock', 'aniblockal@unc.edu', 'China', 'Bamiantong', '1936-03-22', '(883) 9943032', '2010-10-25', 'Huawei Mate 20', 11, 'Android KitKat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (383, 'Mycah', 'Sertin', 'msertinam@xinhuanet.com', 'Brazil', 'Itanhaém', '1943-01-10', '(524) 6945945', '2014-08-11', 'iPhone 8s', 7, 'Android Marshmallow');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (384, 'Katerina', 'McCrie', 'kmccriean@cbc.ca', 'China', 'Xialaxiu', '1933-07-07', '(860) 4038364', '2018-01-16', 'Huawei P20', 1, 'iOS 13.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (385, 'Anjela', 'Laverack', 'alaverackao@reddit.com', 'China', 'Wucheng', '2004-08-18', '(998) 3201448', '2014-04-10', 'Huawei P9 Pro', 2, 'Android Lollipop');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (386, 'Alane', 'Speeks', 'aspeeksap@home.pl', 'Brazil', 'Cajueiro', '2000-01-12', '(601) 5579459', '2013-05-31', 'Galaxy S8', 8, 'iOS 10.3.3');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (387, 'Meara', 'Hambling', 'mhamblingaq@booking.com', 'Russia', 'Ust’-Dzheguta', '1971-09-16', '(513) 1317189', '2016-08-21', 'Huawei Mate 20 Pro', 14, 'iOS 12.4.8');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (388, 'Clarita', 'Klesel', 'ckleselar@aol.com', 'Mauritius', 'Saint Aubin', '2000-12-10', '(902) 9257521', '2015-06-11', 'Huawei Mate 10 Pro', 10, 'Android Marshmallow');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (389, 'Ardelia', 'Strelitzer', 'astrelitzeras@sciencedirect.com', 'China', 'Xambabazar', '1974-01-20', '(113) 6264105', '2014-08-21', 'Huawei P20', 12, 'iOS 9.3.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (390, 'Arnie', 'Metzig', 'ametzigat@ucsd.edu', 'Czech Republic', 'Zlechov', '1950-02-19', '(657) 2026369', '2012-07-01', 'Huawei P9 Pro', 9, 'iOS 13.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (391, 'Niven', 'Leavy', 'nleavyau@wsj.com', 'Russia', 'Orekhovo', '1974-01-26', '(407) 7545459', '2015-04-01', 'iPhone XS', 6, 'iOS 13.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (392, 'Romeo', 'Stitson', 'rstitsonav@joomla.org', 'China', 'Maoshan', '1964-08-25', '(987) 3580231', '2014-07-07', 'Huawei P20 Pro', 13, 'Android Jelly Bean');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (393, 'Adriana', 'Sleight', 'asleightaw@latimes.com', 'Morocco', 'Aknoul', '1991-11-30', '(335) 4556104', '2012-06-24', 'Huawei P10', 1, 'iOS 10.3.3');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (394, 'Celestyn', 'Getten', 'cgettenax@g.co', 'Canada', 'Sparwood', '1961-11-01', '(708) 2805458', '2011-03-02', 'Huawei P20 Pro', 5, 'Android Pie');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (395, 'Ann', 'Bader', 'abaderay@google.com.hk', 'China', 'Fengniancun', '1999-11-06', '(925) 2790927', '2010-04-30', 'iPhone 6s', 2, 'iOS 9.3.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (396, 'Ray', 'Parkisson', 'rparkissonaz@eventbrite.com', 'China', 'Yashan', '1927-09-24', '(316) 8769263', '2018-08-18', 'Huawei Mate 20 Pro', 9, 'Android Jelly Bean');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (397, 'Adina', 'Corbett', 'acorbettb0@etsy.com', 'Mexico', 'El Aguacate', '1924-01-12', '(853) 1619176', '2015-12-05', 'Huawei P20 Pro', 4, 'Android Pie');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (398, 'Lynna', 'Mathevon', 'lmathevonb1@google.com.br', 'Venezuela', 'Ciudad Bolivia', '1920-04-27', '(697) 9203546', '2014-06-19', 'iPhone X', 11, 'Android 10');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (399, 'Georgetta', 'Hadingham', 'ghadinghamb2@deviantart.com', 'China', 'Zhen’an', '1993-11-12', '(340) 8995735', '2014-08-13', 'iPhone 7s', 6, 'iOS 9.3.5');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (400, 'Gabriel', 'Steade', 'gsteadeb3@gnu.org', 'China', 'Xiaochi', '2019-07-31', '(314) 7704760', '2017-01-18', 'Huawei P10 Pro', 1, 'Android Lollipop');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (401, 'Virgie', 'Timothy', 'vtimothyb4@wp.com', 'Indonesia', 'Warung Wetan', '1922-11-21', '(795) 3429421', '2012-12-05', 'iPhone 8s', 13, 'Android Lollipop');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (402, 'Jyoti', 'Monard', 'jmonardb5@histats.com', 'Iran', 'Kelīshād va Sūdarjān', '1939-10-05', '(368) 3020798', '2013-12-18', 'iPhone 7', 8, 'iOS 9.3.5');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (403, 'Waylen', 'Jancik', 'wjancikb6@dion.ne.jp', 'Mongolia', 'Ölgiy', '1969-02-21', '(383) 7915430', '2013-11-26', 'Huawei P20', 7, 'Android Pie');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (404, 'Nathalia', 'Goodlatt', 'ngoodlattb7@xing.com', 'China', 'Xinkai', '1979-09-21', '(381) 5373870', '2013-11-25', 'iPhone XS', 8, 'Android Oreo');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (405, 'Ginnifer', 'Swine', 'gswineb8@canalblog.com', 'Indonesia', 'Gunungkendeng', '1959-09-19', '(447) 1159631', '2012-03-10', 'Huawei P10 Pro', 12, 'Android Pie');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (406, 'Greer', 'Easton', 'geastonb9@usatoday.com', 'Indonesia', 'Gagah', '2007-12-08', '(329) 2970568', '2016-02-21', 'Huawei Mate 10 Pro', 7, 'iOS 13.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (407, 'Foster', 'Romanin', 'fromaninba@nasa.gov', 'Indonesia', 'Samangawah', '1950-05-29', '(878) 9350854', '2011-03-24', 'Huawei Mate 10', 8, 'iOS 9.3.5');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (408, 'Jayme', 'Kinnier', 'jkinnierbb@yellowpages.com', 'France', 'Dijon', '1964-04-16', '(248) 2825663', '2013-04-29', 'iPhone 8', 13, 'Android Lollipop');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (409, 'Gilli', 'Blaksland', 'gblakslandbc@huffingtonpost.com', 'China', 'Golmud', '1968-07-27', '(934) 4366427', '2013-02-02', 'iPhone 7', 13, 'Android 10');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (410, 'Bastien', 'Heninghem', 'bheninghembd@last.fm', 'China', 'Xibin', '2012-11-15', '(861) 9989683', '2017-09-26', 'Galaxy S8', 4, 'iOS 9.3.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (411, 'Tanya', 'Skough', 'tskoughbe@thetimes.co.uk', 'Honduras', 'Duyure', '1968-07-31', '(566) 6527117', '2013-02-19', 'iPhone 6', 7, 'iOS 13.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (412, 'Rochell', 'Ainsworth', 'rainsworthbf@gov.uk', 'Czech Republic', 'Humpolec', '1969-02-05', '(983) 8676118', '2019-05-03', 'Galaxy S9', 5, 'Android Lollipop');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (413, 'Jilleen', 'Milsted', 'jmilstedbg@i2i.jp', 'China', 'Tongliao', '1937-10-30', '(849) 4285277', '2013-05-05', 'iPhone X', 4, 'iOS 9.3.5');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (414, 'Giustina', 'Giacobbo', 'ggiacobbobh@bloomberg.com', 'Burkina Faso', 'Nouna', '1966-05-18', '(311) 7253669', '2011-07-23', 'Huawei P10 Pro', 14, 'iOS 10.3.3');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (415, 'Weylin', 'Pavluk', 'wpavlukbi@webeden.co.uk', 'Latvia', 'Skrunda', '2014-07-20', '(292) 6046307', '2015-05-06', 'Huawei Mate 20', 10, 'iOS 13.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (416, 'Bridget', 'Arthey', 'bartheybj@google.co.jp', 'Philippines', 'Tabiauan', '1984-01-29', '(459) 7478621', '2013-05-12', 'Galaxy S9', 1, 'Android Jelly Bean');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (417, 'Murvyn', 'Roussel', 'mrousselbk@yellowbook.com', 'France', 'Paris La Défense', '1957-10-23', '(244) 2295876', '2013-06-11', 'Huawei P30 Pro', 9, 'iOS 9.3.5');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (418, 'Lind', 'Double', 'ldoublebl@e-recht24.de', 'Nigeria', 'Dadiya', '1931-05-04', '(408) 5327879', '2015-03-30', 'Galaxy S9', 12, 'Android Nougat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (419, 'Alanna', 'Ledgard', 'aledgardbm@sfgate.com', 'Russia', 'Dyurtyuli', '1971-06-08', '(549) 5158716', '2013-12-02', 'Huawei P9', 7, 'Android Marshmallow');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (420, 'Cletis', 'Simmins', 'csimminsbn@timesonline.co.uk', 'Russia', 'Berëzovskiy', '2016-09-27', '(761) 2907868', '2012-12-13', 'Huawei P20', 5, 'Android 10');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (421, 'Carena', 'Benardette', 'cbenardettebo@intel.com', 'Philippines', 'Balucawi', '2016-11-25', '(874) 6695257', '2012-06-05', 'Huawei P30 Pro', 6, 'iOS 10.3.3');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (422, 'Valentino', 'Kidston', 'vkidstonbp@noaa.gov', 'Indonesia', 'Kasiyan', '1967-08-06', '(618) 9980554', '2013-03-14', 'Huawei P30 Pro', 4, 'iOS 13.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (423, 'Ashlie', 'Yesenin', 'ayeseninbq@163.com', 'Sweden', 'Örnsköldsvik', '2005-04-13', '(294) 4406803', '2012-08-12', 'iPhone XS', 10, 'iOS 10.3.4');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (424, 'Koral', 'Weightman', 'kweightmanbr@webeden.co.uk', 'Finland', 'Sumiainen', '1977-04-11', '(956) 8657283', '2013-08-30', 'Huawei P9', 10, 'iOS 10.3.3');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (425, 'Roberta', 'Jansema', 'rjansemabs@virginia.edu', 'Philippines', 'Calinog', '1959-04-15', '(678) 8724063', '2015-06-02', 'Huawei Mate 10 Pro', 11, 'Android 10');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (426, 'Cynthie', 'Truwert', 'ctruwertbt@canalblog.com', 'Brazil', 'Ibaté', '1941-05-19', '(971) 1937957', '2018-02-13', 'Huawei Mate 10', 7, 'iOS 13.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (427, 'Allistir', 'Haydn', 'ahaydnbu@hexun.com', 'Indonesia', 'Banjar Tegal Belodan', '2003-03-26', '(249) 8052089', '2010-09-16', 'Huawei Mate 10', 1, 'iOS 9.3.5');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (428, 'Derk', 'Gavrielly', 'dgavriellybv@wired.com', 'Argentina', 'Gualeguay', '1931-03-23', '(373) 2414102', '2013-04-10', 'iPhone 8', 5, 'iOS 13.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (429, 'Ellette', 'Stedson', 'estedsonbw@sogou.com', 'Guatemala', 'El Estor', '1942-02-06', '(700) 8038579', '2020-06-16', 'Huawei P30 Pro', 10, 'Android Marshmallow');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (430, 'Cristian', 'Dugmore', 'cdugmorebx@bluehost.com', 'Egypt', 'Fāraskūr', '1930-10-09', '(449) 1419072', '2010-10-21', 'iPhone XS', 3, 'Android Lollipop');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (431, 'Elizabeth', 'Piquard', 'epiquardby@un.org', 'Russia', 'Vyselki', '1964-01-17', '(512) 5682002', '2016-09-06', 'Huawei Mate 20', 7, 'Android Jelly Bean');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (432, 'Christye', 'Enright', 'cenrightbz@w3.org', 'Indonesia', 'Nangkasari', '2016-11-05', '(305) 5225544', '2013-07-11', 'Huawei P30', 13, 'Android Marshmallow');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (433, 'Kory', 'Giberd', 'kgiberdc0@reddit.com', 'Brazil', 'Ribeirão Pires', '1996-02-04', '(523) 3868470', '2013-01-20', 'Huawei P20', 2, 'Android Jelly Bean');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (434, 'Joey', 'Sirmon', 'jsirmonc1@earthlink.net', 'Indonesia', 'Mautapaga Bawah', '1994-04-21', '(180) 6293714', '2019-08-03', 'iPhone 7s', 1, 'iOS 12.4.8');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (435, 'Yalonda', 'Woollons', 'ywoollonsc2@hc360.com', 'France', 'Caen', '1988-03-29', '(930) 2947291', '2016-10-14', 'iPhone 8s', 3, 'iOS 9.3.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (436, 'Terri', 'Newis', 'tnewisc3@engadget.com', 'Sweden', 'Kiruna', '1940-01-29', '(961) 9739364', '2011-03-22', 'iPhone XS', 7, 'Android Jelly Bean');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (437, 'Jaquelin', 'Hain', 'jhainc4@studiopress.com', 'Russia', 'Shal’skiy', '1981-12-17', '(478) 6575852', '2012-06-23', 'Huawei P20', 12, 'Android Marshmallow');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (438, 'Christal', 'Botterell', 'cbotterellc5@sohu.com', 'Indonesia', 'Momanalu', '1957-02-25', '(958) 8988431', '2011-05-04', 'Galaxy S10', 12, 'iOS 10.3.3');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (439, 'Belita', 'Jobke', 'bjobkec6@flickr.com', 'Poland', 'Drawsko Pomorskie', '1973-12-30', '(591) 1472173', '2014-12-20', 'Huawei P9', 1, 'iOS 13.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (440, 'Fifine', 'Ceney', 'fceneyc7@gnu.org', 'China', 'Qinglung', '2016-10-02', '(796) 7724122', '2013-07-18', 'Huawei Mate 10 Pro', 5, 'Android Marshmallow');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (441, 'Phip', 'Rape', 'prapec8@columbia.edu', 'United Kingdom', 'Norton', '2011-10-09', '(714) 4033119', '2011-01-03', 'Huawei P10', 3, 'iOS 9.3.5');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (442, 'Hurlee', 'Eisold', 'heisoldc9@youku.com', 'China', 'Huyang', '2018-12-01', '(501) 8676897', '2017-06-22', 'Huawei P20', 6, 'iOS 9.3.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (443, 'Gilberto', 'Longson', 'glongsonca@unicef.org', 'Indonesia', 'Neofbaun', '1983-10-30', '(904) 2762694', '2018-08-14', 'Huawei Mate 20', 1, 'Android Oreo');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (444, 'Simon', 'Skuce', 'sskucecb@etsy.com', 'Poland', 'Puszczykowo', '1963-05-15', '(712) 3921573', '2011-09-05', 'iPhone X', 13, 'Android Jelly Bean');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (445, 'Elijah', 'Blakemore', 'eblakemorecc@cpanel.net', 'Philippines', 'Lugo', '1942-03-24', '(473) 2142235', '2016-10-02', 'iPhone X', 12, 'Android Nougat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (446, 'Juliann', 'Weiss', 'jweisscd@free.fr', 'Sweden', 'Västerås', '2007-11-25', '(628) 9653974', '2012-03-14', 'Huawei P20', 10, 'Android Pie');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (447, 'Duffie', 'Middleditch', 'dmiddleditchce@trellian.com', 'Philippines', 'Sapol', '1924-11-07', '(160) 7580423', '2010-05-28', 'Huawei P9', 14, 'iOS 9.3.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (448, 'Naoma', 'Snufflebottom', 'nsnufflebottomcf@hostgator.com', 'Cambodia', 'Tbêng Méanchey', '2004-04-13', '(722) 1078852', '2017-09-02', 'Galaxy S10', 14, 'iOS 13.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (449, 'Ewell', 'Studders', 'estudderscg@t-online.de', 'Japan', 'Kanoya', '1975-06-25', '(319) 9425247', '2011-03-21', 'Huawei P9', 11, 'Android 10');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (450, 'Siana', 'Coppen', 'scoppench@unc.edu', 'Indonesia', 'Bojonegoro', '1926-01-19', '(984) 4802662', '2016-08-27', 'Huawei P10 Pro', 11, 'iOS 10.3.3');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (451, 'Alasteir', 'Stagge', 'astaggeci@tmall.com', 'North Korea', 'Aoji-ri', '2014-12-27', '(181) 9223412', '2020-01-01', 'Huawei P10', 11, 'Android Nougat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (452, 'Laurianne', 'Murton', 'lmurtoncj@angelfire.com', 'Thailand', 'Mueang Suang', '1929-04-02', '(902) 8540805', '2014-06-21', 'iPhone 7', 5, 'Android KitKat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (453, 'Veda', 'Evason', 'vevasonck@pbs.org', 'Brazil', 'Charqueadas', '1973-10-13', '(484) 5173239', '2011-08-30', 'iPhone 7', 10, 'Android Jelly Bean');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (454, 'Boyce', 'Winney', 'bwinneycl@geocities.jp', 'Russia', 'Nartkala', '1940-06-29', '(967) 2961748', '2017-10-08', 'iPhone 8', 9, 'iOS 10.3.3');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (455, 'Osborn', 'Lorinez', 'olorinezcm@house.gov', 'Japan', 'Kobayashi', '1968-07-06', '(400) 7329355', '2014-06-24', 'iPhone XS', 7, 'Android Pie');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (456, 'Marshal', 'Putley', 'mputleycn@baidu.com', 'China', 'Shangganshan', '1968-10-18', '(441) 8287607', '2012-04-29', 'iPhone 6s', 3, 'iOS 9.3.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (457, 'Tabatha', 'McLernon', 'tmclernonco@bizjournals.com', 'China', 'Lijia', '2015-06-07', '(703) 7974320', '2018-01-31', 'Huawei Mate 10', 8, 'iOS 12.4.8');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (458, 'Isiahi', 'Butterick', 'ibutterickcp@pbs.org', 'Central African Republic', 'Mbaïki', '1952-08-29', '(170) 3598053', '2016-09-16', 'iPhone X', 4, 'Android Nougat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (459, 'Ruddie', 'Foran', 'rforancq@chicagotribune.com', 'United States', 'Asheville', '2002-06-30', '(828) 9762459', '2011-10-25', 'iPhone XS', 13, 'Android Jelly Bean');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (460, 'Odell', 'Giddins', 'ogiddinscr@mayoclinic.com', 'Indonesia', 'Sugihmukti', '2017-01-03', '(828) 4635226', '2012-12-16', 'iPhone 7', 10, 'Android Marshmallow');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (461, 'Edgard', 'Inkpin', 'einkpincs@chicagotribune.com', 'Malaysia', 'Melaka', '2000-07-20', '(625) 1632545', '2015-03-21', 'Galaxy S8', 11, 'Android KitKat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (462, 'Enid', 'Chang', 'echangct@umn.edu', 'China', 'Huangduobu', '2001-04-01', '(251) 4734656', '2018-05-06', 'iPhone XS', 12, 'iOS 12.4.8');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (463, 'Dick', 'Brookes', 'dbrookescu@1und1.de', 'Guatemala', 'Lívingston', '1927-02-09', '(259) 1419631', '2017-08-11', 'iPhone XS', 2, 'Android Marshmallow');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (464, 'Catlee', 'Jukubczak', 'cjukubczakcv@stumbleupon.com', 'Indonesia', 'Kalidawir', '1985-01-06', '(937) 9479415', '2016-06-05', 'Huawei P10', 6, 'iOS 12.4.8');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (465, 'Artus', 'Vellden', 'avelldencw@google.co.uk', 'China', 'Haishan', '1977-03-18', '(986) 7290202', '2011-09-04', 'Huawei P20', 3, 'iOS 10.3.4');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (466, 'Filide', 'Woollaston', 'fwoollastoncx@eepurl.com', 'Poland', 'Balice', '1943-03-16', '(160) 7935225', '2010-05-16', 'iPhone 8s', 2, 'Android Jelly Bean');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (467, 'Otho', 'Tevlin', 'otevlincy@mtv.com', 'China', 'Taipingchuan', '1951-10-13', '(926) 6811067', '2019-01-04', 'Galaxy S10', 13, 'Android Lollipop');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (468, 'Donni', 'Ancketill', 'dancketillcz@auda.org.au', 'Indonesia', 'Salam', '1930-02-03', '(340) 2539337', '2016-03-13', 'iPhone 6', 2, 'iOS 13.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (469, 'Ruby', 'Coode', 'rcooded0@dropbox.com', 'Netherlands', 'Arnhem', '2019-08-07', '(858) 1863343', '2017-12-21', 'Galaxy S8', 8, 'Android 10');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (470, 'Marylin', 'Lawlee', 'mlawleed1@cpanel.net', 'Thailand', 'Nakhon Pathom', '2010-10-01', '(717) 9498138', '2018-09-19', 'iPhone X', 7, 'Android Pie');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (471, 'Ruby', 'Falconer-Taylor', 'rfalconertaylord2@360.cn', 'Indonesia', 'Banjar Kubu', '1946-03-15', '(209) 9039879', '2012-11-28', 'Galaxy S9', 1, 'Android 10');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (472, 'Dill', 'D''Arrigo', 'ddarrigod3@1688.com', 'China', 'Hai’an', '1933-08-09', '(699) 2279035', '2016-09-04', 'Galaxy S10', 14, 'Android Oreo');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (473, 'Eddie', 'Glidden', 'egliddend4@un.org', 'Indonesia', 'Awayan', '1990-09-06', '(129) 2529369', '2020-03-17', 'iPhone 8s', 2, 'Android Jelly Bean');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (474, 'Alvera', 'Doleman', 'adolemand5@biblegateway.com', 'Venezuela', 'Santa Bárbara', '1984-07-10', '(168) 9026418', '2011-06-25', 'Huawei P9 Pro', 4, 'iOS 13.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (475, 'Rozella', 'Gateley', 'rgateleyd6@studiopress.com', 'Albania', 'Armen', '1957-06-27', '(939) 3918924', '2012-08-06', 'Galaxy S10', 2, 'Android Pie');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (476, 'Zarla', 'Shevell', 'zshevelld7@cdbaby.com', 'China', 'Dapo', '1974-03-29', '(585) 7684681', '2011-01-20', 'Huawei Mate 20', 11, 'iOS 12.4.8');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (477, 'Eolanda', 'Lavielle', 'elavielled8@networksolutions.com', 'Ireland', 'Longwood', '1966-04-19', '(144) 4171220', '2015-07-25', 'iPhone XS', 4, 'iOS 9.3.5');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (478, 'Tades', 'Steffens', 'tsteffensd9@wsj.com', 'Mexico', 'Benito Juarez', '1931-03-19', '(689) 8585510', '2012-08-02', 'Galaxy S10', 1, 'iOS 12.4.8');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (479, 'Mavis', 'Kobera', 'mkoberada@geocities.com', 'Slovenia', 'Pesnica pri Mariboru', '1998-04-14', '(292) 2486347', '2014-06-23', 'Huawei Mate 10', 2, 'Android Jelly Bean');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (480, 'Neely', 'Biesinger', 'nbiesingerdb@pen.io', 'China', 'Huangshan', '1948-11-16', '(161) 6860555', '2013-08-19', 'iPhone 8s', 8, 'iOS 13.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (481, 'Raleigh', 'Rolls', 'rrollsdc@vistaprint.com', 'Nicaragua', 'Nuevo Amanecer', '2019-07-17', '(882) 2563196', '2015-07-09', 'iPhone 7', 6, 'iOS 12.4.8');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (482, 'Mary', 'Pischoff', 'mpischoffdd@nih.gov', 'Indonesia', 'Sudimoro', '1937-07-21', '(599) 3570838', '2017-01-11', 'Huawei P10', 11, 'iOS 13.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (483, 'Kipp', 'Stokes', 'kstokesde@hc360.com', 'China', 'Dongning', '2000-12-04', '(768) 4997785', '2016-12-29', 'iPhone 6', 2, 'Android Oreo');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (484, 'Orly', 'Brawley', 'obrawleydf@cam.ac.uk', 'Ukraine', 'Yasynuvata', '1990-11-14', '(794) 9342164', '2014-11-20', 'iPhone X', 10, 'iOS 9.3.5');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (485, 'Dorian', 'Bownde', 'dbowndedg@ameblo.jp', 'Japan', 'Ikoma', '2012-05-17', '(113) 9796630', '2018-06-30', 'Huawei P10', 7, 'Android 10');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (486, 'Nicolas', 'Mesias', 'nmesiasdh@sciencedaily.com', 'Sri Lanka', 'Kurunegala', '1987-06-07', '(123) 4180135', '2012-07-11', 'Huawei Mate 10', 14, 'iOS 10.3.3');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (487, 'Taryn', 'Harbar', 'tharbardi@go.com', 'Bosnia and Herzegovina', 'Barice', '1945-10-26', '(804) 6925629', '2019-05-10', 'iPhone X', 6, 'Android Marshmallow');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (488, 'Beverlie', 'Crannach', 'bcrannachdj@vimeo.com', 'Thailand', 'Na Yong', '1943-06-30', '(634) 9914334', '2016-11-22', 'Huawei P20', 10, 'Android Lollipop');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (489, 'Candy', 'Pallis', 'cpallisdk@businesswire.com', 'United States', 'Carson City', '2019-05-25', '(775) 5905498', '2019-02-26', 'iPhone 6s', 8, 'iOS 12.4.8');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (490, 'Drusilla', 'Tothacot', 'dtothacotdl@wufoo.com', 'Indonesia', 'Menanga', '1925-04-27', '(550) 7031860', '2015-05-03', 'iPhone 8s', 9, 'Android 10');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (491, 'Lazarus', 'Wayte', 'lwaytedm@aol.com', 'Russia', 'Shushary', '1957-05-31', '(541) 3218972', '2013-02-17', 'Huawei P9 Pro', 13, 'Android KitKat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (492, 'Claudianus', 'Eakeley', 'ceakeleydn@wordpress.org', 'Uzbekistan', 'Kogon', '1981-08-26', '(155) 1643580', '2018-02-10', 'Huawei Mate 10 Pro', 13, 'Android Marshmallow');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (493, 'Claudio', 'Pooke', 'cpookedo@usgs.gov', 'Zimbabwe', 'Headlands', '1921-02-25', '(663) 5049313', '2010-03-19', 'Huawei P30', 3, 'iOS 9.3.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (494, 'Fabian', 'Gettone', 'fgettonedp@blogger.com', 'Poland', 'Straszydle', '1970-06-17', '(200) 3514500', '2013-07-20', 'Huawei Mate 10 Pro', 12, 'Android KitKat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (495, 'Colene', 'Dericut', 'cdericutdq@theguardian.com', 'Japan', 'Fukuoka-shi', '1925-02-20', '(349) 3958262', '2013-04-01', 'Galaxy S10', 7, 'iOS 9.3.5');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (496, 'Robenia', 'Witcomb', 'rwitcombdr@cargocollective.com', 'China', 'Zhongcun', '1979-04-23', '(723) 2222524', '2017-12-01', 'Huawei P30 Pro', 8, 'Android Lollipop');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (497, 'Torrence', 'Dandy', 'tdandyds@hostgator.com', 'Indonesia', 'Rote', '2013-09-21', '(878) 7187850', '2014-10-30', 'Galaxy S9', 7, 'Android Oreo');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (498, 'Shani', 'Swetmore', 'sswetmoredt@google.com', 'China', 'Hezhai', '1934-09-15', '(839) 1540655', '2020-07-22', 'Huawei Mate 10 Pro', 8, 'Android Pie');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (499, 'Theodoric', 'Serginson', 'tserginsondu@washington.edu', 'Ukraine', 'Berezne', '1931-05-15', '(786) 1701641', '2019-06-05', 'iPhone 6', 5, 'Android Lollipop');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (500, 'Ferdinande', 'Tod', 'ftoddv@slate.com', 'Yemen', 'Yarīm', '1998-01-30', '(478) 7425099', '2017-11-15', 'iPhone 6s', 4, 'Android Lollipop');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (501, 'Lillian', 'Sudy', 'lsudydw@so-net.ne.jp', 'China', 'Yeping', '1967-03-05', '(477) 2475782', '2011-03-12', 'Galaxy S9', 12, 'Android KitKat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (502, 'Ellerey', 'Tourner', 'etournerdx@ehow.com', 'China', 'Changtan', '1998-09-05', '(117) 9563872', '2012-07-04', 'Huawei P10 Pro', 4, 'Android Oreo');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (503, 'Lenee', 'Louys', 'llouysdy@github.com', 'Russia', 'Dobryanka', '1991-07-27', '(179) 7558921', '2013-02-18', 'Huawei P30', 7, 'iOS 13.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (504, 'Lanni', 'Muzzullo', 'lmuzzullodz@amazon.de', 'Greece', 'Ampeleíes', '2003-01-27', '(355) 9162552', '2012-01-10', 'Huawei Mate 20 Pro', 1, 'iOS 10.3.3');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (505, 'Vick', 'Le Barr', 'vlebarre0@youtube.com', 'Colombia', 'El Tambo', '1983-07-05', '(224) 5087777', '2015-12-25', 'Huawei Mate 20', 9, 'Android Nougat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (506, 'Domeniga', 'Fewlass', 'dfewlasse1@aol.com', 'China', 'Gongchang Zhen', '2012-10-06', '(157) 6348644', '2012-04-15', 'Huawei Mate 10 Pro', 12, 'Android 10');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (507, 'Mair', 'Neligan', 'mneligane2@phoca.cz', 'France', 'Marne-la-Vallée', '1939-06-29', '(326) 8369211', '2010-07-29', 'iPhone 7', 4, 'iOS 10.3.4');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (508, 'Alexis', 'Kettlestringes', 'akettlestringese3@un.org', 'Indonesia', 'Gesik', '2015-08-29', '(114) 4139490', '2014-10-11', 'iPhone X', 2, 'iOS 13.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (509, 'Clarey', 'Bagehot', 'cbagehote4@stanford.edu', 'China', 'Huajialing', '2007-08-06', '(777) 4404615', '2016-06-28', 'Huawei P10', 10, 'iOS 9.3.5');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (510, 'Vanny', 'Garbutt', 'vgarbutte5@fotki.com', 'Venezuela', 'Pedraza La Vieja', '2004-04-23', '(411) 9498550', '2014-02-03', 'iPhone 8', 9, 'iOS 10.3.4');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (511, 'Emelda', 'Croose', 'ecroosee6@sphinn.com', 'Thailand', 'Phatthaya', '1946-06-11', '(144) 8146627', '2018-10-06', 'Huawei P10', 6, 'Android Oreo');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (512, 'Fredelia', 'Handford', 'fhandforde7@surveymonkey.com', 'China', 'Dongxi', '2017-12-15', '(731) 9378892', '2018-12-29', 'iPhone 7s', 1, 'Android Nougat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (513, 'Angeli', 'Daw', 'adawe8@omniture.com', 'China', 'Jiekeng', '1962-11-21', '(424) 7859615', '2020-05-23', 'Huawei Mate 20', 5, 'iOS 10.3.4');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (514, 'Kirk', 'Lindgren', 'klindgrene9@wisc.edu', 'Kazakhstan', 'Ordzhonikidze', '1994-11-09', '(471) 9470880', '2018-05-16', 'Huawei P20', 4, 'Android Lollipop');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (515, 'Bogart', 'Darcey', 'bdarceyea@nifty.com', 'Philippines', 'Lipahan', '1965-01-23', '(184) 2892486', '2013-10-15', 'iPhone X', 12, 'Android Pie');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (516, 'Lia', 'Roomes', 'lroomeseb@squidoo.com', 'Sudan', 'Nyala', '2009-10-05', '(483) 3479567', '2010-02-07', 'Huawei Mate 10', 10, 'Android Pie');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (517, 'Elonore', 'Baff', 'ebaffec@theglobeandmail.com', 'Sweden', 'Fagersta', '1948-08-03', '(990) 7338013', '2014-11-26', 'Huawei P10 Pro', 8, 'iOS 10.3.4');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (518, 'Winston', 'Ribchester', 'wribchestered@mozilla.com', 'Brazil', 'Xanxerê', '1929-11-14', '(799) 2146954', '2019-11-03', 'Huawei Mate 10', 4, 'Android Marshmallow');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (519, 'Sam', 'Sword', 'sswordee@yandex.ru', 'Sweden', 'Stockholm', '1946-01-14', '(311) 6408011', '2014-08-31', 'Huawei P10 Pro', 13, 'iOS 12.4.8');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (520, 'Dudley', 'Studdal', 'dstuddalef@cisco.com', 'China', 'Tianning', '1968-12-09', '(198) 6962842', '2019-02-11', 'Galaxy S10', 10, 'Android Nougat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (521, 'Coretta', 'St. Aubyn', 'cstaubyneg@theglobeandmail.com', 'Thailand', 'Tha Tako', '2012-08-14', '(318) 5750649', '2020-02-07', 'Huawei Mate 10', 3, 'Android Nougat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (522, 'Willie', 'Sand', 'wsandeh@wisc.edu', 'China', 'Zengjia', '1971-08-29', '(822) 9336608', '2013-02-15', 'iPhone 8', 14, 'iOS 13.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (523, 'Francene', 'Tarry', 'ftarryei@smugmug.com', 'Tunisia', 'Douane', '1928-11-02', '(994) 1430058', '2017-10-27', 'iPhone XS', 11, 'Android Oreo');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (524, 'Matty', 'Pollastro', 'mpollastroej@toplist.cz', 'Slovenia', 'Škofljica', '1932-12-24', '(390) 9062657', '2014-03-01', 'Huawei P20 Pro', 11, 'iOS 10.3.3');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (525, 'Elmore', 'Yakovl', 'eyakovlek@csmonitor.com', 'Yemen', 'Ḩajjah', '1975-08-15', '(668) 8024111', '2012-11-10', 'Huawei P10', 9, 'iOS 10.3.4');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (526, 'Bartlett', 'Albutt', 'balbuttel@sina.com.cn', 'Brazil', 'São Luiz Gonzaga', '1943-12-20', '(227) 9045487', '2011-09-06', 'iPhone 7', 10, 'Android Oreo');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (527, 'Henri', 'Throssell', 'hthrossellem@last.fm', 'China', 'Changshan', '1949-02-16', '(646) 6238232', '2014-08-31', 'iPhone XS', 10, 'Android Nougat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (528, 'Phylys', 'Dorre', 'pdorreen@gizmodo.com', 'Philippines', 'Talisayan', '1993-01-10', '(838) 9143921', '2018-05-15', 'iPhone 8s', 6, 'Android Marshmallow');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (529, 'Merell', 'Cragoe', 'mcragoeeo@com.com', 'France', 'Le Mans', '1933-07-04', '(282) 4765396', '2020-02-18', 'iPhone 6s', 8, 'Android Lollipop');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (530, 'Freddy', 'McGuigan', 'fmcguiganep@pen.io', 'Bosnia and Herzegovina', 'Careva Ćuprija', '1927-07-17', '(470) 5838798', '2011-08-28', 'iPhone 7s', 13, 'iOS 9.3.5');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (531, 'Giulietta', 'Camilleri', 'gcamillerieq@hhs.gov', 'Russia', 'Verkhniye Kigi', '1921-10-04', '(225) 1045167', '2010-03-18', 'iPhone XS', 11, 'Android Marshmallow');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (532, 'Tadd', 'Woollends', 'twoollendser@hostgator.com', 'Indonesia', 'Cihaurbeuti', '1943-01-20', '(407) 2140436', '2015-09-19', 'Huawei Mate 20 Pro', 12, 'Android Pie');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (533, 'Bearnard', 'Chellam', 'bchellames@topsy.com', 'China', 'Shengrenjian', '1955-11-18', '(888) 4734566', '2018-01-13', 'Huawei P10', 5, 'Android 10');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (534, 'Mallory', 'Di Giacomettino', 'mdigiacomettinoet@ehow.com', 'Indonesia', 'Rejoagung', '1982-11-30', '(303) 7590436', '2010-12-10', 'Huawei P9', 5, 'Android 10');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (535, 'Melinda', 'Degenhardt', 'mdegenhardteu@histats.com', 'Indonesia', 'Lebahseri', '2010-05-18', '(406) 3086615', '2016-04-17', 'Huawei Mate 10', 3, 'Android Jelly Bean');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (536, 'Cynthie', 'Valentine', 'cvalentineev@samsung.com', 'Japan', 'Chino', '1969-01-06', '(194) 8011886', '2010-12-27', 'Huawei P9', 8, 'Android Jelly Bean');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (537, 'Wildon', 'Barsham', 'wbarshamew@ucoz.ru', 'Ethiopia', 'Gambēla', '1976-08-03', '(372) 9668120', '2019-01-23', 'Huawei P10', 5, 'iOS 10.3.3');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (538, 'Janeva', 'Chatters', 'jchattersex@blogger.com', 'Laos', 'Lamam', '1978-08-26', '(412) 8845223', '2019-04-08', 'Galaxy S8', 3, 'Android Oreo');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (539, 'Phyllys', 'Strathdee', 'pstrathdeeey@diigo.com', 'Moldova', 'Cahul', '2016-12-11', '(156) 4013462', '2018-07-13', 'Huawei P20', 5, 'Android Marshmallow');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (540, 'Denver', 'Guppie', 'dguppieez@cafepress.com', 'Thailand', 'Lom Sak', '1984-11-04', '(215) 5397085', '2015-04-24', 'Huawei P20 Pro', 6, 'iOS 13.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (541, 'Theodora', 'Rouzet', 'trouzetf0@barnesandnoble.com', 'Brazil', 'Porangaba', '1993-08-22', '(938) 6875087', '2019-09-11', 'iPhone 6', 4, 'Android KitKat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (542, 'Morna', 'Dalmon', 'mdalmonf1@phpbb.com', 'Poland', 'Garwolin', '1965-10-26', '(176) 1275682', '2014-04-29', 'Huawei P30 Pro', 2, 'Android Pie');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (543, 'Aubine', 'Kisting', 'akistingf2@de.vu', 'China', 'Chujiang', '1991-01-18', '(616) 7429238', '2010-01-05', 'Huawei P30', 4, 'iOS 9.3.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (544, 'Blaine', 'Munro', 'bmunrof3@discovery.com', 'China', 'Pukou', '2009-04-18', '(265) 3445584', '2014-07-14', 'Huawei P10 Pro', 14, 'iOS 12.4.8');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (545, 'Analise', 'Kleisle', 'akleislef4@vistaprint.com', 'Philippines', 'Dao', '1958-10-04', '(977) 1223205', '2019-06-02', 'Huawei P20', 10, 'Android Jelly Bean');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (546, 'Borg', 'McGrae', 'bmcgraef5@last.fm', 'China', 'Zhenqiao', '1925-06-11', '(831) 5098790', '2016-05-04', 'Galaxy S9', 4, 'iOS 12.4.8');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (547, 'Constanta', 'Dunkerton', 'cdunkertonf6@chron.com', 'China', 'Chengnan', '1955-09-19', '(734) 7954750', '2017-11-18', 'Huawei P20 Pro', 6, 'iOS 10.3.3');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (548, 'Charmian', 'Scougall', 'cscougallf7@yahoo.com', 'Brazil', 'Canoinhas', '1948-08-26', '(830) 9148524', '2018-05-12', 'Galaxy S10', 9, 'Android KitKat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (549, 'Talbert', 'MacGillacolm', 'tmacgillacolmf8@smugmug.com', 'Sweden', 'Uppsala', '2005-09-16', '(602) 6744789', '2018-05-16', 'iPhone X', 9, 'Android Pie');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (550, 'Aili', 'McCaw', 'amccawf9@umich.edu', 'Sri Lanka', 'Kilinochchi', '1968-07-15', '(447) 9199980', '2016-08-24', 'Huawei P10 Pro', 7, 'iOS 10.3.3');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (551, 'Elysia', 'Upstell', 'eupstellfa@123-reg.co.uk', 'Philippines', 'Bamban', '1990-03-30', '(851) 2609036', '2016-02-29', 'Huawei Mate 20 Pro', 6, 'Android Jelly Bean');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (552, 'Hewie', 'O''Connell', 'hoconnellfb@ocn.ne.jp', 'Indonesia', 'Babakan', '1922-07-01', '(454) 9462416', '2017-01-04', 'Huawei P20', 8, 'iOS 10.3.3');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (553, 'Arnold', 'Sutor', 'asutorfc@earthlink.net', 'China', 'Tongmuluo', '1953-05-05', '(623) 3492025', '2018-09-17', 'Huawei P9 Pro', 1, 'iOS 13.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (554, 'Tony', 'Brabyn', 'tbrabynfd@gmpg.org', 'Indonesia', 'Lokatadho', '1953-10-27', '(141) 3575024', '2011-05-07', 'Huawei P20 Pro', 4, 'iOS 10.3.4');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (555, 'Averyl', 'Kinch', 'akinchfe@google.cn', 'Philippines', 'Looc', '1996-05-21', '(200) 8336349', '2016-08-24', 'iPhone 6', 3, 'Android Oreo');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (556, 'Deina', 'Gostyke', 'dgostykeff@arizona.edu', 'China', 'Zhujiatai', '1996-07-22', '(201) 8877278', '2013-08-07', 'iPhone XS', 14, 'iOS 10.3.4');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (557, 'Lilllie', 'Micheli', 'lmichelifg@harvard.edu', 'Belarus', 'Iwye', '1966-03-06', '(334) 7333884', '2017-07-01', 'iPhone 6', 8, 'Android Nougat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (558, 'Marigold', 'Hattiff', 'mhattifffh@census.gov', 'Indonesia', 'Pancoran', '1981-12-17', '(242) 6792129', '2018-11-18', 'iPhone X', 8, 'Android Marshmallow');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (559, 'Lenard', 'Grigoliis', 'lgrigoliisfi@devhub.com', 'Brazil', 'Cupira', '1983-09-22', '(490) 2142673', '2019-09-11', 'iPhone 8', 2, 'iOS 9.3.5');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (560, 'Rodrique', 'Seymour', 'rseymourfj@ebay.com', 'Argentina', 'Corzuela', '1934-07-16', '(655) 6779886', '2010-08-20', 'iPhone X', 3, 'iOS 9.3.5');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (561, 'Fernanda', 'Rafe', 'frafefk@mac.com', 'United States', 'Washington', '1936-04-04', '(202) 6244137', '2012-03-25', 'Galaxy S9', 7, 'iOS 13.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (562, 'Valli', 'Beetham', 'vbeethamfl@parallels.com', 'Philippines', 'Malicboy', '1962-11-27', '(521) 4150103', '2012-08-02', 'Huawei P30 Pro', 4, 'Android Lollipop');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (563, 'Windham', 'Yeskin', 'wyeskinfm@marketwatch.com', 'Thailand', 'Samut Prakan', '1927-01-01', '(962) 6856095', '2020-06-21', 'iPhone 8', 12, 'Android 10');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (564, 'Sarah', 'Mumbray', 'smumbrayfn@imgur.com', 'Morocco', 'Skoura', '2001-06-25', '(339) 2645615', '2014-12-10', 'Huawei P10', 2, 'Android KitKat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (565, 'Alida', 'Allmen', 'aallmenfo@cmu.edu', 'Vietnam', 'Khe Tre', '1998-05-13', '(952) 9785259', '2016-05-08', 'Huawei P9 Pro', 10, 'iOS 12.4.8');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (566, 'Margaretha', 'Duxbury', 'mduxburyfp@lulu.com', 'China', 'Heshang', '1959-11-13', '(776) 2135041', '2018-06-24', 'Huawei P10 Pro', 14, 'Android KitKat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (567, 'Vincenz', 'Ellingham', 'vellinghamfq@symantec.com', 'United States', 'Fairbanks', '1952-06-19', '(907) 7686076', '2015-02-02', 'Huawei P10', 13, 'Android Jelly Bean');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (568, 'Horton', 'Le Prevost', 'hleprevostfr@g.co', 'South Africa', 'Port Saint John’s', '1962-11-03', '(626) 3581036', '2011-06-07', 'Galaxy S9', 11, 'Android 10');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (569, 'Bran', 'Wasmer', 'bwasmerfs@ed.gov', 'China', 'Shangzhang', '1928-02-20', '(543) 1708340', '2020-03-28', 'Galaxy S8', 10, 'Android Lollipop');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (570, 'Kakalina', 'Bracknall', 'kbracknallft@washington.edu', 'France', 'Corbeil-Essonnes', '1956-05-06', '(548) 3566762', '2011-01-27', 'Huawei P10 Pro', 3, 'iOS 9.3.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (571, 'Gibb', 'Lewing', 'glewingfu@washingtonpost.com', 'Greece', 'Vamvakoú', '1941-08-11', '(395) 7754548', '2011-07-19', 'Huawei P9', 4, 'iOS 9.3.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (572, 'Fawnia', 'Wanley', 'fwanleyfv@sourceforge.net', 'Azerbaijan', 'Sumqayıt', '2015-10-24', '(126) 3114089', '2018-02-15', 'Huawei P30', 2, 'Android KitKat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (573, 'York', 'Byrd', 'ybyrdfw@hhs.gov', 'Portugal', 'Sines', '2017-02-11', '(355) 7191985', '2010-09-30', 'Huawei Mate 20 Pro', 9, 'iOS 13.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (574, 'Hillel', 'McLaughlin', 'hmclaughlinfx@canalblog.com', 'Russia', 'Khasavyurt', '1937-01-31', '(494) 2812249', '2019-02-22', 'iPhone 8s', 6, 'Android 10');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (575, 'Roxi', 'Braybrookes', 'rbraybrookesfy@chicagotribune.com', 'Tunisia', 'Akouda', '1929-11-28', '(484) 2962873', '2019-05-24', 'Huawei Mate 10 Pro', 11, 'iOS 12.4.8');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (576, 'Noby', 'Newrick', 'nnewrickfz@sakura.ne.jp', 'China', 'Jianrao', '1978-01-01', '(271) 5697704', '2012-02-21', 'Galaxy S8', 4, 'iOS 9.3.5');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (577, 'Audre', 'Pappi', 'apappig0@printfriendly.com', 'France', 'Brest', '1987-07-25', '(747) 1591376', '2012-03-12', 'Huawei P20 Pro', 3, 'iOS 13.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (578, 'Zachery', 'Coltman', 'zcoltmang1@europa.eu', 'Peru', 'Progreso', '1992-10-12', '(604) 1879635', '2016-02-26', 'Huawei Mate 20', 13, 'Android Jelly Bean');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (579, 'Ella', 'Feander', 'efeanderg2@friendfeed.com', 'Canada', 'Lambton Shores', '1927-03-31', '(227) 1694555', '2014-06-12', 'Galaxy S9', 9, 'iOS 13.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (580, 'Benny', 'Secretan', 'bsecretang3@multiply.com', 'Serbia', 'Bor', '1923-04-16', '(714) 7130923', '2020-02-28', 'Galaxy S8', 13, 'iOS 13.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (581, 'Morgan', 'Lethabridge', 'mlethabridgeg4@google.com.br', 'China', 'Gushui', '2004-08-29', '(887) 4112953', '2015-06-29', 'Huawei P10 Pro', 14, 'iOS 10.3.4');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (582, 'Patty', 'Spirritt', 'pspirrittg5@dot.gov', 'Indonesia', 'Sukoanyar', '1975-10-09', '(850) 6569333', '2019-10-26', 'Huawei P20 Pro', 13, 'Android Lollipop');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (583, 'Terza', 'Duddell', 'tduddellg6@go.com', 'Greece', 'Athens', '1988-12-06', '(728) 5155888', '2014-02-05', 'Galaxy S10', 14, 'Android KitKat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (584, 'Felizio', 'Yokley', 'fyokleyg7@jimdo.com', 'Poland', 'Żarnów', '1938-07-04', '(290) 5344514', '2011-01-19', 'Huawei Mate 10 Pro', 3, 'iOS 9.3.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (585, 'Prudy', 'Gilford', 'pgilfordg8@cdc.gov', 'Albania', 'Patos Fshat', '1923-06-03', '(574) 7379266', '2015-04-30', 'Huawei P10', 14, 'iOS 9.3.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (586, 'Mervin', 'Tweedie', 'mtweedieg9@engadget.com', 'Serbia', 'Neuzina', '2017-11-13', '(505) 8955128', '2020-04-16', 'iPhone X', 4, 'Android 10');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (587, 'Graham', 'Sydry', 'gsydryga@cmu.edu', 'Philippines', 'Taytayan', '1995-02-01', '(588) 8248419', '2015-06-06', 'Huawei P9 Pro', 12, 'Android 10');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (588, 'Pate', 'Bachnic', 'pbachnicgb@google.it', 'Azerbaijan', 'Qaxbaş', '1965-02-06', '(121) 1302310', '2018-10-15', 'Huawei P9 Pro', 1, 'iOS 9.3.5');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (589, 'Brendon', 'Beine', 'bbeinegc@eepurl.com', 'Sweden', 'Tumba', '1969-10-28', '(660) 6983095', '2019-10-28', 'Huawei Mate 20', 10, 'iOS 12.4.8');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (590, 'Dulcinea', 'McFarlan', 'dmcfarlangd@alexa.com', 'Yemen', 'Sa''dah', '1989-05-06', '(998) 8617313', '2019-11-04', 'Huawei P10', 4, 'Android Jelly Bean');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (591, 'Marylee', 'Theze', 'mthezege@sciencedaily.com', 'Tajikistan', 'Norak', '1927-09-30', '(182) 6757240', '2014-05-21', 'Huawei P30', 13, 'Android Oreo');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (592, 'Dena', 'Lant', 'dlantgf@nhs.uk', 'China', 'Rongwo', '1990-08-22', '(462) 4723639', '2012-09-21', 'Huawei P9 Pro', 12, 'iOS 9.3.5');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (593, 'Emalia', 'De Hooch', 'edehoochgg@craigslist.org', 'Philippines', 'Bayanan', '2005-10-03', '(683) 3613529', '2012-07-27', 'Huawei P9 Pro', 4, 'Android KitKat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (594, 'Mae', 'Whitcher', 'mwhitchergh@dailymotion.com', 'Iraq', 'Erbil', '1972-08-25', '(519) 4047111', '2016-08-19', 'Galaxy S10', 13, 'iOS 9.3.5');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (595, 'Chicky', 'Reichelt', 'creicheltgi@weibo.com', 'Egypt', 'Ḩalwān', '2014-06-12', '(897) 1970092', '2013-09-13', 'iPhone XS', 4, 'Android Lollipop');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (596, 'Shaylyn', 'Cashman', 'scashmangj@last.fm', 'Indonesia', 'Kiukasen', '1941-03-24', '(492) 6513972', '2010-05-25', 'iPhone XS', 7, 'iOS 13.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (597, 'Hendrika', 'Leifer', 'hleifergk@xing.com', 'Bangladesh', 'Kushtia', '2015-06-05', '(223) 3755814', '2011-08-04', 'Huawei P10 Pro', 12, 'Android KitKat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (598, 'Elbert', 'Gelletly', 'egelletlygl@t.co', 'Indonesia', 'Kotes', '1949-11-19', '(513) 6677304', '2018-07-19', 'iPhone 8s', 14, 'Android Lollipop');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (599, 'Gisella', 'McCumskay', 'gmccumskaygm@rediff.com', 'China', 'Guankou', '2002-11-06', '(853) 5650134', '2020-01-07', 'Huawei Mate 20', 1, 'iOS 13.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (600, 'Laurie', 'Brownbridge', 'lbrownbridgegn@clickbank.net', 'Poland', 'Limanowa', '1924-08-09', '(286) 4843454', '2017-10-16', 'Huawei P10 Pro', 1, 'Android Marshmallow');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (601, 'Urbain', 'Llorente', 'ullorentego@forbes.com', 'Panama', 'Ustupo', '1952-12-12', '(974) 4669631', '2013-02-26', 'Huawei Mate 10', 1, 'Android KitKat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (602, 'Bobine', 'Dunphy', 'bdunphygp@uiuc.edu', 'United States', 'El Paso', '1943-04-27', '(915) 4566839', '2019-02-13', 'iPhone 8s', 4, 'iOS 9.3.5');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (603, 'Krisha', 'Pearse', 'kpearsegq@blinklist.com', 'United Kingdom', 'Newbiggin', '1987-07-12', '(988) 1708797', '2010-06-27', 'Galaxy S10', 6, 'Android Pie');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (604, 'Martie', 'Fingleton', 'mfingletongr@51.la', 'Ivory Coast', 'Danané', '1941-01-24', '(429) 1623280', '2014-12-30', 'Huawei P20 Pro', 3, 'iOS 12.4.8');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (605, 'Gae', 'Onians', 'goniansgs@sbwire.com', 'Israel', 'Mitzpe Ramon', '1971-03-24', '(512) 9479927', '2016-07-08', 'Huawei P9 Pro', 3, 'iOS 10.3.3');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (606, 'Johnette', 'Gutteridge', 'jgutteridgegt@exblog.jp', 'Russia', 'Mirskoy', '2001-02-07', '(374) 9533323', '2015-11-06', 'Huawei Mate 10 Pro', 10, 'iOS 12.4.8');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (607, 'Carilyn', 'Goodier', 'cgoodiergu@prweb.com', 'Malaysia', 'Pulau Pinang', '1996-11-08', '(408) 7668291', '2013-12-17', 'Galaxy S9', 14, 'iOS 13.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (608, 'Wendy', 'Gibbieson', 'wgibbiesongv@prlog.org', 'Thailand', 'At Samat', '1920-01-14', '(904) 2128578', '2010-10-26', 'Huawei Mate 20', 7, 'Android KitKat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (609, 'Brandea', 'Mingo', 'bmingogw@google.fr', 'Russia', 'Ten’gushevo', '1974-10-08', '(980) 9207922', '2018-09-24', 'iPhone 7', 11, 'Android Pie');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (610, 'Emyle', 'Jakolevitch', 'ejakolevitchgx@moonfruit.com', 'Brazil', 'Brodósqui', '1967-09-26', '(153) 8793907', '2013-01-14', 'iPhone XS', 11, 'iOS 10.3.4');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (611, 'Audrey', 'Dullingham', 'adullinghamgy@about.com', 'Portugal', 'Alcaria', '2017-04-18', '(561) 2874856', '2019-08-06', 'iPhone 8', 6, 'Android 10');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (612, 'Freeland', 'Goly', 'fgolygz@auda.org.au', 'Brazil', 'Astorga', '1942-02-24', '(428) 7562979', '2019-03-21', 'Huawei P30', 13, 'iOS 9.3.5');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (613, 'Coralie', 'July', 'cjulyh0@paypal.com', 'Portugal', 'Azurva', '2010-10-11', '(605) 8847783', '2011-04-19', 'iPhone 6', 6, 'iOS 9.3.5');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (614, 'Binny', 'Kelleway', 'bkellewayh1@bing.com', 'Poland', 'Wola Uhruska', '2010-06-05', '(633) 7931408', '2011-12-26', 'Huawei P20 Pro', 7, 'Android Lollipop');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (615, 'Nathalie', 'Janew', 'njanewh2@craigslist.org', 'Zambia', 'Mkushi', '1961-04-20', '(631) 7049348', '2020-02-12', 'Huawei P30 Pro', 13, 'Android Pie');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (616, 'Julie', 'Schroeder', 'jschroederh3@yahoo.co.jp', 'China', 'Shuiyang', '1963-04-27', '(351) 7013868', '2012-01-18', 'Huawei P20 Pro', 14, 'iOS 9.3.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (617, 'Khalil', 'Grise', 'kgriseh4@360.cn', 'Indonesia', 'Tanggulangin', '1967-03-19', '(777) 9371940', '2010-09-21', 'Huawei P30', 9, 'iOS 10.3.4');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (618, 'Johnath', 'Johann', 'jjohannh5@dailymail.co.uk', 'Botswana', 'Kopong', '1991-09-15', '(616) 9679734', '2016-04-10', 'Huawei P9', 13, 'Android Nougat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (619, 'Stevy', 'McCuffie', 'smccuffieh6@patch.com', 'United States', 'Durham', '2019-01-21', '(919) 2553241', '2018-07-25', 'Huawei P10 Pro', 9, 'Android Marshmallow');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (620, 'Felipe', 'Hamerton', 'fhamertonh7@narod.ru', 'Vietnam', 'Thị Trấn Việt Lâm', '1960-01-30', '(452) 1144168', '2018-12-29', 'Huawei Mate 10 Pro', 8, 'Android Lollipop');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (621, 'Kelcy', 'Wondraschek', 'kwondraschekh8@weebly.com', 'Russia', 'Presnenskiy', '1963-03-25', '(240) 4897884', '2020-07-04', 'Huawei P20 Pro', 3, 'Android 10');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (622, 'Mackenzie', 'Labin', 'mlabinh9@tinypic.com', 'Indonesia', 'Waigete', '2018-01-07', '(811) 7916680', '2017-08-26', 'Huawei P20 Pro', 13, 'iOS 10.3.4');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (623, 'Frasier', 'Tethacot', 'ftethacotha@infoseek.co.jp', 'Philippines', 'Patao', '2008-03-30', '(663) 7484219', '2020-01-17', 'Galaxy S9', 13, 'iOS 9.3.5');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (624, 'Edie', 'Badam', 'ebadamhb@123-reg.co.uk', 'China', 'Qingyuan', '1998-06-25', '(770) 7829800', '2019-06-12', 'iPhone 8s', 9, 'iOS 10.3.3');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (625, 'Allard', 'Gueinn', 'agueinnhc@live.com', 'Peru', 'Angasmarca', '2016-08-30', '(619) 9408522', '2016-08-16', 'iPhone 8s', 6, 'iOS 9.3.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (626, 'Benny', 'Giorgietto', 'bgiorgiettohd@statcounter.com', 'Mongolia', 'Tsenher', '2014-12-27', '(417) 5639277', '2012-04-12', 'Huawei Mate 20 Pro', 14, 'iOS 10.3.4');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (627, 'Milty', 'Elcock', 'melcockhe@mayoclinic.com', 'Portugal', 'Trafaria', '2003-09-14', '(212) 7864118', '2015-12-06', 'Huawei P30', 14, 'Android Oreo');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (628, 'Kale', 'Ethridge', 'kethridgehf@guardian.co.uk', 'Philippines', 'Tipaz', '1980-11-05', '(287) 5179364', '2017-09-05', 'iPhone 6', 11, 'Android Lollipop');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (629, 'Garrard', 'Olivet', 'golivethg@nationalgeographic.com', 'China', 'Shishan', '1939-08-16', '(755) 9605019', '2016-05-12', 'Galaxy S9', 4, 'Android Pie');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (630, 'Deloria', 'Haldane', 'dhaldanehh@oracle.com', 'Philippines', 'Causwagan', '1920-07-07', '(355) 2272663', '2016-05-23', 'iPhone 8', 9, 'Android Nougat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (631, 'Marvin', 'Crippell', 'mcrippellhi@wsj.com', 'Macedonia', 'Gradec', '1956-08-09', '(586) 2413219', '2015-09-08', 'Huawei P20', 1, 'iOS 9.3.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (632, 'Garvin', 'Decent', 'gdecenthj@imdb.com', 'Botswana', 'Kang', '1989-11-08', '(284) 7017754', '2016-07-23', 'Galaxy S8', 10, 'Android 10');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (633, 'Ollie', 'Gambie', 'ogambiehk@java.com', 'Russia', 'Spassk-Dal’niy', '1935-06-17', '(791) 9271067', '2019-01-22', 'Huawei P30', 4, 'iOS 9.3.5');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (634, 'Martguerita', 'Faulks', 'mfaulkshl@icq.com', 'China', 'Chengguan', '1923-08-29', '(819) 8158335', '2011-11-16', 'Huawei Mate 10 Pro', 14, 'Android Oreo');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (635, 'Blancha', 'Swalteridge', 'bswalteridgehm@naver.com', 'Russia', 'Stulovo', '1985-09-13', '(173) 8499001', '2017-03-18', 'Huawei P10 Pro', 4, 'Android Pie');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (636, 'Clifford', 'Files', 'cfileshn@linkedin.com', 'Venezuela', 'Maturín', '1972-03-12', '(814) 5439276', '2012-02-28', 'Huawei P9 Pro', 10, 'iOS 13.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (637, 'Tabb', 'Jephcott', 'tjephcottho@google.fr', 'Philippines', 'Cavinti', '1928-11-22', '(826) 1467450', '2016-07-25', 'Huawei P20', 14, 'Android Oreo');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (638, 'Bryn', 'Milstead', 'bmilsteadhp@github.com', 'Colombia', 'Puerto Colombia', '1996-04-05', '(388) 8383167', '2020-01-12', 'Huawei Mate 10 Pro', 13, 'Android Nougat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (639, 'Madelle', 'Jiroutka', 'mjiroutkahq@npr.org', 'Anguilla', 'The Valley', '1928-10-22', '(273) 1456773', '2016-12-27', 'Huawei P20', 8, 'iOS 9.3.5');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (640, 'Warren', 'Euston', 'weustonhr@gizmodo.com', 'Netherlands', 'Zwolle', '2010-08-26', '(303) 1769530', '2010-03-17', 'iPhone 6', 7, 'Android KitKat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (641, 'Conrade', 'Aleksich', 'caleksichhs@arstechnica.com', 'Sweden', 'Skellefteå', '1965-02-13', '(655) 2633002', '2012-07-29', 'Huawei Mate 10', 10, 'Android Pie');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (642, 'Sonia', 'Sapson', 'ssapsonht@rakuten.co.jp', 'Poland', 'Czernice Borowe', '1977-04-29', '(260) 4495424', '2018-06-25', 'Huawei P9 Pro', 6, 'Android Marshmallow');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (643, 'Beret', 'Pirnie', 'bpirniehu@icio.us', 'Russia', 'Uva', '1933-09-28', '(941) 3385858', '2016-07-19', 'Huawei Mate 20 Pro', 10, 'iOS 9.3.5');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (644, 'Ailbert', 'Nowak', 'anowakhv@constantcontact.com', 'France', 'Nemours', '1935-07-04', '(477) 5651094', '2011-12-08', 'iPhone 6s', 11, 'Android Marshmallow');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (645, 'Orville', 'A''field', 'oafieldhw@gravatar.com', 'Germany', 'Dresden', '1923-12-16', '(613) 6327829', '2015-04-21', 'iPhone 6s', 5, 'Android Marshmallow');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (646, 'Ayn', 'Carlens', 'acarlenshx@freewebs.com', 'Thailand', 'Sop Pong', '2006-02-27', '(317) 3462175', '2019-07-06', 'iPhone XS', 1, 'Android Jelly Bean');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (647, 'Magdaia', 'Meneux', 'mmeneuxhy@yandex.ru', 'Philippines', 'Bato', '2009-04-30', '(521) 8184176', '2012-06-18', 'Galaxy S9', 8, 'Android Oreo');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (648, 'Anne-corinne', 'Crowche', 'acrowchehz@free.fr', 'Vietnam', 'Cao Thượng', '1946-09-07', '(104) 7790143', '2012-04-05', 'Huawei P30', 2, 'Android Nougat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (649, 'Brenna', 'Rieme', 'briemei0@bbc.co.uk', 'China', 'Micheng', '2009-09-11', '(646) 3896283', '2017-04-09', 'iPhone 7s', 3, 'Android Oreo');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (650, 'Nowell', 'Abramowitch', 'nabramowitchi1@wsj.com', 'Finland', 'Suodenniemi', '2010-08-28', '(307) 3712639', '2017-04-05', 'iPhone X', 2, 'Android Pie');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (651, 'Nathalia', 'Stollenbeck', 'nstollenbecki2@mlb.com', 'China', 'Shixiang', '1962-05-09', '(290) 8994047', '2011-07-20', 'Huawei P10', 12, 'iOS 13.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (652, 'Ora', 'Born', 'oborni3@youtu.be', 'Slovakia', 'Bratislava', '2017-07-30', '(942) 4614840', '2018-12-16', 'iPhone 8s', 8, 'iOS 9.3.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (653, 'Faythe', 'Hrinishin', 'fhrinishini4@digg.com', 'Ukraine', 'Zaliznychne', '1942-01-21', '(829) 4460177', '2010-09-11', 'Huawei Mate 10', 2, 'Android Lollipop');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (654, 'Donny', 'Cartlidge', 'dcartlidgei5@slate.com', 'Russia', 'Bobrovka', '1926-11-01', '(203) 7928772', '2011-11-16', 'Huawei P20', 12, 'iOS 9.3.5');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (655, 'Nerty', 'Van der Linde', 'nvanderlindei6@wsj.com', 'China', 'Yantak', '1930-01-26', '(830) 6350760', '2018-03-03', 'Huawei Mate 10 Pro', 1, 'Android Jelly Bean');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (656, 'Goldia', 'Taks', 'gtaksi7@hhs.gov', 'Russia', 'Lianozovo', '2017-02-01', '(562) 8056453', '2020-03-29', 'Huawei Mate 20', 4, 'iOS 13.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (657, 'Merrill', 'Mibourne', 'mmibournei8@domainmarket.com', 'China', 'Huaizhong', '2003-05-01', '(852) 6085387', '2016-06-17', 'Huawei P10', 5, 'iOS 13.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (658, 'Maggy', 'McParlin', 'mmcparlini9@bravesites.com', 'Laos', 'Muang Sing', '1956-03-25', '(457) 9275113', '2010-10-21', 'Huawei P10', 3, 'Android Marshmallow');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (659, 'Dareen', 'Mustard', 'dmustardia@msu.edu', 'Russia', 'Sviblovo', '1965-11-14', '(839) 6179418', '2017-01-19', 'iPhone 7s', 5, 'iOS 13.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (660, 'Mathilda', 'Mityukov', 'mmityukovib@indiatimes.com', 'Brazil', 'Ipojuca', '1930-02-27', '(380) 5734116', '2017-06-26', 'Galaxy S8', 2, 'iOS 12.4.8');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (661, 'Carleen', 'Poulsen', 'cpoulsenic@unblog.fr', 'China', 'Fenglin', '1984-07-30', '(413) 9041363', '2010-03-03', 'iPhone 6', 7, 'iOS 9.3.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (662, 'Ingaborg', 'Masey', 'imaseyid@nih.gov', 'Honduras', 'San Marcos', '1964-03-08', '(503) 5012245', '2019-02-07', 'Huawei P20', 3, 'Android Oreo');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (663, 'Missie', 'Foden', 'mfodenie@weibo.com', 'Indonesia', 'Tembongraja', '1929-04-05', '(137) 9466110', '2010-03-13', 'Huawei Mate 20 Pro', 4, 'Android Nougat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (664, 'Merl', 'Kilmurry', 'mkilmurryif@webs.com', 'Russia', 'Partizan', '1986-07-08', '(816) 5090142', '2013-03-29', 'Huawei Mate 20 Pro', 3, 'iOS 12.4.8');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (665, 'Lorenza', 'Furst', 'lfurstig@theglobeandmail.com', 'Portugal', 'Parada de Todeia', '1989-11-01', '(268) 4259379', '2020-06-21', 'Huawei P20', 2, 'Android Jelly Bean');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (666, 'Car', 'Durtnall', 'cdurtnallih@macromedia.com', 'Maldives', 'Muli', '1990-07-27', '(894) 7949026', '2014-05-21', 'Huawei P9 Pro', 5, 'Android Jelly Bean');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (667, 'Keene', 'Audrey', 'kaudreyii@yelp.com', 'Georgia', 'Dioknisi', '1922-10-13', '(457) 6838561', '2013-05-01', 'Galaxy S10', 7, 'Android Jelly Bean');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (668, 'Norma', 'Winsper', 'nwinsperij@chronoengine.com', 'China', 'Maishi', '1956-12-27', '(572) 6876730', '2016-07-05', 'iPhone XS', 11, 'iOS 9.3.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (669, 'Fleming', 'Rusk', 'fruskik@harvard.edu', 'China', 'Hulan', '1942-07-18', '(888) 4943606', '2016-02-04', 'iPhone 7s', 13, 'iOS 12.4.8');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (670, 'Liz', 'Tilliard', 'ltilliardil@addtoany.com', 'Norway', 'Oslo', '1953-10-06', '(500) 2439399', '2011-03-20', 'Huawei P9 Pro', 12, 'iOS 9.3.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (671, 'Tristan', 'Totterdill', 'ttotterdillim@shinystat.com', 'United States', 'Springfield', '1997-11-22', '(413) 4431514', '2019-12-30', 'Huawei P30', 6, 'iOS 9.3.5');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (672, 'Yulma', 'Warbey', 'ywarbeyin@webmd.com', 'Thailand', 'Prakhon Chai', '1968-08-03', '(364) 1315675', '2015-11-03', 'iPhone XS', 2, 'iOS 10.3.4');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (673, 'Lyndel', 'Buffy', 'lbuffyio@cnet.com', 'Yemen', 'Al Tuḩaytā’', '1951-02-04', '(836) 4834932', '2014-07-16', 'iPhone 8', 13, 'iOS 13.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (674, 'Dallon', 'Burkitt', 'dburkittip@foxnews.com', 'Hungary', 'Érd', '1940-01-01', '(920) 7793835', '2012-03-08', 'Huawei P30 Pro', 10, 'Android Marshmallow');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (675, 'Berti', 'Hutley', 'bhutleyiq@adobe.com', 'North Korea', 'Najin', '1979-05-16', '(726) 4654953', '2015-10-22', 'Galaxy S10', 7, 'iOS 10.3.4');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (676, 'Diandra', 'Zimmerman', 'dzimmermanir@shutterfly.com', 'Portugal', 'Bobadela', '1926-03-31', '(654) 8822917', '2017-03-05', 'Huawei P10 Pro', 14, 'Android 10');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (677, 'Witty', 'Semark', 'wsemarkis@com.com', 'Greece', 'Vília', '1982-07-18', '(538) 8143186', '2012-06-29', 'iPhone X', 8, 'Android Nougat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (678, 'Alfredo', 'Alejandri', 'aalejandriit@blinklist.com', 'China', 'Xijiao', '1979-12-21', '(118) 9083645', '2017-10-12', 'Huawei P10 Pro', 4, 'Android Marshmallow');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (679, 'Keary', 'Jeskins', 'kjeskinsiu@wikispaces.com', 'France', 'La Plaine-Saint-Denis', '2010-08-12', '(774) 4174986', '2017-08-25', 'iPhone 6', 3, 'iOS 9.3.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (680, 'Maiga', 'Hesse', 'mhesseiv@dailymotion.com', 'Ghana', 'Ho', '1959-12-29', '(182) 6883762', '2010-09-22', 'Huawei Mate 10 Pro', 4, 'Android Marshmallow');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (681, 'Mirelle', 'Eingerfield', 'meingerfieldiw@weibo.com', 'Japan', 'Chatan', '1952-01-05', '(908) 9951438', '2019-06-17', 'iPhone 6s', 5, 'iOS 12.4.8');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (682, 'Floyd', 'Feldhorn', 'ffeldhornix@ca.gov', 'China', 'Xinji', '1937-10-26', '(499) 2044190', '2015-04-24', 'Huawei P30', 2, 'iOS 12.4.8');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (683, 'Hatty', 'Loughead', 'hlougheadiy@wufoo.com', 'Netherlands', 'Emmen', '1956-03-02', '(210) 3631224', '2020-06-07', 'iPhone 7', 12, 'iOS 10.3.4');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (684, 'Vita', 'Pattesall', 'vpattesalliz@opera.com', 'China', 'Chengmagang', '2003-08-01', '(758) 8910632', '2019-10-25', 'iPhone X', 6, 'Android Oreo');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (685, 'Rebekah', 'Schimann', 'rschimannj0@amazonaws.com', 'Sweden', 'Edsbyn', '1973-08-22', '(226) 4747002', '2012-04-22', 'Huawei Mate 20 Pro', 8, 'Android 10');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (686, 'Kerstin', 'Shwenn', 'kshwennj1@prweb.com', 'Morocco', 'Sidi Yahia el Gharb', '2014-01-18', '(878) 9207986', '2013-08-01', 'iPhone 8s', 13, 'iOS 12.4.8');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (687, 'Alyosha', 'Giraldez', 'agiraldezj2@lycos.com', 'China', 'Qingshanhu', '1939-08-02', '(865) 9256284', '2014-03-16', 'Huawei Mate 10 Pro', 9, 'Android Lollipop');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (688, 'Olly', 'Ellsworthe', 'oellsworthej3@gov.uk', 'China', 'Guandukou', '1958-12-17', '(497) 5713802', '2016-09-11', 'Huawei P20', 2, 'iOS 13.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (689, 'Ophelie', 'O''Shea', 'oosheaj4@sfgate.com', 'Moldova', 'Rîbniţa', '2007-03-15', '(371) 6727174', '2011-02-02', 'Galaxy S10', 7, 'Android Lollipop');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (690, 'Concettina', 'Bote', 'cbotej5@a8.net', 'Indonesia', 'Kalodu', '1987-04-05', '(723) 4044133', '2015-07-30', 'iPhone 7', 2, 'Android Pie');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (691, 'Cleopatra', 'Judron', 'cjudronj6@devhub.com', 'Portugal', 'Custóias', '1929-04-08', '(908) 4768328', '2012-09-19', 'iPhone 6', 5, 'Android Nougat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (692, 'Lilith', 'Hehnke', 'lhehnkej7@noaa.gov', 'China', 'Shangqiu', '1964-10-14', '(867) 2297711', '2012-01-15', 'Huawei P10 Pro', 6, 'iOS 12.4.8');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (693, 'Karin', 'Kemme', 'kkemmej8@nationalgeographic.com', 'United States', 'Minneapolis', '1937-04-07', '(612) 8612312', '2013-04-27', 'Huawei P20', 8, 'iOS 12.4.8');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (694, 'Peggie', 'Duignan', 'pduignanj9@yolasite.com', 'Japan', 'Fuji', '1961-02-02', '(790) 7596152', '2013-05-01', 'iPhone 7', 6, 'Android Oreo');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (695, 'Lambert', 'Fauning', 'lfauningja@chron.com', 'Germany', 'Hamburg', '2014-09-07', '(654) 6438500', '2013-11-26', 'iPhone XS', 14, 'Android Lollipop');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (696, 'Karleen', 'Roe', 'kroejb@sfgate.com', 'Thailand', 'Sida', '1981-07-12', '(751) 9766037', '2017-05-28', 'iPhone 7s', 13, 'Android Jelly Bean');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (697, 'Sianna', 'MacScherie', 'smacscheriejc@blog.com', 'United States', 'Clearwater', '2013-09-16', '(305) 6081387', '2011-10-09', 'Galaxy S9', 2, 'Android KitKat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (698, 'Terri', 'Gillibrand', 'tgillibrandjd@tamu.edu', 'Japan', 'Kitahama', '1984-04-30', '(830) 4348732', '2018-07-14', 'Galaxy S9', 5, 'iOS 10.3.3');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (699, 'Jan', 'Terrazzo', 'jterrazzoje@japanpost.jp', 'Bosnia and Herzegovina', 'Dobrljin', '1939-07-10', '(897) 1943489', '2014-12-07', 'Galaxy S9', 6, 'Android 10');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (700, 'Elyse', 'McDuffy', 'emcduffyjf@storify.com', 'China', 'Lubao', '1930-01-31', '(358) 6584733', '2016-07-02', 'iPhone XS', 11, 'Android Lollipop');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (701, 'Winnie', 'Ingre', 'wingrejg@wordpress.org', 'China', 'Aykol', '1942-06-18', '(292) 1116230', '2010-06-30', 'Huawei Mate 10 Pro', 14, 'iOS 10.3.4');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (702, 'Etan', 'O''Hara', 'eoharajh@oakley.com', 'Croatia', 'Ježdovec', '1971-03-15', '(678) 9989764', '2018-09-01', 'Huawei P20', 12, 'Android Pie');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (703, 'Ceil', 'Van Der Weedenburg', 'cvanderweedenburgji@ovh.net', 'Indonesia', 'Bulusari', '1998-11-01', '(135) 9989107', '2011-03-16', 'Huawei Mate 10 Pro', 14, 'Android Marshmallow');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (704, 'Ernestine', 'Macknish', 'emacknishjj@house.gov', 'Belarus', 'Yubilyeyny', '2013-11-13', '(917) 8244037', '2017-04-24', 'Galaxy S9', 7, 'Android Oreo');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (705, 'Evelyn', 'Doohan', 'edoohanjk@bandcamp.com', 'Croatia', 'Gospić', '2018-07-24', '(928) 5207691', '2019-02-22', 'Galaxy S9', 1, 'Android Lollipop');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (706, 'Zolly', 'Hartzog', 'zhartzogjl@berkeley.edu', 'China', 'Jianxin', '2005-01-19', '(623) 9345785', '2014-07-07', 'Huawei P30', 6, 'Android KitKat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (707, 'Issie', 'Muselli', 'imusellijm@wikimedia.org', 'Brazil', 'São Luís', '1965-06-03', '(695) 8960614', '2016-07-13', 'Huawei P30', 11, 'iOS 10.3.3');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (708, 'Lloyd', 'Byrkmyr', 'lbyrkmyrjn@canalblog.com', 'China', 'Yongqin', '1951-12-28', '(876) 4075599', '2018-01-16', 'iPhone 7s', 6, 'Android 10');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (709, 'Fabio', 'Allred', 'fallredjo@slate.com', 'Poland', 'Tarłów', '1967-12-30', '(824) 7128687', '2011-07-28', 'Huawei P9 Pro', 5, 'Android Pie');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (710, 'Mercedes', 'Watman', 'mwatmanjp@liveinternet.ru', 'Thailand', 'Ban Tak', '2009-01-01', '(861) 2344296', '2017-10-27', 'iPhone 8s', 7, 'Android Marshmallow');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (711, 'Husain', 'Churches', 'hchurchesjq@usa.gov', 'Zambia', 'Petauke', '1940-07-17', '(721) 3257367', '2014-04-23', 'Huawei Mate 10', 6, 'iOS 10.3.4');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (712, 'Cody', 'Palphreyman', 'cpalphreymanjr@yandex.ru', 'Colombia', 'Medellín', '1972-05-10', '(885) 5354509', '2019-09-26', 'Huawei P9', 3, 'iOS 10.3.4');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (713, 'Jacqueline', 'Toten', 'jtotenjs@pbs.org', 'China', 'Liudu', '1930-05-09', '(386) 3410483', '2011-06-03', 'Huawei P9', 3, 'iOS 9.3.5');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (714, 'Tybie', 'Snassell', 'tsnasselljt@weibo.com', 'Sweden', 'Arvidsjaur', '1941-12-26', '(400) 7340115', '2019-10-19', 'Huawei P9', 3, 'Android Jelly Bean');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (715, 'Bridget', 'Belcham', 'bbelchamju@ucoz.com', 'Indonesia', 'Lhokkruet', '1922-08-26', '(321) 3804311', '2011-12-15', 'iPhone 6s', 3, 'Android Nougat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (716, 'Mendel', 'Tocque', 'mtocquejv@foxnews.com', 'Portugal', 'Sobreira', '2004-08-03', '(263) 6890191', '2020-02-11', 'Huawei P9 Pro', 3, 'Android KitKat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (717, 'Adelle', 'Tritten', 'atrittenjw@taobao.com', 'China', 'Yangyuan', '1997-03-22', '(690) 3701299', '2018-02-04', 'iPhone 7', 11, 'iOS 12.4.8');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (718, 'Winston', 'Zorzi', 'wzorzijx@unesco.org', 'China', 'Guoxiang', '1935-01-19', '(850) 1594362', '2020-04-03', 'iPhone 7', 9, 'iOS 10.3.3');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (719, 'Vick', 'Llorente', 'vllorentejy@ox.ac.uk', 'Spain', 'Santiago De Compostela', '1952-03-07', '(867) 8416552', '2018-12-06', 'Huawei Mate 20', 8, 'iOS 13.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (720, 'Lorrie', 'Murkitt', 'lmurkittjz@histats.com', 'China', 'Bailu', '1961-07-24', '(944) 1301745', '2018-08-20', 'Huawei Mate 10 Pro', 8, 'iOS 13.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (721, 'Brietta', 'Nesbeth', 'bnesbethk0@drupal.org', 'China', 'Yangqiao', '2010-07-09', '(492) 7077004', '2019-04-13', 'iPhone 7', 13, 'Android Lollipop');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (722, 'Hoebart', 'Dunthorne', 'hdunthornek1@sourceforge.net', 'France', 'Romorantin-Lanthenay', '1923-06-29', '(217) 8667192', '2010-04-21', 'iPhone 8s', 6, 'iOS 10.3.4');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (723, 'Linell', 'Jamme', 'ljammek2@etsy.com', 'China', 'Saparbay', '2005-06-15', '(187) 2100901', '2012-03-31', 'Huawei P9', 1, 'iOS 9.3.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (724, 'Shermie', 'Bernardino', 'sbernardinok3@bizjournals.com', 'Belgium', 'Charleroi', '1937-09-18', '(746) 5920007', '2013-09-14', 'iPhone X', 11, 'Android Nougat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (725, 'Phillip', 'Grestye', 'pgrestyek4@tripod.com', 'Indonesia', 'Banjar Jagasatru', '1966-06-09', '(877) 3958018', '2012-01-26', 'iPhone 7s', 9, 'iOS 9.3.5');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (726, 'Tresa', 'Ockendon', 'tockendonk5@sciencedaily.com', 'United States', 'Saint Louis', '1979-04-22', '(314) 5236042', '2015-07-20', 'Galaxy S8', 7, 'Android Jelly Bean');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (727, 'Stacy', 'Stolting', 'sstoltingk6@vistaprint.com', 'China', 'Hongping', '2014-09-28', '(755) 9447446', '2017-03-22', 'Huawei P10 Pro', 14, 'iOS 10.3.4');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (728, 'Wini', 'Mackrill', 'wmackrillk7@engadget.com', 'China', 'Nierumai', '1928-07-18', '(845) 3270529', '2018-12-13', 'Galaxy S8', 7, 'Android Pie');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (729, 'Juliet', 'Avramovsky', 'javramovskyk8@comcast.net', 'Russia', 'Mendeleyevsk', '1981-12-04', '(772) 1444231', '2019-12-14', 'Huawei Mate 20 Pro', 5, 'iOS 10.3.4');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (730, 'Eward', 'Bennitt', 'ebennittk9@instagram.com', 'Canada', 'Mont-Tremblant', '1968-04-11', '(664) 3993918', '2016-07-01', 'iPhone 8', 10, 'iOS 9.3.5');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (731, 'Clementius', 'Forsdicke', 'cforsdickeka@liveinternet.ru', 'Azerbaijan', 'Sabirabad', '1982-04-01', '(503) 1385447', '2012-05-24', 'Huawei Mate 10 Pro', 6, 'Android Pie');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (732, 'Rosette', 'Lindup', 'rlindupkb@yahoo.co.jp', 'Russia', 'Lyuban’', '2014-05-08', '(352) 5606848', '2016-07-09', 'Huawei Mate 10', 11, 'iOS 10.3.4');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (733, 'Konstantin', 'McKernon', 'kmckernonkc@t.co', 'Indonesia', 'Ciparakan', '1983-07-01', '(131) 5016223', '2019-07-05', 'iPhone 6', 8, 'Android Nougat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (734, 'Ange', 'Pennycock', 'apennycockkd@last.fm', 'Peru', 'Llama', '1990-03-21', '(950) 5879127', '2016-04-08', 'Huawei P10', 2, 'Android 10');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (735, 'Cherrita', 'Burberry', 'cburberryke@fema.gov', 'Indonesia', 'Gontar', '2001-08-19', '(963) 7787237', '2017-03-07', 'iPhone X', 7, 'Android Marshmallow');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (736, 'Emogene', 'Freestone', 'efreestonekf@ucoz.ru', 'Nepal', 'Sirāhā', '1988-08-31', '(665) 4711032', '2010-04-06', 'Huawei P20', 2, 'Android Nougat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (737, 'Christyna', 'Syder', 'csyderkg@networksolutions.com', 'China', 'Jiuchenggong', '1999-09-22', '(196) 3483595', '2015-10-16', 'iPhone 6', 14, 'Android Jelly Bean');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (738, 'Jared', 'Reed', 'jreedkh@facebook.com', 'China', 'Xinkaikou', '2005-12-04', '(558) 4198539', '2011-08-08', 'Huawei P9 Pro', 5, 'iOS 13.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (739, 'Katrina', 'Wardrop', 'kwardropki@altervista.org', 'Jamaica', 'Linstead', '2014-06-29', '(344) 4901212', '2018-10-01', 'Huawei P30', 9, 'iOS 13.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (740, 'Nicko', 'Cavendish', 'ncavendishkj@stumbleupon.com', 'China', 'Nanfeng', '1993-03-12', '(802) 1325890', '2017-07-06', 'Huawei P9', 4, 'Android Pie');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (741, 'Amelia', 'Grizard', 'agrizardkk@istockphoto.com', 'China', 'Kongwan', '1977-11-05', '(321) 1835556', '2017-01-29', 'Galaxy S10', 7, 'iOS 9.3.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (742, 'Manuel', 'Nisard', 'mnisardkl@wikipedia.org', 'Japan', 'Tomakomai', '1974-03-15', '(907) 1829031', '2016-05-26', 'Huawei P30 Pro', 14, 'Android Pie');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (743, 'Carolyn', 'Close', 'cclosekm@wordpress.org', 'Portugal', 'Ribeiro', '2005-03-24', '(383) 5956427', '2013-11-27', 'Huawei Mate 10 Pro', 10, 'Android Jelly Bean');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (744, 'Elianora', 'Wisniowski', 'ewisniowskikn@gizmodo.com', 'China', 'Zhonglong', '1983-12-22', '(227) 7068036', '2016-07-29', 'Huawei P30', 6, 'Android 10');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (745, 'Forbes', 'Goldston', 'fgoldstonko@webeden.co.uk', 'Ireland', 'Ballyboden', '1995-07-12', '(765) 6528732', '2015-03-24', 'Huawei P20', 8, 'iOS 12.4.8');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (746, 'Teodor', 'Eaddy', 'teaddykp@home.pl', 'Peru', 'Ucuncha', '1937-01-10', '(320) 5888359', '2015-01-25', 'Huawei P20', 6, 'iOS 9.3.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (747, 'Jedediah', 'Syred', 'jsyredkq@alibaba.com', 'Nigeria', 'Buni Yadi', '2017-01-17', '(550) 6792035', '2012-08-22', 'iPhone 8', 7, 'iOS 9.3.5');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (748, 'Sapphire', 'Tarborn', 'starbornkr@cdc.gov', 'Indonesia', 'Bei', '1941-08-04', '(177) 7327667', '2015-10-18', 'Huawei P10 Pro', 8, 'Android 10');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (749, 'Meridel', 'Scutter', 'mscutterks@nationalgeographic.com', 'Norway', 'Kristiansand S', '1947-05-08', '(913) 7920809', '2020-03-06', 'iPhone 6', 13, 'Android KitKat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (750, 'Virgilio', 'Sears', 'vsearskt@thetimes.co.uk', 'Afghanistan', 'Khayr Kōṯ', '2011-09-01', '(290) 1494865', '2010-05-22', 'Huawei P9 Pro', 11, 'Android Marshmallow');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (751, 'Meridel', 'Dyment', 'mdymentku@go.com', 'Portugal', 'Sete Cidades', '2014-04-27', '(806) 1767936', '2019-07-30', 'Huawei P10 Pro', 13, 'iOS 10.3.3');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (752, 'Marika', 'McCosh', 'mmccoshkv@histats.com', 'Brazil', 'Maragogipe', '1931-12-30', '(712) 9520764', '2016-09-15', 'Huawei Mate 20 Pro', 14, 'Android 10');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (753, 'Max', 'Faulkes', 'mfaulkeskw@blog.com', 'Nigeria', 'Kumagunnam', '1953-11-11', '(774) 8632485', '2010-01-07', 'iPhone 8s', 9, 'iOS 10.3.3');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (754, 'Gilberto', 'Zouch', 'gzouchkx@sogou.com', 'Brazil', 'Recife', '1977-10-05', '(463) 7804591', '2013-03-28', 'iPhone 7s', 11, 'Android KitKat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (755, 'Chrotoem', 'Chew', 'cchewky@google.co.jp', 'Russia', 'Tabaga', '1924-12-31', '(940) 3916468', '2020-04-15', 'Galaxy S9', 12, 'Android 10');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (756, 'Jard', 'Skillman', 'jskillmankz@usda.gov', 'Portugal', 'Refojos de Riba de Ave', '1961-08-28', '(779) 5934470', '2015-11-10', 'Galaxy S10', 6, 'Android 10');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (757, 'Inger', 'Ebden', 'iebdenl0@cornell.edu', 'China', 'Gulai', '1920-02-15', '(157) 2585181', '2010-03-30', 'iPhone 6s', 3, 'Android Lollipop');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (758, 'Chloette', 'Vaisey', 'cvaiseyl1@examiner.com', 'Netherlands', 'Brunssum', '1972-09-23', '(815) 8320850', '2017-07-07', 'Galaxy S8', 4, 'Android Jelly Bean');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (759, 'Abran', 'Champneys', 'achampneysl2@nhs.uk', 'Chile', 'Lampa', '1968-09-12', '(800) 1324821', '2014-05-16', 'Huawei P10 Pro', 8, 'iOS 12.4.8');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (760, 'Paxon', 'Roj', 'projl3@buzzfeed.com', 'China', 'Henan’an', '1944-05-21', '(668) 1134474', '2010-01-17', 'Huawei Mate 10', 13, 'Android Nougat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (761, 'Moyra', 'Nibley', 'mnibleyl4@oakley.com', 'Kazakhstan', 'Ayagoz', '1995-08-17', '(697) 7601077', '2019-06-17', 'Galaxy S10', 2, 'iOS 10.3.4');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (762, 'Marv', 'Brandsen', 'mbrandsenl5@artisteer.com', 'China', 'Nanshi', '1957-12-14', '(396) 1488660', '2019-08-18', 'iPhone 6', 9, 'iOS 10.3.3');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (763, 'Bryon', 'Exell', 'bexelll6@redcross.org', 'Poland', 'Krotoszyn', '1947-08-02', '(181) 8054766', '2016-03-24', 'Huawei P30 Pro', 1, 'iOS 9.3.5');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (764, 'Lin', 'Girvin', 'lgirvinl7@blogs.com', 'Ukraine', 'Smyga', '1976-10-25', '(920) 9520340', '2015-08-23', 'Huawei P30 Pro', 7, 'iOS 9.3.5');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (765, 'Hermine', 'Braunfeld', 'hbraunfeldl8@ed.gov', 'Armenia', 'Kamaris', '2013-01-20', '(690) 7992704', '2011-11-19', 'iPhone 8s', 1, 'Android Pie');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (766, 'Maryann', 'MacClenan', 'mmacclenanl9@alibaba.com', 'Indonesia', 'Sirnarasa', '1969-08-15', '(493) 1251794', '2018-10-29', 'Huawei P9 Pro', 5, 'iOS 9.3.5');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (767, 'Lorri', 'Tyhurst', 'ltyhurstla@comsenz.com', 'Indonesia', 'Gubengairlangga', '1935-06-07', '(582) 4077397', '2015-05-26', 'iPhone 7', 12, 'iOS 13.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (768, 'Udall', 'Muscroft', 'umuscroftlb@discovery.com', 'United States', 'Tucson', '1956-04-11', '(520) 8632172', '2011-08-06', 'iPhone 6s', 11, 'iOS 12.4.8');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (769, 'Batsheva', 'Catcheside', 'bcatchesidelc@infoseek.co.jp', 'Indonesia', 'Cidolog', '1967-11-05', '(909) 2434349', '2010-03-29', 'Huawei Mate 20 Pro', 9, 'Android KitKat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (770, 'Denny', 'Classen', 'dclassenld@altervista.org', 'Bolivia', 'La Cueva', '1947-04-02', '(427) 9128088', '2019-02-01', 'Huawei P10', 14, 'Android 10');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (771, 'Dominica', 'Ingreda', 'dingredale@github.io', 'Philippines', 'Luksuhin', '1984-01-06', '(546) 3331659', '2011-01-02', 'Huawei P20', 11, 'Android 10');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (772, 'Elfrieda', 'Chaff', 'echafflf@admin.ch', 'China', 'Jisegumen', '1963-07-20', '(559) 6997283', '2018-05-04', 'iPhone X', 4, 'Android Marshmallow');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (773, 'Guillaume', 'Edwin', 'gedwinlg@domainmarket.com', 'Brazil', 'Salinas', '1962-12-27', '(386) 2429565', '2012-03-10', 'Huawei P9 Pro', 6, 'iOS 12.4.8');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (774, 'Sully', 'Tidswell', 'stidswelllh@fotki.com', 'China', 'Beicheng', '1966-01-07', '(917) 4954103', '2018-06-15', 'Huawei P10', 7, 'Android Jelly Bean');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (775, 'Gaylene', 'Kinker', 'gkinkerli@ameblo.jp', 'China', 'Chixi', '1988-11-18', '(260) 6964996', '2017-04-23', 'Huawei P20', 4, 'iOS 9.3.5');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (776, 'Lorette', 'Gallant', 'lgallantlj@jimdo.com', 'Brazil', 'Apucarana', '2008-10-19', '(114) 4861591', '2017-05-13', 'iPhone XS', 6, 'iOS 12.4.8');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (777, 'Garold', 'Pietruschka', 'gpietruschkalk@ocn.ne.jp', 'Armenia', 'Noyemberyan', '1986-01-15', '(450) 9326963', '2020-07-20', 'iPhone 8s', 12, 'Android 10');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (778, 'Gawen', 'Oaten', 'goatenll@deliciousdays.com', 'Philippines', 'Atabayan', '2006-07-12', '(950) 4648486', '2015-03-11', 'Huawei Mate 20 Pro', 1, 'Android KitKat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (779, 'Federica', 'Albany', 'falbanylm@prlog.org', 'Vietnam', 'Phù Mỹ', '2008-09-08', '(121) 8689501', '2010-08-03', 'Galaxy S8', 9, 'Android KitKat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (780, 'Nikolas', 'De Rye Barrett', 'nderyebarrettln@nasa.gov', 'Indonesia', 'Sendangagung', '1989-06-01', '(319) 7972699', '2016-11-17', 'Huawei P10 Pro', 4, 'iOS 13.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (781, 'Charis', 'Belderson', 'cbeldersonlo@bigcartel.com', 'Tunisia', 'Al Matlīn', '1958-11-11', '(324) 3795304', '2020-01-27', 'Galaxy S9', 4, 'Android 10');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (782, 'Shem', 'Tither', 'stitherlp@tmall.com', 'Somalia', 'Burao', '2015-08-09', '(766) 3441290', '2017-01-26', 'Huawei Mate 10 Pro', 4, 'Android Marshmallow');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (783, 'Vassili', 'Callender', 'vcallenderlq@marketwatch.com', 'Venezuela', 'Caucaguita', '1952-03-30', '(772) 1380714', '2016-08-23', 'iPhone 8s', 5, 'Android Pie');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (784, 'Olive', 'Shepperd', 'oshepperdlr@hatena.ne.jp', 'Brazil', 'Ipauçu', '1923-11-12', '(314) 1959410', '2012-01-30', 'iPhone 6s', 6, 'Android Jelly Bean');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (785, 'Harriette', 'Dilston', 'hdilstonls@examiner.com', 'China', 'Liangshan', '1988-09-22', '(785) 3572041', '2011-09-13', 'Huawei Mate 20', 3, 'iOS 10.3.3');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (786, 'Hillie', 'Radbond', 'hradbondlt@washingtonpost.com', 'Pakistan', 'Sann', '2000-04-09', '(742) 1053394', '2016-04-07', 'Galaxy S10', 5, 'iOS 13.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (787, 'Alec', 'Frisch', 'afrischlu@msn.com', 'Indonesia', 'Cigintung', '1937-08-31', '(952) 4740460', '2016-10-16', 'Huawei Mate 20', 10, 'iOS 12.4.8');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (788, 'Joela', 'Whotton', 'jwhottonlv@booking.com', 'Kazakhstan', 'Zhezqazghan', '1978-11-29', '(285) 7577118', '2012-12-15', 'Huawei P20', 4, 'Android KitKat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (789, 'Kai', 'Romain', 'kromainlw@examiner.com', 'United States', 'Erie', '1965-02-21', '(814) 3928515', '2013-06-20', 'Huawei P9 Pro', 11, 'Android Pie');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (790, 'Gretal', 'Beceril', 'gbecerillx@cmu.edu', 'Malaysia', 'Kuala Lumpur', '1947-03-26', '(945) 5731660', '2018-12-22', 'Galaxy S9', 2, 'iOS 13.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (791, 'Flint', 'Braywood', 'fbraywoodly@gmpg.org', 'Philippines', 'Bayawan', '1951-03-25', '(175) 6966046', '2015-03-23', 'Huawei Mate 20', 7, 'Android Oreo');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (792, 'Griffie', 'Kenryd', 'gkenrydlz@dion.ne.jp', 'Portugal', 'Marisol', '1973-06-01', '(315) 2564005', '2012-03-25', 'iPhone 7s', 4, 'Android Lollipop');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (793, 'Red', 'Mathevet', 'rmathevetm0@mapy.cz', 'Syria', 'Mahīn', '2014-06-25', '(625) 7252754', '2017-10-28', 'Huawei P10', 10, 'iOS 12.4.8');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (794, 'Hobard', 'Bilbey', 'hbilbeym1@mtv.com', 'Portugal', 'Vale de Figueira', '2020-07-17', '(899) 9837278', '2011-03-22', 'iPhone 7s', 11, 'Android 10');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (795, 'Elfie', 'Zoanetti', 'ezoanettim2@google.pl', 'Honduras', 'Lucerna', '1981-04-26', '(817) 3581922', '2016-01-24', 'iPhone 7', 5, 'iOS 13.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (796, 'Gregory', 'Bickerstasse', 'gbickerstassem3@youtube.com', 'Tunisia', 'Menzel Bourguiba', '1957-11-21', '(127) 7020276', '2013-04-05', 'Huawei P30', 2, 'iOS 9.3.5');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (797, 'Fayre', 'Flieger', 'ffliegerm4@businessinsider.com', 'China', 'Jinlong', '1934-10-19', '(425) 7180178', '2010-04-29', 'Huawei P20 Pro', 2, 'iOS 10.3.4');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (798, 'Ali', 'Bellison', 'abellisonm5@joomla.org', 'China', 'Luoyang', '1972-10-24', '(202) 5109741', '2010-05-18', 'Galaxy S8', 11, 'Android Pie');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (799, 'Pattie', 'Garrad', 'pgarradm6@cbsnews.com', 'Colombia', 'La Ceja', '1992-01-18', '(375) 5202375', '2014-01-23', 'Galaxy S9', 5, 'iOS 9.3.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (800, 'Isabeau', 'Mensler', 'imenslerm7@sourceforge.net', 'Serbia', 'Paraćin', '1940-11-22', '(981) 2722177', '2014-06-06', 'Galaxy S9', 2, 'Android Oreo');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (801, 'Liz', 'Vasyagin', 'lvasyaginm8@europa.eu', 'Pakistan', 'Toba Tek Singh', '1965-05-02', '(691) 8347701', '2012-05-25', 'Huawei P20', 12, 'Android KitKat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (802, 'Michele', 'Boteman', 'mbotemanm9@paypal.com', 'China', 'Dayuan', '1968-01-21', '(535) 4173363', '2017-11-06', 'iPhone 8s', 4, 'Android Oreo');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (803, 'Gabie', 'Womack', 'gwomackma@examiner.com', 'Portugal', 'Póvoa', '1981-01-22', '(580) 4977069', '2017-01-15', 'Huawei P9', 8, 'Android Marshmallow');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (804, 'Britteny', 'Staniforth', 'bstaniforthmb@amazonaws.com', 'Myanmar', 'Pyinmana', '2014-10-26', '(522) 4625025', '2016-08-10', 'Huawei P30 Pro', 14, 'Android 10');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (805, 'Teressa', 'Cellone', 'tcellonemc@tripod.com', 'Georgia', 'Vani', '1929-06-30', '(323) 5168292', '2019-07-25', 'Huawei Mate 20 Pro', 9, 'Android Lollipop');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (806, 'Kristy', 'Lymer', 'klymermd@mediafire.com', 'Russia', 'Kirzhach', '1939-06-04', '(879) 5965070', '2012-11-15', 'iPhone 7s', 1, 'Android Pie');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (807, 'Lonny', 'Geraldo', 'lgeraldome@psu.edu', 'Russia', 'Overyata', '1997-09-14', '(237) 4629387', '2011-01-16', 'iPhone 7s', 11, 'iOS 9.3.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (808, 'Royall', 'Agastina', 'ragastinamf@answers.com', 'Poland', 'Czarnocin', '2012-01-30', '(728) 9976366', '2014-10-14', 'Huawei P30 Pro', 11, 'Android KitKat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (809, 'Kippy', 'Drayton', 'kdraytonmg@plala.or.jp', 'Bosnia and Herzegovina', 'Tomislavgrad', '1935-02-10', '(272) 2454707', '2015-09-13', 'iPhone X', 8, 'Android Pie');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (810, 'Ashley', 'Rassell', 'arassellmh@dion.ne.jp', 'Poland', 'Haczów', '1957-03-12', '(819) 5505594', '2012-05-31', 'Galaxy S9', 2, 'Android Marshmallow');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (811, 'Robinett', 'Heintzsch', 'rheintzschmi@wp.com', 'Sweden', 'Stockholm', '1940-07-05', '(892) 5843309', '2010-08-17', 'Huawei Mate 20', 2, 'iOS 12.4.8');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (812, 'Jennica', 'Tures', 'jturesmj@businesswire.com', 'France', 'Brest', '1932-04-18', '(965) 7757583', '2012-04-13', 'Huawei P10 Pro', 8, 'Android Jelly Bean');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (813, 'Kean', 'Landrieu', 'klandrieumk@dagondesign.com', 'Colombia', 'Cereté', '1929-06-11', '(456) 4837055', '2014-04-17', 'Huawei P10 Pro', 8, 'Android Lollipop');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (814, 'Richmound', 'Penniell', 'rpenniellml@mail.ru', 'Czech Republic', 'Ludgeřovice', '1974-05-24', '(450) 6202098', '2017-01-01', 'Huawei Mate 10 Pro', 3, 'Android Pie');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (815, 'Jephthah', 'De Gregoli', 'jdegregolimm@4shared.com', 'Czech Republic', 'Milevsko', '1938-12-31', '(978) 8676078', '2015-12-16', 'Huawei P20', 7, 'Android Jelly Bean');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (816, 'Rakel', 'Vogt', 'rvogtmn@nasa.gov', 'Russia', 'Mendeleyevskiy', '1962-11-13', '(761) 4265925', '2010-06-26', 'Huawei Mate 10 Pro', 4, 'iOS 10.3.3');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (817, 'Irwin', 'Alcido', 'ialcidomo@google.ru', 'North Korea', 'Samho-rodongjagu', '1994-12-10', '(105) 1753133', '2020-03-16', 'Huawei P20 Pro', 11, 'iOS 10.3.3');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (818, 'Sibel', 'Gyurkovics', 'sgyurkovicsmp@merriam-webster.com', 'Poland', 'Leśnica', '2005-06-16', '(828) 8196904', '2016-09-25', 'iPhone 7', 1, 'Android Pie');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (819, 'Odo', 'Toner', 'otonermq@examiner.com', 'Cambodia', 'Svay Rieng', '2010-04-17', '(481) 5290420', '2014-04-05', 'iPhone 6s', 3, 'Android Pie');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (820, 'Lorie', 'Byrnes', 'lbyrnesmr@123-reg.co.uk', 'Indonesia', 'Losari', '2000-03-11', '(424) 8130280', '2020-04-30', 'Huawei P9', 5, 'iOS 9.3.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (821, 'Taber', 'Puddin', 'tpuddinms@mlb.com', 'Uzbekistan', 'Kosonsoy', '1920-07-29', '(855) 2942850', '2012-06-15', 'iPhone X', 14, 'iOS 12.4.8');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (822, 'Sid', 'Matchett', 'smatchettmt@miitbeian.gov.cn', 'Ukraine', 'Kremenets’', '1943-06-12', '(114) 2562318', '2019-03-12', 'iPhone 8s', 11, 'iOS 9.3.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (823, 'Lin', 'Marusik', 'lmarusikmu@t.co', 'Indonesia', 'Kiaranonggeng', '1992-12-01', '(170) 5837518', '2020-07-04', 'iPhone X', 9, 'iOS 13.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (824, 'Daniel', 'Sparkes', 'dsparkesmv@marketwatch.com', 'Sweden', 'Göteborg', '2018-11-11', '(502) 8759353', '2017-04-25', 'iPhone 8', 4, 'Android Lollipop');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (825, 'Lowe', 'McGraw', 'lmcgrawmw@yahoo.com', 'Ecuador', 'La Troncal', '1956-09-21', '(396) 7374835', '2018-07-30', 'iPhone 8', 10, 'Android KitKat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (826, 'Cathie', 'Lathy', 'clathymx@msn.com', 'Indonesia', 'Kapinango', '1975-10-14', '(909) 1941616', '2011-12-31', 'Huawei P10', 5, 'iOS 12.4.8');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (827, 'Thaine', 'Haddow', 'thaddowmy@epa.gov', 'Vietnam', 'Quốc Oai', '1993-11-04', '(752) 2209266', '2011-09-03', 'Huawei P30 Pro', 9, 'Android Marshmallow');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (828, 'Frederik', 'Raith', 'fraithmz@amazon.co.uk', 'Mongolia', 'Bayanbulag', '1952-01-11', '(132) 1684626', '2016-01-05', 'Huawei Mate 10', 13, 'iOS 12.4.8');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (829, 'Mala', 'Cazin', 'mcazinn0@whitehouse.gov', 'Sweden', 'Hägersten', '1971-05-11', '(784) 9990814', '2017-01-20', 'Huawei P20 Pro', 10, 'iOS 12.4.8');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (830, 'Minni', 'Hanbidge', 'mhanbidgen1@usatoday.com', 'France', 'Montesson', '1977-12-29', '(385) 6621247', '2015-03-07', 'Huawei Mate 10', 6, 'Android Jelly Bean');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (831, 'Son', 'Gilbee', 'sgilbeen2@tripod.com', 'China', 'Dalian', '1921-04-23', '(231) 7308319', '2012-03-22', 'Huawei Mate 10', 5, 'Android Marshmallow');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (832, 'Nikolos', 'Ibanez', 'nibanezn3@europa.eu', 'China', 'Tehetu', '1997-10-14', '(792) 9332779', '2013-05-23', 'Huawei P9', 2, 'iOS 13.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (833, 'Rice', 'Kemston', 'rkemstonn4@icio.us', 'Colombia', 'El Cocuy', '1975-02-04', '(393) 8666999', '2013-06-19', 'iPhone 6s', 1, 'Android KitKat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (834, 'Ingamar', 'Smithson', 'ismithsonn5@flavors.me', 'Japan', 'Koshigaya', '1922-09-07', '(217) 7942298', '2014-07-12', 'Huawei Mate 10', 9, 'Android 10');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (835, 'Leo', 'Plomer', 'lplomern6@hc360.com', 'Peru', 'Succha', '1995-10-21', '(526) 6621423', '2012-02-05', 'Huawei Mate 10 Pro', 10, 'Android Jelly Bean');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (836, 'Rodrique', 'O''Shee', 'rosheen7@i2i.jp', 'Myanmar', 'Hinthada', '1948-11-04', '(645) 3941860', '2014-03-23', 'Galaxy S9', 9, 'Android Oreo');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (837, 'Venus', 'Hammel', 'vhammeln8@nifty.com', 'Indonesia', 'Naebugis', '2004-06-22', '(973) 1100815', '2013-11-30', 'Huawei P30 Pro', 12, 'Android Nougat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (838, 'Reed', 'Courvert', 'rcourvertn9@delicious.com', 'Indonesia', 'Kertasari', '2006-08-23', '(982) 5534063', '2014-08-05', 'iPhone 8', 8, 'iOS 9.3.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (839, 'Janelle', 'Somers', 'jsomersna@examiner.com', 'France', 'Saint-Claude', '1946-05-21', '(472) 1099424', '2013-12-03', 'iPhone X', 10, 'iOS 10.3.4');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (840, 'Tresa', 'Chsteney', 'tchsteneynb@example.com', 'United States', 'Des Moines', '1994-10-06', '(515) 5505059', '2011-05-03', 'Galaxy S10', 13, 'iOS 13.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (841, 'Pincas', 'Bansal', 'pbansalnc@surveymonkey.com', 'Belarus', 'Ivanava', '1983-02-15', '(417) 5872198', '2016-08-30', 'iPhone 6', 1, 'iOS 12.4.8');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (842, 'Burnaby', 'Washington', 'bwashingtonnd@istockphoto.com', 'Macedonia', 'Bedinje', '1928-04-08', '(649) 5302326', '2015-10-16', 'Huawei P9', 6, 'iOS 9.3.6');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (843, 'Hadley', 'Mohammed', 'hmohammedne@forbes.com', 'China', 'Tayuan', '1992-12-11', '(307) 1081378', '2018-04-27', 'Galaxy S8', 3, 'Android Pie');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (844, 'Abbe', 'Frentz', 'afrentznf@hhs.gov', 'Venezuela', 'Pampanito', '2009-01-05', '(449) 8620145', '2011-02-04', 'iPhone 7', 2, 'Android Lollipop');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (845, 'Aluino', 'Hutable', 'ahutableng@google.es', 'Thailand', 'Lom Sak', '1959-12-10', '(863) 4771687', '2011-06-03', 'iPhone 6s', 3, 'Android Jelly Bean');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (846, 'Nahum', 'Auchterlonie', 'nauchterlonienh@bizjournals.com', 'China', 'Dengfang', '1928-10-05', '(734) 3613810', '2016-06-10', 'Galaxy S9', 14, 'Android Oreo');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (847, 'Donia', 'Van der Brugge', 'dvanderbruggeni@mozilla.org', 'Portugal', 'Cercal', '1946-10-21', '(138) 2403542', '2011-02-26', 'Galaxy S9', 12, 'iOS 10.3.4');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (848, 'Ruggiero', 'Hassent', 'rhassentnj@infoseek.co.jp', 'Mexico', 'Rancho Viejo', '1988-07-27', '(586) 1474566', '2017-05-27', 'Huawei P30', 8, 'Android Pie');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (849, 'Devonna', 'Peele', 'dpeelenk@mysql.com', 'Russia', 'Medveditskiy', '1944-04-26', '(906) 5052561', '2018-07-14', 'Huawei P10 Pro', 2, 'Android Lollipop');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (850, 'Dasie', 'Kyle', 'dkylenl@hubpages.com', 'Russia', 'Sosnovyy Bor', '1976-06-10', '(772) 7722054', '2013-12-20', 'iPhone 6', 11, 'Android Pie');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (851, 'Eda', 'Wozencraft', 'ewozencraftnm@purevolume.com', 'Indonesia', 'Oja', '1967-07-18', '(363) 9145495', '2020-02-15', 'Huawei Mate 10', 14, 'Android Nougat');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (852, 'Alexander', 'Maffioletti', 'amaffiolettinn@rambler.ru', 'Poland', 'Siemiechów', '1987-08-07', '(649) 9191989', '2019-03-18', 'Huawei Mate 10 Pro', 14, 'Android 10');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (853, 'Shelba', 'McCullen', 'smccullenno@fc2.com', 'China', 'Longbo', '1992-02-15', '(713) 3234721', '2014-04-30', 'iPhone 6s', 9, 'iOS 9.3.5');
insert into Users (UserID, FirstName, LastName, email, Country, City, BirthDate, Phone, RegDate, DeviceName, CampaignID, Platform) values (854, 'Larine', 'Greensmith', 'lgreensmithnp@army.mil', 'Philippines', 'Lalauigan', '2008-04-07', '(388) 8822961', '2010-07-07', 'Huawei P10 Pro', 4, 'iOS 10.3.3');
GO

-- Inputting Data into Games_Installs table
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (1, 590, 5, null, '2017-11-24');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (2, 639, 3, null, '2019-08-05');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (3, 59, 8, null, '2018-03-09');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (4, 25, 8, null, '2013-09-21');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (5, 344, 1, null, '2012-07-13');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (6, 510, 3, null, '2010-08-01');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (7, 211, 12, null, '2018-11-28');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (8, 96, 2, null, '2017-01-16');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (9, 803, 12, null, '2016-06-06');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (10, 194, 1, null, '2015-01-06');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (11, 851, 5, null, '2010-05-07');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (12, 111, 5, null, '2017-01-16');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (13, 768, 7, null, '2018-02-23');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (14, 281, 13, null, '2018-08-03');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (15, 526, 2, null, '2013-11-10');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (16, 836, 1, null, '2011-09-23');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (17, 252, 13, null, '2011-12-02');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (18, 603, 8, null, '2015-07-04');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (19, 786, 4, null, '2011-11-18');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (20, 260, 11, null, '2012-02-13');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (21, 739, 4, null, '2017-09-28');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (22, 415, 7, null, '2017-11-09');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (23, 282, 12, null, '2018-11-06');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (24, 723, 3, null, '2015-09-17');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (25, 233, 9, null, '2012-11-08');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (26, 296, 11, null, '2018-03-19');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (27, 134, 9, null, '2013-05-19');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (28, 733, 9, null, '2011-07-24');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (29, 469, 5, null, '2018-07-05');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (30, 794, 13, null, '2020-04-04');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (31, 42, 5, null, '2015-12-06');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (32, 230, 6, null, '2013-10-28');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (33, 365, 2, null, '2018-12-18');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (34, 93, 3, null, '2019-03-22');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (35, 647, 5, null, '2018-05-30');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (36, 82, 3, null, '2016-09-11');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (37, 235, 4, null, '2015-11-09');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (38, 220, 6, null, '2011-08-12');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (39, 660, 2, null, '2010-11-03');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (40, 296, 8, null, '2017-07-23');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (41, 341, 9, null, '2011-02-22');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (42, 141, 9, null, '2018-08-02');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (43, 208, 2, null, '2011-02-28');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (44, 236, 3, null, '2014-09-08');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (45, 604, 9, null, '2015-01-09');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (46, 374, 2, null, '2014-07-04');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (47, 850, 9, null, '2014-08-27');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (48, 814, 4, null, '2013-08-21');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (49, 379, 11, null, '2017-02-13');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (50, 379, 13, null, '2018-04-18');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (51, 479, 5, null, '2016-01-16');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (52, 821, 7, null, '2011-11-01');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (53, 553, 5, null, '2018-12-14');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (54, 590, 2, null, '2012-01-11');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (55, 661, 6, null, '2013-02-16');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (56, 273, 3, null, '2016-09-15');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (57, 705, 10, null, '2017-12-05');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (58, 84, 9, null, '2013-03-03');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (59, 382, 1, null, '2020-04-12');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (60, 567, 1, null, '2012-01-31');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (61, 601, 3, null, '2010-08-19');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (62, 581, 2, null, '2018-07-17');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (63, 54, 12, null, '2018-11-22');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (64, 3, 8, null, '2016-11-01');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (65, 356, 5, null, '2010-10-16');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (66, 18, 3, null, '2013-01-14');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (67, 24, 13, null, '2012-07-27');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (68, 305, 2, null, '2015-01-30');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (69, 469, 9, null, '2018-12-07');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (70, 794, 12, null, '2013-11-21');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (71, 416, 9, null, '2017-07-07');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (72, 38, 12, null, '2011-08-22');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (73, 604, 10, null, '2014-05-27');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (74, 373, 1, null, '2010-05-06');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (75, 3, 3, null, '2012-09-02');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (76, 160, 12, null, '2019-06-22');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (77, 829, 8, null, '2011-04-12');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (78, 571, 4, null, '2011-05-30');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (79, 498, 3, null, '2019-10-02');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (80, 273, 7, null, '2010-08-03');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (81, 368, 13, null, '2014-07-30');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (82, 635, 5, null, '2014-08-09');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (83, 421, 10, null, '2010-10-15');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (84, 451, 11, null, '2010-11-27');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (85, 453, 9, null, '2013-10-10');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (86, 196, 9, null, '2017-04-28');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (87, 243, 11, null, '2015-03-08');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (88, 618, 6, null, '2015-11-28');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (89, 318, 8, null, '2018-03-31');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (90, 252, 8, null, '2015-10-31');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (91, 664, 7, null, '2015-04-15');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (92, 761, 10, null, '2011-09-02');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (93, 47, 8, null, '2012-09-17');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (94, 737, 13, null, '2016-02-13');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (95, 203, 13, null, '2017-04-10');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (96, 73, 12, null, '2010-11-08');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (97, 521, 7, null, '2016-10-18');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (98, 19, 5, null, '2015-08-01');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (99, 131, 9, null, '2013-04-07');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (100, 359, 6, null, '2016-09-13');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (101, 55, 2, null, '2011-12-10');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (102, 496, 2, null, '2014-07-07');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (103, 188, 12, null, '2012-03-16');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (104, 560, 5, null, '2010-08-06');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (105, 270, 8, null, '2017-07-14');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (106, 537, 10, null, '2017-08-20');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (107, 828, 11, null, '2017-07-05');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (108, 853, 3, null, '2014-07-23');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (109, 828, 11, null, '2013-07-19');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (110, 59, 6, null, '2013-02-08');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (111, 540, 13, null, '2011-01-13');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (112, 621, 5, null, '2010-06-05');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (113, 184, 1, null, '2018-06-16');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (114, 567, 8, null, '2010-05-07');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (115, 844, 4, null, '2016-02-06');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (116, 648, 6, null, '2016-11-29');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (117, 670, 8, null, '2011-11-14');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (118, 688, 9, null, '2018-04-02');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (119, 159, 11, null, '2013-07-12');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (120, 438, 8, null, '2015-03-05');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (121, 610, 2, null, '2015-10-02');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (122, 451, 10, null, '2012-07-14');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (123, 516, 3, null, '2011-04-15');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (124, 337, 2, null, '2020-01-29');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (125, 257, 13, null, '2018-11-26');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (126, 162, 2, null, '2010-09-26');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (127, 47, 2, null, '2017-03-27');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (128, 410, 10, null, '2017-03-15');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (129, 311, 10, null, '2011-02-11');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (130, 242, 1, null, '2012-04-01');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (131, 684, 7, null, '2020-03-10');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (132, 281, 4, null, '2012-10-31');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (133, 247, 7, null, '2012-12-28');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (134, 539, 12, null, '2012-03-19');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (135, 460, 7, null, '2011-08-05');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (136, 328, 4, null, '2013-10-26');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (137, 85, 11, null, '2010-12-20');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (138, 237, 13, null, '2014-04-24');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (139, 54, 4, null, '2011-03-07');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (140, 822, 6, null, '2019-01-28');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (141, 3, 13, null, '2012-09-12');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (142, 660, 11, null, '2012-01-18');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (143, 474, 2, null, '2019-10-30');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (144, 349, 7, null, '2015-02-18');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (145, 657, 6, null, '2020-04-29');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (146, 231, 1, null, '2013-03-12');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (147, 807, 2, null, '2011-10-02');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (148, 239, 5, null, '2012-03-31');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (149, 233, 7, null, '2016-04-11');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (150, 629, 7, null, '2020-01-23');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (151, 633, 6, null, '2019-10-06');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (152, 90, 10, null, '2014-04-25');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (153, 188, 5, null, '2010-09-11');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (154, 169, 10, null, '2015-08-01');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (155, 309, 5, null, '2017-02-22');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (156, 121, 12, null, '2015-05-01');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (157, 152, 3, null, '2013-11-23');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (158, 435, 2, null, '2011-12-24');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (159, 212, 7, null, '2015-10-26');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (160, 685, 7, null, '2019-04-19');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (161, 717, 9, null, '2016-11-25');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (162, 772, 5, null, '2017-12-28');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (163, 46, 11, null, '2015-12-06');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (164, 248, 10, null, '2014-05-20');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (165, 440, 10, null, '2014-11-18');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (166, 43, 5, null, '2014-10-30');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (167, 854, 1, null, '2019-10-30');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (168, 694, 6, null, '2018-11-10');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (169, 98, 6, null, '2020-04-10');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (170, 529, 8, null, '2011-10-31');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (171, 835, 10, null, '2016-02-16');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (172, 278, 5, null, '2015-10-06');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (173, 66, 5, null, '2015-06-13');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (174, 44, 8, null, '2017-07-19');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (175, 478, 13, null, '2014-03-01');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (176, 784, 3, null, '2010-05-21');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (177, 522, 11, null, '2015-06-11');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (178, 531, 13, null, '2014-08-06');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (179, 496, 5, null, '2013-08-31');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (180, 318, 6, null, '2013-03-10');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (181, 178, 12, null, '2012-08-20');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (182, 602, 6, null, '2019-09-22');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (183, 315, 7, null, '2015-05-29');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (184, 27, 5, null, '2012-10-03');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (185, 716, 11, null, '2013-04-20');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (186, 554, 8, null, '2019-10-17');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (187, 468, 4, null, '2014-03-06');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (188, 242, 8, null, '2016-08-06');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (189, 620, 6, null, '2016-10-22');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (190, 844, 1, null, '2019-06-11');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (191, 556, 1, null, '2014-04-05');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (192, 471, 13, null, '2018-03-08');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (193, 113, 13, null, '2019-06-24');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (194, 805, 6, null, '2012-12-15');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (195, 698, 10, null, '2015-06-05');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (196, 601, 7, null, '2018-01-08');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (197, 548, 13, null, '2017-12-05');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (198, 55, 5, null, '2012-01-30');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (199, 358, 1, null, '2015-03-19');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (200, 228, 2, null, '2012-08-11');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (201, 47, 6, null, '2019-05-29');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (202, 673, 10, null, '2016-04-17');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (203, 706, 6, null, '2019-01-21');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (204, 291, 5, null, '2012-07-02');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (205, 452, 13, null, '2014-05-11');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (206, 173, 5, null, '2013-11-27');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (207, 233, 10, null, '2013-11-29');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (208, 417, 3, null, '2017-07-24');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (209, 693, 11, null, '2017-09-26');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (210, 588, 3, null, '2012-01-03');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (211, 743, 12, null, '2011-09-07');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (212, 595, 3, null, '2017-02-22');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (213, 200, 3, null, '2014-01-20');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (214, 484, 5, null, '2013-09-06');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (215, 424, 5, null, '2014-12-25');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (216, 319, 7, null, '2013-06-24');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (217, 248, 1, null, '2015-03-30');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (218, 561, 6, null, '2014-11-22');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (219, 205, 13, null, '2011-08-13');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (220, 185, 7, null, '2016-12-13');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (221, 648, 13, null, '2018-10-30');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (222, 785, 6, null, '2010-11-30');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (223, 827, 3, null, '2019-03-04');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (224, 655, 7, null, '2010-10-12');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (225, 58, 3, null, '2013-09-26');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (226, 36, 6, null, '2019-04-20');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (227, 515, 4, null, '2012-09-02');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (228, 283, 8, null, '2015-05-21');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (229, 802, 7, null, '2019-03-03');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (230, 430, 6, null, '2017-08-03');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (231, 259, 1, null, '2012-11-05');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (232, 676, 7, null, '2015-03-06');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (233, 329, 7, null, '2011-05-11');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (234, 838, 12, null, '2017-07-05');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (235, 425, 12, null, '2014-03-04');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (236, 829, 11, null, '2018-03-30');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (237, 549, 4, null, '2014-12-30');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (238, 547, 2, null, '2012-11-14');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (239, 534, 2, null, '2013-04-16');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (240, 372, 3, null, '2018-10-18');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (241, 408, 12, null, '2012-08-23');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (242, 614, 13, null, '2012-12-30');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (243, 642, 10, null, '2014-08-03');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (244, 314, 9, null, '2017-04-27');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (245, 233, 8, null, '2011-02-04');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (246, 86, 11, null, '2019-10-08');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (247, 420, 10, null, '2018-12-30');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (248, 742, 2, null, '2011-01-19');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (249, 165, 5, null, '2010-11-18');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (250, 449, 4, null, '2017-06-26');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (251, 102, 10, null, '2011-01-12');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (252, 796, 6, null, '2015-02-23');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (253, 210, 13, null, '2013-12-01');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (254, 610, 8, null, '2013-12-03');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (255, 604, 9, null, '2011-06-07');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (256, 377, 3, null, '2016-03-07');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (257, 735, 2, null, '2019-03-15');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (258, 303, 5, null, '2018-08-31');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (259, 79, 8, null, '2013-10-17');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (260, 260, 3, null, '2017-11-11');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (261, 384, 6, null, '2018-10-26');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (262, 652, 5, null, '2016-03-22');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (263, 610, 9, null, '2013-06-22');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (264, 111, 1, null, '2016-07-07');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (265, 814, 12, null, '2018-05-08');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (266, 30, 7, null, '2019-01-10');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (267, 581, 12, null, '2010-11-11');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (268, 673, 6, null, '2010-05-30');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (269, 443, 2, null, '2013-06-22');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (270, 850, 11, null, '2012-05-30');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (271, 10, 1, null, '2017-07-09');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (272, 84, 13, null, '2018-05-07');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (273, 10, 1, null, '2012-10-23');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (274, 707, 1, null, '2013-02-26');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (275, 578, 7, null, '2017-10-10');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (276, 746, 5, null, '2012-06-14');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (277, 610, 3, null, '2012-12-26');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (278, 343, 1, null, '2012-04-23');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (279, 629, 2, null, '2010-11-20');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (280, 355, 9, null, '2017-02-21');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (281, 361, 10, null, '2020-03-14');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (282, 407, 1, null, '2010-10-01');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (283, 294, 2, null, '2015-02-07');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (284, 124, 1, null, '2013-11-13');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (285, 662, 7, null, '2016-02-21');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (286, 617, 5, null, '2016-04-03');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (287, 69, 9, null, '2019-05-13');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (288, 754, 12, null, '2018-01-17');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (289, 204, 7, null, '2013-06-17');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (290, 849, 13, null, '2014-01-17');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (291, 819, 5, null, '2016-09-03');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (292, 830, 1, null, '2019-08-26');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (293, 158, 4, null, '2016-04-21');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (294, 6, 9, null, '2017-11-30');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (295, 682, 5, null, '2019-07-25');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (296, 478, 12, null, '2013-03-31');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (297, 705, 5, null, '2012-03-06');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (298, 426, 8, null, '2015-12-09');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (299, 28, 9, null, '2020-04-12');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (300, 550, 10, null, '2013-10-04');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (301, 99, 10, null, '2015-05-21');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (302, 307, 8, null, '2015-08-09');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (303, 470, 10, null, '2014-06-24');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (304, 243, 7, null, '2017-07-20');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (305, 159, 13, null, '2015-05-15');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (306, 53, 11, null, '2020-04-04');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (307, 234, 8, null, '2017-02-23');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (308, 463, 8, null, '2013-05-11');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (309, 114, 8, null, '2013-05-18');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (310, 123, 12, null, '2018-02-11');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (311, 160, 3, null, '2011-09-01');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (312, 652, 9, null, '2017-07-27');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (313, 559, 9, null, '2017-10-07');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (314, 310, 6, null, '2016-07-29');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (315, 85, 12, null, '2018-04-18');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (316, 216, 10, null, '2019-09-29');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (317, 372, 1, null, '2014-02-26');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (318, 720, 10, null, '2011-02-05');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (319, 732, 5, null, '2016-07-02');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (320, 354, 8, null, '2019-08-01');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (321, 376, 1, null, '2019-05-24');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (322, 338, 10, null, '2013-02-02');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (323, 772, 11, null, '2012-01-15');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (324, 323, 3, null, '2017-01-19');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (325, 481, 13, null, '2019-05-14');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (326, 735, 10, null, '2018-05-03');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (327, 637, 10, null, '2017-11-16');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (328, 402, 12, null, '2011-03-16');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (329, 606, 4, null, '2018-09-14');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (330, 843, 1, null, '2011-08-06');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (331, 195, 3, null, '2019-09-03');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (332, 447, 7, null, '2016-07-03');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (333, 783, 7, null, '2010-08-20');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (334, 662, 2, null, '2011-05-11');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (335, 843, 2, null, '2013-10-06');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (336, 200, 13, null, '2012-05-25');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (337, 814, 13, null, '2010-05-18');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (338, 824, 11, null, '2019-05-21');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (339, 680, 9, null, '2015-06-19');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (340, 89, 4, null, '2020-02-20');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (341, 171, 10, null, '2013-11-24');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (342, 266, 8, null, '2015-04-17');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (343, 111, 2, null, '2018-02-27');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (344, 790, 3, null, '2019-05-09');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (345, 627, 5, null, '2015-07-24');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (346, 155, 2, null, '2014-01-30');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (347, 671, 5, null, '2014-05-02');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (348, 578, 9, null, '2013-10-24');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (349, 854, 8, null, '2020-02-12');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (350, 743, 12, null, '2011-01-10');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (351, 410, 8, null, '2014-05-25');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (352, 835, 12, null, '2016-10-14');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (353, 80, 12, null, '2018-04-22');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (354, 127, 2, null, '2019-08-16');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (355, 769, 13, null, '2013-09-25');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (356, 229, 4, null, '2011-10-30');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (357, 320, 4, null, '2018-03-12');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (358, 555, 10, null, '2015-07-10');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (359, 251, 9, null, '2018-08-25');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (360, 585, 1, null, '2012-10-19');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (361, 737, 8, null, '2012-07-26');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (362, 634, 9, null, '2013-12-03');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (363, 569, 11, null, '2013-12-27');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (364, 623, 5, null, '2019-05-22');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (365, 101, 7, null, '2017-06-23');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (366, 653, 1, null, '2018-02-04');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (367, 100, 9, null, '2014-05-15');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (368, 473, 10, null, '2011-03-24');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (369, 26, 10, null, '2014-10-15');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (370, 134, 5, null, '2019-04-29');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (371, 126, 5, null, '2012-05-15');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (372, 810, 1, null, '2014-01-04');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (373, 841, 11, null, '2020-04-30');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (374, 762, 8, null, '2013-04-14');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (375, 338, 1, null, '2018-04-07');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (376, 697, 5, null, '2019-11-16');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (377, 383, 1, null, '2020-04-25');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (378, 778, 8, null, '2012-08-07');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (379, 781, 13, null, '2014-09-03');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (380, 272, 4, null, '2017-12-16');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (381, 50, 8, null, '2017-06-12');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (382, 250, 12, null, '2017-10-05');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (383, 242, 1, null, '2019-03-03');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (384, 82, 7, null, '2012-11-30');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (385, 767, 1, null, '2016-06-06');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (386, 276, 13, null, '2012-08-26');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (387, 740, 4, null, '2014-07-29');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (388, 460, 2, null, '2015-02-22');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (389, 847, 6, null, '2018-04-24');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (390, 714, 11, null, '2019-08-31');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (391, 704, 11, null, '2019-06-29');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (392, 493, 13, null, '2018-04-18');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (393, 539, 13, null, '2011-03-15');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (394, 810, 11, null, '2016-11-05');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (395, 270, 3, null, '2019-08-16');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (396, 646, 9, null, '2012-08-10');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (397, 33, 13, null, '2010-11-05');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (398, 49, 7, null, '2015-03-07');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (399, 847, 13, null, '2017-03-26');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (400, 608, 4, null, '2017-10-29');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (401, 814, 13, null, '2016-03-23');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (402, 592, 12, null, '2012-05-04');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (403, 346, 1, null, '2015-10-09');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (404, 799, 7, null, '2016-12-25');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (405, 374, 10, null, '2013-06-01');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (406, 605, 12, null, '2014-11-19');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (407, 372, 4, null, '2013-03-16');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (408, 41, 3, null, '2016-12-06');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (409, 340, 5, null, '2011-05-31');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (410, 769, 9, null, '2012-12-26');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (411, 18, 5, null, '2019-07-17');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (412, 231, 5, null, '2018-07-30');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (413, 663, 1, null, '2017-05-01');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (414, 62, 6, null, '2015-10-16');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (415, 69, 5, null, '2020-02-05');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (416, 816, 5, null, '2012-05-12');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (417, 812, 3, null, '2019-09-03');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (418, 126, 4, null, '2018-07-26');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (419, 394, 13, null, '2014-03-01');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (420, 388, 6, null, '2018-03-22');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (421, 830, 8, null, '2010-09-14');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (422, 670, 9, null, '2019-05-21');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (423, 770, 11, null, '2013-11-03');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (424, 578, 11, null, '2018-01-21');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (425, 330, 12, null, '2019-11-26');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (426, 459, 6, null, '2017-10-08');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (427, 613, 9, null, '2017-10-03');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (428, 377, 10, null, '2010-05-18');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (429, 497, 1, null, '2019-03-14');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (430, 91, 12, null, '2016-11-21');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (431, 371, 11, null, '2016-12-27');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (432, 554, 2, null, '2011-12-01');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (433, 256, 2, null, '2010-11-24');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (434, 819, 9, null, '2019-12-19');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (435, 78, 10, null, '2013-07-11');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (436, 30, 11, null, '2010-05-04');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (437, 696, 2, null, '2017-07-16');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (438, 719, 3, null, '2011-05-02');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (439, 9, 10, null, '2019-02-01');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (440, 825, 7, null, '2013-07-17');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (441, 448, 6, null, '2018-09-24');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (442, 830, 2, null, '2017-05-20');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (443, 14, 7, null, '2015-11-20');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (444, 748, 9, null, '2017-12-09');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (445, 100, 4, null, '2018-04-01');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (446, 222, 9, null, '2015-05-11');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (447, 648, 1, null, '2019-03-09');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (448, 574, 10, null, '2011-05-13');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (449, 373, 13, null, '2016-04-01');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (450, 791, 9, null, '2019-12-15');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (451, 572, 6, null, '2014-05-11');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (452, 466, 6, null, '2013-11-29');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (453, 810, 11, null, '2016-09-16');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (454, 577, 2, null, '2019-01-17');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (455, 663, 5, null, '2011-07-13');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (456, 144, 6, null, '2015-02-12');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (457, 735, 7, null, '2019-07-15');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (458, 128, 4, null, '2013-03-07');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (459, 781, 8, null, '2012-06-30');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (460, 719, 3, null, '2012-03-30');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (461, 511, 5, null, '2016-08-05');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (462, 337, 6, null, '2013-06-01');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (463, 419, 12, null, '2011-08-17');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (464, 564, 1, null, '2010-12-28');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (465, 807, 8, null, '2016-04-04');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (466, 780, 8, null, '2015-12-25');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (467, 638, 11, null, '2018-12-22');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (468, 770, 4, null, '2012-02-29');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (469, 718, 11, null, '2016-10-13');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (470, 690, 3, null, '2010-06-18');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (471, 712, 11, null, '2018-03-21');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (472, 556, 9, null, '2014-03-10');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (473, 32, 2, null, '2016-03-05');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (474, 166, 9, null, '2012-01-16');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (475, 800, 4, null, '2015-02-24');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (476, 684, 13, null, '2018-07-13');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (477, 163, 12, null, '2020-02-22');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (478, 194, 1, null, '2011-10-30');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (479, 434, 12, null, '2019-07-24');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (480, 140, 3, null, '2012-06-09');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (481, 618, 5, null, '2018-05-21');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (482, 616, 2, null, '2013-05-08');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (483, 729, 1, null, '2017-02-07');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (484, 125, 7, null, '2013-06-09');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (485, 29, 5, null, '2013-05-08');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (486, 299, 3, null, '2013-11-23');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (487, 136, 11, null, '2011-09-19');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (488, 443, 8, null, '2015-09-24');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (489, 808, 1, null, '2010-12-26');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (490, 587, 6, null, '2017-07-31');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (491, 200, 4, null, '2015-04-25');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (492, 106, 12, null, '2016-10-28');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (493, 229, 8, null, '2012-03-27');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (494, 526, 10, null, '2013-11-30');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (495, 522, 8, null, '2019-11-03');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (496, 309, 2, null, '2012-02-02');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (497, 850, 10, null, '2010-05-07');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (498, 473, 12, null, '2010-05-26');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (499, 9, 2, null, '2017-07-25');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (500, 418, 5, null, '2015-06-28');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (501, 98, 7, null, '2015-10-05');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (502, 798, 11, null, '2018-05-22');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (503, 375, 6, null, '2013-07-31');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (504, 19, 12, null, '2020-02-11');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (505, 587, 9, null, '2015-11-12');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (506, 172, 10, null, '2018-05-04');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (507, 686, 10, null, '2018-08-21');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (508, 512, 6, null, '2010-12-04');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (509, 750, 9, null, '2012-04-29');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (510, 172, 10, null, '2018-11-17');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (511, 829, 12, null, '2016-07-10');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (512, 156, 3, null, '2013-08-18');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (513, 639, 5, null, '2017-11-30');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (514, 343, 8, null, '2013-05-30');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (515, 595, 5, null, '2017-09-29');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (516, 773, 10, null, '2019-05-23');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (517, 354, 12, null, '2014-05-04');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (518, 223, 7, null, '2012-01-21');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (519, 790, 3, null, '2017-04-08');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (520, 721, 10, null, '2014-09-07');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (521, 137, 13, null, '2017-08-29');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (522, 452, 3, null, '2015-07-19');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (523, 107, 7, null, '2015-03-26');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (524, 14, 10, null, '2016-04-13');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (525, 146, 6, null, '2018-01-31');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (526, 204, 13, null, '2017-07-10');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (527, 817, 7, null, '2010-08-27');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (528, 166, 6, null, '2010-09-25');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (529, 678, 8, null, '2014-01-20');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (530, 398, 12, null, '2011-09-15');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (531, 461, 9, null, '2018-12-15');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (532, 765, 5, null, '2017-08-04');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (533, 74, 6, null, '2017-11-07');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (534, 13, 12, null, '2013-11-09');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (535, 700, 8, null, '2015-01-26');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (536, 394, 8, null, '2013-01-20');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (537, 591, 1, null, '2011-11-12');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (538, 553, 5, null, '2012-01-11');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (539, 329, 8, null, '2014-10-31');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (540, 410, 13, null, '2018-09-06');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (541, 787, 2, null, '2018-02-16');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (542, 53, 12, null, '2010-12-25');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (543, 199, 7, null, '2010-09-24');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (544, 384, 11, null, '2019-03-24');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (545, 100, 4, null, '2017-02-09');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (546, 512, 8, null, '2015-06-21');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (547, 694, 5, null, '2015-05-10');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (548, 104, 10, null, '2016-01-16');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (549, 77, 2, null, '2014-07-07');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (550, 556, 10, null, '2013-03-04');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (551, 428, 8, null, '2014-03-22');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (552, 849, 11, null, '2019-07-23');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (553, 257, 4, null, '2012-11-10');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (554, 223, 1, null, '2015-11-19');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (555, 372, 13, null, '2013-03-23');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (556, 462, 12, null, '2010-08-13');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (557, 265, 2, null, '2014-08-15');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (558, 411, 7, null, '2018-02-09');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (559, 821, 6, null, '2014-02-27');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (560, 355, 2, null, '2011-05-12');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (561, 760, 5, null, '2014-03-19');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (562, 601, 3, null, '2016-05-07');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (563, 626, 5, null, '2016-01-15');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (564, 318, 9, null, '2016-03-22');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (565, 308, 2, null, '2017-03-09');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (566, 654, 3, null, '2015-09-15');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (567, 762, 6, null, '2018-09-12');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (568, 231, 7, null, '2019-06-04');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (569, 159, 1, null, '2019-06-21');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (570, 563, 2, null, '2019-07-19');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (571, 580, 11, null, '2016-11-26');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (572, 203, 11, null, '2011-01-18');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (573, 620, 4, null, '2014-11-20');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (574, 820, 10, null, '2015-02-26');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (575, 168, 1, null, '2020-01-15');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (576, 849, 4, null, '2010-11-09');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (577, 368, 5, null, '2015-10-12');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (578, 540, 13, null, '2017-09-06');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (579, 446, 13, null, '2018-03-06');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (580, 639, 2, null, '2012-12-08');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (581, 129, 4, null, '2020-04-24');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (582, 235, 12, null, '2015-02-03');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (583, 218, 5, null, '2011-06-16');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (584, 29, 11, null, '2016-05-15');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (585, 99, 11, null, '2012-05-25');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (586, 680, 6, null, '2011-05-25');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (587, 80, 1, null, '2012-02-21');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (588, 16, 6, null, '2011-08-20');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (589, 295, 10, null, '2019-09-12');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (590, 602, 9, null, '2010-08-03');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (591, 586, 6, null, '2012-10-31');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (592, 342, 6, null, '2014-05-29');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (593, 359, 9, null, '2015-01-05');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (594, 280, 2, null, '2016-08-29');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (595, 679, 13, null, '2010-09-10');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (596, 758, 11, null, '2012-09-30');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (597, 59, 10, null, '2016-11-13');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (598, 231, 12, null, '2019-12-17');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (599, 260, 8, null, '2019-06-15');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (600, 366, 7, null, '2015-04-13');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (601, 101, 4, null, '2018-10-07');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (602, 436, 3, null, '2014-02-20');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (603, 632, 12, null, '2015-04-13');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (604, 276, 11, null, '2016-03-18');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (605, 719, 1, null, '2015-10-12');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (606, 15, 8, null, '2016-04-10');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (607, 414, 4, null, '2011-10-31');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (608, 40, 2, null, '2019-04-28');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (609, 674, 11, null, '2010-06-24');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (610, 34, 7, null, '2016-07-02');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (611, 156, 6, null, '2014-04-18');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (612, 526, 2, null, '2012-05-15');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (613, 181, 9, null, '2017-08-28');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (614, 361, 5, null, '2014-12-21');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (615, 828, 2, null, '2012-12-24');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (616, 372, 8, null, '2017-11-13');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (617, 833, 2, null, '2012-04-11');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (618, 659, 11, null, '2014-02-23');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (619, 535, 9, null, '2016-03-14');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (620, 434, 13, null, '2016-02-20');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (621, 415, 13, null, '2013-05-18');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (622, 559, 8, null, '2011-08-12');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (623, 603, 13, null, '2018-10-09');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (624, 188, 3, null, '2019-06-27');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (625, 602, 7, null, '2016-10-28');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (626, 277, 8, null, '2014-11-10');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (627, 830, 7, null, '2018-01-16');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (628, 11, 4, null, '2016-07-11');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (629, 281, 1, null, '2016-06-12');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (630, 221, 4, null, '2013-08-09');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (631, 379, 11, null, '2012-07-28');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (632, 770, 8, null, '2017-03-22');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (633, 182, 9, null, '2014-04-03');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (634, 190, 5, null, '2012-06-05');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (635, 278, 9, null, '2011-07-23');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (636, 479, 3, null, '2015-09-12');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (637, 303, 13, null, '2015-01-21');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (638, 590, 6, null, '2015-08-08');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (639, 35, 1, null, '2019-09-01');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (640, 542, 2, null, '2020-05-04');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (641, 522, 7, null, '2016-01-28');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (642, 216, 2, null, '2020-01-08');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (643, 9, 3, null, '2010-05-15');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (644, 361, 2, null, '2014-07-25');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (645, 368, 11, null, '2013-02-21');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (646, 272, 6, null, '2015-08-27');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (647, 515, 10, null, '2019-05-07');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (648, 254, 8, null, '2013-02-04');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (649, 509, 11, null, '2014-11-11');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (650, 279, 12, null, '2019-10-10');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (651, 270, 7, null, '2018-08-29');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (652, 568, 3, null, '2019-11-03');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (653, 377, 9, null, '2017-07-10');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (654, 470, 10, null, '2018-06-01');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (655, 145, 13, null, '2015-07-20');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (656, 225, 9, null, '2019-02-10');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (657, 498, 12, null, '2015-04-13');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (658, 53, 5, null, '2010-07-06');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (659, 353, 7, null, '2014-09-13');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (660, 839, 3, null, '2014-03-10');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (661, 468, 5, null, '2018-12-15');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (662, 681, 7, null, '2017-11-06');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (663, 477, 2, null, '2013-08-13');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (664, 322, 6, null, '2010-09-22');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (665, 252, 12, null, '2016-07-09');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (666, 561, 11, null, '2014-03-04');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (667, 682, 9, null, '2016-09-13');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (668, 616, 8, null, '2020-04-16');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (669, 760, 10, null, '2018-04-12');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (670, 304, 3, null, '2019-08-08');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (671, 824, 6, null, '2013-10-31');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (672, 328, 11, null, '2014-07-20');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (673, 591, 11, null, '2018-02-07');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (674, 659, 12, null, '2019-06-25');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (675, 323, 4, null, '2015-10-17');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (676, 835, 9, null, '2016-04-24');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (677, 330, 13, null, '2018-05-18');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (678, 367, 3, null, '2019-12-21');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (679, 588, 2, null, '2014-04-13');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (680, 166, 9, null, '2019-12-27');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (681, 77, 12, null, '2012-02-24');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (682, 833, 7, null, '2014-06-10');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (683, 30, 7, null, '2018-11-07');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (684, 463, 2, null, '2016-07-18');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (685, 5, 11, null, '2012-10-17');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (686, 433, 7, null, '2011-08-21');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (687, 183, 7, null, '2017-07-23');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (688, 259, 5, null, '2012-08-12');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (689, 382, 7, null, '2017-04-09');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (690, 693, 6, null, '2011-07-28');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (691, 431, 5, null, '2019-02-02');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (692, 658, 7, null, '2016-04-19');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (693, 367, 8, null, '2013-03-10');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (694, 144, 1, null, '2011-01-26');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (695, 556, 6, null, '2011-01-10');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (696, 695, 7, null, '2012-03-23');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (697, 425, 10, null, '2012-06-03');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (698, 345, 9, null, '2013-06-09');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (699, 79, 10, null, '2018-02-02');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (700, 443, 9, null, '2017-03-11');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (701, 153, 8, null, '2017-01-08');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (702, 78, 12, null, '2014-05-15');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (703, 628, 2, null, '2013-05-22');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (704, 419, 8, null, '2016-02-14');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (705, 460, 6, null, '2017-04-24');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (706, 556, 2, null, '2015-10-16');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (707, 243, 10, null, '2010-12-10');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (708, 797, 11, null, '2017-04-25');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (709, 178, 5, null, '2013-01-02');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (710, 449, 9, null, '2018-12-09');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (711, 704, 4, null, '2016-11-24');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (712, 575, 10, null, '2012-10-31');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (713, 351, 10, null, '2016-07-10');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (714, 227, 10, null, '2015-05-12');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (715, 778, 10, null, '2012-05-28');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (716, 192, 2, null, '2017-07-16');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (717, 310, 7, null, '2011-12-11');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (718, 410, 2, null, '2015-07-03');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (719, 303, 10, null, '2017-06-20');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (720, 32, 13, null, '2020-02-29');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (721, 518, 5, null, '2017-10-15');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (722, 259, 12, null, '2015-01-03');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (723, 687, 2, null, '2019-08-02');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (724, 263, 1, null, '2013-04-03');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (725, 428, 8, null, '2014-04-26');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (726, 423, 5, null, '2019-03-18');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (727, 34, 1, null, '2010-10-20');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (728, 137, 7, null, '2014-02-17');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (729, 715, 8, null, '2014-11-25');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (730, 305, 8, null, '2019-05-18');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (731, 258, 13, null, '2018-03-01');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (732, 540, 11, null, '2015-10-31');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (733, 123, 6, null, '2011-05-21');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (734, 24, 10, null, '2014-12-12');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (735, 313, 7, null, '2017-08-21');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (736, 39, 11, null, '2010-07-15');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (737, 577, 10, null, '2012-03-29');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (738, 784, 5, null, '2016-06-06');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (739, 232, 13, null, '2013-11-07');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (740, 682, 10, null, '2011-12-30');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (741, 83, 3, null, '2012-12-31');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (742, 507, 4, null, '2013-08-29');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (743, 180, 2, null, '2018-09-27');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (744, 26, 5, null, '2017-03-05');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (745, 639, 9, null, '2019-04-18');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (746, 620, 5, null, '2012-02-24');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (747, 503, 7, null, '2019-06-21');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (748, 745, 2, null, '2017-08-29');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (749, 261, 1, null, '2014-07-17');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (750, 416, 9, null, '2013-11-22');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (751, 426, 12, null, '2010-08-23');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (752, 175, 2, null, '2017-01-11');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (753, 305, 9, null, '2013-12-02');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (754, 457, 10, null, '2014-07-25');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (755, 8, 5, null, '2015-08-22');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (756, 620, 1, null, '2012-04-06');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (757, 224, 4, null, '2012-03-18');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (758, 389, 3, null, '2014-05-21');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (759, 25, 10, null, '2010-05-02');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (760, 599, 5, null, '2016-10-04');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (761, 356, 9, null, '2013-07-31');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (762, 418, 2, null, '2016-01-12');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (763, 91, 11, null, '2018-08-20');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (764, 761, 10, null, '2015-08-22');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (765, 490, 13, null, '2015-01-28');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (766, 700, 11, null, '2014-10-01');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (767, 512, 11, null, '2018-03-10');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (768, 699, 11, null, '2016-07-03');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (769, 257, 2, null, '2011-05-10');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (770, 278, 3, null, '2016-12-13');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (771, 243, 2, null, '2011-08-11');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (772, 217, 1, null, '2019-03-03');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (773, 183, 13, null, '2013-01-22');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (774, 30, 4, null, '2015-07-27');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (775, 679, 3, null, '2013-02-26');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (776, 794, 13, null, '2015-05-14');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (777, 111, 4, null, '2010-08-23');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (778, 739, 13, null, '2014-02-18');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (779, 151, 7, null, '2016-04-08');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (780, 498, 5, null, '2017-03-26');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (781, 626, 4, null, '2018-09-04');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (782, 401, 6, null, '2012-11-21');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (783, 593, 9, null, '2020-04-18');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (784, 733, 13, null, '2016-08-23');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (785, 564, 12, null, '2014-05-15');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (786, 229, 7, null, '2019-02-22');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (787, 168, 6, null, '2014-08-26');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (788, 267, 6, null, '2011-04-06');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (789, 765, 3, null, '2015-06-30');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (790, 46, 8, null, '2018-10-26');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (791, 531, 9, null, '2012-06-08');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (792, 332, 11, null, '2018-09-21');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (793, 86, 2, null, '2012-11-24');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (794, 271, 7, null, '2017-05-20');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (795, 132, 12, null, '2019-05-04');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (796, 523, 13, null, '2017-03-14');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (797, 837, 1, null, '2014-04-06');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (798, 503, 6, null, '2013-08-28');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (799, 329, 2, null, '2012-12-01');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (800, 17, 6, null, '2011-04-01');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (801, 75, 10, null, '2012-09-13');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (802, 23, 8, null, '2011-08-27');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (803, 16, 11, null, '2011-08-29');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (804, 352, 2, null, '2016-01-31');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (805, 579, 7, null, '2010-05-16');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (806, 147, 3, null, '2019-10-31');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (807, 721, 6, null, '2011-07-08');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (808, 142, 6, null, '2018-04-20');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (809, 841, 8, null, '2015-10-20');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (810, 25, 10, null, '2019-01-01');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (811, 578, 7, null, '2018-01-05');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (812, 65, 13, null, '2016-03-22');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (813, 709, 6, null, '2014-11-08');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (814, 312, 2, null, '2019-06-09');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (815, 482, 1, null, '2014-06-15');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (816, 387, 5, null, '2011-07-18');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (817, 238, 11, null, '2011-11-24');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (818, 321, 2, null, '2011-06-05');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (819, 428, 4, null, '2018-05-23');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (820, 408, 5, null, '2017-06-17');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (821, 110, 7, null, '2013-03-22');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (822, 579, 1, null, '2014-04-15');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (823, 52, 2, null, '2016-09-14');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (824, 75, 6, null, '2011-08-18');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (825, 181, 10, null, '2014-07-04');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (826, 629, 4, null, '2013-06-16');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (827, 333, 7, null, '2014-10-26');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (828, 435, 5, null, '2013-03-13');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (829, 586, 8, null, '2017-09-02');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (830, 358, 10, null, '2014-03-15');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (831, 485, 6, null, '2015-06-10');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (832, 578, 9, null, '2011-10-22');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (833, 811, 11, null, '2012-03-12');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (834, 395, 7, null, '2010-05-01');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (835, 610, 4, null, '2012-05-17');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (836, 257, 3, null, '2016-04-13');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (837, 168, 10, null, '2015-10-25');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (838, 811, 8, null, '2016-06-16');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (839, 81, 1, null, '2018-11-27');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (840, 819, 2, null, '2014-10-31');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (841, 724, 12, null, '2013-05-21');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (842, 129, 6, null, '2019-06-08');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (843, 289, 4, null, '2011-05-19');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (844, 664, 9, null, '2019-06-22');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (845, 649, 10, null, '2018-05-29');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (846, 380, 1, null, '2014-06-10');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (847, 455, 10, null, '2011-07-02');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (848, 157, 5, null, '2013-04-03');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (849, 782, 4, null, '2017-05-07');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (850, 591, 8, null, '2019-12-13');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (851, 508, 3, null, '2013-05-15');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (852, 5, 1, null, '2010-08-22');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (853, 6, 5, null, '2011-06-15');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (854, 426, 12, null, '2014-12-18');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (855, 79, 10, null, '2015-04-02');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (856, 7, 10, null, '2012-08-01');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (857, 850, 2, null, '2017-02-13');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (858, 138, 13, null, '2012-12-31');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (859, 628, 3, null, '2014-02-04');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (860, 661, 9, null, '2018-03-25');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (861, 813, 2, null, '2010-05-17');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (862, 400, 6, null, '2012-05-27');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (863, 661, 2, null, '2016-04-09');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (864, 165, 13, null, '2016-12-13');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (865, 205, 7, null, '2017-12-01');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (866, 221, 3, null, '2010-06-23');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (867, 801, 12, null, '2012-02-21');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (868, 741, 12, null, '2018-06-28');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (869, 388, 6, null, '2010-10-12');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (870, 283, 2, null, '2018-05-22');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (871, 77, 13, null, '2016-06-14');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (872, 374, 9, null, '2018-11-25');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (873, 260, 7, null, '2014-01-11');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (874, 458, 5, null, '2010-07-22');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (875, 593, 3, null, '2015-10-17');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (876, 815, 9, null, '2020-01-18');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (877, 641, 5, null, '2020-03-30');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (878, 191, 4, null, '2013-10-15');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (879, 117, 3, null, '2010-09-09');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (880, 283, 9, null, '2012-08-12');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (881, 827, 11, null, '2015-06-07');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (882, 118, 10, null, '2011-12-27');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (883, 254, 11, null, '2015-01-15');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (884, 476, 13, null, '2015-05-26');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (885, 612, 2, null, '2013-12-28');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (886, 618, 1, null, '2018-04-20');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (887, 188, 1, null, '2011-02-01');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (888, 30, 2, null, '2013-10-07');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (889, 774, 13, null, '2014-09-12');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (890, 639, 8, null, '2011-10-05');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (891, 38, 2, null, '2014-08-30');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (892, 351, 13, null, '2013-12-07');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (893, 282, 11, null, '2017-04-02');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (894, 546, 5, null, '2011-03-09');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (895, 448, 8, null, '2013-03-18');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (896, 503, 3, null, '2019-03-18');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (897, 267, 8, null, '2017-10-29');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (898, 434, 2, null, '2019-09-09');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (899, 154, 2, null, '2010-07-07');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (900, 459, 8, null, '2011-02-10');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (901, 549, 13, null, '2014-06-03');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (902, 134, 7, null, '2015-07-31');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (903, 334, 5, null, '2015-06-17');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (904, 785, 6, null, '2016-06-13');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (905, 483, 11, null, '2014-07-21');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (906, 55, 4, null, '2018-08-26');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (907, 459, 4, null, '2012-01-07');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (908, 781, 4, null, '2014-04-20');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (909, 586, 3, null, '2019-12-25');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (910, 24, 9, null, '2016-08-01');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (911, 390, 11, null, '2016-04-16');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (912, 173, 11, null, '2017-11-10');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (913, 827, 1, null, '2013-03-29');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (914, 316, 2, null, '2013-01-30');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (915, 744, 11, null, '2010-05-27');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (916, 1, 12, null, '2017-11-11');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (917, 556, 7, null, '2012-01-13');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (918, 807, 13, null, '2014-03-15');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (919, 73, 8, null, '2015-07-19');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (920, 466, 10, null, '2016-06-19');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (921, 638, 11, null, '2019-09-29');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (922, 120, 6, null, '2017-05-09');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (923, 107, 9, null, '2017-07-06');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (924, 218, 6, null, '2011-03-16');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (925, 331, 8, null, '2018-10-27');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (926, 70, 1, null, '2015-12-17');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (927, 639, 3, null, '2015-01-10');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (928, 201, 13, null, '2013-11-10');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (929, 250, 10, null, '2017-09-20');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (930, 217, 9, null, '2019-04-24');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (931, 121, 7, null, '2010-09-13');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (932, 660, 11, null, '2016-06-30');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (933, 158, 13, null, '2012-04-13');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (934, 356, 9, null, '2020-03-09');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (935, 34, 5, null, '2019-10-26');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (936, 612, 5, null, '2019-02-11');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (937, 824, 9, null, '2012-11-23');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (938, 98, 3, null, '2015-03-31');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (939, 723, 4, null, '2013-09-30');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (940, 707, 6, null, '2011-03-21');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (941, 75, 12, null, '2014-09-02');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (942, 566, 7, null, '2012-01-10');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (943, 531, 7, null, '2018-08-12');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (944, 72, 2, null, '2013-12-07');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (945, 139, 12, null, '2015-08-23');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (946, 695, 10, null, '2019-01-06');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (947, 154, 9, null, '2014-08-26');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (948, 212, 3, null, '2018-03-14');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (949, 559, 8, null, '2017-11-07');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (950, 168, 11, null, '2018-11-17');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (951, 712, 6, null, '2011-09-04');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (952, 200, 13, null, '2018-12-20');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (953, 789, 7, null, '2017-12-01');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (954, 221, 8, null, '2018-09-15');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (955, 588, 7, null, '2016-01-09');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (956, 188, 9, null, '2017-03-16');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (957, 550, 7, null, '2012-04-17');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (958, 445, 13, null, '2010-05-02');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (959, 582, 4, null, '2020-01-25');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (960, 325, 7, null, '2019-03-24');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (961, 780, 12, null, '2020-04-21');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (962, 848, 4, null, '2010-07-16');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (963, 508, 10, null, '2017-05-22');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (964, 413, 12, null, '2018-04-19');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (965, 779, 3, null, '2018-11-22');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (966, 277, 12, null, '2012-08-18');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (967, 347, 13, null, '2011-12-26');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (968, 313, 11, null, '2016-12-27');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (969, 69, 7, null, '2019-11-18');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (970, 324, 6, null, '2018-02-04');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (971, 140, 5, null, '2019-10-14');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (972, 275, 13, null, '2013-10-06');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (973, 487, 11, null, '2010-10-29');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (974, 520, 13, null, '2019-04-08');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (975, 198, 13, null, '2014-10-14');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (976, 86, 4, null, '2016-07-16');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (977, 234, 9, null, '2017-04-01');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (978, 91, 8, null, '2012-03-07');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (979, 110, 6, null, '2013-02-13');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (980, 121, 3, null, '2016-07-13');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (981, 771, 3, null, '2019-03-07');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (982, 181, 13, null, '2014-05-30');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (983, 193, 8, null, '2011-07-20');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (984, 532, 4, null, '2014-02-08');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (985, 541, 5, null, '2020-02-23');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (986, 213, 13, null, '2017-05-26');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (987, 2, 1, null, '2015-12-06');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (988, 24, 7, null, '2017-05-14');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (989, 39, 11, null, '2015-11-06');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (990, 467, 2, null, '2014-01-11');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (991, 685, 7, null, '2015-04-13');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (992, 745, 9, null, '2011-06-01');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (993, 628, 3, null, '2018-07-13');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (994, 464, 12, null, '2013-09-05');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (995, 85, 7, null, '2015-12-30');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (996, 693, 5, null, '2016-01-07');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (997, 540, 13, null, '2014-04-14');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (998, 777, 8, null, '2018-01-14');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (999, 146, 10, null, '2018-09-02');
insert into Games_Installs (InstallID, UserID, GameID, GameName, DateInstalled) values (1000, 264, 4, null, '2017-11-13');
GO

/*
	SELECT * FROM Games_Installs GI JOIN Games G ON GI.GameID = G.GameID WHERE GI.DateInstalled > G.DatePublished
	SELECT * FROM Games_Installs

	BEGIN TRANSACTION
*/ 

-- A command to delete all Games_Installs rows that their actual GI.DateInstalled is before the actual publish date of the game because I added randomized data from Mockaroo
	DELETE FROM games_installs 
	WHERE UserID IN (
						SELECT DISTINCT GI.UserID
						FROM games_installs GI JOIN games G
						ON GI.GameID = G.GameID
						WHERE GI.DateInstalled < G.DatePublished
					 )

-- A command to update the gamename in the table
UPDATE Games_Installs SET GameName = G.GameName FROM Games G JOIN Games_Installs GI ON G.GameID =  GI.GameID


-- Inputting data into Sessions Table
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (285, 9, 772, '2015-10-08 21:38:45', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (993, 7, 35, '2020-01-07 01:56:37', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (706, 6, 132, '2016-10-20 17:17:16', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (571, 9, 595, '2019-10-03 13:32:19', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (562, 3, 550, '2020-01-03 12:10:42', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (18, 11, 235, '2013-09-06 20:02:50', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (414, 9, 406, '2013-04-18 19:25:56', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (217, 2, 630, '2010-01-14 07:30:33', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (291, 8, 739, '2013-09-25 04:27:18', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (472, null, 803, '2018-12-25 08:57:25', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (85, 8, 723, '2018-05-12 04:17:04', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (999, 11, 604, '2016-09-14 05:32:33', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (172, 11, 375, '2010-03-17 01:04:55', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (524, 6, 83, '2017-12-09 12:01:10', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (614, 3, 747, '2018-11-05 09:47:13', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (198, 1, 287, '2018-03-23 21:52:07', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (228, 10, 309, '2014-07-06 11:29:14', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (388, 11, 560, '2013-03-31 05:04:12', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (163, 5, 591, '2014-01-03 03:44:35', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (768, 9, 499, '2012-05-08 01:21:05', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (33, 11, 778, '2012-11-23 03:25:14', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (705, 3, 145, '2010-07-21 23:13:55', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (766, 5, 15, '2015-05-04 13:24:49', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (809, 4, 593, '2020-07-22 13:41:13', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (819, 3, 204, '2020-07-06 21:04:24', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (223, 8, 665, '2015-04-26 02:58:39', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (559, 9, 770, '2015-12-08 12:40:57', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (165, 8, 479, '2014-09-09 07:50:26', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (254, 9, 397, '2014-07-03 03:09:31', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (689, 2, 798, '2015-07-10 10:42:33', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (813, 9, 125, '2016-01-02 13:59:15', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (57, 3, 757, '2017-03-16 09:18:09', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (19, 7, 399, '2011-06-01 01:51:56', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (835, 6, 553, '2014-07-05 18:27:55', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (364, 2, 458, '2011-07-21 09:46:21', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1361, 8, 389, '2012-02-26 00:01:01', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (982, 2, 262, '2011-11-28 17:53:49', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (405, 9, 678, '2011-07-17 01:32:10', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (139, 3, 741, '2010-01-08 22:58:41', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (277, 1, 515, '2011-04-02 14:41:50', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1362, 4, 715, '2013-11-17 02:22:05', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (871, 7, 557, '2015-10-02 11:55:52', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (592, 7, 564, '2017-01-21 03:28:14', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (868, 13, 789, '2012-10-26 15:47:54', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (356, 3, 663, '2014-09-06 23:33:48', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (613, 7, 804, '2015-10-27 16:43:05', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (288, 10, 156, '2010-10-18 14:11:13', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (119, 8, 786, '2018-04-05 01:15:53', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (467, 12, 59, '2014-06-13 07:56:10', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (477, 4, 419, '2017-05-25 05:04:35', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (570, 4, 609, '2013-09-11 01:56:58', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (634, 5, 677, '2010-12-20 06:28:43', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (915, 2, 359, '2018-05-19 16:33:05', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (646, 7, 87, '2017-10-04 12:30:22', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (750, 10, 414, '2016-03-14 20:16:01', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (719, 1, 264, '2010-01-13 23:22:13', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (525, 11, 373, '2015-10-12 15:15:38', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (36, 5, 596, '2010-05-09 22:03:36', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (785, 11, 409, '2014-09-14 14:55:36', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (430, 10, 258, '2010-04-08 21:37:30', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1001, 13, 443, '2010-11-30 09:00:10', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1002, 3, 715, '2018-10-14 02:43:13', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (118, 13, 310, '2013-08-26 10:31:23', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (435, 12, 703, '2019-03-08 06:37:04', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (428, 7, 11, '2014-05-02 12:26:30', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1003, 12, 93, '2015-05-26 18:20:52', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (779, 5, 175, '2016-05-08 14:38:08', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1, 10, 747, '2010-07-19 10:05:51', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (940, 12, 848, '2013-03-16 02:24:14', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (700, 11, 392, '2015-05-21 08:22:13', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1004, 1, 237, '2019-03-03 06:09:06', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (275, 13, 275, '2014-07-13 09:36:08', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (440, 9, 347, '2011-07-15 14:18:04', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (612, 8, 247, '2013-11-20 23:18:00', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (332, 4, 474, '2012-07-23 05:17:00', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (424, 5, 598, '2014-08-31 20:33:27', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (76, 3, 587, '2012-09-09 10:34:37', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (174, 4, 603, '2015-03-08 00:17:35', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (175, 9, 226, '2012-08-19 20:51:13', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (797, 8, 505, '2014-02-12 03:15:24', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (34, 2, 511, '2016-12-29 06:39:23', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (231, 11, 257, '2019-06-21 22:49:11', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (591, 5, 466, '2010-03-08 00:05:00', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (90, 11, 745, '2015-01-01 18:54:51', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (842, 10, 275, '2016-03-18 06:27:39', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (596, 6, 766, '2015-04-09 17:36:36', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (710, 3, 93, '2013-09-04 16:24:18', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (373, 11, 259, '2019-11-11 10:54:28', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (704, 2, 429, '2017-06-12 16:55:26', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (973, 1, 370, '2014-11-14 01:26:54', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (599, null, 448, '2019-08-29 00:09:04', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (523, 8, 127, '2016-03-05 05:50:49', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (216, 8, 179, '2012-03-01 22:19:15', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (453, 6, 520, '2017-08-20 19:43:59', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (858, 7, 140, '2020-06-27 14:59:46', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (310, 6, 475, '2014-06-25 23:45:03', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (282, 1, 576, '2017-06-26 04:45:40', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (821, 10, 176, '2016-05-09 00:28:52', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (349, 7, 200, '2019-07-18 10:50:25', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (507, 12, 226, '2018-12-16 03:04:31', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (521, 6, 129, '2012-03-26 08:16:29', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1005, 3, 586, '2014-01-25 22:14:43', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (26, 13, 621, '2011-01-05 02:38:23', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (296, null, 400, '2016-04-10 11:06:10', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (59, 13, 18, '2012-08-05 06:39:47', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (9, 7, 807, '2010-09-27 00:52:56', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (129, 9, 203, '2011-03-17 11:50:08', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (446, 13, 496, '2013-07-03 05:43:54', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (448, 13, 744, '2017-03-31 13:47:21', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1006, 10, 75, '2017-06-03 14:52:04', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (230, 13, 382, '2016-04-18 13:43:13', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (251, 3, 24, '2015-05-07 10:06:39', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (588, 12, 85, '2012-03-03 00:04:14', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (15, 1, 596, '2020-07-25 12:02:49', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (952, 11, 524, '2016-07-31 07:19:32', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (236, 6, 608, '2012-11-17 19:32:49', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (913, 3, 317, '2013-03-01 11:59:22', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (765, 9, 130, '2018-01-03 05:28:22', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (723, 9, 515, '2013-11-03 00:44:11', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (625, 5, 28, '2017-02-12 01:57:31', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (101, 12, 603, '2017-09-25 22:32:34', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (615, 12, 295, '2020-03-26 01:23:28', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (494, 8, 81, '2015-03-30 08:33:47', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (707, null, 221, '2019-01-25 23:32:50', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (110, 6, 783, '2014-11-26 22:57:20', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (878, 11, 781, '2019-06-07 11:59:46', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (8, 1, 276, '2015-05-19 07:28:19', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (692, 13, 174, '2018-03-31 11:02:45', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (518, 5, 243, '2012-03-16 16:29:42', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (12, null, 420, '2017-10-05 20:18:25', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (678, 1, 203, '2019-11-18 09:54:40', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (44, 8, 339, '2019-10-24 05:54:13', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (649, 11, 542, '2013-08-14 16:34:13', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (635, 5, 32, '2014-10-12 14:51:41', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (897, 6, 123, '2014-07-18 03:25:28', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (967, 12, 260, '2018-11-02 14:35:41', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (781, 8, 571, '2017-01-08 04:58:08', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (962, 11, 134, '2017-05-25 11:09:42', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (459, 13, 433, '2014-12-18 02:23:56', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (214, 11, 842, '2017-11-05 13:16:19', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1007, 1, 76, '2012-11-14 07:22:45', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1008, 11, 377, '2012-10-05 23:14:45', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (256, 4, 791, '2010-05-22 05:28:22', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1009, 4, 160, '2011-11-05 08:17:39', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (324, 2, 497, '2011-12-12 11:19:55', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (658, 10, 86, '2014-05-05 20:10:03', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (376, 10, 367, '2015-05-28 16:08:13', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (755, 11, 262, '2010-07-22 23:28:54', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (454, 1, 564, '2012-12-05 17:46:16', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (73, 1, 319, '2017-04-28 01:24:14', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (130, 11, 323, '2015-11-13 17:52:52', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (426, 3, 356, '2014-09-21 06:31:30', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (177, 5, 173, '2020-04-13 13:08:16', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (487, 12, 597, '2010-03-22 08:11:10', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1010, null, 235, '2010-11-14 16:01:34', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (969, 11, 598, '2019-05-27 09:58:21', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (697, 10, 173, '2016-02-19 12:36:08', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (680, 2, 677, '2012-09-22 19:19:18', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (97, 5, 799, '2020-06-03 12:29:53', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (167, 6, 423, '2015-03-05 05:55:57', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (439, 5, 45, '2010-08-08 17:16:06', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (786, 5, 361, '2016-10-21 21:56:04', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (407, 5, 412, '2011-05-04 14:42:29', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (199, 5, 389, '2014-07-13 20:26:48', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (991, 8, 794, '2010-08-04 01:12:05', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (825, 2, 338, '2016-01-24 04:40:19', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (313, 12, 843, '2011-02-14 22:26:27', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (889, 6, 166, '2019-04-22 22:57:36', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (357, 9, 194, '2020-07-27 08:45:40', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (925, 11, 840, '2018-03-25 05:38:04', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (517, 7, 465, '2018-10-04 22:54:36', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (415, 7, 116, '2017-10-02 16:05:54', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (286, 9, 226, '2017-10-18 22:30:06', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1011, 6, 294, '2010-07-12 22:37:09', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1012, 4, 159, '2015-09-18 23:56:37', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (959, 2, 43, '2019-08-01 12:27:15', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (209, 12, 269, '2015-02-11 03:02:37', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (203, 10, 219, '2012-06-18 01:09:17', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (693, 9, 349, '2013-03-06 03:56:53', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (746, 4, 798, '2014-08-01 08:24:37', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (71, 7, 466, '2015-12-30 13:53:07', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (682, 4, 403, '2013-03-04 08:23:34', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (385, 11, 709, '2016-06-08 15:44:11', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (636, 4, 833, '2015-10-28 01:54:24', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (669, 6, 196, '2013-04-02 01:56:59', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1013, 11, 677, '2013-01-18 21:30:13', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (239, 8, 254, '2015-12-23 19:20:07', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (633, 3, 100, '2018-12-03 00:39:43', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (47, 4, 501, '2013-10-11 20:42:46', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (328, 5, 416, '2010-06-07 06:31:03', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (473, 7, 831, '2016-08-11 10:12:42', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (735, 6, 398, '2015-05-02 02:14:17', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (416, 7, 805, '2013-11-07 23:41:48', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (10, null, 664, '2018-12-10 09:10:52', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (770, 7, 677, '2011-10-10 14:30:18', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (460, 12, 101, '2011-03-03 01:52:09', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (605, 9, 785, '2017-07-15 20:49:01', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1014, 4, 752, '2019-03-02 11:24:02', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1015, 10, 649, '2011-05-24 03:34:14', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (990, 6, 352, '2010-06-13 20:08:37', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (249, 3, 249, '2014-11-18 03:01:28', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (6, 5, 249, '2013-05-15 11:40:14', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (855, 11, 100, '2011-08-02 03:06:46', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1016, 13, 17, '2015-08-01 05:27:30', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1017, 13, 577, '2011-04-20 11:25:25', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (377, 6, 105, '2010-08-26 22:17:51', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (465, 12, 808, '2011-01-24 18:46:01', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (394, 8, 338, '2010-07-27 17:08:45', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (621, 5, 194, '2016-11-20 06:02:49', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (187, 3, 747, '2020-04-06 17:15:55', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (292, 7, 726, '2011-09-22 05:10:47', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (334, 1, 489, '2018-08-27 03:54:51', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (74, 6, 403, '2011-07-30 07:23:55', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (278, 4, 816, '2013-08-21 19:18:35', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (114, 1, 536, '2015-10-18 05:04:11', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (974, 13, 115, '2010-01-30 22:17:36', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1018, 4, 688, '2019-10-31 09:22:05', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (108, 13, 388, '2018-08-07 02:19:38', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (497, 9, 316, '2010-07-15 19:19:28', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (145, 3, 540, '2019-04-21 15:14:27', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (859, 11, 804, '2012-07-22 16:35:29', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (92, 7, 371, '2014-03-02 05:52:28', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1019, 4, 428, '2018-10-01 07:04:42', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (469, 5, 560, '2017-06-06 10:52:24', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (406, 4, 3, '2014-06-21 15:42:48', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (510, 13, 854, '2016-07-25 10:40:49', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1020, 6, 56, '2016-09-18 18:41:09', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (760, 3, 495, '2019-03-24 13:03:37', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (178, 1, 384, '2013-02-13 00:25:45', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (107, 11, 691, '2012-08-01 00:15:55', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (679, 13, 635, '2010-04-01 23:01:17', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (252, 11, 758, '2014-08-29 08:12:08', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (644, 5, 312, '2015-08-07 05:28:58', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (70, 8, 642, '2020-02-26 11:05:06', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1021, 2, 784, '2020-06-26 02:10:27', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (39, 7, 343, '2019-04-14 07:49:09', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (466, 11, 670, '2010-01-05 21:51:18', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (776, 11, 689, '2018-12-27 00:21:32', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (427, 11, 77, '2013-06-12 22:19:49', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (954, 7, 468, '2015-12-20 00:28:55', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1022, 2, 33, '2019-07-02 17:44:42', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (166, 7, 616, '2012-03-03 20:10:36', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (505, 4, 471, '2011-07-02 01:51:24', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (342, 13, 91, '2014-02-25 15:16:01', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (874, 9, 88, '2013-08-07 05:22:13', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1023, 8, 392, '2020-01-31 20:22:35', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1024, 8, 503, '2017-02-28 09:52:16', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (789, 8, 434, '2018-01-28 01:33:17', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (312, 1, 150, '2013-01-24 15:14:26', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (452, 3, 132, '2010-08-23 10:57:27', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1025, 2, 565, '2012-03-13 23:24:31', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (40, 8, 180, '2014-10-28 21:07:22', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1026, 1, 766, '2015-10-06 16:15:08', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (237, 5, 436, '2017-10-10 04:37:16', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (3, 9, 575, '2018-09-17 13:57:00', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (773, 10, 643, '2015-03-19 13:48:48', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (133, 1, 402, '2013-11-29 15:29:33', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1027, 3, 753, '2019-07-26 09:04:28', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1028, 7, 172, '2011-06-17 14:12:26', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (739, 1, 282, '2013-02-28 12:53:17', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (890, 3, 167, '2012-02-18 07:12:50', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (262, 7, 520, '2019-05-21 13:14:30', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1029, 6, 374, '2010-04-11 19:43:22', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (600, 4, 293, '2016-01-23 17:43:49', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (308, 10, 380, '2011-11-27 03:44:55', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (456, 3, 421, '2016-05-17 14:01:12', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (513, 8, 500, '2010-11-16 00:45:02', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (7, 1, 747, '2018-03-25 21:27:15', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (138, 3, 458, '2012-12-09 13:44:14', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (849, 4, 257, '2014-09-09 08:35:12', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (892, 11, 748, '2016-07-07 04:51:20', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1030, 5, 762, '2020-05-26 22:03:53', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (632, 12, 31, '2014-12-06 17:36:34', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (269, 4, 643, '2019-03-06 08:09:55', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1031, 6, 530, '2011-12-21 01:45:46', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (801, 11, 173, '2018-10-11 12:02:19', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (38, 1, 157, '2015-05-29 08:28:29', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (656, 7, 345, '2015-11-19 15:12:29', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (96, 4, 524, '2010-05-07 10:35:06', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (861, 12, 172, '2012-12-14 07:26:21', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (884, 6, 131, '2012-07-31 00:21:17', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (764, 3, 603, '2012-10-26 17:56:17', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (222, 13, 624, '2014-12-12 12:56:24', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1032, 9, 713, '2014-12-12 13:11:11', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1033, null, 70, '2020-06-15 07:01:49', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1034, 4, 375, '2016-02-10 14:29:00', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (751, 9, 290, '2020-07-21 04:50:22', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1035, 2, 292, '2019-06-13 05:48:46', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1036, 6, 340, '2014-05-08 18:54:16', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (24, 10, 158, '2015-06-29 22:04:27', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1037, 13, 196, '2019-10-02 08:29:48', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1038, 10, 515, '2014-07-01 15:04:06', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (215, 6, 44, '2020-08-27 05:04:19', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1039, 10, 38, '2018-12-15 12:45:24', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (852, null, 528, '2015-08-04 10:10:36', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (396, 8, 738, '2011-01-30 20:57:59', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (774, 9, 65, '2011-02-13 03:08:27', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (540, 11, 75, '2012-07-03 22:12:24', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (111, 9, 75, '2010-04-03 22:21:09', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1040, 7, 370, '2017-05-01 19:39:19', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (369, 12, 423, '2013-12-01 10:21:42', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (200, 8, 688, '2010-12-28 11:43:48', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1041, 10, 504, '2019-01-01 03:43:30', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1042, 7, 183, '2016-07-05 02:43:09', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1043, 12, 103, '2011-06-22 01:14:07', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (864, 7, 100, '2011-01-26 00:51:31', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (546, 5, 821, '2018-01-10 03:37:27', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (949, 7, 337, '2014-11-12 14:58:11', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1044, 8, 489, '2016-06-29 14:53:25', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (715, 5, 431, '2012-07-14 02:39:29', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1045, 9, 281, '2019-02-28 00:18:50', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (831, 3, 745, '2015-10-07 15:39:35', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (893, 5, 726, '2011-12-22 09:12:28', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (553, 2, 39, '2018-01-05 23:43:38', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1046, 8, 354, '2020-05-10 21:28:31', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (87, 6, 17, '2010-12-14 17:32:09', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (29, 4, 125, '2015-09-26 19:50:18', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (64, 1, 719, '2018-09-14 04:14:27', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1047, 9, 806, '2015-05-28 01:34:42', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (509, 6, 540, '2010-09-12 07:31:09', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (279, 11, 495, '2011-10-19 05:38:52', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1048, 2, 614, '2013-11-14 22:26:35', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1049, 11, 463, '2011-03-28 17:13:51', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1050, 12, 730, '2010-12-15 08:28:13', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (666, 2, 655, '2016-04-28 22:31:34', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (354, 11, 159, '2018-10-27 05:40:35', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1051, 12, 209, '2014-07-21 00:12:15', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (182, 3, 34, '2018-11-18 14:11:05', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (205, 11, 216, '2013-12-31 11:01:34', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (14, 13, 487, '2018-01-20 20:42:57', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (916, 13, 589, '2017-03-17 09:53:16', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (318, 4, 448, '2019-04-19 08:31:23', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (429, 7, 132, '2018-03-23 17:56:17', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (21, 12, 274, '2017-10-23 12:44:33', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (837, 4, 638, '2017-03-05 12:51:48', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1052, 10, 704, '2020-05-04 17:41:23', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (677, 5, 263, '2017-11-18 03:32:47', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (556, 12, 422, '2019-09-16 14:11:20', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1053, 1, 3, '2013-12-18 07:09:58', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (528, 11, 453, '2010-06-04 04:56:02', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1054, 13, 695, '2015-08-24 14:48:58', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (186, 9, 377, '2013-08-22 23:29:09', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (534, 10, 447, '2010-03-16 07:50:14', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (664, 3, 653, '2018-08-13 10:12:11', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1056, 4, 57, '2015-05-30 13:55:28', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (934, 7, 153, '2011-08-19 21:36:56', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (876, 1, 291, '2017-08-25 04:27:55', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (827, 10, 398, '2017-02-27 04:03:34', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1057, 9, 848, '2012-11-16 23:21:35', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (420, 2, 73, '2014-03-13 01:22:05', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1058, 6, 30, '2011-08-31 14:17:18', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (539, 13, 376, '2013-02-12 14:44:03', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (603, null, 242, '2012-10-02 03:41:44', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (379, 8, 156, '2018-10-10 21:03:30', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (179, null, 307, '2010-09-25 08:24:46', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (348, 7, 799, '2016-02-02 02:56:05', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (368, 6, 437, '2020-02-25 08:44:19', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (266, 3, 110, '2014-09-01 16:46:10', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1059, 10, 317, '2014-03-10 04:40:43', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (234, 4, 525, '2013-10-24 19:23:42', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1060, 9, 354, '2015-08-26 12:14:29', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (480, 4, 200, '2013-10-08 13:21:05', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (185, 13, 494, '2016-07-12 21:25:04', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (544, 4, 69, '2013-11-05 10:10:22', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1061, 3, 730, '2019-03-23 18:07:50', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1062, 11, 237, '2017-02-26 21:46:40', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1063, 6, 384, '2018-05-08 03:51:08', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (730, 6, 606, '2018-04-06 06:47:44', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1064, 9, 1, '2015-09-06 09:21:03', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (158, 11, 709, '2013-04-12 12:27:21', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (536, 13, 163, '2010-05-01 22:10:05', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1065, 13, 415, '2012-08-09 11:54:58', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1066, 4, 455, '2010-09-04 01:00:08', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (563, 5, 77, '2020-08-28 13:27:45', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (273, 5, 303, '2013-07-17 06:30:33', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (832, 10, 517, '2010-04-15 21:02:20', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1067, 13, 77, '2019-02-12 15:37:43', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (56, 8, 551, '2012-10-02 09:54:10', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (885, 11, 296, '2013-07-17 16:50:32', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (896, 9, 772, '2011-11-23 18:45:13', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1068, 11, 314, '2017-02-10 16:38:29', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (617, 6, 695, '2020-05-09 04:38:14', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1069, 1, 304, '2012-05-25 15:57:47', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (843, 1, 402, '2020-08-05 02:36:59', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (906, 7, 505, '2010-08-14 22:22:33', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (551, 8, 336, '2018-01-17 13:43:08', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1070, 13, 322, '2017-03-16 01:34:17', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (653, 13, 804, '2019-11-24 05:48:25', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1071, 2, 212, '2015-03-23 17:14:17', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1072, 9, 383, '2011-02-05 20:39:25', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (737, 11, 753, '2016-06-26 14:48:17', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (727, 10, 492, '2020-08-18 16:20:52', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (338, 2, 368, '2014-05-20 03:00:42', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1073, 5, 775, '2019-07-14 13:39:04', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (86, 10, 779, '2018-03-15 21:43:01', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1074, 9, 331, '2011-07-15 17:10:04', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (204, 13, 349, '2020-05-19 17:47:36', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1075, 13, 145, '2014-06-08 14:15:51', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (271, 8, 273, '2015-08-11 17:18:26', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (701, 5, 628, '2018-04-07 14:36:44', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (754, 7, 77, '2017-09-16 11:53:14', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (694, 10, 741, '2016-05-09 23:48:41', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (696, null, 787, '2018-06-18 03:54:20', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1076, 2, 561, '2016-09-28 12:12:02', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1077, 2, 203, '2012-07-05 14:49:36', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (333, 7, 596, '2010-05-25 17:25:12', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (146, 8, 280, '2014-10-22 19:24:45', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (971, 1, 224, '2014-04-05 16:00:17', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1078, 4, 215, '2013-02-23 11:48:43', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (608, 13, 515, '2018-01-18 08:01:58', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1079, 2, 513, '2012-02-04 09:02:35', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (598, 8, 34, '2012-04-05 02:08:25', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1080, 2, 832, '2020-02-10 23:42:44', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1081, 7, 684, '2015-03-30 05:43:43', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (558, 5, 317, '2020-08-05 16:37:10', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (955, 10, 381, '2017-04-18 02:15:12', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1082, 6, 366, '2019-06-24 05:01:26', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (508, 11, 556, '2012-11-20 04:11:34', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (586, 1, 533, '2016-12-13 17:45:46', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (589, 3, 372, '2010-12-17 11:42:03', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (189, 12, 704, '2014-05-31 08:27:01', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1083, 8, 484, '2010-03-06 20:49:34', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1084, 1, 518, '2015-12-21 15:26:55', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1085, 13, 356, '2011-12-02 17:54:14', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (169, 1, 336, '2013-01-03 21:52:56', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (899, 9, 198, '2011-12-27 05:16:25', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1086, 5, 490, '2013-11-30 16:47:22', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1087, 6, 287, '2016-01-05 09:02:28', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1265, 3, 47, '2014-01-12 17:22:41', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (584, 10, 295, '2012-01-13 16:07:42', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (170, 13, 535, '2015-06-17 20:41:48', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (11, 9, 411, '2019-10-05 03:02:14', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (747, 12, 744, '2012-03-01 07:12:23', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (670, 8, 124, '2011-04-05 13:09:48', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1088, 7, 321, '2013-02-20 16:30:07', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (844, null, 361, '2013-04-12 13:12:53', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1089, 10, 109, '2011-11-24 04:06:02', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (438, 1, 749, '2013-11-15 15:24:57', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (93, 3, 845, '2019-06-26 05:21:34', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (306, 6, 453, '2018-04-22 01:27:36', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (17, 4, 260, '2018-03-15 03:40:45', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1090, 5, 560, '2019-03-19 07:32:59', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (820, 6, 486, '2016-05-26 19:17:01', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (112, 6, 128, '2020-06-13 17:52:40', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (437, 12, 771, '2019-01-01 23:24:40', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (611, 4, 659, '2013-09-16 17:01:36', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (577, 10, 15, '2020-07-06 12:28:17', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1091, 4, 27, '2017-06-30 09:28:16', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1092, 13, 202, '2014-01-28 00:38:00', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (573, 11, 328, '2018-11-21 07:18:18', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (398, 4, 308, '2020-02-11 20:08:54', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (375, 8, 135, '2014-03-03 11:39:21', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1093, 7, 22, '2011-01-12 10:39:17', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (206, 8, 81, '2010-12-24 01:39:47', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (976, 6, 572, '2014-12-23 14:31:01', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (82, 12, 500, '2020-01-04 13:48:26', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (854, 6, 632, '2019-07-06 07:42:43', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (792, 9, 835, '2011-02-10 15:23:49', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (168, 12, 623, '2014-01-08 09:05:01', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1094, 8, 108, '2014-11-18 14:21:09', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1095, 6, 422, '2013-02-07 18:55:04', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (322, 12, 18, '2013-03-16 00:55:57', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (78, 11, 371, '2017-11-17 17:18:08', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (756, 10, 253, '2018-05-02 09:23:06', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (300, 9, 319, '2010-11-28 07:05:30', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (225, 9, 853, '2010-12-11 07:15:16', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (533, 11, 356, '2016-06-06 18:44:55', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1096, 1, 173, '2019-08-02 03:50:31', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (323, 11, 676, '2020-07-28 06:45:53', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (703, 11, 826, '2018-01-23 03:06:40', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (113, 4, 799, '2012-06-26 09:23:13', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1097, 10, 590, '2019-11-21 05:42:36', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (767, 7, 217, '2020-01-22 00:06:20', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (142, 5, 523, '2012-01-08 16:29:07', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (311, 2, 239, '2010-05-02 09:05:04', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (824, 4, 164, '2018-05-01 23:00:15', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1098, 6, 305, '2010-11-15 22:53:44', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (462, 2, 476, '2010-03-09 03:25:55', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (137, 6, 211, '2013-09-12 03:01:32', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1099, 5, 138, '2012-11-20 21:46:36', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (891, 4, 206, '2019-09-14 15:52:39', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1100, 1, 631, '2018-10-16 19:35:01', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (840, 10, 335, '2019-08-12 02:07:45', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (50, 2, 446, '2020-03-11 12:22:56', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (725, 9, 478, '2020-07-02 01:47:12', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (155, 7, 33, '2018-10-31 16:30:45', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (289, 13, 95, '2019-12-20 11:50:11', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1101, 10, 581, '2013-08-14 20:14:45', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1102, 13, 134, '2014-01-08 06:25:40', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (977, 7, 317, '2012-11-05 21:41:16', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (302, 6, 328, '2012-03-07 20:37:34', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1103, 4, 89, '2010-11-03 12:03:07', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (698, 4, 529, '2013-07-24 21:50:05', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (818, 7, 665, '2019-10-03 07:44:07', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (639, 2, 274, '2019-09-07 15:02:27', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (287, 9, 643, '2011-03-01 00:42:29', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1104, 1, 482, '2017-06-16 14:09:27', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1105, 11, 809, '2014-11-22 07:18:51', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (724, 8, 762, '2018-08-10 07:46:04', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1106, 10, 742, '2012-10-15 18:50:02', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1107, 7, 259, '2015-07-30 04:31:49', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (667, 12, 249, '2020-08-16 06:35:54', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (817, 11, 224, '2011-06-30 01:23:59', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1108, 7, 779, '2016-12-13 21:40:00', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1109, 13, 184, '2013-04-13 21:58:45', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (905, 11, 2, '2016-04-02 17:00:16', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1110, 4, 202, '2010-05-30 21:13:32', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1111, null, 484, '2020-08-27 07:13:51', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (188, 10, 366, '2019-10-15 15:26:49', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (83, 9, 495, '2015-11-09 08:46:14', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1112, 5, 754, '2020-02-11 17:42:44', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (244, 4, 776, '2011-02-21 04:31:06', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (645, 4, 763, '2016-09-23 15:49:11', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (956, 11, 770, '2018-06-17 09:27:59', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (609, 9, 335, '2015-07-09 06:44:23', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (928, 1, 322, '2014-03-15 07:26:37', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (258, 4, 813, '2012-04-19 10:32:11', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (856, 9, 212, '2017-12-27 13:36:02', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1113, 6, 763, '2018-09-28 12:55:44', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (403, 7, 327, '2019-05-11 15:20:39', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1114, 13, 686, '2013-06-11 02:49:23', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1115, 12, 188, '2015-11-09 04:44:34', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (211, 2, 241, '2013-11-06 20:24:27', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (685, 12, 653, '2018-01-03 20:35:05', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1116, 10, 407, '2018-05-15 05:57:00', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (575, 6, 441, '2013-03-04 19:10:15', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (136, 13, 208, '2011-10-14 16:29:51', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (568, 3, 752, '2012-01-31 20:22:09', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1117, 13, 795, '2015-07-01 05:24:56', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (350, 4, 304, '2019-06-15 07:52:42', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (16, 5, 818, '2012-06-29 23:37:15', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (626, 10, 92, '2013-03-10 21:58:18', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (708, 7, 795, '2014-02-05 12:00:58', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (100, 13, 89, '2010-07-21 17:30:18', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (461, 7, 94, '2017-04-21 05:43:28', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (950, 6, 580, '2013-11-18 04:07:54', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (668, 7, 162, '2014-11-10 10:56:53', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (48, 4, 459, '2011-08-07 07:16:44', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (921, 12, 288, '2019-04-30 06:37:13', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (250, 9, 78, '2010-01-09 18:35:29', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (412, 4, 159, '2019-12-16 07:44:43', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (729, 8, 501, '2014-04-05 00:15:29', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (393, 13, 394, '2012-05-02 14:52:14', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (863, 4, 553, '2015-02-22 11:40:08', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (171, 11, 405, '2019-03-05 07:26:51', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (945, 8, 510, '2014-09-12 09:49:12', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (503, 5, 448, '2014-05-07 14:23:02', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (164, 3, 737, '2012-11-21 22:23:23', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (325, 6, 170, '2015-07-23 15:05:01', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (150, 8, 89, '2019-06-18 16:52:17', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1118, 3, 135, '2017-08-06 13:01:24', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1119, 4, 386, '2013-06-19 06:01:46', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (622, 8, 740, '2020-06-10 06:33:21', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (815, 9, 57, '2015-04-27 11:58:54', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1120, 9, 352, '2016-04-07 13:46:43', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (895, 3, 428, '2017-03-28 22:14:08', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1121, 12, 655, '2017-04-11 16:56:43', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1122, 2, 441, '2015-10-10 18:05:37', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1123, 2, 392, '2012-08-28 23:07:48', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1000, 7, 812, '2014-07-10 01:47:14', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (341, 11, 582, '2011-02-11 23:15:41', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (793, 8, 468, '2012-10-28 12:23:57', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (208, 12, 642, '2011-04-25 20:33:20', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (686, 1, 511, '2019-12-28 04:21:24', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1124, 3, 93, '2010-02-02 22:28:50', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (274, 11, 828, '2014-07-08 14:45:28', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (253, 13, 182, '2012-03-23 02:33:14', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1125, 12, 740, '2012-04-11 01:20:24', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (783, 3, 761, '2017-10-30 17:17:52', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1126, 6, 670, '2010-04-18 19:31:20', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (610, null, 546, '2012-07-16 00:30:22', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1127, 3, 347, '2011-12-15 09:25:43', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (628, 10, 191, '2010-12-01 16:41:09', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (761, 4, 646, '2014-09-14 07:56:02', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1128, 8, 702, '2013-10-13 04:03:18', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (425, 2, 281, '2019-03-07 05:53:04', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (413, 10, 154, '2019-02-04 20:11:05', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1129, 3, 221, '2020-02-13 05:42:07', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1130, 9, 422, '2015-06-06 11:25:39', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1131, 11, 820, '2012-02-25 22:59:12', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (749, 2, 475, '2018-09-13 18:20:12', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (798, 13, 89, '2020-02-14 09:52:39', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (49, 4, 452, '2016-09-05 20:41:47', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1132, null, 383, '2018-03-15 13:09:03', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (702, 12, 600, '2016-11-20 11:04:57', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1133, 9, 631, '2019-09-14 16:15:37', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (975, 6, 231, '2018-08-24 22:48:32', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1134, 3, 583, '2016-03-20 06:38:21', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (654, 12, 552, '2013-08-21 03:04:43', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (922, 10, 801, '2016-03-20 14:09:52', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (616, 8, 18, '2013-01-15 11:09:59', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (75, 6, 674, '2013-01-02 19:04:54', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (46, 9, 381, '2019-10-23 03:43:20', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (869, 7, 560, '2014-08-26 04:31:19', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1135, 2, 276, '2010-09-27 07:08:45', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1136, 9, 609, '2011-07-22 19:38:27', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1137, 3, 528, '2017-05-17 05:14:18', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (947, 11, 548, '2015-12-20 21:46:05', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (212, 2, 19, '2011-07-17 20:02:17', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (484, 13, 161, '2016-07-01 07:46:11', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1138, 2, 380, '2012-04-08 16:44:46', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (880, 5, 196, '2016-06-07 20:34:31', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1139, 9, 317, '2010-06-20 21:33:13', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (383, 8, 191, '2019-09-15 17:55:24', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (865, 4, 214, '2010-02-17 15:57:18', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (728, 12, 624, '2011-02-18 16:04:29', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1140, 10, 576, '2011-10-06 10:56:38', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (98, 8, 465, '2013-09-17 18:54:24', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1141, 2, 719, '2019-02-14 04:01:19', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (336, 1, 40, '2018-06-04 07:39:05', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1142, 12, 794, '2011-01-22 22:04:25', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1143, 7, 304, '2013-06-08 09:33:24', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (640, 11, 546, '2012-02-11 17:11:24', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (411, 4, 476, '2015-10-24 15:43:09', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1145, 9, 305, '2012-03-30 13:55:58', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1146, 9, 576, '2011-01-11 16:48:47', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (931, 3, 750, '2011-12-12 02:43:02', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (740, 5, 333, '2012-07-12 20:48:21', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1147, 9, 241, '2015-11-23 02:22:53', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (870, 1, 393, '2014-07-12 11:42:46', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1148, 12, 509, '2017-04-14 13:13:10', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1149, 9, 18, '2016-02-11 20:21:16', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (500, 6, 106, '2014-09-06 08:11:01', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (201, 6, 376, '2015-09-30 01:02:19', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1150, 11, 32, '2020-01-06 03:42:36', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (213, 10, 209, '2013-12-10 11:54:37', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1151, 5, 585, '2017-12-22 21:07:32', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1152, 1, 84, '2013-12-26 15:26:01', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1153, 6, 124, '2016-03-29 18:49:12', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (527, 6, 138, '2012-01-15 12:46:57', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (926, null, 698, '2014-07-23 18:58:34', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (284, 10, 165, '2012-06-14 14:24:17', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1154, 8, 577, '2014-10-31 12:26:48', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1155, 13, 242, '2015-05-12 07:43:09', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (67, 5, 223, '2017-03-02 15:48:45', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1156, 8, 79, '2012-05-09 07:00:21', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (733, 7, 324, '2015-09-17 02:16:43', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1157, 7, 492, '2020-04-24 11:59:06', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (660, 5, 543, '2015-02-11 05:51:05', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (30, 6, 99, '2018-12-28 03:12:22', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (304, 7, 327, '2010-01-21 06:48:31', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1158, 3, 655, '2020-03-27 03:16:11', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (550, 4, 607, '2018-02-06 09:13:31', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1159, 3, 107, '2013-05-13 11:09:55', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1160, 3, 765, '2014-12-03 11:47:15', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (55, 11, 184, '2014-02-01 03:04:15', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (248, 10, 76, '2014-04-17 16:47:14', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (481, 6, 155, '2010-01-08 07:36:09', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1161, 6, 451, '2013-03-15 01:58:13', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1162, 8, 612, '2012-12-22 03:55:04', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1163, 12, 771, '2011-09-25 08:27:51', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1164, 4, 281, '2012-01-22 09:59:22', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (731, 4, 23, '2010-01-28 07:21:22', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (504, 13, 149, '2014-11-21 03:04:37', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (807, 2, 103, '2019-05-11 23:03:56', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (828, 2, 556, '2011-05-06 14:55:11', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (699, 3, 442, '2010-02-09 05:24:18', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (176, 4, 817, '2017-06-22 17:22:49', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1165, 12, 786, '2020-05-06 02:56:24', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (295, 6, 804, '2018-09-11 04:31:55', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1166, 6, 467, '2015-07-30 05:03:03', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1167, null, 422, '2014-03-03 11:44:44', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1168, 13, 834, '2014-06-24 12:05:12', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (978, 9, 812, '2018-09-08 08:51:36', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (421, 2, 271, '2011-10-19 11:23:02', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1169, 6, 394, '2012-07-26 04:49:00', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1170, 2, 36, '2019-09-28 14:25:41', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1171, 12, 284, '2019-02-24 03:15:48', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1172, null, 496, '2015-09-16 13:55:04', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1173, 3, 689, '2011-10-29 04:21:40', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1174, 8, 464, '2010-05-23 19:01:14', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (498, 2, 123, '2012-08-18 23:17:33', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (69, 8, 521, '2020-07-09 02:36:28', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1175, 3, 726, '2018-12-12 20:18:30', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (580, 2, 266, '2011-06-24 18:33:00', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1176, 12, 769, '2010-09-07 14:07:59', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (541, 5, 498, '2020-03-17 03:58:21', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1177, 11, 629, '2018-03-22 00:58:48', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (972, 6, 284, '2019-03-06 15:59:17', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (196, 4, 671, '2020-02-03 16:45:31', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (326, null, 676, '2019-07-23 07:25:13', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (963, 11, 645, '2011-09-02 03:26:41', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (676, 2, 238, '2020-07-20 02:47:01', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (757, 3, 539, '2018-07-03 20:48:08', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1178, 2, 7, '2016-10-10 13:50:05', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1179, 13, 749, '2014-03-08 13:40:09', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1180, 12, 34, '2020-02-01 12:38:50', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (45, 2, 748, '2015-01-16 23:26:52', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (128, 10, 540, '2015-05-26 05:30:02', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1181, 1, 173, '2012-05-29 23:50:29', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1182, 6, 192, '2012-07-08 12:30:55', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1183, 6, 746, '2019-07-24 00:31:07', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1184, 7, 430, '2020-07-25 02:09:11', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1185, 11, 383, '2014-06-29 02:49:33', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1186, 6, 727, '2011-08-07 13:21:48', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (882, 7, 89, '2016-07-20 09:15:33', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1187, 10, 595, '2020-01-19 19:23:18', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1188, 6, 742, '2014-05-21 14:04:50', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1189, 7, 804, '2012-12-11 08:44:08', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1190, 5, 842, '2013-05-15 05:44:08', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (651, 8, 708, '2014-11-24 19:55:54', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1191, 3, 433, '2019-08-25 16:04:28', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (918, 13, 97, '2016-07-07 06:28:44', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (102, 4, 403, '2015-09-30 15:01:36', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1192, 13, 425, '2019-04-13 09:10:14', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (219, 4, 4, '2015-09-06 22:06:40', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (260, 9, 164, '2013-05-02 15:17:38', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1193, 4, 685, '2019-05-12 10:24:40', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1194, 5, 529, '2011-04-15 16:48:26', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1195, 13, 323, '2019-05-22 20:09:47', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1196, 2, 515, '2010-01-15 20:08:43', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (881, 8, 207, '2014-01-31 10:29:45', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1197, 9, 687, '2017-12-13 09:57:53', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (788, 10, 149, '2016-08-17 21:39:43', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1198, 7, 56, '2015-05-20 03:13:58', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (25, 13, 660, '2014-10-07 17:45:41', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1199, 4, 549, '2016-01-30 12:06:30', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1200, 12, 605, '2015-08-08 07:37:30', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (194, 12, 7, '2016-09-27 02:41:57', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1201, 3, 232, '2019-02-01 20:54:55', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1202, 12, 119, '2016-07-30 13:55:41', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (650, 7, 586, '2019-06-11 20:23:23', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1203, 6, 599, '2019-11-06 00:06:28', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1204, 4, 723, '2017-08-12 08:51:52', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (344, 1, 159, '2018-01-20 15:57:31', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (875, 13, 547, '2016-09-26 19:22:03', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1205, 7, 480, '2020-05-02 08:25:35', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (989, 12, 805, '2013-10-15 00:39:29', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1206, 2, 604, '2010-11-25 18:48:15', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1207, 4, 693, '2019-04-10 02:31:49', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (671, 5, 234, '2016-10-19 09:09:44', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1208, 10, 478, '2016-09-18 18:31:51', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (151, 3, 510, '2020-04-26 18:05:35', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (532, 11, 437, '2018-02-02 01:45:57', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1209, 13, 675, '2015-01-27 13:03:34', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (720, 5, 441, '2011-09-27 04:36:48', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1210, 12, 846, '2017-12-16 21:52:55', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1211, 3, 294, '2014-12-20 23:53:22', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (833, 13, 677, '2019-01-23 04:23:06', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (877, 12, 306, '2013-04-05 02:19:26', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1212, 10, 658, '2016-01-30 11:34:03', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1213, 2, 175, '2010-09-22 13:13:15', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (850, 12, 134, '2019-03-09 05:17:28', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (22, 3, 691, '2012-12-29 11:14:49', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (569, 6, 189, '2015-04-20 15:49:15', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1214, 1, 573, '2014-08-01 16:22:50', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1215, 3, 480, '2012-05-15 19:57:44', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1216, 11, 810, '2020-07-27 16:46:32', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1217, 13, 143, '2012-04-19 02:26:18', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (769, 5, 508, '2011-10-11 02:35:28', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1218, 9, 233, '2013-08-27 20:51:38', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (476, 4, 453, '2020-03-16 18:44:03', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (800, 8, 372, '2011-08-01 09:26:28', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (210, 5, 727, '2012-02-13 11:48:39', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (994, 11, 558, '2017-04-17 04:18:01', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1219, 5, 733, '2014-06-06 23:38:51', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1220, 10, 545, '2017-08-22 01:16:59', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1221, 7, 294, '2013-04-25 17:15:01', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1222, 8, 128, '2012-10-05 19:44:32', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (814, 5, 433, '2014-12-08 06:09:31', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (52, 5, 3, '2018-04-24 14:47:53', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (992, 3, 489, '2019-09-30 13:44:58', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (229, 11, 360, '2019-03-12 18:55:52', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1223, 4, 589, '2018-11-13 17:46:12', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (475, 6, 457, '2014-12-14 02:17:30', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1224, 1, 249, '2017-05-02 00:33:13', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (662, 9, 310, '2012-03-02 19:46:49', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1225, 7, 315, '2012-12-02 07:41:01', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1226, 5, 628, '2015-04-06 13:16:17', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1227, 6, 505, '2016-05-22 20:39:38', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (759, 3, 684, '2015-12-22 09:35:38', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1228, 1, 26, '2014-09-16 22:07:29', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (156, 12, 24, '2015-07-22 11:12:04', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1229, 8, 754, '2016-06-13 23:39:46', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1230, 2, 668, '2020-08-10 19:54:35', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (942, 4, 337, '2017-05-19 18:18:17', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1231, 7, 549, '2011-09-23 02:16:02', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (642, 8, 232, '2016-01-05 00:58:20', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1232, 8, 47, '2013-09-05 08:47:26', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1233, 7, 166, '2015-09-22 15:48:17', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1234, 10, 606, '2016-09-17 20:47:05', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (80, 10, 505, '2012-02-23 19:40:40', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1235, 2, 376, '2011-10-29 06:47:59', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1236, 11, 403, '2016-11-28 04:25:06', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1237, 13, 360, '2016-07-18 11:36:43', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1238, 12, 414, '2013-08-16 14:51:28', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1239, 5, 34, '2016-10-18 03:06:41', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (687, 12, 507, '2011-12-11 17:06:27', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1240, 1, 307, '2011-09-14 06:11:04', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1241, 12, 573, '2012-12-03 22:37:57', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (557, 10, 4, '2016-05-31 14:33:50', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (652, 11, 840, '2014-04-30 16:38:22', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1242, 8, 203, '2019-01-25 18:20:36', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1243, 1, 546, '2019-02-03 03:39:52', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1244, 9, 716, '2014-10-16 08:31:48', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1245, 11, 583, '2011-12-28 02:56:06', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (937, 10, 652, '2014-09-06 14:06:23', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (297, 5, 770, '2018-01-24 06:52:34', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1246, 2, 840, '2012-05-14 18:27:51', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1247, 5, 313, '2013-06-02 21:38:09', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (951, 11, 742, '2016-09-03 11:25:26', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1248, 1, 453, '2014-09-15 18:41:42', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1249, 13, 228, '2010-08-20 04:27:45', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1250, 12, 802, '2014-03-07 18:33:47', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1251, 3, 525, '2014-05-13 01:11:14', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (794, 10, 440, '2019-07-15 07:50:50', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1252, 2, 49, '2015-01-06 02:16:14', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1253, 13, 448, '2013-10-10 23:01:03', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1254, 8, 344, '2019-07-11 20:56:44', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1255, 1, 419, '2014-05-05 05:39:58', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (366, 9, 696, '2018-01-25 15:05:00', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (981, 9, 713, '2019-03-01 12:31:46', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1256, 5, 605, '2010-09-24 23:40:20', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1257, 9, 460, '2013-02-28 16:16:39', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1258, 12, 668, '2011-04-23 12:14:37', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1259, 1, 684, '2011-04-19 01:00:40', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1260, 1, 493, '2013-04-21 04:41:35', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1261, 4, 704, '2011-09-24 04:56:38', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1262, null, 669, '2016-10-08 18:04:41', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (444, 3, 750, '2016-01-24 20:05:29', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (422, 11, 671, '2012-06-28 03:12:00', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1263, 2, 414, '2014-06-01 11:20:35', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1264, 1, 531, '2017-12-26 10:00:49', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (121, 5, 177, '2011-08-16 18:19:34', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1364, 12, 242, '2017-03-24 14:22:41', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (745, 6, 16, '2019-01-11 01:31:54', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (930, 4, 407, '2012-05-23 20:40:30', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1266, 2, 460, '2011-07-22 01:17:07', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1267, 6, 309, '2016-01-10 02:54:45', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1268, 9, 375, '2011-02-02 00:25:49', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (303, 5, 395, '2017-12-18 01:49:49', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (887, 10, 160, '2012-03-20 12:20:58', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1269, 5, 850, '2019-08-09 16:32:26', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (351, 2, 562, '2013-04-05 19:36:16', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (281, 1, 108, '2010-10-12 23:26:41', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (929, 2, 473, '2014-01-24 08:09:35', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1270, 10, 335, '2018-11-14 19:40:12', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1271, 8, 170, '2016-07-08 21:54:09', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1272, 11, 491, '2014-06-05 16:55:53', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (152, 4, 173, '2016-11-14 01:11:13', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1273, 2, 79, '2014-11-29 11:16:47', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (511, 6, 685, '2013-08-21 21:30:03', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (60, 11, 794, '2016-08-11 14:08:19', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (4, 13, 759, '2011-08-08 09:56:22', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1274, 11, 571, '2018-02-26 14:01:03', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1275, 8, 661, '2014-02-22 00:53:02', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (103, 6, 546, '2011-03-13 03:28:22', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (873, 4, 288, '2013-09-12 00:56:51', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1276, 5, 541, '2015-01-31 10:33:14', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1277, 13, 234, '2017-02-15 20:45:32', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1278, 5, 695, '2010-04-28 22:32:57', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (946, 9, 423, '2013-10-29 17:17:26', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1279, 13, 382, '2017-08-07 05:00:09', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1280, 1, 667, '2015-02-13 19:16:26', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1281, 9, 811, '2012-07-21 09:02:54', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1282, 12, 696, '2012-07-17 10:15:02', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (294, 1, 708, '2014-07-14 18:39:13', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (822, 6, 313, '2014-12-06 22:43:59', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (623, 13, 182, '2018-01-02 10:47:33', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (965, 7, 12, '2010-09-14 13:42:24', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1283, 13, 633, '2015-04-07 19:54:28', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (132, 12, 662, '2013-01-12 01:46:58', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (802, 4, 594, '2013-07-07 02:44:05', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (104, 5, 766, '2019-11-19 07:56:36', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1284, 10, 685, '2012-03-16 06:41:35', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (782, 7, 287, '2019-08-05 22:29:30', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1285, 5, 666, '2020-05-06 15:25:15', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1286, 5, 19, '2016-08-29 16:59:09', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (392, 8, 626, '2017-12-06 05:01:37', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (938, 1, 854, '2020-03-03 20:45:02', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1287, 2, 345, '2012-02-05 10:22:06', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1288, 11, 305, '2018-01-25 03:35:39', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1289, 10, 503, '2015-08-30 05:55:31', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1290, 1, 714, '2010-12-31 00:07:38', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1291, 8, 262, '2020-02-02 03:03:46', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1292, 13, 285, '2019-09-29 02:42:29', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1293, 3, 515, '2014-08-07 17:01:05', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1294, 5, 47, '2019-11-19 15:08:44', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (23, 12, 199, '2012-09-14 20:26:00', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1295, 5, 315, '2018-06-12 03:36:21', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1296, 13, 594, '2020-02-26 03:14:05', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (241, 3, 615, '2013-12-30 05:10:09', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1297, 2, 361, '2016-06-03 22:58:01', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1298, 7, 767, '2020-05-06 13:34:55', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1299, 13, 820, '2011-06-08 00:06:20', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1300, 2, 777, '2018-08-06 11:32:22', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1301, 1, 728, '2017-03-18 07:07:28', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (224, 4, 283, '2019-11-05 15:33:52', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (932, 7, 738, '2020-02-25 05:31:27', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (442, 4, 595, '2013-03-28 01:49:42', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (647, 2, 193, '2012-07-25 06:24:53', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1302, 2, 395, '2011-02-24 20:33:44', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1303, 11, 392, '2019-06-03 23:07:51', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (748, 9, 159, '2010-05-20 10:21:04', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (722, 1, 790, '2018-01-07 02:32:30', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (836, 9, 18, '2011-03-26 16:36:57', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1304, 9, 568, '2020-04-04 22:06:35', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1305, null, 320, '2012-04-25 15:33:48', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1306, 5, 237, '2014-09-05 20:09:43', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1307, 4, 61, '2012-12-01 15:16:20', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (226, 5, 77, '2011-03-05 21:46:52', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (638, 3, 689, '2011-07-25 10:47:55', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1308, null, 463, '2010-07-30 23:23:45', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1309, 4, 568, '2012-01-25 01:32:07', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (321, 3, 9, '2015-06-09 01:00:51', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (995, 4, 238, '2020-06-26 14:02:34', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1310, 13, 128, '2017-12-31 11:58:15', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1311, 1, 155, '2017-12-10 16:06:51', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (502, 7, 550, '2011-10-10 11:19:50', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1312, 12, 446, '2018-09-30 08:52:40', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (665, 12, 567, '2018-01-18 01:00:02', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (479, 13, 827, '2011-07-03 11:16:29', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (419, 4, 153, '2014-12-30 19:26:47', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (380, 11, 44, '2014-04-02 22:23:12', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1313, 3, 228, '2017-12-03 18:42:28', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1314, 2, 828, '2019-03-26 15:09:03', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (247, 2, 799, '2019-07-03 10:52:41', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1315, 5, 443, '2014-07-17 16:30:54', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (924, 1, 454, '2015-11-29 14:53:23', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (387, 12, 719, '2019-12-25 18:42:26', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (867, 7, 506, '2019-04-09 20:41:42', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1316, 12, 232, '2015-11-09 14:05:20', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1317, 6, 637, '2012-09-19 04:52:55', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1318, 3, 486, '2019-04-02 11:24:45', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (688, 5, 575, '2015-02-10 18:01:53', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1319, 10, 834, '2016-06-08 07:45:52', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1320, 5, 751, '2012-09-08 07:12:51', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1321, 6, 29, '2010-04-26 10:50:00', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1322, null, 171, '2014-10-05 06:07:35', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (193, 11, 745, '2017-08-05 16:53:40', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (157, 7, 568, '2015-03-30 13:45:36', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1323, 8, 136, '2020-01-30 17:03:28', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (144, 10, 444, '2020-08-29 21:44:03', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1324, 12, 194, '2014-12-13 05:42:43', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1325, 2, 102, '2019-11-11 17:09:06', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (58, 1, 118, '2018-05-17 20:08:35', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1326, 7, 95, '2014-08-30 01:28:21', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1327, 11, 805, '2012-01-05 14:14:02', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (851, 5, 135, '2014-09-17 04:50:11', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1328, 1, 374, '2012-09-16 22:21:23', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (305, 2, 663, '2020-01-16 11:31:31', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (641, 6, 663, '2018-06-13 20:59:53', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (943, 8, 603, '2011-01-03 15:07:29', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1329, 11, 659, '2014-02-13 19:42:15', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1330, 7, 430, '2018-04-12 03:41:44', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (597, 9, 593, '2018-11-20 01:57:15', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1331, 8, 8, '2011-09-16 14:39:28', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1332, 12, 203, '2018-03-11 06:24:52', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (857, 8, 353, '2014-08-29 08:08:54', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1333, 12, 854, '2016-07-05 20:20:17', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1334, null, 761, '2016-05-02 17:38:44', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (195, 1, 786, '2014-04-24 13:25:39', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (317, 13, 801, '2014-10-20 07:04:58', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1335, 8, 720, '2016-04-11 21:54:36', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1336, 5, 505, '2017-10-24 03:15:44', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (220, 9, 288, '2014-12-23 09:58:49', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1337, 4, 740, '2020-03-24 02:49:41', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (143, 13, 551, '2013-03-08 19:44:53', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (433, 12, 614, '2019-03-10 02:18:05', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (590, 6, 189, '2015-05-15 20:16:22', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1338, 8, 112, '2010-02-02 08:20:43', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1339, 9, 95, '2018-12-11 08:29:05', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1340, 12, 128, '2017-07-29 04:11:12', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1341, 12, 221, '2018-06-03 01:15:39', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1342, 7, 196, '2017-01-13 19:24:44', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1343, 5, 534, '2012-08-15 12:38:14', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (795, 6, 51, '2016-08-26 22:34:43', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1344, 6, 286, '2011-08-27 06:12:22', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1345, 12, 307, '2014-02-01 13:52:21', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1346, 2, 453, '2013-10-20 18:18:21', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (117, 3, 781, '2011-10-03 14:24:30', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (360, 13, 830, '2014-01-31 07:23:26', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1347, 5, 453, '2010-07-01 13:09:46', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1348, 6, 444, '2017-05-31 09:39:26', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1349, 12, 193, '2015-02-17 05:34:10', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (53, 13, 737, '2017-09-20 20:57:19', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (272, 9, 198, '2011-01-02 18:14:51', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (672, 2, 467, '2018-12-28 16:27:35', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1350, 1, 6, '2017-08-30 18:13:26', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1351, 8, 700, '2018-07-14 18:18:11', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1352, 7, 592, '2016-02-01 11:52:09', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (159, 6, 285, '2018-01-21 05:39:28', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (13, 6, 796, '2010-04-04 15:07:29', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (106, 7, 482, '2016-05-24 11:00:02', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1353, 13, 17, '2011-12-27 14:11:44', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1354, 2, 558, '2011-03-17 06:11:49', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (684, 7, 667, '2015-05-26 23:01:13', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1355, 9, 827, '2019-11-07 08:54:01', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1356, 12, 838, '2010-10-19 12:47:25', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (673, 6, 344, '2014-08-31 04:52:14', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (43, 5, 90, '2011-05-30 10:57:27', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (567, 7, 45, '2012-05-07 06:47:22', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (331, 11, 510, '2016-10-12 07:15:44', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1357, 9, 839, '2019-07-01 15:23:23', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (486, 4, 342, '2019-11-27 19:01:54', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (542, 5, 528, '2014-10-20 19:40:58', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1358, 13, 379, '2019-11-26 04:13:40', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1359, 2, 423, '2016-07-12 08:15:00', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (1360, 7, 692, '2013-06-11 19:32:59', null, null);
insert into Sessions (SessionID, GameID, UserID, SessionStart, SessionEnd, SessionDuration) values (775, 4, 630, '2016-02-17 03:49:13', null, null);
GO


-- A While loop that updates the session time in a random max 300 minutes value, and detects whether the Session Start time is after the game publish date 

	DECLARE
		@gamedate DATETIME,
		@GameID INT,
		@SessionID INT,
		@SessionStart DATETIME,
		@SessionEnd DATETIME,
		@counter INT,
		@SessiongamesiD INT
	SET @counter = 1
	WHILE @counter <= 1364
	
		BEGIN
			SELECT @SessionID = SessionID FROM Sessions WHERE SessionID = @counter
			SELECT @SessionStart = SessionStart FROM Sessions WHERE SessionID = @counter
			SELECT @gamedate = DatePublished FROM Games WHERE Gameid = (Select gameid FROM Sessions WHERE SessionID = @counter)
			SELECT @GameID = gameid FROM Games WHERE Gameid = (Select gameid FROM Sessions WHERE SessionID = @counter)
			SELECT @SessiongamesiD = gameid FROM Sessions WHERE SessionID = @counter
	
		IF @SessiongamesiD IS NULL
			SET @counter = @counter + 1
		ELSE IF @gamedate < @SessionStart AND @SessionStart < GETDATE() - 1 
			BEGIN
				SET @SessionEnd = @SessionStart + DATEADD(Minute,RAND()*(300-1)+1,0)
				UPDATE Sessions SET SessionEnd = @SessionEnd WHERE SessionID = @counter
				SET @counter = @counter + 1
			END
		ELSE IF @gamedate > @SessionStart
				BEGIN
					DELETE FROM Sessions WHERE SessionID = @counter
					SET @counter = @counter + 1
				END
		ELSE
			SET @counter = @counter + 1
		END
GO


-- ROLLBACK/COMMIT



-- A While loop that Updates the SessionDuration column in the table

-- BEGIN TRANSACTION

DECLARE
		@gamedate DATETIME,
		@GameID INT,
		@SessionID INT,
		@SessionStart DATETIME,
		@SessionEnd DATETIME,
		@counter INT,
		@SessionDuration INT
	SET @counter = 1
	WHILE @counter <= 1364
	
		BEGIN
			SELECT @SessionID = SessionID FROM Sessions WHERE SessionID = @counter
			SELECT @SessionStart = SessionStart FROM Sessions WHERE SessionID = @counter
			SELECT @SessionEnd = SessionEnd FROM Sessions WHERE SessionID = @counter
			SELECT @gamedate = DatePublished FROM Games WHERE Gameid = (Select gameid FROM Sessions WHERE SessionID = @counter)
			SELECT @GameID = gameid FROM Games WHERE Gameid = (Select gameid FROM Sessions WHERE SessionID = @counter)
	
		IF @SessionEnd IS NULL
			SET @counter = @counter + 1
		ELSE 
			BEGIN
				SET @SessionDuration = DATEDIFF(MINUTE, @SessionStart, @SessionEnd)
				UPDATE Sessions SET SessionDuration = @SessionDuration WHERE SessionID = @counter
				SET @counter = @counter + 1
			END
		END
GO

--Deleting Sessions that have no GameID (Want to have only Sessions with GameID)
DELETE FROM SESSIONS WHERE GameID IS NULL
GO

-- ROLLBACK/COMMIT


-- Inputting Data into Events table
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (1, 361, 'Rolling Wheel', null, 2, 2026, null, null, 93180, 38611);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (2, 360, 'Lose Level', null, 13, 2366, null, null, 28995, 64429);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (3, 842, 'Free Roll', null, 6, 1971, null, null, 67307, 3399);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (4, 88, 'Opened game', null, 8, 1559, null, null, 76799, 9395);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (5, 542, 'Win level', null, 8, 3574, null, null, 15551, 22831);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (6, 618, 'Free Roll', null, 13, 130, null, null, 70535, 65427);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (7, 629, 'Diamond Purchase', null, 4, 1271, null, null, 62016, 17785);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (8, 752, 'Free Roll', null, 3, 709, null, null, 77605, 25706);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (9, 447, 'Gained a life', null, 10, 3196, null, null, 75050, 99260);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (10, 164, 'Win level', null, 13, 3978, null, null, 50387, 60766);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (11, 713, 'Win level', null, 1, 3501, null, null, 83109, 36174);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (12, 669, 'Rolling Wheel', null, 13, 2354, null, null, 12979, 72261);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (13, 398, 'Lifes Purchase', null, 4, 2762, null, null, 9007, 83467);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (14, 106, 'Gained a life', null, 3, 1145, null, null, 46152, 47415);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (15, 288, 'Win level', null, 10, 1408, null, null, 35800, 32221);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (16, 501, 'Points Purchase', null, 13, 2308, null, null, 71378, 27346);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (17, 3, 'Game Purchase', null, 8, 1151, null, null, 73058, 4304);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (18, 846, 'Lose Level', null, 6, 3405, null, null, 33734, 7351);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (19, 266, 'Lifes Purchase', null, 11, 2814, null, null, 61787, 99442);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (20, 125, 'Gained a life', null, 1, 215, null, null, 81713, 34977);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (21, 81, 'Gold Purchase', null, 4, 2834, null, null, 95160, 66519);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (22, 694, 'Lifes Purchase', null, 9, 445, null, null, 97887, 36019);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (23, 247, 'Wood Purchase', null, 8, 2541, null, null, 89983, 18253);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (24, 789, 'Opened game', null, 11, 2193, null, null, 84371, 65681);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (25, 506, 'Gold Purchase', null, 13, 3224, null, null, 55245, 40865);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (26, 301, 'Game Purchase', null, 6, 2328, null, null, 32302, 12693);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (27, 503, 'Gold Purchase', null, 10, 3360, null, null, 32994, 4705);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (28, 38, 'Gold Purchase', null, 5, 3559, null, null, 78393, 1365);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (29, 426, 'Game Purchase', null, 5, 612, null, null, 51858, 19491);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (30, 72, 'Lifes Purchase', null, 1, 2892, null, null, 16433, 13361);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (31, 806, 'General action', null, 8, 1180, null, null, 50879, 5015);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (32, 230, 'General action', null, 3, 1120, null, null, 26455, 74531);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (33, 124, 'Gold Purchase', null, 1, 2056, null, null, 38958, 47642);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (34, 30, 'Wood Purchase', null, 11, 1989, null, null, 34380, 51750);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (35, 607, 'Win level', null, 9, 2250, null, null, 18579, 81439);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (36, 821, 'Lifes Purchase', null, 11, 1658, null, null, 2634, 89619);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (37, 210, 'Gold Purchase', null, 2, 2024, null, null, 61274, 40820);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (38, 118, 'Diamond Purchase', null, 12, 854, null, null, 83898, 66958);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (39, 204, 'Lose Level', null, 7, 538, null, null, 34947, 60027);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (40, 664, 'General action', null, 5, 2120, null, null, 18104, 57437);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (41, 634, 'Points Purchase', null, 1, 1666, null, null, 16064, 96799);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (42, 246, 'Gained a life', null, 11, 1597, null, null, 40997, 98882);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (43, 415, 'Opened game', null, 8, 335, null, null, 21277, 10138);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (44, 367, 'Game Purchase', null, 5, 3233, null, null, 88637, 84091);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (45, 119, 'Diamond Purchase', null, 10, 3378, null, null, 68492, 51629);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (46, 263, 'General action', null, 5, 1567, null, null, 70503, 79568);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (47, 776, 'Opened game', null, 7, 724, null, null, 36595, 99383);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (48, 509, 'Free Roll', null, 8, 3448, null, null, 90255, 43648);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (49, 145, 'Game Purchase', null, 1, 3554, null, null, 77800, 58265);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (50, 165, 'Gold Purchase', null, 8, 2784, null, null, 80899, 58394);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (51, 111, 'Lifes Purchase', null, 10, 1792, null, null, 8997, 84916);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (52, 728, 'Lose Level', null, 12, 1294, null, null, 69494, 38277);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (53, 42, 'Free Roll', null, 6, 3091, null, null, 65262, 8177);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (54, 582, 'Points Purchase', null, 9, 1025, null, null, 48048, 10239);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (55, 641, 'Gained a life', null, 11, 1306, null, null, 37728, 81461);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (56, 53, 'General action', null, 12, 2338, null, null, 42405, 3986);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (57, 800, 'Wood Purchase', null, 11, 1599, null, null, 81958, 91706);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (58, 615, 'Opened game', null, 10, 2194, null, null, 76917, 57570);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (59, 338, 'Wood Purchase', null, 2, 3560, null, null, 38103, 94045);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (60, 79, 'Lose Level', null, 7, 347, null, null, 71470, 62083);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (61, 554, 'Lose Level', null, 13, 1485, null, null, 12445, 95693);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (62, 128, 'Opened game', null, 13, 236, null, null, 22169, 99313);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (63, 493, 'Opened game', null, 11, 990, null, null, 11230, 84826);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (64, 297, 'General action', null, 13, 3285, null, null, 40093, 36967);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (65, 139, 'Wood Purchase', null, 4, 142, null, null, 8832, 44790);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (66, 603, 'Rolling Wheel', null, 5, 1044, null, null, 82857, 74410);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (67, 584, 'Diamond Purchase', null, 2, 2951, null, null, 23947, 18798);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (68, 194, 'Gained a life', null, 10, 432, null, null, 97263, 95952);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (69, 109, 'Diamond Purchase', null, 2, 705, null, null, 63194, 28148);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (70, 288, 'Lose Level', null, 9, 25, null, null, 4545, 71447);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (71, 234, 'General action', null, 6, 2976, null, null, 53733, 86629);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (72, 559, 'Gold Purchase', null, 6, 3210, null, null, 81924, 70932);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (73, 619, 'Diamond Purchase', null, 7, 3749, null, null, 54578, 21668);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (74, 839, 'Rolling Wheel', null, 7, 3912, null, null, 54590, 87407);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (75, 273, 'Gained a life', null, 4, 3565, null, null, 11751, 91120);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (76, 391, 'Lifes Purchase', null, 9, 835, null, null, 7195, 36583);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (77, 21, 'Lifes Purchase', null, 12, 3327, null, null, 24498, 94376);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (78, 22, 'Win level', null, 9, 1796, null, null, 35651, 29911);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (79, 370, 'Lose Level', null, 6, 2245, null, null, 25979, 34622);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (80, 790, 'Diamond Purchase', null, 12, 1003, null, null, 46962, 55969);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (81, 488, 'Lose Level', null, 8, 256, null, null, 15186, 46025);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (82, 581, 'Diamond Purchase', null, 5, 1919, null, null, 21632, 43286);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (83, 842, 'Wood Purchase', null, 10, 583, null, null, 4377, 76098);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (84, 10, 'Rolling Wheel', null, 12, 1757, null, null, 84031, 45818);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (85, 140, 'Wood Purchase', null, 6, 1453, null, null, 50810, 71482);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (86, 603, 'Wood Purchase', null, 9, 492, null, null, 10317, 30832);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (87, 446, 'Win level', null, 7, 2518, null, null, 22310, 19839);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (88, 826, 'Gained a life', null, 12, 3247, null, null, 59233, 83016);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (89, 479, 'Game Purchase', null, 10, 2830, null, null, 95074, 25417);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (90, 654, 'Lose Level', null, 9, 2568, null, null, 67498, 55990);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (91, 589, 'Free Roll', null, 1, 1264, null, null, 68743, 60859);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (92, 681, 'Win level', null, 7, 3161, null, null, 44243, 53159);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (93, 824, 'Rolling Wheel', null, 10, 1868, null, null, 38784, 76338);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (94, 390, 'Points Purchase', null, 4, 2017, null, null, 18085, 7510);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (95, 834, 'Free Roll', null, 12, 3707, null, null, 64654, 19327);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (96, 705, 'Free Roll', null, 13, 567, null, null, 58971, 23500);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (97, 753, 'Points Purchase', null, 13, 560, null, null, 32113, 2520);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (98, 779, 'Opened game', null, 12, 2014, null, null, 72269, 78409);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (99, 337, 'Lifes Purchase', null, 10, 3752, null, null, 51985, 31346);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (100, 377, 'Free Roll', null, 4, 2830, null, null, 57872, 91162);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (101, 711, 'General action', null, 7, 3069, null, null, 75422, 5207);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (102, 415, 'General action', null, 7, 1749, null, null, 59519, 1184);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (103, 232, 'Diamond Purchase', null, 5, 391, null, null, 82571, 34541);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (104, 140, 'Win level', null, 5, 3306, null, null, 44674, 8121);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (105, 419, 'Opened game', null, 4, 1682, null, null, 87042, 35699);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (106, 267, 'Gained a life', null, 5, 1542, null, null, 74012, 81958);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (107, 213, 'Free Roll', null, 8, 724, null, null, 51392, 6405);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (108, 611, 'Wood Purchase', null, 7, 1852, null, null, 22830, 62377);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (109, 564, 'Diamond Purchase', null, 12, 1823, null, null, 37270, 67358);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (110, 121, 'Opened game', null, 3, 730, null, null, 98122, 35999);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (111, 712, 'Win level', null, 12, 1812, null, null, 12201, 13055);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (112, 542, 'Points Purchase', null, 5, 1846, null, null, 79644, 27882);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (113, 827, 'Rolling Wheel', null, 8, 1988, null, null, 93541, 12636);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (114, 276, 'Gold Purchase', null, 10, 3604, null, null, 78500, 26092);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (115, 640, 'Gained a life', null, 3, 2731, null, null, 94466, 20749);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (116, 772, 'Wood Purchase', null, 12, 1784, null, null, 18582, 62596);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (117, 379, 'Win level', null, 11, 687, null, null, 58604, 91061);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (118, 52, 'Win level', null, 1, 2433, null, null, 11663, 87339);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (119, 209, 'Wood Purchase', null, 5, 3035, null, null, 61608, 37467);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (120, 335, 'Points Purchase', null, 8, 748, null, null, 86205, 5414);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (121, 694, 'General action', null, 8, 1599, null, null, 68169, 45620);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (122, 495, 'Gained a life', null, 6, 132, null, null, 97043, 11342);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (123, 167, 'Gold Purchase', null, 7, 873, null, null, 70867, 71181);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (124, 187, 'Rolling Wheel', null, 2, 2608, null, null, 47269, 33211);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (125, 601, 'Gold Purchase', null, 5, 1728, null, null, 89156, 51513);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (126, 298, 'Gained a life', null, 3, 2657, null, null, 31150, 51364);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (127, 578, 'Points Purchase', null, 1, 2843, null, null, 32551, 36899);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (128, 382, 'Gained a life', null, 8, 766, null, null, 63473, 86809);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (129, 75, 'Rolling Wheel', null, 2, 3703, null, null, 20647, 81220);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (130, 772, 'Wood Purchase', null, 6, 3906, null, null, 79159, 20744);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (131, 669, 'Lifes Purchase', null, 2, 2305, null, null, 77040, 68095);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (132, 453, 'Wood Purchase', null, 1, 1751, null, null, 79754, 33455);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (133, 479, 'Diamond Purchase', null, 5, 2088, null, null, 15333, 36933);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (134, 653, 'General action', null, 11, 130, null, null, 2795, 51131);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (135, 464, 'Game Purchase', null, 10, 3621, null, null, 5373, 20808);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (136, 237, 'Opened game', null, 8, 3847, null, null, 5347, 83343);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (137, 816, 'Points Purchase', null, 3, 4, null, null, 46158, 49916);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (138, 177, 'Points Purchase', null, 11, 3853, null, null, 99500, 2496);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (139, 793, 'Gained a life', null, 5, 735, null, null, 70850, 3693);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (140, 408, 'Diamond Purchase', null, 11, 2760, null, null, 25535, 64463);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (141, 626, 'Game Purchase', null, 11, 1010, null, null, 70980, 20820);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (142, 58, 'Free Roll', null, 11, 76, null, null, 70195, 80715);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (143, 602, 'Points Purchase', null, 2, 3578, null, null, 71110, 70252);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (144, 537, 'Points Purchase', null, 2, 228, null, null, 25179, 91639);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (145, 212, 'Gained a life', null, 2, 979, null, null, 65184, 57751);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (146, 217, 'Gained a life', null, 3, 2295, null, null, 5387, 7365);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (147, 310, 'Gold Purchase', null, 4, 2727, null, null, 35331, 24516);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (148, 341, 'Free Roll', null, 6, 1859, null, null, 16476, 73326);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (149, 377, 'Lose Level', null, 6, 3054, null, null, 81581, 88130);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (150, 780, 'Lifes Purchase', null, 8, 3674, null, null, 67013, 24132);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (151, 738, 'Lose Level', null, 1, 355, null, null, 16964, 47052);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (152, 456, 'Lifes Purchase', null, 9, 3742, null, null, 58522, 9566);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (153, 545, 'Opened game', null, 12, 3930, null, null, 31464, 97688);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (154, 141, 'Wood Purchase', null, 4, 3783, null, null, 36982, 42562);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (155, 608, 'Gained a life', null, 9, 249, null, null, 32659, 26374);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (156, 212, 'Rolling Wheel', null, 9, 2136, null, null, 9750, 73828);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (157, 698, 'Gained a life', null, 2, 462, null, null, 24214, 10007);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (158, 742, 'General action', null, 7, 326, null, null, 78152, 16858);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (159, 841, 'Rolling Wheel', null, 4, 2024, null, null, 78536, 66443);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (160, 766, 'Lifes Purchase', null, 10, 238, null, null, 44981, 71238);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (161, 674, 'Rolling Wheel', null, 3, 3420, null, null, 47325, 49554);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (162, 505, 'Lose Level', null, 13, 1769, null, null, 63375, 34049);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (163, 601, 'Diamond Purchase', null, 10, 684, null, null, 81662, 51023);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (164, 812, 'Rolling Wheel', null, 8, 3245, null, null, 23098, 83169);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (165, 329, 'General action', null, 9, 3152, null, null, 82475, 4641);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (166, 392, 'Free Roll', null, 2, 1724, null, null, 67073, 52580);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (167, 39, 'Rolling Wheel', null, 10, 1549, null, null, 29552, 60636);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (168, 222, 'General action', null, 8, 1034, null, null, 14546, 57461);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (169, 393, 'Wood Purchase', null, 12, 2635, null, null, 4748, 11995);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (170, 123, 'Gold Purchase', null, 1, 2178, null, null, 88911, 20353);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (171, 707, 'Opened game', null, 12, 1716, null, null, 69782, 53643);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (172, 529, 'General action', null, 9, 78, null, null, 59235, 39977);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (173, 276, 'Free Roll', null, 12, 283, null, null, 27362, 23870);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (174, 842, 'Gold Purchase', null, 7, 3590, null, null, 32452, 31471);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (175, 207, 'Lose Level', null, 13, 3350, null, null, 93365, 84601);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (176, 19, 'Wood Purchase', null, 5, 1788, null, null, 91293, 57026);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (177, 216, 'Opened game', null, 8, 3278, null, null, 41335, 37774);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (178, 532, 'Gained a life', null, 5, 3526, null, null, 52495, 6694);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (179, 309, 'Lose Level', null, 9, 3630, null, null, 80790, 51035);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (180, 281, 'Game Purchase', null, 5, 3351, null, null, 29395, 67895);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (181, 331, 'Game Purchase', null, 9, 1476, null, null, 1017, 64008);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (182, 516, 'Lifes Purchase', null, 5, 1483, null, null, 98612, 37120);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (183, 499, 'Gold Purchase', null, 2, 2481, null, null, 56023, 98622);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (184, 479, 'Game Purchase', null, 11, 715, null, null, 11456, 26915);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (185, 581, 'Lose Level', null, 3, 1040, null, null, 38747, 57295);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (186, 90, 'General action', null, 1, 1094, null, null, 17090, 10192);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (187, 144, 'Gained a life', null, 9, 2806, null, null, 44911, 52761);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (188, 529, 'Rolling Wheel', null, 5, 1440, null, null, 18703, 27218);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (189, 36, 'Lifes Purchase', null, 10, 1582, null, null, 55301, 3629);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (190, 46, 'Lifes Purchase', null, 13, 3221, null, null, 5982, 45385);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (191, 253, 'Gold Purchase', null, 6, 1448, null, null, 77095, 58589);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (192, 255, 'Opened game', null, 9, 3786, null, null, 53641, 34034);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (193, 596, 'Points Purchase', null, 3, 3523, null, null, 49662, 6089);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (194, 59, 'Lifes Purchase', null, 8, 3768, null, null, 47189, 77742);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (195, 716, 'Opened game', null, 13, 364, null, null, 97162, 34344);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (196, 740, 'Lifes Purchase', null, 7, 3142, null, null, 31810, 35867);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (197, 90, 'Wood Purchase', null, 9, 2679, null, null, 71435, 78440);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (198, 117, 'Rolling Wheel', null, 1, 3064, null, null, 66004, 45608);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (199, 796, 'Opened game', null, 2, 3343, null, null, 36657, 49857);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (200, 806, 'General action', null, 1, 2247, null, null, 62446, 64969);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (201, 268, 'Win level', null, 11, 3440, null, null, 50173, 58414);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (202, 494, 'Rolling Wheel', null, 10, 2833, null, null, 3329, 54750);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (203, 727, 'Win level', null, 2, 487, null, null, 88624, 22348);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (204, 83, 'Lose Level', null, 2, 371, null, null, 58888, 4799);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (205, 813, 'Lifes Purchase', null, 9, 1333, null, null, 42977, 57748);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (206, 571, 'Diamond Purchase', null, 13, 3419, null, null, 18999, 94049);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (207, 481, 'General action', null, 4, 167, null, null, 93748, 50156);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (208, 612, 'Game Purchase', null, 1, 276, null, null, 8251, 8153);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (209, 97, 'Wood Purchase', null, 7, 2201, null, null, 6077, 48334);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (210, 41, 'Opened game', null, 9, 1844, null, null, 1389, 67059);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (211, 132, 'Gold Purchase', null, 7, 1684, null, null, 50639, 82819);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (212, 365, 'Points Purchase', null, 4, 3453, null, null, 19334, 33301);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (213, 488, 'Lose Level', null, 13, 2112, null, null, 16487, 45642);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (214, 361, 'Gained a life', null, 7, 2927, null, null, 66514, 88143);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (215, 11, 'Lifes Purchase', null, 7, 141, null, null, 35051, 80461);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (216, 214, 'Opened game', null, 2, 1360, null, null, 76910, 50780);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (217, 194, 'Lose Level', null, 6, 2812, null, null, 78108, 82308);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (218, 648, 'Rolling Wheel', null, 7, 3525, null, null, 2662, 19872);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (219, 185, 'Points Purchase', null, 3, 2308, null, null, 77049, 80688);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (220, 63, 'Points Purchase', null, 10, 3803, null, null, 46760, 72025);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (221, 516, 'Lose Level', null, 11, 1545, null, null, 79111, 16922);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (222, 609, 'Rolling Wheel', null, 4, 1834, null, null, 98372, 5184);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (223, 817, 'Gained a life', null, 7, 878, null, null, 46911, 2284);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (224, 691, 'Gold Purchase', null, 12, 3173, null, null, 30122, 63792);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (225, 626, 'Opened game', null, 8, 2305, null, null, 73959, 98945);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (226, 769, 'Opened game', null, 12, 1621, null, null, 26238, 16074);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (227, 188, 'Wood Purchase', null, 1, 3739, null, null, 26414, 17509);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (228, 133, 'Gained a life', null, 9, 3960, null, null, 74082, 35506);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (229, 79, 'Points Purchase', null, 4, 1148, null, null, 89900, 83170);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (230, 449, 'Gained a life', null, 8, 2453, null, null, 42749, 35127);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (231, 508, 'Opened game', null, 6, 1580, null, null, 19076, 38161);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (232, 502, 'Gold Purchase', null, 1, 1876, null, null, 85282, 32226);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (233, 525, 'Win level', null, 4, 59, null, null, 30612, 39653);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (234, 612, 'Diamond Purchase', null, 10, 1345, null, null, 23169, 52668);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (235, 471, 'Free Roll', null, 13, 3265, null, null, 92146, 65053);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (236, 735, 'Lose Level', null, 7, 1879, null, null, 65604, 94314);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (237, 304, 'Rolling Wheel', null, 8, 1818, null, null, 33878, 24817);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (238, 853, 'Opened game', null, 2, 1684, null, null, 85233, 57065);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (239, 832, 'General action', null, 12, 485, null, null, 2738, 42174);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (240, 684, 'Game Purchase', null, 12, 627, null, null, 75705, 47793);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (241, 325, 'Free Roll', null, 3, 1624, null, null, 82311, 27625);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (242, 435, 'Wood Purchase', null, 12, 1717, null, null, 48766, 95371);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (243, 815, 'Game Purchase', null, 2, 1966, null, null, 11923, 34700);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (244, 118, 'Points Purchase', null, 10, 2564, null, null, 16274, 29098);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (245, 793, 'Lose Level', null, 6, 1667, null, null, 59421, 58751);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (246, 94, 'Rolling Wheel', null, 11, 822, null, null, 58673, 90978);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (247, 674, 'Wood Purchase', null, 10, 1380, null, null, 59957, 74958);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (248, 694, 'Points Purchase', null, 7, 1553, null, null, 5212, 72585);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (249, 752, 'Rolling Wheel', null, 13, 1293, null, null, 10022, 52315);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (250, 582, 'Lose Level', null, 7, 2382, null, null, 23922, 71174);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (251, 449, 'Win level', null, 11, 2728, null, null, 88181, 27922);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (252, 16, 'Free Roll', null, 4, 1759, null, null, 76615, 73377);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (253, 824, 'Opened game', null, 11, 2112, null, null, 67204, 46805);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (254, 566, 'Lifes Purchase', null, 11, 1418, null, null, 78949, 91954);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (255, 828, 'General action', null, 4, 1276, null, null, 43603, 69376);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (256, 368, 'Points Purchase', null, 11, 2642, null, null, 55454, 52026);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (257, 49, 'Win level', null, 11, 1301, null, null, 83682, 36852);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (258, 483, 'Lifes Purchase', null, 7, 3936, null, null, 75967, 37017);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (259, 564, 'Game Purchase', null, 8, 564, null, null, 42700, 26035);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (260, 645, 'Wood Purchase', null, 1, 3599, null, null, 73130, 95946);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (261, 92, 'Free Roll', null, 1, 1901, null, null, 66095, 22643);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (262, 509, 'Rolling Wheel', null, 8, 3047, null, null, 89645, 47920);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (263, 459, 'Points Purchase', null, 7, 3365, null, null, 39433, 3552);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (264, 319, 'Wood Purchase', null, 4, 1422, null, null, 3006, 66290);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (265, 328, 'Lose Level', null, 9, 794, null, null, 32999, 55204);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (266, 387, 'Free Roll', null, 5, 968, null, null, 33312, 36858);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (267, 815, 'Free Roll', null, 3, 973, null, null, 8452, 71971);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (268, 188, 'Gold Purchase', null, 2, 2023, null, null, 9565, 28234);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (269, 747, 'Free Roll', null, 2, 3617, null, null, 27333, 8655);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (270, 424, 'Lifes Purchase', null, 1, 709, null, null, 28951, 11093);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (271, 332, 'Game Purchase', null, 4, 1401, null, null, 82522, 14170);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (272, 542, 'General action', null, 3, 3019, null, null, 67648, 92817);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (273, 218, 'Gained a life', null, 3, 2423, null, null, 26639, 61560);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (274, 725, 'Opened game', null, 6, 471, null, null, 11442, 40373);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (275, 692, 'Points Purchase', null, 6, 2866, null, null, 7361, 7520);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (276, 355, 'Gold Purchase', null, 5, 3939, null, null, 29794, 49280);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (277, 174, 'Rolling Wheel', null, 6, 979, null, null, 22300, 25710);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (278, 181, 'Win level', null, 11, 2571, null, null, 50418, 24402);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (279, 666, 'General action', null, 12, 2302, null, null, 86479, 30577);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (280, 328, 'Gold Purchase', null, 1, 3741, null, null, 35553, 19747);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (281, 418, 'Win level', null, 1, 1262, null, null, 97978, 89570);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (282, 555, 'Wood Purchase', null, 7, 256, null, null, 77671, 37569);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (283, 587, 'Diamond Purchase', null, 2, 434, null, null, 43669, 75262);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (284, 375, 'Wood Purchase', null, 8, 581, null, null, 49108, 19731);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (285, 88, 'General action', null, 3, 560, null, null, 8642, 31709);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (286, 826, 'Diamond Purchase', null, 2, 3871, null, null, 94154, 18758);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (287, 500, 'Rolling Wheel', null, 8, 2785, null, null, 86948, 69241);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (288, 351, 'Lose Level', null, 9, 3599, null, null, 96116, 62374);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (289, 127, 'General action', null, 8, 3327, null, null, 1472, 69071);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (290, 257, 'Opened game', null, 12, 2876, null, null, 27220, 46677);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (291, 51, 'Game Purchase', null, 8, 1334, null, null, 4049, 78946);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (292, 632, 'Diamond Purchase', null, 8, 619, null, null, 49575, 92919);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (293, 740, 'General action', null, 3, 3259, null, null, 2789, 82389);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (294, 585, 'General action', null, 5, 2489, null, null, 30965, 4820);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (295, 134, 'Points Purchase', null, 10, 2143, null, null, 19969, 19833);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (296, 785, 'General action', null, 4, 3926, null, null, 38993, 42544);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (297, 127, 'Opened game', null, 11, 1017, null, null, 3350, 25973);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (298, 532, 'Points Purchase', null, 2, 497, null, null, 78942, 1283);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (299, 845, 'Gained a life', null, 11, 1250, null, null, 9491, 5956);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (300, 642, 'Wood Purchase', null, 1, 2165, null, null, 57618, 21034);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (301, 488, 'Rolling Wheel', null, 2, 415, null, null, 20874, 26149);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (302, 305, 'Wood Purchase', null, 11, 3157, null, null, 53553, 75699);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (303, 308, 'Gold Purchase', null, 13, 2847, null, null, 46170, 86343);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (304, 552, 'Points Purchase', null, 11, 254, null, null, 97341, 635);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (305, 534, 'General action', null, 13, 658, null, null, 68875, 46387);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (306, 775, 'Free Roll', null, 5, 2087, null, null, 14443, 37120);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (307, 262, 'Gained a life', null, 3, 747, null, null, 69523, 77819);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (308, 411, 'Win level', null, 1, 3637, null, null, 50221, 34309);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (309, 153, 'Rolling Wheel', null, 7, 2889, null, null, 74370, 22895);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (310, 767, 'General action', null, 6, 20, null, null, 97822, 86632);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (311, 513, 'Lose Level', null, 3, 616, null, null, 39544, 26129);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (312, 561, 'Game Purchase', null, 11, 1716, null, null, 96563, 59095);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (313, 220, 'Free Roll', null, 5, 898, null, null, 54067, 85970);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (314, 556, 'Points Purchase', null, 4, 485, null, null, 40199, 60107);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (315, 748, 'Lifes Purchase', null, 6, 1656, null, null, 92872, 82218);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (316, 632, 'Free Roll', null, 5, 3159, null, null, 7227, 72501);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (317, 386, 'Points Purchase', null, 5, 675, null, null, 29769, 37366);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (318, 482, 'Gained a life', null, 12, 3212, null, null, 8954, 18145);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (319, 387, 'Wood Purchase', null, 3, 999, null, null, 65061, 90935);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (320, 547, 'Rolling Wheel', null, 3, 2601, null, null, 59707, 3885);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (321, 833, 'Points Purchase', null, 9, 1985, null, null, 75003, 98335);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (322, 736, 'General action', null, 13, 2227, null, null, 28611, 33242);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (323, 612, 'Free Roll', null, 10, 1174, null, null, 44366, 62446);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (324, 278, 'Opened game', null, 3, 2621, null, null, 16962, 84603);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (325, 509, 'Gained a life', null, 9, 2989, null, null, 82866, 45403);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (326, 487, 'Rolling Wheel', null, 1, 2461, null, null, 31029, 78142);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (327, 192, 'Opened game', null, 1, 3921, null, null, 30077, 51186);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (328, 833, 'Win level', null, 4, 49, null, null, 71603, 72566);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (329, 735, 'Opened game', null, 9, 3731, null, null, 84785, 12794);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (330, 50, 'Points Purchase', null, 1, 288, null, null, 74592, 60528);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (331, 407, 'Game Purchase', null, 3, 2973, null, null, 8232, 98768);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (332, 38, 'Win level', null, 12, 1241, null, null, 31521, 23929);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (333, 53, 'Gold Purchase', null, 12, 3073, null, null, 89249, 45214);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (334, 151, 'Points Purchase', null, 12, 311, null, null, 21268, 56866);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (335, 310, 'Lifes Purchase', null, 10, 1177, null, null, 40413, 22839);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (336, 121, 'General action', null, 8, 1400, null, null, 78751, 38781);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (337, 486, 'Win level', null, 9, 1019, null, null, 44568, 69364);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (338, 672, 'Lose Level', null, 1, 3355, null, null, 32330, 99903);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (339, 5, 'Free Roll', null, 3, 2536, null, null, 18308, 49249);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (340, 115, 'Lifes Purchase', null, 7, 364, null, null, 2864, 11736);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (341, 485, 'Points Purchase', null, 1, 1280, null, null, 26548, 60432);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (342, 212, 'Diamond Purchase', null, 13, 3249, null, null, 55997, 43916);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (343, 700, 'Game Purchase', null, 12, 2517, null, null, 70894, 42318);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (344, 407, 'Rolling Wheel', null, 6, 2655, null, null, 97348, 42388);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (345, 422, 'Wood Purchase', null, 6, 2382, null, null, 53001, 19185);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (346, 685, 'Win level', null, 10, 2294, null, null, 71196, 53295);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (347, 145, 'General action', null, 2, 351, null, null, 15098, 78733);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (348, 723, 'Opened game', null, 10, 538, null, null, 29044, 11597);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (349, 649, 'Game Purchase', null, 1, 1011, null, null, 21799, 58249);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (350, 230, 'Points Purchase', null, 5, 2835, null, null, 71865, 7161);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (351, 732, 'Points Purchase', null, 11, 3831, null, null, 86689, 61281);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (352, 30, 'Rolling Wheel', null, 2, 339, null, null, 48551, 24900);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (353, 469, 'Gained a life', null, 6, 2227, null, null, 37180, 70992);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (354, 438, 'General action', null, 10, 1308, null, null, 86835, 47856);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (355, 459, 'Wood Purchase', null, 13, 3739, null, null, 90887, 42573);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (356, 197, 'Rolling Wheel', null, 5, 1750, null, null, 38182, 28457);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (357, 39, 'Lifes Purchase', null, 13, 1380, null, null, 78186, 44167);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (358, 248, 'Free Roll', null, 7, 171, null, null, 36038, 21332);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (359, 479, 'Rolling Wheel', null, 12, 2840, null, null, 30328, 36427);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (360, 53, 'Diamond Purchase', null, 1, 2328, null, null, 99079, 5296);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (361, 476, 'Gained a life', null, 9, 1750, null, null, 1553, 22092);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (362, 429, 'Game Purchase', null, 6, 619, null, null, 33866, 87554);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (363, 854, 'Rolling Wheel', null, 1, 900, null, null, 50994, 21558);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (364, 400, 'Gained a life', null, 12, 2365, null, null, 79549, 99534);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (365, 130, 'Wood Purchase', null, 10, 1061, null, null, 20430, 74300);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (366, 286, 'Gained a life', null, 9, 1404, null, null, 74474, 85455);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (367, 732, 'Wood Purchase', null, 5, 2859, null, null, 39433, 1711);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (368, 780, 'Diamond Purchase', null, 8, 422, null, null, 494, 27556);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (369, 672, 'Free Roll', null, 13, 3119, null, null, 732, 55557);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (370, 769, 'Free Roll', null, 5, 1511, null, null, 32547, 97096);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (371, 125, 'Diamond Purchase', null, 11, 1251, null, null, 54440, 65431);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (372, 428, 'Diamond Purchase', null, 8, 1445, null, null, 57090, 60500);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (373, 719, 'Rolling Wheel', null, 3, 336, null, null, 89792, 8943);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (374, 515, 'Free Roll', null, 13, 3029, null, null, 77580, 47420);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (375, 706, 'Lifes Purchase', null, 9, 2985, null, null, 75939, 17055);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (376, 786, 'Diamond Purchase', null, 13, 1048, null, null, 84084, 75478);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (377, 393, 'Game Purchase', null, 6, 391, null, null, 18775, 59282);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (378, 214, 'Wood Purchase', null, 4, 3138, null, null, 45940, 51124);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (379, 810, 'General action', null, 7, 989, null, null, 88933, 11012);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (380, 359, 'Diamond Purchase', null, 11, 1677, null, null, 25051, 80022);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (381, 553, 'Gained a life', null, 1, 1235, null, null, 95208, 18971);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (382, 684, 'Rolling Wheel', null, 12, 1267, null, null, 16212, 12532);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (383, 305, 'Diamond Purchase', null, 3, 3410, null, null, 63898, 12095);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (384, 509, 'General action', null, 1, 727, null, null, 93933, 78071);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (385, 274, 'Win level', null, 12, 3117, null, null, 23218, 90880);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (386, 847, 'Gained a life', null, 1, 853, null, null, 98773, 63795);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (387, 15, 'Rolling Wheel', null, 5, 3866, null, null, 94617, 55158);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (388, 513, 'Free Roll', null, 12, 1018, null, null, 27900, 86007);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (389, 478, 'Rolling Wheel', null, 11, 1666, null, null, 60575, 69761);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (390, 848, 'Free Roll', null, 13, 2090, null, null, 38922, 15693);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (391, 22, 'Win level', null, 7, 844, null, null, 14536, 11980);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (392, 834, 'Lose Level', null, 2, 3032, null, null, 49689, 90057);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (393, 745, 'Lifes Purchase', null, 11, 17, null, null, 21587, 96430);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (394, 772, 'General action', null, 6, 3868, null, null, 36454, 50525);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (395, 524, 'Lifes Purchase', null, 10, 2291, null, null, 89589, 43369);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (396, 520, 'Lose Level', null, 5, 1187, null, null, 59841, 97117);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (397, 23, 'Rolling Wheel', null, 10, 3440, null, null, 78982, 82333);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (398, 471, 'Rolling Wheel', null, 6, 1107, null, null, 18452, 82738);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (399, 136, 'Game Purchase', null, 10, 3268, null, null, 70553, 53062);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (400, 802, 'Gained a life', null, 9, 3508, null, null, 58535, 78505);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (401, 200, 'Wood Purchase', null, 8, 709, null, null, 35387, 63034);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (402, 775, 'Win level', null, 12, 3124, null, null, 38398, 63470);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (403, 150, 'General action', null, 5, 2219, null, null, 50057, 94947);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (404, 670, 'General action', null, 9, 1959, null, null, 62223, 76047);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (405, 788, 'Game Purchase', null, 6, 3270, null, null, 60961, 8332);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (406, 75, 'Opened game', null, 4, 2841, null, null, 74482, 81134);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (407, 471, 'Gained a life', null, 9, 506, null, null, 72395, 85044);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (408, 803, 'Game Purchase', null, 2, 2470, null, null, 26969, 92368);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (409, 307, 'Win level', null, 11, 3025, null, null, 10025, 47287);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (410, 848, 'Win level', null, 12, 3786, null, null, 40976, 47179);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (411, 484, 'Rolling Wheel', null, 7, 332, null, null, 24692, 51949);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (412, 232, 'Gained a life', null, 9, 2766, null, null, 75085, 47641);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (413, 696, 'Lifes Purchase', null, 9, 3626, null, null, 73362, 3559);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (414, 363, 'Points Purchase', null, 1, 1926, null, null, 36016, 86912);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (415, 805, 'Gained a life', null, 2, 1881, null, null, 71028, 18246);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (416, 273, 'Win level', null, 4, 3640, null, null, 46197, 28644);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (417, 236, 'Game Purchase', null, 5, 3056, null, null, 13876, 54388);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (418, 621, 'Diamond Purchase', null, 5, 2851, null, null, 16162, 1286);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (419, 614, 'Diamond Purchase', null, 9, 3571, null, null, 54614, 53091);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (420, 588, 'Gold Purchase', null, 3, 3027, null, null, 95832, 60634);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (421, 214, 'Gold Purchase', null, 5, 3882, null, null, 29911, 60842);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (422, 691, 'Game Purchase', null, 10, 1888, null, null, 92366, 72075);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (423, 365, 'Diamond Purchase', null, 9, 1564, null, null, 14343, 60393);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (424, 638, 'General action', null, 9, 3343, null, null, 55383, 94130);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (425, 144, 'Points Purchase', null, 9, 2722, null, null, 55737, 53623);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (426, 78, 'Lifes Purchase', null, 7, 974, null, null, 43469, 491);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (427, 72, 'Lose Level', null, 13, 356, null, null, 14518, 88881);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (428, 512, 'Opened game', null, 12, 3087, null, null, 28105, 99362);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (429, 224, 'Diamond Purchase', null, 6, 2686, null, null, 9063, 91350);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (430, 337, 'Diamond Purchase', null, 5, 2696, null, null, 9191, 16201);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (431, 263, 'General action', null, 4, 793, null, null, 79836, 65765);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (432, 794, 'Diamond Purchase', null, 7, 371, null, null, 30781, 10485);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (433, 752, 'Gold Purchase', null, 10, 3558, null, null, 1886, 46418);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (434, 76, 'Win level', null, 6, 837, null, null, 52712, 48149);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (435, 441, 'Opened game', null, 1, 1186, null, null, 42520, 59178);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (436, 777, 'Lifes Purchase', null, 5, 3438, null, null, 62744, 54828);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (437, 413, 'Diamond Purchase', null, 5, 1085, null, null, 73357, 54181);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (438, 724, 'Points Purchase', null, 9, 2904, null, null, 81723, 99966);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (439, 689, 'Rolling Wheel', null, 4, 1173, null, null, 75517, 19495);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (440, 764, 'Gold Purchase', null, 8, 1077, null, null, 40118, 81589);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (441, 764, 'Gold Purchase', null, 1, 1943, null, null, 5484, 43203);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (442, 89, 'Points Purchase', null, 13, 2935, null, null, 81391, 20290);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (443, 27, 'Gold Purchase', null, 8, 2963, null, null, 43005, 80272);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (444, 124, 'Wood Purchase', null, 1, 2791, null, null, 93514, 33655);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (445, 641, 'Rolling Wheel', null, 10, 1069, null, null, 63192, 20786);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (446, 275, 'Diamond Purchase', null, 6, 683, null, null, 25052, 85123);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (447, 648, 'General action', null, 12, 848, null, null, 80318, 56501);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (448, 600, 'General action', null, 6, 2528, null, null, 24174, 9260);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (449, 171, 'Rolling Wheel', null, 7, 3158, null, null, 63627, 27188);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (450, 167, 'Points Purchase', null, 1, 1515, null, null, 65012, 51142);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (451, 231, 'Gained a life', null, 1, 2958, null, null, 47681, 70486);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (452, 738, 'Rolling Wheel', null, 8, 486, null, null, 45582, 84137);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (453, 461, 'Gold Purchase', null, 5, 579, null, null, 37460, 28313);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (454, 809, 'Diamond Purchase', null, 9, 1204, null, null, 27299, 76184);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (455, 423, 'General action', null, 3, 302, null, null, 98030, 65701);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (456, 29, 'Lose Level', null, 4, 2838, null, null, 77647, 28080);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (457, 826, 'Free Roll', null, 3, 1355, null, null, 89242, 96790);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (458, 623, 'Lifes Purchase', null, 5, 869, null, null, 42928, 71431);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (459, 649, 'Points Purchase', null, 7, 92, null, null, 65275, 7325);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (460, 354, 'Wood Purchase', null, 5, 3742, null, null, 5256, 80139);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (461, 65, 'Win level', null, 12, 820, null, null, 26960, 88566);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (462, 182, 'Gold Purchase', null, 11, 840, null, null, 28252, 14040);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (463, 87, 'Lifes Purchase', null, 9, 121, null, null, 22939, 14457);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (464, 669, 'Lose Level', null, 13, 2712, null, null, 2615, 6857);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (465, 642, 'Game Purchase', null, 13, 2782, null, null, 55293, 41660);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (466, 134, 'Win level', null, 4, 712, null, null, 91600, 3483);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (467, 826, 'Opened game', null, 4, 231, null, null, 83329, 34750);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (468, 824, 'Free Roll', null, 2, 2463, null, null, 52264, 88181);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (469, 715, 'Gold Purchase', null, 2, 450, null, null, 99297, 8552);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (470, 83, 'Gained a life', null, 13, 3986, null, null, 3366, 65418);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (471, 165, 'Gold Purchase', null, 2, 138, null, null, 75040, 68541);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (472, 299, 'Gained a life', null, 10, 2707, null, null, 64433, 20897);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (473, 609, 'Opened game', null, 3, 162, null, null, 79416, 12261);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (474, 76, 'Rolling Wheel', null, 6, 988, null, null, 6827, 82063);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (475, 836, 'Rolling Wheel', null, 7, 3814, null, null, 79341, 12245);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (476, 509, 'Win level', null, 12, 1459, null, null, 10169, 58122);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (477, 701, 'Lifes Purchase', null, 11, 2495, null, null, 29319, 60013);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (478, 440, 'General action', null, 5, 2094, null, null, 77601, 62043);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (479, 675, 'Points Purchase', null, 11, 777, null, null, 25820, 70798);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (480, 702, 'Rolling Wheel', null, 5, 2714, null, null, 35586, 70912);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (481, 477, 'Gained a life', null, 7, 2868, null, null, 81161, 81457);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (482, 791, 'Wood Purchase', null, 8, 921, null, null, 73786, 1919);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (483, 351, 'Rolling Wheel', null, 5, 165, null, null, 46738, 53346);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (484, 7, 'Gold Purchase', null, 12, 1813, null, null, 95317, 7750);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (485, 351, 'Win level', null, 13, 2826, null, null, 24871, 51001);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (486, 379, 'Gold Purchase', null, 10, 2330, null, null, 53411, 29420);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (487, 526, 'Win level', null, 9, 222, null, null, 72011, 8452);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (488, 444, 'Gold Purchase', null, 1, 747, null, null, 88481, 1131);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (489, 468, 'Points Purchase', null, 3, 3851, null, null, 62002, 55160);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (490, 483, 'Wood Purchase', null, 11, 2798, null, null, 33036, 20107);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (491, 418, 'Lose Level', null, 10, 2265, null, null, 99211, 29715);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (492, 374, 'Lifes Purchase', null, 6, 626, null, null, 85136, 59676);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (493, 240, 'Rolling Wheel', null, 9, 1209, null, null, 18375, 29157);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (494, 43, 'Lose Level', null, 1, 1755, null, null, 69875, 62333);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (495, 431, 'Diamond Purchase', null, 4, 1008, null, null, 38954, 37309);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (496, 511, 'Gold Purchase', null, 3, 935, null, null, 88123, 45823);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (497, 661, 'Gained a life', null, 9, 152, null, null, 51601, 86167);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (498, 729, 'Win level', null, 3, 3149, null, null, 20233, 77666);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (499, 537, 'Gained a life', null, 5, 600, null, null, 44289, 89686);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (500, 615, 'Gold Purchase', null, 4, 2201, null, null, 15728, 35884);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (501, 24, 'Win level', null, 13, 3037, null, null, 86097, 76192);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (502, 361, 'Gold Purchase', null, 6, 2948, null, null, 2507, 80024);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (503, 541, 'Game Purchase', null, 11, 1491, null, null, 65270, 72857);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (504, 411, 'Game Purchase', null, 13, 2531, null, null, 57459, 40879);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (505, 380, 'Free Roll', null, 7, 1810, null, null, 14873, 34636);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (506, 145, 'Gold Purchase', null, 2, 3703, null, null, 27290, 46783);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (507, 305, 'Wood Purchase', null, 11, 2294, null, null, 66045, 62719);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (508, 524, 'Free Roll', null, 12, 212, null, null, 45660, 40832);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (509, 555, 'Points Purchase', null, 10, 912, null, null, 24510, 45157);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (510, 615, 'Free Roll', null, 3, 566, null, null, 38013, 78110);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (511, 300, 'Free Roll', null, 5, 27, null, null, 68288, 51874);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (512, 88, 'Free Roll', null, 1, 87, null, null, 22295, 45201);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (513, 276, 'Game Purchase', null, 10, 2476, null, null, 97311, 44920);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (514, 487, 'Free Roll', null, 2, 2671, null, null, 39251, 63220);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (515, 417, 'Lifes Purchase', null, 6, 1754, null, null, 72458, 96758);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (516, 434, 'Wood Purchase', null, 7, 2627, null, null, 4907, 74170);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (517, 799, 'General action', null, 7, 295, null, null, 17422, 42155);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (518, 222, 'Wood Purchase', null, 10, 2591, null, null, 52267, 40191);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (519, 21, 'Diamond Purchase', null, 1, 433, null, null, 33265, 47462);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (520, 173, 'Lose Level', null, 4, 783, null, null, 88493, 69497);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (521, 437, 'Free Roll', null, 6, 1228, null, null, 21979, 35110);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (522, 716, 'Win level', null, 9, 2962, null, null, 93565, 44766);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (523, 850, 'Opened game', null, 2, 1958, null, null, 7931, 6420);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (524, 87, 'Opened game', null, 12, 2371, null, null, 57735, 31204);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (525, 451, 'Lose Level', null, 6, 3710, null, null, 37710, 93894);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (526, 546, 'Points Purchase', null, 10, 157, null, null, 19933, 2885);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (527, 309, 'Gained a life', null, 6, 286, null, null, 52968, 96785);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (528, 356, 'Gained a life', null, 8, 1673, null, null, 76427, 27499);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (529, 795, 'Win level', null, 13, 551, null, null, 3433, 37344);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (530, 293, 'Opened game', null, 10, 76, null, null, 91940, 56099);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (531, 635, 'General action', null, 6, 1356, null, null, 2035, 81340);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (532, 100, 'Gold Purchase', null, 6, 850, null, null, 51337, 68215);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (533, 214, 'Lose Level', null, 8, 2977, null, null, 81791, 73275);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (534, 244, 'Wood Purchase', null, 3, 1270, null, null, 54235, 23530);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (535, 60, 'Wood Purchase', null, 4, 1767, null, null, 53981, 99967);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (536, 466, 'Lifes Purchase', null, 9, 2833, null, null, 21257, 9080);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (537, 712, 'Gained a life', null, 3, 2471, null, null, 6540, 85850);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (538, 73, 'Opened game', null, 1, 1259, null, null, 47275, 67833);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (539, 37, 'Lifes Purchase', null, 9, 1463, null, null, 82032, 44562);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (540, 498, 'Gained a life', null, 12, 3927, null, null, 98840, 99235);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (541, 178, 'Lifes Purchase', null, 11, 3614, null, null, 94473, 69426);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (542, 384, 'Points Purchase', null, 7, 3374, null, null, 54948, 75906);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (543, 394, 'Lose Level', null, 10, 809, null, null, 83329, 10925);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (544, 510, 'Game Purchase', null, 9, 2930, null, null, 56520, 93212);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (545, 446, 'Gold Purchase', null, 7, 1480, null, null, 82098, 85845);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (546, 425, 'Win level', null, 5, 872, null, null, 15363, 19691);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (547, 290, 'Lose Level', null, 13, 3429, null, null, 52138, 78104);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (548, 3, 'Gained a life', null, 3, 2834, null, null, 57379, 66587);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (549, 629, 'Opened game', null, 4, 2540, null, null, 37730, 99349);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (550, 168, 'Game Purchase', null, 7, 2675, null, null, 10212, 21453);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (551, 333, 'General action', null, 3, 2670, null, null, 19676, 22264);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (552, 391, 'Rolling Wheel', null, 1, 3566, null, null, 53587, 66186);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (553, 169, 'General action', null, 7, 2456, null, null, 22243, 81242);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (554, 346, 'Diamond Purchase', null, 8, 3931, null, null, 31085, 41432);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (555, 771, 'Opened game', null, 1, 206, null, null, 8725, 85657);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (556, 410, 'Lifes Purchase', null, 5, 3200, null, null, 43625, 98874);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (557, 760, 'Wood Purchase', null, 12, 2846, null, null, 92833, 29121);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (558, 169, 'Diamond Purchase', null, 9, 3093, null, null, 15123, 23161);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (559, 208, 'Win level', null, 5, 633, null, null, 45850, 64609);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (560, 86, 'Gold Purchase', null, 4, 2742, null, null, 24836, 69122);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (561, 750, 'Gold Purchase', null, 13, 1418, null, null, 93438, 80334);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (562, 321, 'Wood Purchase', null, 12, 1329, null, null, 86449, 595);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (563, 468, 'Game Purchase', null, 2, 1193, null, null, 86825, 53109);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (564, 667, 'Game Purchase', null, 1, 1442, null, null, 39854, 94593);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (565, 734, 'Diamond Purchase', null, 10, 1200, null, null, 65960, 96835);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (566, 95, 'Lifes Purchase', null, 2, 2231, null, null, 97010, 50711);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (567, 130, 'Diamond Purchase', null, 4, 847, null, null, 90231, 895);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (568, 64, 'Game Purchase', null, 13, 3445, null, null, 50959, 70831);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (569, 612, 'Free Roll', null, 1, 3194, null, null, 32197, 7829);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (570, 527, 'Win level', null, 6, 2876, null, null, 43955, 7803);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (571, 348, 'Lifes Purchase', null, 13, 49, null, null, 34251, 70364);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (572, 414, 'Gained a life', null, 8, 3282, null, null, 23336, 15159);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (573, 805, 'Free Roll', null, 6, 2230, null, null, 73474, 27204);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (574, 739, 'Lose Level', null, 9, 56, null, null, 21044, 75158);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (575, 747, 'Wood Purchase', null, 7, 3185, null, null, 45003, 39993);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (576, 539, 'Lifes Purchase', null, 12, 3393, null, null, 34754, 62919);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (577, 496, 'Lifes Purchase', null, 11, 1817, null, null, 4362, 48558);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (578, 607, 'Diamond Purchase', null, 12, 2044, null, null, 58981, 75742);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (579, 655, 'Rolling Wheel', null, 12, 3887, null, null, 14092, 5525);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (580, 400, 'Gained a life', null, 12, 3198, null, null, 89622, 11148);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (581, 5, 'Game Purchase', null, 6, 1157, null, null, 39623, 52714);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (582, 69, 'General action', null, 6, 3353, null, null, 69757, 66719);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (583, 464, 'Game Purchase', null, 12, 1428, null, null, 24593, 10951);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (584, 332, 'Diamond Purchase', null, 13, 3992, null, null, 1444, 1884);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (585, 309, 'Gold Purchase', null, 12, 3805, null, null, 11039, 93808);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (586, 273, 'Lifes Purchase', null, 12, 3920, null, null, 61727, 82453);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (587, 772, 'Lifes Purchase', null, 7, 3813, null, null, 27392, 21174);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (588, 557, 'Diamond Purchase', null, 13, 1187, null, null, 3361, 30537);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (589, 324, 'Free Roll', null, 12, 3921, null, null, 82730, 39061);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (590, 177, 'Lose Level', null, 4, 1383, null, null, 17498, 67866);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (591, 397, 'Lose Level', null, 8, 1371, null, null, 73032, 86694);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (592, 407, 'Free Roll', null, 7, 1722, null, null, 17578, 71385);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (593, 541, 'Diamond Purchase', null, 7, 1405, null, null, 32135, 78924);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (594, 265, 'Lose Level', null, 6, 3278, null, null, 52992, 43864);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (595, 9, 'Free Roll', null, 7, 2089, null, null, 76681, 24410);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (596, 630, 'Rolling Wheel', null, 10, 330, null, null, 65908, 62263);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (597, 553, 'Gained a life', null, 9, 3477, null, null, 34932, 89549);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (598, 317, 'Wood Purchase', null, 4, 3899, null, null, 81742, 17162);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (599, 266, 'Free Roll', null, 3, 1289, null, null, 78783, 10750);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (600, 387, 'Rolling Wheel', null, 2, 3366, null, null, 16498, 5507);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (601, 88, 'Gold Purchase', null, 6, 2153, null, null, 48332, 57059);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (602, 619, 'Free Roll', null, 10, 2784, null, null, 37464, 13057);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (603, 834, 'Lose Level', null, 4, 519, null, null, 26699, 17112);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (604, 477, 'Wood Purchase', null, 10, 3273, null, null, 86879, 30896);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (605, 463, 'Free Roll', null, 6, 2921, null, null, 74253, 56229);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (606, 38, 'Gold Purchase', null, 5, 3937, null, null, 76600, 24636);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (607, 367, 'Gold Purchase', null, 4, 2632, null, null, 16307, 65883);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (608, 806, 'Game Purchase', null, 2, 988, null, null, 18397, 87161);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (609, 436, 'Points Purchase', null, 3, 3171, null, null, 73292, 91020);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (610, 643, 'Diamond Purchase', null, 8, 2058, null, null, 21926, 60532);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (611, 506, 'Gold Purchase', null, 8, 389, null, null, 83418, 99230);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (612, 810, 'Lifes Purchase', null, 11, 3125, null, null, 8891, 2444);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (613, 114, 'Gained a life', null, 8, 2367, null, null, 31788, 24113);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (614, 196, 'Game Purchase', null, 9, 3097, null, null, 20550, 30747);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (615, 462, 'Gold Purchase', null, 9, 2287, null, null, 54930, 65577);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (616, 100, 'Free Roll', null, 4, 1860, null, null, 66471, 19904);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (617, 670, 'Gold Purchase', null, 6, 167, null, null, 72166, 9264);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (618, 591, 'Lose Level', null, 8, 1462, null, null, 73582, 47692);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (619, 615, 'Lifes Purchase', null, 10, 2678, null, null, 17522, 50815);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (620, 755, 'Gained a life', null, 11, 2617, null, null, 60133, 31310);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (621, 333, 'Opened game', null, 13, 1007, null, null, 73960, 3539);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (622, 55, 'Gold Purchase', null, 1, 3122, null, null, 96879, 85179);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (623, 436, 'Diamond Purchase', null, 4, 852, null, null, 63817, 53940);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (624, 850, 'Diamond Purchase', null, 9, 283, null, null, 35749, 53687);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (625, 367, 'Points Purchase', null, 6, 3776, null, null, 48879, 76717);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (626, 104, 'Points Purchase', null, 10, 855, null, null, 48725, 92320);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (627, 376, 'Gained a life', null, 4, 108, null, null, 42555, 32533);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (628, 303, 'Points Purchase', null, 12, 2983, null, null, 6917, 3820);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (629, 386, 'Game Purchase', null, 2, 3365, null, null, 77693, 84081);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (630, 183, 'Free Roll', null, 13, 587, null, null, 34291, 41117);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (631, 648, 'Gold Purchase', null, 8, 569, null, null, 34619, 93413);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (632, 202, 'Diamond Purchase', null, 3, 3526, null, null, 90382, 92977);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (633, 774, 'Gold Purchase', null, 11, 469, null, null, 2985, 6943);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (634, 476, 'General action', null, 13, 804, null, null, 76592, 30385);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (635, 628, 'Gained a life', null, 6, 1586, null, null, 67699, 5359);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (636, 50, 'Opened game', null, 5, 3164, null, null, 55267, 21260);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (637, 143, 'Free Roll', null, 13, 2269, null, null, 56433, 61913);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (638, 13, 'General action', null, 6, 983, null, null, 71748, 88145);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (639, 545, 'Gold Purchase', null, 2, 79, null, null, 57921, 96878);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (640, 245, 'General action', null, 5, 3442, null, null, 85699, 61851);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (641, 130, 'Game Purchase', null, 4, 1187, null, null, 14420, 63574);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (642, 510, 'Points Purchase', null, 8, 65, null, null, 68019, 83143);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (643, 444, 'Gold Purchase', null, 5, 3872, null, null, 56425, 12909);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (644, 149, 'General action', null, 5, 470, null, null, 89440, 29685);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (645, 465, 'Lifes Purchase', null, 1, 3614, null, null, 68500, 44786);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (646, 47, 'Wood Purchase', null, 13, 1564, null, null, 47085, 70689);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (647, 518, 'Win level', null, 4, 589, null, null, 70974, 98899);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (648, 244, 'Points Purchase', null, 12, 3830, null, null, 2907, 51557);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (649, 605, 'Free Roll', null, 10, 3299, null, null, 17939, 67123);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (650, 656, 'Game Purchase', null, 12, 3610, null, null, 66178, 98150);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (651, 385, 'Win level', null, 3, 3976, null, null, 93660, 10269);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (652, 672, 'Wood Purchase', null, 8, 2843, null, null, 32648, 9099);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (653, 463, 'Lifes Purchase', null, 1, 3935, null, null, 82157, 49068);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (654, 67, 'Wood Purchase', null, 13, 2894, null, null, 53670, 20212);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (655, 778, 'General action', null, 3, 3048, null, null, 82862, 76794);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (656, 60, 'Points Purchase', null, 13, 568, null, null, 8501, 36912);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (657, 565, 'Diamond Purchase', null, 8, 392, null, null, 26828, 6850);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (658, 216, 'Win level', null, 9, 3886, null, null, 76840, 67221);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (659, 808, 'Win level', null, 3, 2631, null, null, 8199, 75326);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (660, 739, 'Win level', null, 4, 1991, null, null, 3013, 6338);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (661, 380, 'Game Purchase', null, 2, 2455, null, null, 41318, 75469);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (662, 782, 'Lifes Purchase', null, 5, 3284, null, null, 71676, 20907);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (663, 530, 'Gained a life', null, 11, 2556, null, null, 16801, 9330);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (664, 798, 'Rolling Wheel', null, 12, 3661, null, null, 37383, 91520);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (665, 219, 'Wood Purchase', null, 12, 2821, null, null, 95125, 91084);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (666, 679, 'Wood Purchase', null, 3, 2354, null, null, 84602, 20107);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (667, 438, 'Opened game', null, 3, 2139, null, null, 2925, 80969);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (668, 401, 'General action', null, 10, 3810, null, null, 14231, 15442);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (669, 436, 'Points Purchase', null, 3, 2812, null, null, 50923, 98039);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (670, 538, 'Lose Level', null, 2, 3246, null, null, 3651, 81552);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (671, 86, 'Free Roll', null, 12, 3139, null, null, 22028, 28836);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (672, 48, 'Points Purchase', null, 1, 3884, null, null, 34345, 76402);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (673, 585, 'Gold Purchase', null, 9, 657, null, null, 63289, 77444);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (674, 617, 'Gold Purchase', null, 3, 745, null, null, 19969, 85990);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (675, 776, 'Gold Purchase', null, 4, 2061, null, null, 41236, 38097);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (676, 546, 'Gold Purchase', null, 1, 1194, null, null, 83526, 71748);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (677, 674, 'Gained a life', null, 9, 2247, null, null, 83698, 95149);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (678, 502, 'Diamond Purchase', null, 9, 2825, null, null, 74559, 33947);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (679, 293, 'Wood Purchase', null, 3, 1786, null, null, 2346, 49031);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (680, 725, 'General action', null, 7, 3206, null, null, 61054, 46570);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (681, 789, 'General action', null, 10, 114, null, null, 61185, 63145);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (682, 518, 'Gold Purchase', null, 11, 3599, null, null, 96087, 82252);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (683, 664, 'Opened game', null, 12, 167, null, null, 60568, 27687);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (684, 253, 'Opened game', null, 12, 514, null, null, 59043, 48523);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (685, 711, 'Opened game', null, 5, 98, null, null, 91655, 65862);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (686, 440, 'Game Purchase', null, 11, 3880, null, null, 62707, 39023);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (687, 92, 'Gained a life', null, 11, 1347, null, null, 58973, 57881);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (688, 65, 'Diamond Purchase', null, 5, 3092, null, null, 78651, 65379);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (689, 639, 'Lose Level', null, 5, 3031, null, null, 53233, 72345);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (690, 852, 'Gold Purchase', null, 7, 1461, null, null, 16554, 4496);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (691, 109, 'Wood Purchase', null, 8, 2886, null, null, 54182, 92569);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (692, 182, 'Diamond Purchase', null, 10, 2363, null, null, 7249, 73265);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (693, 795, 'General action', null, 10, 782, null, null, 89583, 50714);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (694, 14, 'Lifes Purchase', null, 7, 1153, null, null, 25148, 94931);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (695, 112, 'Lifes Purchase', null, 1, 3731, null, null, 86643, 29289);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (696, 264, 'Rolling Wheel', null, 8, 3557, null, null, 45728, 89012);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (697, 352, 'Points Purchase', null, 1, 1287, null, null, 91114, 29000);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (698, 172, 'General action', null, 9, 187, null, null, 34196, 89060);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (699, 802, 'Gold Purchase', null, 12, 3498, null, null, 31339, 16362);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (700, 811, 'Gained a life', null, 3, 1473, null, null, 32240, 47260);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (701, 713, 'Opened game', null, 11, 314, null, null, 63899, 55498);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (702, 43, 'Free Roll', null, 11, 462, null, null, 2172, 25000);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (703, 56, 'Lose Level', null, 3, 2569, null, null, 3863, 68633);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (704, 101, 'Game Purchase', null, 11, 737, null, null, 44059, 4177);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (705, 728, 'Diamond Purchase', null, 3, 279, null, null, 6569, 73567);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (706, 773, 'Lifes Purchase', null, 9, 3914, null, null, 5843, 3760);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (707, 247, 'Game Purchase', null, 8, 1682, null, null, 55745, 55116);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (708, 284, 'Diamond Purchase', null, 6, 2661, null, null, 35563, 90275);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (709, 109, 'Diamond Purchase', null, 6, 2229, null, null, 14275, 76711);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (710, 772, 'General action', null, 4, 1298, null, null, 46023, 24953);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (711, 656, 'Opened game', null, 13, 2454, null, null, 9221, 80786);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (712, 598, 'Diamond Purchase', null, 7, 2665, null, null, 81943, 50160);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (713, 800, 'Free Roll', null, 9, 3160, null, null, 91146, 86892);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (714, 204, 'General action', null, 6, 2472, null, null, 82008, 97522);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (715, 333, 'Rolling Wheel', null, 8, 1596, null, null, 71872, 94055);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (716, 62, 'Lifes Purchase', null, 4, 2079, null, null, 18407, 60382);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (717, 120, 'Lifes Purchase', null, 5, 1860, null, null, 80293, 89894);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (718, 10, 'Lose Level', null, 8, 2009, null, null, 34623, 7000);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (719, 712, 'Win level', null, 5, 3170, null, null, 72061, 87628);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (720, 588, 'Free Roll', null, 13, 3301, null, null, 91232, 95282);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (721, 456, 'Rolling Wheel', null, 4, 3469, null, null, 83173, 50649);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (722, 469, 'Win level', null, 12, 2503, null, null, 44917, 82780);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (723, 854, 'Lose Level', null, 7, 2946, null, null, 72553, 9692);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (724, 364, 'Rolling Wheel', null, 11, 3451, null, null, 13702, 43096);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (725, 484, 'General action', null, 12, 3109, null, null, 26598, 73031);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (726, 140, 'Lifes Purchase', null, 3, 230, null, null, 33456, 58762);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (727, 241, 'Lose Level', null, 5, 1104, null, null, 46319, 73698);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (728, 495, 'Free Roll', null, 12, 1551, null, null, 94200, 42075);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (729, 294, 'Wood Purchase', null, 13, 3885, null, null, 22044, 62826);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (730, 721, 'General action', null, 1, 2378, null, null, 35445, 61926);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (731, 308, 'Rolling Wheel', null, 10, 3589, null, null, 12435, 1242);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (732, 796, 'Win level', null, 6, 189, null, null, 97746, 96835);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (733, 111, 'Lose Level', null, 10, 1087, null, null, 29216, 8912);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (734, 288, 'Points Purchase', null, 7, 1503, null, null, 78102, 16934);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (735, 40, 'Lifes Purchase', null, 10, 3514, null, null, 95653, 89036);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (736, 397, 'Gold Purchase', null, 13, 3771, null, null, 48207, 87887);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (737, 37, 'Game Purchase', null, 11, 3749, null, null, 8236, 97378);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (738, 725, 'Gold Purchase', null, 9, 1784, null, null, 17092, 44470);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (739, 720, 'Lifes Purchase', null, 10, 2278, null, null, 51233, 86556);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (740, 727, 'Wood Purchase', null, 2, 3784, null, null, 34048, 70899);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (741, 13, 'Opened game', null, 7, 1020, null, null, 72477, 85477);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (742, 121, 'Gained a life', null, 6, 2803, null, null, 63068, 59999);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (743, 695, 'Gained a life', null, 13, 782, null, null, 75784, 21439);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (744, 100, 'Rolling Wheel', null, 5, 3972, null, null, 51435, 64863);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (745, 854, 'General action', null, 8, 2023, null, null, 7007, 21265);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (746, 175, 'Rolling Wheel', null, 12, 1768, null, null, 88814, 39478);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (747, 753, 'Opened game', null, 8, 3520, null, null, 31607, 37961);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (748, 204, 'General action', null, 11, 636, null, null, 79031, 48350);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (749, 110, 'Win level', null, 7, 2075, null, null, 90887, 51476);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (750, 329, 'Free Roll', null, 2, 2156, null, null, 10535, 71581);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (751, 563, 'Gained a life', null, 11, 1653, null, null, 25045, 19309);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (752, 376, 'Lose Level', null, 3, 1314, null, null, 90563, 42297);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (753, 459, 'Lifes Purchase', null, 8, 3973, null, null, 79771, 37203);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (754, 483, 'Lifes Purchase', null, 12, 1363, null, null, 14180, 24585);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (755, 495, 'Wood Purchase', null, 13, 1351, null, null, 87993, 78426);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (756, 666, 'Diamond Purchase', null, 13, 1368, null, null, 37866, 67346);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (757, 433, 'Free Roll', null, 13, 658, null, null, 40376, 59237);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (758, 765, 'Opened game', null, 5, 378, null, null, 86774, 61922);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (759, 528, 'Diamond Purchase', null, 4, 1067, null, null, 54212, 68202);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (760, 189, 'Points Purchase', null, 10, 1374, null, null, 74715, 54654);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (761, 298, 'Free Roll', null, 2, 3305, null, null, 64763, 50790);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (762, 287, 'Rolling Wheel', null, 3, 3549, null, null, 15614, 73052);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (763, 327, 'Gold Purchase', null, 1, 149, null, null, 255, 83278);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (764, 785, 'Points Purchase', null, 11, 3928, null, null, 1032, 64760);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (765, 464, 'Gold Purchase', null, 1, 1609, null, null, 19992, 39867);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (766, 534, 'Gold Purchase', null, 4, 196, null, null, 76234, 48094);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (767, 213, 'Gold Purchase', null, 1, 205, null, null, 8573, 49359);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (768, 387, 'Lifes Purchase', null, 8, 2719, null, null, 56560, 75574);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (769, 613, 'Opened game', null, 12, 3541, null, null, 45368, 34516);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (770, 190, 'Free Roll', null, 9, 3262, null, null, 96475, 43247);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (771, 101, 'Lifes Purchase', null, 6, 2320, null, null, 11168, 80564);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (772, 185, 'Diamond Purchase', null, 6, 2287, null, null, 52286, 41556);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (773, 225, 'Win level', null, 1, 198, null, null, 48039, 91547);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (774, 82, 'General action', null, 7, 2791, null, null, 37908, 9767);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (775, 712, 'Lifes Purchase', null, 7, 2002, null, null, 60389, 60974);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (776, 520, 'Gold Purchase', null, 10, 2284, null, null, 40774, 67003);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (777, 98, 'Points Purchase', null, 9, 1872, null, null, 64536, 25178);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (778, 471, 'Win level', null, 4, 3484, null, null, 44368, 36759);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (779, 89, 'Opened game', null, 1, 2435, null, null, 63607, 77999);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (780, 652, 'General action', null, 6, 1657, null, null, 88030, 29261);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (781, 149, 'Free Roll', null, 13, 1627, null, null, 90519, 15002);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (782, 348, 'Lose Level', null, 8, 2801, null, null, 65636, 56308);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (783, 366, 'General action', null, 7, 51, null, null, 71199, 20411);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (784, 706, 'Wood Purchase', null, 12, 2667, null, null, 45308, 91214);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (785, 681, 'Diamond Purchase', null, 7, 916, null, null, 59199, 64774);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (786, 321, 'Gained a life', null, 4, 3758, null, null, 23162, 52344);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (787, 576, 'Wood Purchase', null, 7, 3615, null, null, 28886, 52818);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (788, 502, 'Gained a life', null, 13, 3269, null, null, 68925, 39226);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (789, 677, 'Gold Purchase', null, 3, 3416, null, null, 3282, 87508);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (790, 97, 'Game Purchase', null, 6, 2019, null, null, 35060, 34302);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (791, 730, 'Gold Purchase', null, 10, 3959, null, null, 37229, 62273);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (792, 305, 'Game Purchase', null, 3, 1567, null, null, 23516, 84182);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (793, 133, 'Diamond Purchase', null, 8, 1112, null, null, 7709, 15063);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (794, 291, 'Gold Purchase', null, 5, 1679, null, null, 60697, 61297);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (795, 127, 'Gained a life', null, 7, 3725, null, null, 74497, 18424);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (796, 359, 'Opened game', null, 1, 3827, null, null, 85180, 58999);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (797, 66, 'Gold Purchase', null, 3, 1731, null, null, 35230, 67982);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (798, 255, 'General action', null, 8, 1392, null, null, 73408, 89917);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (799, 751, 'Lose Level', null, 11, 3550, null, null, 5043, 32049);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (800, 221, 'Gained a life', null, 13, 1693, null, null, 45165, 76870);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (801, 749, 'Lose Level', null, 11, 2874, null, null, 99056, 54530);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (802, 637, 'Rolling Wheel', null, 2, 343, null, null, 14080, 62583);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (803, 780, 'Gained a life', null, 1, 3723, null, null, 46364, 52111);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (804, 57, 'Wood Purchase', null, 7, 3688, null, null, 49993, 47954);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (805, 199, 'Diamond Purchase', null, 6, 2950, null, null, 53813, 19352);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (806, 193, 'Rolling Wheel', null, 13, 848, null, null, 22888, 52623);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (807, 335, 'Diamond Purchase', null, 8, 2837, null, null, 91063, 38123);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (808, 508, 'Free Roll', null, 10, 3844, null, null, 49938, 23377);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (809, 362, 'Free Roll', null, 4, 296, null, null, 6779, 55346);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (810, 624, 'Gained a life', null, 12, 2270, null, null, 72488, 99902);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (811, 97, 'Lose Level', null, 5, 193, null, null, 78871, 59723);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (812, 515, 'Lose Level', null, 5, 1917, null, null, 51735, 12359);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (813, 474, 'Gained a life', null, 1, 3402, null, null, 20627, 83043);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (814, 546, 'Game Purchase', null, 1, 838, null, null, 99499, 46838);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (815, 155, 'Game Purchase', null, 4, 2913, null, null, 77467, 45304);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (816, 53, 'Wood Purchase', null, 4, 3555, null, null, 90129, 64954);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (817, 611, 'General action', null, 6, 2511, null, null, 59418, 65213);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (818, 825, 'General action', null, 8, 3705, null, null, 2334, 40991);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (819, 170, 'Free Roll', null, 9, 3265, null, null, 96199, 4460);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (820, 828, 'Wood Purchase', null, 7, 2732, null, null, 72092, 27161);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (821, 818, 'Free Roll', null, 2, 1608, null, null, 70269, 46765);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (822, 510, 'Rolling Wheel', null, 10, 1106, null, null, 98863, 17257);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (823, 402, 'Lose Level', null, 4, 2441, null, null, 29850, 43792);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (824, 397, 'Gold Purchase', null, 12, 3683, null, null, 7910, 77085);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (825, 123, 'Gained a life', null, 6, 343, null, null, 54653, 43926);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (826, 717, 'Lose Level', null, 7, 2013, null, null, 10513, 26898);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (827, 133, 'Game Purchase', null, 1, 2377, null, null, 51245, 81944);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (828, 672, 'Lifes Purchase', null, 1, 1374, null, null, 30999, 9022);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (829, 421, 'Diamond Purchase', null, 4, 1247, null, null, 77442, 93358);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (830, 732, 'Diamond Purchase', null, 5, 3154, null, null, 90372, 33516);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (831, 347, 'Wood Purchase', null, 1, 282, null, null, 19538, 85100);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (832, 333, 'Wood Purchase', null, 12, 1744, null, null, 29239, 60393);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (833, 66, 'Free Roll', null, 7, 443, null, null, 30669, 22497);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (834, 854, 'Free Roll', null, 4, 1448, null, null, 19150, 59435);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (835, 394, 'Win level', null, 4, 1388, null, null, 72512, 28310);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (836, 80, 'Free Roll', null, 6, 828, null, null, 17939, 89995);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (837, 649, 'Free Roll', null, 4, 22, null, null, 64102, 99850);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (838, 227, 'Gold Purchase', null, 1, 2594, null, null, 80684, 99834);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (839, 834, 'Opened game', null, 8, 1058, null, null, 2075, 73473);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (840, 845, 'Opened game', null, 4, 2434, null, null, 48577, 70687);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (841, 229, 'Opened game', null, 13, 2884, null, null, 32657, 94464);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (842, 595, 'Gold Purchase', null, 1, 2028, null, null, 84031, 40372);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (843, 183, 'Lifes Purchase', null, 13, 32, null, null, 48586, 86821);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (844, 489, 'Diamond Purchase', null, 2, 612, null, null, 49610, 14947);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (845, 101, 'Game Purchase', null, 4, 733, null, null, 97825, 68176);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (846, 272, 'General action', null, 7, 3549, null, null, 93937, 57060);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (847, 747, 'Points Purchase', null, 13, 3253, null, null, 21683, 6244);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (848, 678, 'Gained a life', null, 2, 2784, null, null, 58914, 73497);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (849, 463, 'Lose Level', null, 13, 530, null, null, 45096, 56376);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (850, 455, 'Gold Purchase', null, 9, 3140, null, null, 10747, 95682);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (851, 703, 'Game Purchase', null, 3, 2036, null, null, 13691, 90934);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (852, 727, 'Points Purchase', null, 4, 2857, null, null, 27552, 21836);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (853, 571, 'Game Purchase', null, 5, 3314, null, null, 3111, 55477);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (854, 612, 'Wood Purchase', null, 8, 2479, null, null, 95844, 536);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (855, 531, 'Gold Purchase', null, 5, 1718, null, null, 95081, 59658);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (856, 586, 'Wood Purchase', null, 11, 1465, null, null, 96137, 82597);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (857, 763, 'Wood Purchase', null, 8, 2474, null, null, 41856, 75158);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (858, 292, 'Points Purchase', null, 2, 1613, null, null, 43951, 8737);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (859, 177, 'General action', null, 10, 1692, null, null, 41051, 90837);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (860, 757, 'Wood Purchase', null, 8, 3344, null, null, 30480, 66973);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (861, 657, 'Rolling Wheel', null, 5, 880, null, null, 63026, 157);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (862, 368, 'Diamond Purchase', null, 6, 3183, null, null, 43969, 2364);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (863, 816, 'General action', null, 13, 2463, null, null, 63060, 77151);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (864, 7, 'Win level', null, 6, 3837, null, null, 94136, 18687);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (865, 473, 'General action', null, 6, 1106, null, null, 90583, 75214);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (866, 64, 'Gained a life', null, 11, 3490, null, null, 52017, 14004);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (867, 489, 'Gained a life', null, 10, 3948, null, null, 54132, 98893);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (868, 557, 'Game Purchase', null, 1, 2505, null, null, 46716, 54915);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (869, 21, 'Lose Level', null, 6, 1300, null, null, 18810, 63237);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (870, 652, 'General action', null, 9, 3577, null, null, 12116, 79726);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (871, 625, 'Points Purchase', null, 3, 344, null, null, 75454, 3602);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (872, 595, 'Gold Purchase', null, 13, 1405, null, null, 51403, 24024);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (873, 154, 'Rolling Wheel', null, 4, 1048, null, null, 70508, 2166);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (874, 810, 'Win level', null, 11, 1117, null, null, 81900, 63862);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (875, 120, 'Gold Purchase', null, 13, 2727, null, null, 52791, 52105);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (876, 232, 'Game Purchase', null, 10, 921, null, null, 83871, 94730);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (877, 452, 'Lose Level', null, 1, 2911, null, null, 18524, 68142);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (878, 456, 'Gained a life', null, 8, 622, null, null, 27388, 17548);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (879, 591, 'Game Purchase', null, 11, 2781, null, null, 35070, 43759);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (880, 66, 'Free Roll', null, 2, 1609, null, null, 57983, 95157);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (881, 106, 'Game Purchase', null, 6, 2766, null, null, 65697, 86268);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (882, 142, 'Lifes Purchase', null, 1, 2352, null, null, 29692, 79022);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (883, 125, 'Free Roll', null, 1, 265, null, null, 95279, 48091);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (884, 505, 'Game Purchase', null, 5, 235, null, null, 89738, 93333);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (885, 838, 'Diamond Purchase', null, 4, 3630, null, null, 42626, 78492);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (886, 765, 'Lose Level', null, 11, 3563, null, null, 66057, 73977);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (887, 205, 'Rolling Wheel', null, 12, 1162, null, null, 33324, 76228);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (888, 139, 'Diamond Purchase', null, 2, 128, null, null, 80258, 41476);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (889, 444, 'Diamond Purchase', null, 2, 3318, null, null, 13794, 99845);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (890, 607, 'Lifes Purchase', null, 13, 1327, null, null, 30261, 11345);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (891, 616, 'Points Purchase', null, 8, 640, null, null, 29084, 9958);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (892, 453, 'Gold Purchase', null, 4, 2724, null, null, 78927, 91807);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (893, 829, 'Wood Purchase', null, 12, 1204, null, null, 81231, 55682);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (894, 762, 'Lose Level', null, 13, 507, null, null, 98846, 32956);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (895, 22, 'Win level', null, 3, 898, null, null, 78073, 22991);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (896, 188, 'Diamond Purchase', null, 11, 112, null, null, 51795, 72265);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (897, 156, 'Diamond Purchase', null, 9, 3167, null, null, 43464, 56194);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (898, 603, 'Rolling Wheel', null, 12, 2544, null, null, 23524, 86806);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (899, 736, 'Lose Level', null, 5, 2149, null, null, 29422, 47799);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (900, 830, 'Gold Purchase', null, 8, 1710, null, null, 53240, 83246);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (901, 86, 'Game Purchase', null, 4, 2003, null, null, 66719, 71450);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (902, 108, 'Lose Level', null, 9, 1377, null, null, 75105, 32673);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (903, 423, 'Opened game', null, 10, 1370, null, null, 56383, 72458);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (904, 680, 'Diamond Purchase', null, 5, 3143, null, null, 15049, 93743);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (905, 813, 'Diamond Purchase', null, 1, 2769, null, null, 66745, 83651);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (906, 489, 'Opened game', null, 13, 404, null, null, 43918, 86225);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (907, 818, 'Gold Purchase', null, 7, 599, null, null, 92497, 16173);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (908, 356, 'Diamond Purchase', null, 12, 2743, null, null, 78053, 27079);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (909, 549, 'Diamond Purchase', null, 10, 2049, null, null, 35060, 816);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (910, 835, 'Free Roll', null, 1, 1968, null, null, 66035, 26728);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (911, 414, 'Game Purchase', null, 7, 2840, null, null, 11023, 42472);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (912, 256, 'Points Purchase', null, 9, 2828, null, null, 364, 56223);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (913, 179, 'General action', null, 3, 2035, null, null, 33505, 75610);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (914, 526, 'Game Purchase', null, 9, 1076, null, null, 34984, 88592);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (915, 698, 'Rolling Wheel', null, 8, 666, null, null, 71409, 25364);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (916, 219, 'Gained a life', null, 4, 1276, null, null, 55369, 7724);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (917, 56, 'Lose Level', null, 9, 3435, null, null, 94989, 23840);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (918, 772, 'Lifes Purchase', null, 11, 144, null, null, 64187, 97850);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (919, 76, 'Points Purchase', null, 5, 1107, null, null, 99964, 8613);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (920, 201, 'Points Purchase', null, 7, 3406, null, null, 6917, 59029);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (921, 399, 'Free Roll', null, 10, 3601, null, null, 90761, 14984);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (922, 240, 'Win level', null, 7, 3025, null, null, 87829, 21936);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (923, 726, 'Rolling Wheel', null, 9, 1642, null, null, 15913, 61199);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (924, 106, 'Points Purchase', null, 11, 2356, null, null, 91809, 87691);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (925, 239, 'Lose Level', null, 13, 3695, null, null, 89391, 68170);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (926, 502, 'Gained a life', null, 12, 508, null, null, 4441, 71158);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (927, 821, 'Rolling Wheel', null, 7, 2320, null, null, 5322, 50406);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (928, 725, 'Gold Purchase', null, 13, 3795, null, null, 35887, 44735);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (929, 623, 'Points Purchase', null, 4, 664, null, null, 53498, 94846);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (930, 814, 'Rolling Wheel', null, 12, 1120, null, null, 62200, 36165);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (931, 567, 'Lifes Purchase', null, 3, 97, null, null, 4916, 83618);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (932, 116, 'Opened game', null, 11, 613, null, null, 95134, 44315);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (933, 129, 'General action', null, 8, 1487, null, null, 81103, 45653);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (934, 150, 'Rolling Wheel', null, 1, 150, null, null, 49061, 63800);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (935, 518, 'Diamond Purchase', null, 5, 3527, null, null, 23478, 1335);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (936, 532, 'Gained a life', null, 5, 2400, null, null, 34979, 45526);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (937, 285, 'Gained a life', null, 13, 1749, null, null, 33647, 66934);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (938, 439, 'Lose Level', null, 5, 1986, null, null, 89131, 61206);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (939, 616, 'Lifes Purchase', null, 1, 3367, null, null, 98307, 98723);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (940, 227, 'Rolling Wheel', null, 8, 1194, null, null, 10165, 86550);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (941, 282, 'Wood Purchase', null, 11, 2676, null, null, 70824, 15037);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (942, 827, 'Gained a life', null, 6, 1949, null, null, 56891, 98524);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (943, 227, 'Gained a life', null, 5, 639, null, null, 78558, 70604);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (944, 624, 'Gained a life', null, 7, 2563, null, null, 67518, 75638);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (945, 331, 'Lose Level', null, 6, 716, null, null, 9097, 81585);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (946, 567, 'Rolling Wheel', null, 5, 741, null, null, 34774, 15751);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (947, 165, 'Gained a life', null, 4, 3577, null, null, 79540, 45687);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (948, 82, 'Wood Purchase', null, 12, 2470, null, null, 64316, 13938);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (949, 463, 'General action', null, 12, 1627, null, null, 41014, 226);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (950, 618, 'Gold Purchase', null, 6, 219, null, null, 38448, 72898);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (951, 428, 'Gold Purchase', null, 4, 1887, null, null, 79596, 40554);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (952, 29, 'Lifes Purchase', null, 8, 834, null, null, 72177, 49503);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (953, 104, 'Diamond Purchase', null, 12, 144, null, null, 5269, 71633);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (954, 214, 'Win level', null, 10, 2995, null, null, 72074, 18277);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (955, 369, 'Opened game', null, 5, 1129, null, null, 58882, 33949);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (956, 413, 'Points Purchase', null, 6, 112, null, null, 37809, 63520);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (957, 678, 'Lifes Purchase', null, 8, 2726, null, null, 79902, 9325);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (958, 317, 'Rolling Wheel', null, 4, 2140, null, null, 86076, 33398);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (959, 426, 'Wood Purchase', null, 13, 1302, null, null, 90931, 10478);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (960, 409, 'Lose Level', null, 7, 1624, null, null, 51810, 67584);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (961, 307, 'Win level', null, 2, 2782, null, null, 24002, 43633);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (962, 254, 'General action', null, 1, 1137, null, null, 60161, 24822);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (963, 44, 'Points Purchase', null, 5, 12, null, null, 90649, 32970);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (964, 846, 'Diamond Purchase', null, 9, 2840, null, null, 58359, 9389);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (965, 564, 'Wood Purchase', null, 9, 3003, null, null, 33790, 59636);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (966, 751, 'Gained a life', null, 4, 2951, null, null, 54751, 55705);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (967, 489, 'General action', null, 13, 3069, null, null, 83854, 22684);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (968, 658, 'Wood Purchase', null, 7, 2067, null, null, 18639, 61769);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (969, 179, 'Lose Level', null, 6, 2952, null, null, 83822, 90710);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (970, 102, 'Diamond Purchase', null, 11, 524, null, null, 71175, 62322);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (971, 36, 'Gold Purchase', null, 4, 247, null, null, 60114, 19185);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (972, 500, 'Game Purchase', null, 10, 1441, null, null, 6660, 28860);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (973, 56, 'Gained a life', null, 9, 875, null, null, 24320, 53648);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (974, 336, 'Lose Level', null, 7, 2115, null, null, 12709, 15985);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (975, 56, 'Wood Purchase', null, 12, 2448, null, null, 47048, 14948);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (976, 725, 'Diamond Purchase', null, 6, 1635, null, null, 40519, 12157);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (977, 702, 'Points Purchase', null, 4, 65, null, null, 27962, 54649);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (978, 386, 'Lifes Purchase', null, 7, 1923, null, null, 5434, 41535);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (979, 732, 'General action', null, 9, 431, null, null, 17596, 25963);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (980, 612, 'Rolling Wheel', null, 7, 2118, null, null, 89554, 3192);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (981, 1, 'Rolling Wheel', null, 1, 1275, null, null, 37610, 99712);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (982, 527, 'Rolling Wheel', null, 12, 2293, null, null, 85700, 54310);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (983, 784, 'Win level', null, 13, 1005, null, null, 18609, 44564);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (984, 586, 'Wood Purchase', null, 11, 1673, null, null, 42968, 67746);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (985, 316, 'General action', null, 11, 1749, null, null, 35402, 25605);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (986, 534, 'Points Purchase', null, 2, 2993, null, null, 97252, 41621);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (987, 490, 'Opened game', null, 10, 3838, null, null, 74782, 73620);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (988, 391, 'Gained a life', null, 6, 2003, null, null, 66299, 73990);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (989, 650, 'Gold Purchase', null, 7, 1752, null, null, 34140, 17673);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (990, 727, 'Points Purchase', null, 3, 3034, null, null, 45545, 43346);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (991, 219, 'Gained a life', null, 1, 3412, null, null, 63884, 84540);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (992, 532, 'General action', null, 10, 3756, null, null, 82164, 99682);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (993, 575, 'Game Purchase', null, 8, 729, null, null, 33867, 66524);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (994, 692, 'General action', null, 11, 2334, null, null, 46258, 13788);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (995, 564, 'Rolling Wheel', null, 4, 2816, null, null, 48438, 58134);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (996, 739, 'Win level', null, 9, 721, null, null, 18452, 66859);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (997, 481, 'Points Purchase', null, 10, 3844, null, null, 18601, 70015);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (998, 112, 'Lose Level', null, 2, 604, null, null, 81537, 350);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (999, 483, 'Game Purchase', null, 2, 2691, null, null, 91487, 34472);
insert into Events (EventID, UserID, EventDes, EventDate, GameID, PlayerLevel, SessionID, Balance, BalanceIncrease, BalanceDecrease) values (1000, 593, 'Wood Purchase', null, 12, 3215, null, null, 51877, 22659);
GO

-- Inserting a SessionID 
DECLARE
		@EventID INT,
		@UserID INT,
		@SessionID INT,
		@counter INT,
		@variable INT

	SET @counter = 1
	WHILE @counter <= 2000
	
		BEGIN
			SELECT @EventID = EventID FROM Events WHERE EventID = @counter
			SELECT @UserID = UserID FROM Events WHERE EventID = @counter
			SELECT @SessionID = SessionID FROM Sessions WHERE UserID = (SELECT UserID FROM Events WHERE EventID = @counter)
			SELECT @variable = UserID FROM Sessions WHERE UserID = (SELECT UserID FROM Events WHERE EventID = @counter)
			IF @UserID = @variable
				BEGIN
					UPDATE Events SET SessionID = @SessionID WHERE EventID = @counter
					SET @counter = @counter + 1
				END
			ELSE
				SET @counter = @counter + 1
		END
GO

-- Inserting Sessions to NULL SessionID on Events
DECLARE
		@gamedate DATETIME,
		@GameID INT,
		@SessionID INT,
		@SessionStart DATETIME,
		@SessionEnd DATETIME,
		@counter INT,
		@SessionEventiD INT,
		@EventDate DATETIME,
		@UserID INT,
		@SessionDuration INT
	SET @counter = 1
	WHILE @counter <= 1000
	
		BEGIN
			SELECT @SessionEventiD = SessionID FROM Events WHERE EventID = @counter
			SELECT @EventDate = EventDate FROM Events WHERE EventID = @counter
			SELECT @UserID = UserID FROM Events WHERE EventID = @counter
			SELECT @gamedate = DatePublished FROM Games WHERE Gameid = (Select gameid FROM Sessions WHERE SessionID = @counter)
			SELECT @SessionStart = EventDate FROM Events WHERE EventID = @counter
			SELECT @GameID = gameid FROM Games WHERE Gameid = (Select gameid FROM Sessions WHERE SessionID = @counter)		
		IF @SessionEventiD IS NULL AND @gamedate < @SessionStart AND @SessionStart < GETDATE() - 1 
			BEGIN
				SELECT @SessionID = RAND()*(2000-1001)+1001
				SET @SessionEnd = @SessionStart + DATEADD(Minute,RAND()*(300-1)+1,0)
				SET @SessionDuration = DATEDIFF(MINUTE, @SessionStart, @SessionEnd)
				INSERT INTO Sessions VALUES (@SessionID, @GameID, @UserID, @SessionStart, @SessionEnd, @SessionDuration)
				SET @counter = @counter + 1
			END
		ELSE  
			SET @counter = @counter + 1
		END
GO

-- Inserting a SessionID to Events that were NULL before
 DECLARE
		@EventID INT,
		@UserID INT,
		@SessionID INT,
		@counter INT,
		@variable INT

	SET @counter = 1
	WHILE @counter <= 2000
	
		BEGIN
			SELECT @EventID = EventID FROM Events WHERE EventID = @counter
			SELECT @UserID = UserID FROM Events WHERE EventID = @counter
			SELECT @SessionID = SessionID FROM Sessions WHERE UserID = (SELECT UserID FROM Events WHERE EventID = @counter)
			SELECT @variable = UserID FROM Sessions WHERE UserID = (SELECT UserID FROM Events WHERE EventID = @counter)
			IF @UserID = @variable
				BEGIN
					UPDATE Events SET SessionID = @SessionID WHERE EventID = @counter
					SET @counter = @counter + 1
				END
			ELSE
				SET @counter = @counter + 1
		END
GO

-- Deleting the rest of the NULL SessionIDs (Incorrect Events)
DELETE FROM Events WHERE SessionID IS NULL
GO

-- Inserting random EventDate

-- BEGIN TRANSACTION 

DECLARE
		@EventID INT,
		@UserID INT,
		@EventDes VARCHAR(50),
		@EventDate DATETIME,
		@SessionID INT,
		@counter INT,
		@SessionStart DATETIME,
		@SessionEnd DATETIME

	SET @counter = 1
	WHILE @counter <= 1000
	
		BEGIN
			SELECT @EventID = EventID FROM Events WHERE EventID = @counter
			SELECT @UserID = UserID FROM Events WHERE EventID = @counter
			SELECT @EventDes = EventDes FROM Events WHERE EventID = @counter
			SELECT @SessionID = SessionID FROM Events WHERE EventID = @counter
			SELECT @SessionStart = SessionStart FROM Sessions WHERE SessionID = @SessionID
			SELECT @SessionEnd = SessionEnd FROM Sessions WHERE SessionID = @SessionID
			SET @EventDate = CAST(RAND()*(CAST(@SessionEnd AS INT)-CAST(@SessionStart AS INT))+CAST(@SessionStart AS INT) AS DATETIME)
				UPDATE Events SET EventDate = @EventDate WHERE EventID = @counter
			SET @counter = @counter + 1
		END
GO

-- Deleting Balance values
-- BEGIN TRANSACTION
UPDATE EVENTS SET BalanceIncrease = Null;
UPDATE EVENTS SET BalanceDecrease = Null;
UPDATE EVENTS SET Balance = Null;
DELETE EVENTS WHERE EventDate IS NULL;
-- ROLLBACK/COMMIT
GO

--Adding Balances by the Event Description

--BEGIN TRANSACTION

DECLARE @Balance INT,
		@Count INT,
		@EventID INT,
		@EventDes VARCHAR(50)
	SET @count = 1
WHILE @count <= 1000
BEGIN
	SELECT @EventID = EventID FROM Events WHERE EventID = @count
	SELECT @EventDes = EventDes FROM Events WHERE EventID = @count
	IF @EventDes LIKE ('%Life%')
		BEGIN
			SET @Balance = CAST(RAND()*(10-1)+1 AS INT)
			UPDATE EVENTS SET Balance = @Balance WHERE EventID = @count
			UPDATE EVENTS SET BalanceIncrease = NULL WHERE EventID = @count
			UPDATE EVENTS SET BalanceDecrease = NULL WHERE EventID = @count
			SET @count = @count +1
		END
	ELSE IF @EventDes LIKE ('%Purchase%') AND @EventDes NOT LIKE ('Game Purchase') AND @EventDes NOT LIKE ('%Life%')
		BEGIN
			SET @Balance = CAST(RAND()*(1000000-1)+1 AS INT)
			UPDATE EVENTS SET BalanceIncrease = @Balance WHERE EventID = @count
			UPDATE EVENTS SET Balance = @Balance + CAST(RAND()*(1000000-1)+1 AS INT) WHERE EventID = @count
			SET @count = @count +1
		END
	ELSE IF @EventDes LIKE ('Win Level')
		BEGIN
			SET @Balance = CAST(RAND()*(1000000-1)+1 AS INT)
			UPDATE EVENTS SET Balance = @Balance WHERE EventID = @count
			UPDATE EVENTS SET BalanceIncrease = NULL WHERE EventID = @count
			UPDATE EVENTS SET BalanceDecrease = NULL WHERE EventID = @count
			SET @count = @count +1
		END
	ELSE IF @EventDes LIKE ('Lose Level')
		BEGIN
			SET @Balance = CAST(RAND()*(1000000-1)+1 AS INT)
			UPDATE EVENTS SET Balance = @Balance WHERE EventID = @count
			UPDATE EVENTS SET BalanceIncrease = NULL WHERE EventID = @count
			UPDATE EVENTS SET BalanceDecrease = NULL WHERE EventID = @count
			SET @count = @count +1
		END
	ELSE
		BEGIN
			UPDATE EVENTS SET BalanceIncrease = NULL WHERE EventID = @count
			UPDATE EVENTS SET BalanceDecrease = NULL WHERE EventID = @count
			SET @count = @count +1
		END
END
GO
/*
ROLLBACK

COMMIT

*/
-- TRUNCATE TABLE Purchases

-- Inputting Purchases table infos

-- BEGIN TRANSACTION 

DECLARE @PurchaseID INT,
		@IDCounter INT,
		@UserID INT,
		@EventID INT,
		@EventDate DATETIME,
		@PurchaseAmount NUMERIC(8,2),
		@PurchaseDesc VARCHAR(100),
		@Counter INT,
		@GameID INT,
		@Gamecost NUMERIC (8,2)
	SET @Counter = 1
	SET @PurchaseID = 1
WHILE @Counter <= 1000
BEGIN
	SELECT @EventID = EventID FROM Events WHERE EventID = @Counter
	SELECT @EventDate = EventDate FROM Events WHERE EventID = @Counter
	SELECT @PurchaseDesc = EventDes FROM Events WHERE EventID = @Counter
	SELECT @UserID = UserID FROM Events WHERE EventID = @Counter
	SELECT @Gamecost = Cost FROM Games WHERE GameID = (SELECT GameID FROM Events WHERE EventID = @Counter)
	SELECT @GameID = GameID FROM Games WHERE GameID = (SELECT GameID FROM Events WHERE EventID = @Counter)
	-- Inputting Game Amount into the PurchaseAmount Column
	IF @EventID != @Counter
		SET @Counter = @Counter + 1
	ELSE IF @PurchaseDesc = 'Game Purchase' AND @Gamecost IS NOT NULL
		BEGIN
			INSERT INTO Purchases VALUES (@PurchaseID, @GameID, @UserID, @EventID, @EventDate, @Gamecost, @PurchaseDesc)
			SET @Counter = @Counter + 1
			SET @PurchaseID = @PurchaseID + 1
		END
	-- Inputting Random amount for Life Purchases into the PurchaseAmount Column
	 ELSE IF @PurchaseDesc LIKE ('%Life%Purchase%')
		BEGIN
			SET @Gamecost = CAST(RAND()*(10-1)+1 AS INT)
			INSERT INTO Purchases VALUES (@PurchaseID, @GameID, @UserID, @EventID, @EventDate, @Gamecost, @PurchaseDesc)
			SET @Counter = @Counter + 1
			SET @PurchaseID = @PurchaseID + 1
		END
	-- Inputting Random amount for All other Purchases into the PurchaseAmount Column
	ELSE IF @PurchaseDesc LIKE ('%Purchase%') AND @PurchaseDesc NOT LIKE ('%Life%') AND @PurchaseDesc != 'Game Purchase'
		BEGIN
			SET @Gamecost = CAST(RAND()*(300-1)+1 AS INT)
			INSERT INTO Purchases VALUES (@PurchaseID, @GameID, @UserID, @EventID, @EventDate, @Gamecost, @PurchaseDesc)
			SET @Counter = @Counter + 1
			SET @PurchaseID = @PurchaseID + 1
		END
	ELSE
			SET @Counter = @Counter + 1
END
GO


/* SELECT * FROM Purchases

ROLLBACK

SELECT * FROM Events WHERE EventDes LIKE ('%Purchase%') ORDER BY EventDes

COMMIT
*/

-- Inputting FTD (First time deposit) into Users 

-- BEGIN TRANSACTION 

DECLARE @FTD DATETIME,
		@PurchaseID INT,
		@PurchaseDate DATETIME,
		@Counter INT,
		@Min_eventdate DATETIME
	SET @Counter = 1
WHILE @Counter <= 854
BEGIN
	SELECT @PurchaseDate = EventDate FROM Purchases WHERE UserID = @Counter
	SELECT @PurchaseID = PurchaseID FROM Purchases WHERE UserID = @Counter
	SELECT @Min_eventdate = MIN(EventDate) FROM Purchases WHERE UserID = @Counter
	IF @PurchaseDate = @Min_eventdate 
		BEGIN
			SET @FTD = @Min_eventdate
			UPDATE Users SET FTD = @Min_eventdate WHERE UserID = @counter
			SET @counter = @counter + 1
		END
	ELSE
		SET @counter = @counter + 1
END
GO

--ROLLBACK/COMMIT

/*

SELECT * FROM Users
SELECT * FROM Games
SELECT * FROM Games_Installs
SELECT * FROM Sessions
SELECT * FROM Events
SELECT * FROM Purchases
SELECT * FROM Campaigns
*/
