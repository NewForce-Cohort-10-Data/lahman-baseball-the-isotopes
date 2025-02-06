-- 3. Find all players in the database who played at Vanderbilt University. Create a list showing each player’s first and last names as well as the total salary they earned in the major leagues. Sort this list in descending order by the total salary earned. Which Vanderbilt player earned the most money in the majors?

SELECT DISTINCT playerid, namefirst, namelast
FROM people
JOIN collegeplaying
USING (playerid)
JOIN schools
USING (schoolid)
WHERE schoolname = 'Vanderbilt University';

WITH vanderbilt_players AS (
	SELECT DISTINCT playerid, namefirst, namelast
	FROM people
	JOIN collegeplaying
	USING (playerid)
	JOIN schools
	USING (schoolid)
	WHERE schoolname = 'Vanderbilt University'
	)
SELECT DISTINCT playerid, namefirst, namelast, SUM(salary)::numeric::money AS total_salary
FROM vanderbilt_players
JOIN salaries
USING (playerid)
GROUP BY playerid, namefirst, namelast
ORDER BY total_salary DESC;

-- Which Vanderbilt player earned the most money in the majors? David Price