# Premier-League-Match-Analysis-Using-SQL
This project conducts a comprehensive analysis of Premier League matches, focusing on team performances across various seasons. The analysis includes examining match outcomes, goals scored, and overall team performance in terms of wins, draws, losses, and points accumulated.

# Dataset
The analysis is based on the Premier League Matches dataset, covering seasons from 1992 to 2022. The dataset includes detailed match statistics such as home and away team names, goals scored by each team, and match outcomes.
Dataset Source: Premier League Matches 1992-2022

# Analysis Overview
The analysis involves several SQL queries executed on Microsoft SQL Server, structured as follows:

1. Season Data Completeness Check
Verified that each team played twice (home and away) against their opponents each season.
Noted the league's reduction from 22 to 20 teams starting in the 1995/1996 season.
2. Match Outcome Analysis
Calculated the total home wins, draws, away wins, and their respective percentages for each season.
3. Goals Analysis
Determined the total goals scored and the average goals per game for each season.
4. Home and Away Statistics
Created home_stats and away_stats tables to store home and away match statistics for each team per season.
5. Team Performance Overview
Developed a perf_overview table to aggregate overall team performance across all seasons, including wins, draws, losses, goals scored/conceded, and points.
6. Best Season Analysis
Identified the best season for each team based on the maximum points gained, using a combination of subqueries and join operations.
SQL Queries
The repository contains a series of SQL queries used to perform the analysis, outlined in the project's steps section. These queries include data manipulation, aggregation, and complex joins to synthesize and extract meaningful insights from the dataset.

# Conclusions
The analysis reveals insights into the dynamics of the Premier League, such as the impact of league structure changes on match outcomes and team performances.
It highlights the seasons with the highest home wins, draws, and away wins percentages, as well as the variability in goals scored across different seasons.
Teams with the most home and away wins in a single season are identified, showcasing exceptional performances in Premier League history.

# Usage
To replicate this analysis, ensure you have access to Microsoft SQL Server. Import the dataset into your SQL Server instance and execute the provided SQL queries in order.
