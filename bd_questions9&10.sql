--9. Which managers have won the TSN Manager of the Year award in both the National League (NL) and 
--the American League (AL)? Give their full name and the teams that they were managing when they won the award.

SELECT people.namefirst, people.namelast, teams.name
FROM people
INNER JOIN awardsmanagers
USING (playerid)
INNER JOIN managers
USING (playerid)
INNER JOIN teams
USING (teamid)
WHERE awardsmanagers.awardid = 'TSN Manager of the Year'
AND awardsmanagers.lgid = 'NL' OR awardsmanagers.lgid = 'AL'
GROUP BY people.namefirst, people.namelast, teams.name;

-- 10. Find all players who hit their career highest number of home runs (batting.HR) in 2016. 
-- Consider only players who have played in the league for at least 10 years(people.debut = 2015), 
-- and who hit at least one home run in 2016(batting.yearID). 
-- Report the players' first and last names and the number of home runs they hit in 2016.

SELECT people.namefirst, people.namelast, batting.HR
FROM batting
INNER JOIN people
USING (playerid)
WHERE batting.yearID = 2016
AND people.debut >= '2015-01-01'
AND batting.HR > 0
AND batting.HR = ( SELECT MAX(b.HR)
					FROM batting as b
					WHERE b.playerid = batting.playerid
					GROUP BY b.playerid );



SELECT *
FROM people;

SELECT *
FROM awardsplayers;
