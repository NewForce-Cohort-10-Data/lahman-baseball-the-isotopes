-- 7.  From 1970 – 2016, what is the largest number of wins for a team that did not win the world series? 
-- What is the smallest number of wins for a team that did win the world series? 
-- Doing this will probably result in an unusually small number of wins for a world series champion – determine why this is the case. 
-- Then redo your query, excluding the problem year. How often from 1970 – 2016 was it the case that a team with the most wins also won the world series? 
-- What percentage of the time?

-- teams, wswin(world series win), teamid(team), frnachid (franchise id), yearid, name(teams full name), w(wins)
SELECT name, max(w) AS max_wins, yearid
FROM teams
	WHERE yearid BETWEEN 1970 AND 2016
	AND wswin = 'N'
GROUP BY name, yearid
ORDER BY max_wins DESC;
--ANSWER: Seattle Mariners, 116 wins in 2001

-- What is the smallest number of wins for a team that did win the world series? 
SELECT name, min(w) AS min_wins, yearid
FROM teams
	WHERE yearid BETWEEN 1970 AND 2016
	AND wswin = 'Y'
GROUP BY name, yearid
ORDER BY min_wins ASC;
--ANSWER: Los Angeles Dodgers, 63 wins, 1981

-- Doing this will probably result in an unusually small number of wins for a world series champion – determine why this is the case. g(games played)

SELECT yearid, SUM(g) AS total_games
FROM teams
WHERE yearid BETWEEN 1970 AND 2016
GROUP BY yearid
ORDER BY total_games ASC

-- ANSWER: 1981 had the least amount of games played compared to other years

-- Then redo your query, excluding the problem year. How often from 1970 – 2016 was it the case that a team with the most wins also won the world series? need help on this one




	





SELECT *
FROM teams