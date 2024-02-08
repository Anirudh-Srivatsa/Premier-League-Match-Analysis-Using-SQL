-- Checking if the season data is complete - each team should have played twice(a home match and an away match) against their opponents.
-- The Premier League was reduced from 22 teams to 20 teams in the 1995/1996 season after the first three seasons of the Premier League.
select 
	Season_End_Year, count(Season_End_Year) as Matches_Played
from eplmatches
group by Season_End_Year
order by Season_End_Year;
----------------------------------------------------------------------------------------
-- Calculating home wins, draws, away wins and as well as percentage for each result type
SELECT 
	Season_End_Year, 
    COUNT(CASE WHEN FTR = 'H' THEN 1 END) as Home_Wins, 
    CAST(COUNT(CASE WHEN FTR = 'H' THEN 1 END) as DECIMAL) / NULLIF(COUNT(Season_End_Year), 0) * 100 as Home_Wins_Percentage,
    COUNT(CASE WHEN FTR = 'D' THEN 1 END) as Draws, 
    CAST(COUNT(CASE WHEN FTR = 'D' THEN 1 END) as DECIMAL) / NULLIF(COUNT(Season_End_Year), 0) * 100 as Draws_Percentage,
    COUNT(CASE WHEN FTR = 'A' THEN 1 END) as Away_Wins, 
    CAST(COUNT(CASE WHEN FTR = 'A' THEN 1 END) as DECIMAL) / NULLIF(COUNT(Season_End_Year), 0) * 100 as Away_Wins_Percentage
FROM eplmatches
GROUP BY Season_End_Year
ORDER BY Home_Wins_Percentage DESC;
/*The most home wins (percentage) were in season 2009/2010, second most in 2005/2006 - both above 50%.
We also see that in season 2018/2019 there were less than 20% of draws -> 18.68%
There were above 40% away wins in season 2020/2021, which is much more than average (second most away wins 33.95% in 2021/2022).*/
-----------------------------------------------------------------------------------------
 -- Selecting seasons stats - goals scored and goals per game for each season
SELECT 
    Season_End_Year, 
    SUM(HomeGoals + AwayGoals) as Goals_Scored, 
    CAST(CAST(SUM(HomeGoals + AwayGoals) as DECIMAL(10,2)) / COUNT(Season_End_Year) as DECIMAL(10,2)) as Goals_Per_Game
FROM eplmatches
GROUP BY Season_End_Year
ORDER BY Goals_Per_Game DESC;
/*During the 2022/23 and 2018/2019 seasons, the highest average number of goals scored per game was 2.85. 
On the other hand, the lowest average number of goals scored per game occurred during the 2006/2007 season, with an average of 2.45 goals per game.*/
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------

--Creating new table with home match stats for each team
CREATE TABLE home_stats (
    Season_End_Year INT,
    Home VARCHAR(255), 
    HomeWins INT,
    HomeDraws INT,
    HomeLoses INT,
    HomeGoalsScored INT,
    HomeGoalsConceded INT
);

INSERT INTO home_stats (Season_End_Year, Home, HomeWins, HomeDraws, HomeLoses, HomeGoalsScored, HomeGoalsConceded)
SELECT 
    Season_End_Year,
    Home,
    COUNT(CASE WHEN FTR = 'H' THEN 1 END) as HomeWins,
    COUNT(CASE WHEN FTR = 'D' THEN 1 END) as HomeDraws,
    COUNT(CASE WHEN FTR = 'A' THEN 1 END) as HomeLoses,
    SUM(HomeGoals) as HomeGoalsScored,
    SUM(AwayGoals) as HomeGoalsConceded
FROM eplmatches
GROUP BY Season_End_Year, Home
ORDER BY Home, Season_End_Year;

-- Checking most home wins over all seasons
SELECT * FROM home_stats
ORDER BY HomeWins DESC
/* Only a few teams in Premier League history have achieved 18 out of 19 home wins in a single season. 
These teams include Man City (twice), Man United, Liverpool and Chelsea.*/
------------------------------------------------------------------------------------------
--Creating new table with away match stats for each team
CREATE TABLE away_stats (
    Season_End_Year INT,
    Away VARCHAR(255), 
    AwayWins INT,
    AwayDraws INT,
    AwayLoses INT,
    AwayGoalsScored INT,
    AwayGoalsConceded INT
);
INSERT INTO away_stats (Season_End_Year, Away, AwayWins, AwayDraws, AwayLoses, AwayGoalsScored, AwayGoalsConceded)
SELECT 
    Season_End_Year,
    Away,
    COUNT(CASE WHEN FTR = 'A' THEN 1 END) as AwayWins,
    COUNT(CASE WHEN FTR = 'D' THEN 1 END) as AwayDraws,
    COUNT(CASE WHEN FTR = 'H' THEN 1 END) as AwayLoses,
    SUM(AwayGoals) as AwayGoalsScored,
    SUM(HomeGoals) as AwayGoalsConceded
FROM eplmatches
GROUP BY Season_End_Year, Away;

-- Checking most away wins over all seasons
SELECT * FROM away_stats
ORDER BY AwayWins DESC
/* Only one team in Premier League history has achieved 16 out of 19 away wins in a single season. 
This team is Man City in 2017/2018 season.*/
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------

--Creating detailed overview of team's performance over all seasons from both new created tables
--COALESCE was used to get first non-null selection (create one column from two columns)
SELECT TOP 5
    COALESCE(a.Season_End_Year, h.Season_End_Year) as Season_End_Year, 
    COALESCE(a.Away, h.Home) as Team,
    h.HomeWins, a.AwayWins,
    h.HomeDraws, a.AwayDraws,
    h.HomeLoses, a.AwayLoses,
    h.HomeGoalsScored, a.AwayGoalsScored,
    h.HomeGoalsConceded, a.AwayGoalsConceded
FROM away_stats a
LEFT JOIN home_stats h
    ON a.Season_End_Year = h.Season_End_Year
    AND a.Away = h.Home
ORDER BY a.AwayWins DESC; 
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------

-- Creating short overview of team's performance over all seasons from both new created tables
CREATE TABLE perf_overview (
    Season_End_Year INT,
    Team VARCHAR(255),
    Wins INT,
    Draws INT,
    Loses INT,
    GoalsScored INT,
    GoalsConceded INT,
    Points INT
);

INSERT INTO perf_overview (Season_End_Year, Team, Wins, Draws, Loses, GoalsScored, GoalsConceded, Points)
SELECT
    COALESCE(a.Season_End_Year, h.Season_End_Year) as Season_End_Year,
    COALESCE(a.Away, h.Home) as Team,
    ISNULL(h.HomeWins, 0) +  ISNULL(a.AwayWins, 0) as Wins,
    ISNULL(h.HomeDraws, 0) +  ISNULL(a.AwayDraws, 0) as Draws,
    ISNULL(h.HomeLoses, 0) +  ISNULL(a.AwayLoses, 0) as Loses,
    ISNULL(h.HomeGoalsScored, 0) + ISNULL(a.AwayGoalsScored, 0) as GoalsScored,
    ISNULL(h.HomeGoalsConceded, 0) + ISNULL(a.AwayGoalsConceded, 0) as GoalsConceded,
    3 * (ISNULL(h.HomeWins, 0) +  ISNULL(a.AwayWins, 0)) + (ISNULL(h.HomeDraws, 0) +  ISNULL(a.AwayDraws, 0)) as Points
FROM away_stats a
LEFT JOIN home_stats h ON a.Season_End_Year = h.Season_End_Year AND a.Away = h.Home
ORDER BY Wins DESC;

------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
/*Finding the best season for every team in PL history in terms of points gained
To get the complete overview of the best season for each team I used subquery that retrieves the maximum points for each team and the corresponding season.
Than I joined that subquery with original table.*/

SELECT p.*
FROM perf_overview AS p
INNER JOIN (
  SELECT Team, Season_End_Year, MAX(Points) AS MaxPoints
  FROM perf_overview
  GROUP BY Team, Season_End_Year
) AS max_points
ON p.Team = max_points.Team AND p.Points = max_points.MaxPoints AND p.Season_End_Year = max_points.Season_End_Year
ORDER BY p.Points DESC, p.Season_End_Year DESC;


