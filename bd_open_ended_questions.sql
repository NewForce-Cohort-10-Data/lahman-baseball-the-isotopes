-- 11. Is there any correlation between number of wins and team salary?
-- Use data from 2000 and later to answer this question. As you do this analysis, 
-- keep in mind that salaries across the whole league tend to increase together, 
-- so you may want to look on a year-by-year basis.

-- people, salaries, teams

SELECT SUM(teams.w) AS total_wins, teams.teamid, SUM(salaries.salary)::NUMERIC::MONEY AS total_salary, salaries.yearid
FROM people
INNER JOIN salaries
USING (playerid)
INNER JOIN teams 
USING (teamid)
WHERE salaries.yearid >= 2000
GROUP BY teams.teamid, salaries.yearid
ORDER BY salaries.yearid ASC;


-- 12. In this question, you will explore the connection between number of wins and attendance.
		-- Does there appear to be any correlation between attendance at home games 
		-- and number of wins?
		-- Do teams that win the world series see a boost in attendance the following 
		-- year? What about teams that made the playoffs? Making the playoffs means 
		-- either being a division winner or a wild card winner.

-- 		homegames, teams

SELECT homegames.attendance, homegames.year, SUM(teams.w) as total_wins, teams.teamid, parks.park_name
FROM homegames
INNER JOIN teams
ON homegames.team = teams.teamid
INNER JOIN parks
ON homegames.park = parks.park
GROUP BY homegames.attendance, homegames.year, teams.teamid, parks.park_name
ORDER BY teams.teamid;


-- 13. It is thought that since left-handed pitchers are more rare, causing batters 
-- to face them less often, that they are more effective. Investigate this claim and 
-- present evidence to either support or dispute this claim. First, determine just 
-- how rare left-handed pitchers are compared with right-handed pitchers. 
-- Are left-handed pitchers more likely to win the Cy Young Award? 
-- Are they more likely to make it into the hall of fame?


SELECT throws
FROM people;