--1. In this question, you'll get to practice correlated subqueries and learn about the LATERAL keyword. 
-- Note: This could be done using window functions, but we'll do it in a different way in order to revisit correlated subqueries and see another keyword - LATERAL.

--1a. First, write a query utilizing a correlated subquery to find the team with the most wins from each league in 2016.
SELECT DISTINCT lgid AS league, 
    (
        SELECT teamid
        FROM teams
        WHERE teams.lgid = winners.lgid 
          AND teams.yearid = 2016
        ORDER BY teams.w DESC
        LIMIT 1
    ) AS most_wins
FROM teams AS winners
WHERE yearid = 2016;


--1b. One downside to using correlated subqueries is that you can only return exactly one row and one column.
--This means, for example that if we wanted to pull in not just the teamid but also the number of wins, we couldn't do so using just a single subquery.
--(Try it and see the error you get). Add another correlated subquery to your query on the previous part so that your result shows not just the teamid but also the number of wins by that team.

SELECT DISTINCT lgid AS league, 
    (
        SELECT teamid, w
        FROM teams
        WHERE teams.lgid = winners.lgid 
          AND teams.yearid = 2016
        ORDER BY teams.w DESC
        LIMIT 1
    ) AS most_wins
FROM teams AS winners
WHERE yearid = 2016;
--ERROR:  subquery must return only one column



SELECT DISTINCT lgid AS league, 
    (
        SELECT teamid
        FROM teams
        WHERE teams.lgid = winners.lgid 
          AND teams.yearid = 2016
        ORDER BY teams.w DESC
        LIMIT 1
    ) AS most_wins,
    (
        SELECT w
        FROM teams
        WHERE teams.lgid = winners.lgid 
          AND teams.yearid = 2016
        ORDER BY teams.w DESC
        LIMIT 1
    ) AS wins
FROM teams AS winners
WHERE yearid = 2016;

