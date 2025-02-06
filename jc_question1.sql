-- 1. What range of years for baseball games played does the provided database cover? 
SELECT MAX(yearid), MIN(yearid)
FROM teams;

--1871 to 2016
--Side note: I chose the table "teams" because it has "yearly stats and standings" as mentioned in the data dictionary.