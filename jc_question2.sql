-- 2. Find the name and height of the shortest player in the database. 
-- How many games did he play in? What is the name of the team for which he played?

SELECT namefirst, namelast, MIN(height) AS height_inches, g_all AS games_played, name AS team_name
FROM people
INNER JOIN appearances
USING(playerid)
INNER JOIN teams
USING(teamid)
GROUP BY namefirst, namelast, g_all, name
ORDER BY height_inches
LIMIT 1;

-- Eddie Gaedel was 43 inches (around 3 feet and 6 inches), played 1 game for the St. Louis Browns.