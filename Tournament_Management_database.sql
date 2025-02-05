-- 1. Database Creation
CREATE DATABASE IF NOT EXISTS Tournament_Management;
USE Tournament_Management;

-- 2. Main Tables

-- Teams Table
-- Stores details about teams.
CREATE TABLE IF NOT EXISTS Teams (
    Team_ID INT PRIMARY KEY,
    Team_Name VARCHAR(100) NOT NULL,
    City VARCHAR(100),
    Division VARCHAR(50),
    Conference VARCHAR(50),
    Historical_Performance VARCHAR(255)
);

-- Players Table
-- Tracks players associated with teams.
CREATE TABLE IF NOT EXISTS Players (
    Player_ID INT PRIMARY KEY,
    Player_Name VARCHAR(100) NOT NULL,
    Team_ID INT,
    Position VARCHAR(50),
    Career_Statistics VARCHAR(255),
    Health_Records VARCHAR(255),
    FOREIGN KEY (Team_ID) REFERENCES Teams(Team_ID) ON DELETE SET NULL
);

-- Games Table
-- Records game-specific information.
CREATE TABLE IF NOT EXISTS Games (
    Game_ID INT PRIMARY KEY,
    Game_Date DATE NOT NULL,
    Home_Team_ID INT,
    Away_Team_ID INT,
    Venue VARCHAR(100),
    Home_Team_Score INT,
    Away_Team_Score INT,
    Outcome VARCHAR(50),
    FOREIGN KEY (Home_Team_ID) REFERENCES Teams(Team_ID) ON DELETE CASCADE,
    FOREIGN KEY (Away_Team_ID) REFERENCES Teams(Team_ID) ON DELETE CASCADE
);

-- Sponsors Table
-- Holds sponsor information.
CREATE TABLE IF NOT EXISTS Sponsors (
    Sponsor_ID INT PRIMARY KEY,
    Sponsor_Name VARCHAR(100) NOT NULL,
    Deal_Amount DECIMAL(15, 2),
    Contract_Duration VARCHAR(50)
);

-- Sponsor_Teams Table 
CREATE TABLE IF NOT EXISTS Sponsor_Teams (
    Sponsor_ID INT,
    Team_ID INT,
    PRIMARY KEY (Sponsor_ID, Team_ID),
    FOREIGN KEY (Sponsor_ID) REFERENCES Sponsors(Sponsor_ID) ON DELETE CASCADE,
    FOREIGN KEY (Team_ID) REFERENCES Teams(Team_ID) ON DELETE CASCADE
);

-- Sponsor_Games Table
CREATE TABLE IF NOT EXISTS Sponsor_Games (
    Sponsor_ID INT,
    Game_ID INT,
    PRIMARY KEY (Sponsor_ID, Game_ID),
    FOREIGN KEY (Sponsor_ID) REFERENCES Sponsors(Sponsor_ID) ON DELETE CASCADE,
    FOREIGN KEY (Game_ID) REFERENCES Games(Game_ID) ON DELETE CASCADE
);



-- SuperBowl Table
-- Tracks Super Bowl details, including the champions.
CREATE TABLE IF NOT EXISTS SuperBowl (
    SuperBowl_ID INT PRIMARY KEY,
    AFC_Champion_Team_ID INT,
    NFC_Champion_Team_ID INT,
    Game_ID INT,
    FOREIGN KEY (AFC_Champion_Team_ID) REFERENCES Teams(Team_ID) ON DELETE CASCADE,
    FOREIGN KEY (NFC_Champion_Team_ID) REFERENCES Teams(Team_ID) ON DELETE CASCADE,
    FOREIGN KEY (Game_ID) REFERENCES Games(Game_ID) ON DELETE CASCADE
);

-- 3. Supplemental Tables

-- Weather Data Table
-- Logs weather conditions for games.
CREATE TABLE IF NOT EXISTS Weather_Data (
    Weather_ID INT PRIMARY KEY,
    Game_ID INT,
    Weather_Condition VARCHAR(50),
    Temperature VARCHAR(10),
    Wind_Speed VARCHAR(10),
    Precipitation VARCHAR(10),
    Humidity VARCHAR(10),
    FOREIGN KEY (Game_ID) REFERENCES Games(Game_ID) ON DELETE CASCADE
);

-- Fan Demographics Table
-- Tracks fan data for marketing and analysis.
CREATE TABLE IF NOT EXISTS Fan_Demographics (
    Demographic_ID INT PRIMARY KEY,
    Team_ID INT,
    Region VARCHAR(50),
    Average_Age INT,
    Gender_Percentage_Male VARCHAR(10),
    Average_Income DECIMAL(15, 2),
    Fan_Base_Size INT,
    FOREIGN KEY (Team_ID) REFERENCES Teams(Team_ID) ON DELETE CASCADE
);

-- Economic Impact Data Table
-- Measures the economic impact of games.
CREATE TABLE IF NOT EXISTS Economic_Impact (
    Impact_ID INT PRIMARY KEY,
    Game_ID INT,
    City VARCHAR(100),
    Total_Revenue DECIMAL(15, 2),
    Ticket_Sales DECIMAL(15, 2),
    Merchandise_Sales DECIMAL(15, 2),
    Local_Economic_Impact DECIMAL(15, 2),
    FOREIGN KEY (Game_ID) REFERENCES Games(Game_ID) ON DELETE CASCADE
);

-- Create the Staff table

CREATE TABLE IF NOT EXISTS Staff (
    Staff_no INT PRIMARY KEY NOT NULL,
    StaffName VARCHAR(100),
    Age INT,
    Salary DECIMAL(10, 2)    

);

-- Create the Office table
CREATE TABLE IF NOT EXISTS Office (
    Office_no INT PRIMARY KEY NOT NULL,
    office_location VARCHAR(100)
);

-- Create the Marketing_event table
CREATE TABLE IF NOT EXISTS Marketing_event (
    Marketing_event_no INT PRIMARY KEY NOT NULL,
    event_location VARCHAR(100),
    event_cost DECIMAL(10,2),
    Staff_no INT,
    Office_no INT,
    Team_ID INT,
    FOREIGN KEY (Staff_no) REFERENCES Staff ON DELETE CASCADE,
    FOREIGN KEY (Office_no) REFERENCES Office ON DELETE CASCADE,
    FOREIGN KEY (Team_ID) REFERENCES Teams ON DELETE CASCADE
);

 

-- Insert data into Teams table
INSERT INTO Teams (Team_ID, Team_Name, City, Division, Conference, Historical_Performance) VALUES
(1, 'Eagles', 'Philadelphia', 'NFC East', 'NFC', '3 Super Bowl wins, 6 Conference titles'),
(2, 'Patriots', 'New England', 'AFC East', 'AFC', '6 Super Bowl wins, 11 Conference titles'),
(3, 'Chiefs', 'Kansas City', 'AFC West', 'AFC', '3 Super Bowl wins, 5 Conference titles'),
(4, 'Cowboys', 'Dallas', 'NFC East', 'NFC', '5 Super Bowl wins, 10 Conference titles'),
(5, 'Packers', 'Green Bay', 'NFC North', 'NFC', '4 Super Bowl wins, 13 Conference titles'),
(6, '49ers', 'San Francisco', 'NFC West', 'NFC', '5 Super Bowl wins, 7 Conference titles'),
(7, 'Ravens', 'Baltimore', 'AFC North', 'AFC', '2 Super Bowl wins, 4 Conference titles'),
(8, 'Steelers', 'Pittsburgh', 'AFC North', 'AFC', '6 Super Bowl wins, 8 Conference titles'),
(9, 'Bills', 'Buffalo', 'AFC East', 'AFC', '0 Super Bowl wins, 4 Conference titles'),
(10, 'Giants', 'New York', 'NFC East', 'NFC', '4 Super Bowl wins, 8 Conference titles');

-- Insert data into Players table
INSERT INTO Players (Player_ID, Player_Name, Team_ID, Position, Career_Statistics, Health_Records) VALUES
(1, 'Tom Brady', 2, 'Quarterback', '89,214 passing yards, 649 TDs', 'No major injuries'),
(2, 'Patrick Mahomes', 3, 'Quarterback', '23,831 passing yards, 192 TDs', 'Knee dislocation (recovered)'),
(3, 'Aaron Rodgers', 5, 'Quarterback', '59,055 passing yards, 475 TDs', 'Collarbone fracture (recovered)'),
(4, 'Ezekiel Elliott', 4, 'Running Back', '8,262 rushing yards, 68 TDs', 'No major injuries'),
(5, 'Travis Kelce', 3, 'Tight End', '10,344 receiving yards, 71 TDs', 'Shoulder strain (recovered)'),
(6, 'Cooper Kupp', 6, 'Wide Receiver', '6,329 receiving yards, 49 TDs', 'ACL tear (recovered)'),
(7, 'T.J. Watt', 8, 'Linebacker', '80 sacks, 22 forced fumbles', 'Pectoral injury (recovered)'),
(8, 'Stefon Diggs', 9, 'Wide Receiver', '7,634 receiving yards, 52 TDs', 'Hamstring strain (recovered)'),
(9, 'Lamar Jackson', 7, 'Quarterback', '12,209 passing yards, 4,437 rushing yards', 'Ankle sprain (recovered)'),
(10, 'Saquon Barkley', 10, 'Running Back', '4,620 rushing yards, 29 TDs', 'ACL tear (recovered)');

-- Insert data into Games table
INSERT INTO Games (Game_ID, Game_Date, Home_Team_ID, Away_Team_ID, Venue, Home_Team_Score, Away_Team_Score, Outcome) VALUES
(1, '2024-09-08', 1, 2, 'Lincoln Financial Field', 24, 21, 'Eagles Win'),
(2, '2024-09-15', 3, 4, 'Arrowhead Stadium', 31, 28, 'Chiefs Win'),
(3, '2024-09-22', 5, 6, 'Lambeau Field', 17, 20, '49ers Win'),
(4, '2024-09-29', 7, 8, 'M&T Bank Stadium', 27, 24, 'Ravens Win'),
(5, '2024-10-06', 9, 10, 'Highmark Stadium', 14, 31, 'Giants Win'),
(6, '2024-10-13', 2, 1, 'Gillette Stadium', 28, 27, 'Patriots Win'),
(7, '2024-10-20', 4, 3, 'AT&T Stadium', 24, 35, 'Chiefs Win'),
(8, '2024-10-27', 6, 5, 'Levi\'s Stadium', 21, 24, 'Packers Win'),
(9, '2024-11-03', 8, 7, 'Acrisure Stadium', 14, 17, 'Ravens Win'),
(10, '2024-11-10', 10, 9, 'MetLife Stadium', 27, 21, 'Giants Win');

INSERT INTO Sponsors (Sponsor_ID, Sponsor_Name, Deal_Amount, Contract_Duration) VALUES
(1, 'Nike', 150000000.00, '5 years'),
(2, 'Pepsi', 200000000.00, '6 years'),
(3, 'Budweiser', 100000000.00, '3 years'),
(4, 'Amazon', 250000000.00, '7 years'),
(5, 'Coca-Cola', 180000000.00, '5 years');

-- Insert data into Sponsor_Teams table
INSERT INTO Sponsor_Teams (Sponsor_ID, Team_ID) VALUES
(1, 1),
(1, 2),
(2, 3),
(2, 4),
(3, 5),
(4, 6),
(5, 7),
(5, 8);


-- Insert data into Sponsor_Games table
INSERT INTO Sponsor_Games (Sponsor_ID, Game_ID) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);


-- Insert data into Playoffs table
INSERT INTO Playoffs (Playoff_ID, Game_ID, Round) VALUES
(1, 6, 'Wild Card'),
(2, 7, 'Divisional Round'),
(3, 8, 'Conference Championship'),
(4, 9, 'Conference Championship'),
(5, 10, 'Super Bowl');

-- Insert data into SuperBowl table
INSERT INTO SuperBowl (SuperBowl_ID, AFC_Champion_Team_ID, NFC_Champion_Team_ID, Game_ID) VALUES
(1, 3, 5, 10);


-- Insert data into Weather_Data table
INSERT INTO Weather_Data (Weather_ID, Game_ID, Weather_Condition, Temperature, Wind_Speed, Precipitation, Humidity) VALUES
(1, 1, 'Clear', '75F', '10mph', '0%', '45%'),
(2, 2, 'Rain', '60F', '15mph', '80%', '70%'),
(3, 3, 'Snow', '32F', '20mph', '100%', '85%'),
(4, 4, 'Cloudy', '55F', '5mph', '20%', '50%'),
(5, 5, 'Clear', '80F', '8mph', '0%', '40%');


-- Insert data into Fan_Demographics table
INSERT INTO Fan_Demographics (Demographic_ID, Team_ID, Region, Average_Age, Gender_Percentage_Male, Average_Income, Fan_Base_Size) VALUES
(1, 1, 'Northeast', 34, '60%', 75000.00, 1000000),
(2, 2, 'Northeast', 36, '65%', 85000.00, 1200000),
(3, 3, 'Midwest', 32, '58%', 68000.00, 950000),
(4, 4, 'South', 30, '62%', 72000.00, 1100000),
(5, 5, 'Midwest', 29, '55%', 70000.00, 1050000),
(6, 6, 'West', 33, '57%', 82000.00, 980000),
(7, 7, 'Mid-Atlantic', 31, '61%', 71000.00, 1020000),
(8, 8, 'Northeast', 35, '63%', 80000.00, 1150000);

-- Insert  data into Staff table

INSERT INTO Staff (Staff_no, StaffName, Age, Salary)
VALUES
(1, 'Addle Ron', 30, 50000.00),
(2, 'cinnr gow', 40, 600000.00),
(3, 'jai rolsea', 35, 55000.00);

-- Insert  data into Office table
INSERT INTO Office (Office_no, office_location)
VALUES
(101, 'blue wing'),
(102, 'red wing'),
(103, 'yellow wing');

-- Insert  data into Marketing_event table

INSERT INTO Marketing_event (Marketing_event_no, event_location, event_cost, Staff_no, Office_no, Team_ID)
VALUES
(201, 'Cactus', 1500.00, 1, 101, 7),
(202, 'Browns ', 2000.00, 2, 102, 8),
(203, 'Royals', 1200.00, 3, 103, 9);




DESC TABLES;





CREATE VIEW SuperBowlChampionView AS ( 
SELECT SB.SuperBowl_ID, T1.Team_Name AS AFC_Champion, T1.City AS AFC_City, T2.Team_Name AS NFC_Champion, T2.City AS NFC_City
 FROM SuperBowl SB 
 JOIN 
 Teams T1 ON SB.AFC_Champion_Team_ID = T1.Team_ID 
 JOIN 
 Teams T2 ON SB.NFC_Champion_Team_ID = T2.Team_ID
 );


