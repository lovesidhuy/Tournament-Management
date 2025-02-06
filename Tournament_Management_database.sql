-- Database Creation
CREATE DATABASE IF NOT EXISTS Tournament_Management;
USE Tournament_Management;

-- Teams Table
CREATE TABLE IF NOT EXISTS Teams (
    Team_ID INT PRIMARY KEY,
    Team_Name VARCHAR(100) NOT NULL,
    City VARCHAR(100),
    Division VARCHAR(50),
    Conference VARCHAR(50),
    Historical_Performance VARCHAR(255)
);

-- Players Table
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
CREATE TABLE IF NOT EXISTS SuperBowl (
    SuperBowl_ID INT PRIMARY KEY,
    AFC_Champion_Team_ID INT,
    NFC_Champion_Team_ID INT,
    Game_ID INT,
    FOREIGN KEY (AFC_Champion_Team_ID) REFERENCES Teams(Team_ID) ON DELETE CASCADE,
    FOREIGN KEY (NFC_Champion_Team_ID) REFERENCES Teams(Team_ID) ON DELETE CASCADE,
    FOREIGN KEY (Game_ID) REFERENCES Games(Game_ID) ON DELETE CASCADE
);

-- Weather Data Table
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
    FOREIGN KEY (Staff_no) REFERENCES Staff (Staff_no) ON DELETE CASCADE,
    FOREIGN KEY (Office_no) REFERENCES Office (Office_no) ON DELETE CASCADE,
    FOREIGN KEY (Team_ID) REFERENCES Teams (Team_ID) ON DELETE CASCADE
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
(6, '2024-10-13', 2, 1, 'Gillette Stadium', 28, 27, 'Patriots Win');

-- Insert data into Sponsors table
INSERT INTO Sponsors (Sponsor_ID, Sponsor_Name, Deal_Amount, Contract_Duration) VALUES
(1, 'Nike', 150000000.00, '5 years'),
(2, 'Pepsi', 200000000.00, '6 years'),
(3, 'Budweiser', 100000000.00, '3 years'),
(4, 'Amazon', 250000000.00, '7 years'),
(5, 'Coca-Cola', 180000000.00, '5 years');

-- Insert data into Sponsor_Teams table
INSERT INTO Sponsor_Teams (Sponsor_ID, Team_ID) VALUES
(1, 1), (1, 2), (2, 3), (2, 4), (3, 5), (4, 6), (5, 7), (5, 8);

-- Insert data into Weather_Data table
INSERT INTO Weather_Data (Weather_ID, Game_ID, Weather_Condition, Temperature, Wind_Speed, Precipitation, Humidity) VALUES
(1, 1, 'Clear', '75F', '10mph', '0%', '45%'),
(2, 2, 'Rain', '60F', '15mph', '80%', '70%'),
(3, 3, 'Snow', '32F', '20mph', '100%', '85%');

-- Insert data into Economic_Impact table
INSERT INTO Economic_Impact (Impact_ID, Game_ID, City, Total_Revenue, Ticket_Sales, Merchandise_Sales, Local_Economic_Impact) VALUES
(1, 1, 'Philadelphia', 5000000.00, 2000000.00, 1500000.00, 1500000.00),
(2, 2, 'Kansas City', 7500000.00, 3000000.00, 2000000.00, 2500000.00),
(3, 3, 'Green Bay', 6500000.00, 2500000.00, 1800000.00, 2200000.00);

-- Insert data into Fan_Demographics table
INSERT INTO Fan_Demographics (Demographic_ID, Team_ID, Region, Average_Age, Gender_Percentage_Male, Average_Income, Fan_Base_Size) VALUES
(1, 1, 'Northeast', 34, '60%', 75000.00, 1000000),
(2, 2, 'Northeast', 36, '65%', 85000.00, 1200000),
(3, 3, 'Midwest', 32, '58%', 68000.00, 950000);

-- Insert data into Office table
INSERT INTO Office (Office_no, office_location) VALUES
(101, 'Blue Wing'), (102, 'Red Wing'), (103, 'Yellow Wing');

-- Insert data into Staff table
INSERT INTO Staff (Staff_no, StaffName, Age, Salary, Email) VALUES
(1, 'Addle Ron', 30, 50000.00, NULL),
(2, 'Cinnr Gow', 40, 600000.00, NULL),
(3, 'Jai Rolsea', 35, 55000.00, NULL);

-- Insert data into Marketing_event table
INSERT INTO Marketing_event (Marketing_event_no, event_location, event_cost, Staff_no, Office_no, Team_ID) VALUES
(201, 'Cactus', 2500.00, 1, 101, 7),
(202, 'Browns', 2000.00, 2, 102, 8),
(203, 'Rbs', 1777.00, 3, 103, 9);

-- Insert data into SuperBowl table
INSERT INTO SuperBowl (SuperBowl_ID, AFC_Champion_Team_ID, NFC_Champion_Team_ID, Game_ID) VALUES
(1, 3, 5, 10);


-- Create View for SuperBowl Champions
CREATE VIEW SuperBowlChampionView AS (
    SELECT SB.SuperBowl_ID, 
           T1.Team_Name AS AFC_Champion, T1.City AS AFC_City, 
           T2.Team_Name AS NFC_Champion, T2.City AS NFC_City
    FROM SuperBowl SB
    JOIN Teams T1 ON SB.AFC_Champion_Team_ID = T1.Team_ID
    JOIN Teams T2 ON SB.NFC_Champion_Team_ID = T2.Team_ID
);

-- Sample Query to Fetch Games and Outcomes
SELECT Game_ID, Game_Date, Venue, Outcome FROM Games ORDER BY Game_Date DESC;

-- Query to Retrieve Economic Impact per City
SELECT City, SUM(Total_Revenue) AS Total_Revenue FROM Economic_Impact GROUP BY City;

-- Query to Fetch Players with Career Stats
SELECT Player_Name, Position, Career_Statistics FROM Players ORDER BY Position;


