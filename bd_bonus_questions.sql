-- First, write a query utilizing a correlated subquery to find the team with the most wins from each league in 2016.

WITH wins AS (
SELECT teams.w, teams.yearID, teams.teamID, teams.name, teams.lgID
FROM teams
WHERE yearID = 2016)

SELECT MAX(wins.w) AS max_wins, wins.teamID,
	CASE 
		WHEN wins.lgid = 'AL' THEN 'AL'
		WHEN wins.lgid = 'NL' THEN 'NL'
	END AS league
FROM wins
GROUP BY wins.lgid, wins.teamID;	


-- b. One downside to using correlated subqueries is that you can only return exactly one row and one column. 
-- This means, for example that if we wanted to pull in not just the teamid but also the number of wins, 
-- we couldn't do so using just a single subquery. (Try it and see the error you get). 
-- Add another correlated subquery to your query on the previous part so that your result shows not 
--just the teamid but also the number of wins by that team.