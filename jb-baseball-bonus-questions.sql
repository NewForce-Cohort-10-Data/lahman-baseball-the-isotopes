--1. In this question, you'll get to practice correlated subqueries and learn about the LATERAL keyword. 
-- Note: This could be done using window functions, but we'll do it in a different way in order to revisit correlated subqueries and see another keyword - LATERAL.

--1a. First, write a query utilizing a correlated subquery to find the team with the most wins from each league in 2016.

--find the team with most wins per league in 2016
SELECT DISTINCT lgid AS league,  --select leagues
    (
        SELECT teamid  --select top teams
        FROM teams  --from teams
        WHERE teams.lgid = winners.lgid  --where league is most wins
          AND teams.yearid = 2016  --only for 2016
        ORDER BY teams.w DESC  --sort by wins
        LIMIT 1  --limit to top team only
    ) AS most_wins 
FROM teams AS winners --show most wins
WHERE yearid = 2016; --only for 2016


--1b. One downside to using correlated subqueries is that you can only return exactly one row and one column.
--This means, for example that if we wanted to pull in not just the teamid but also the number of wins, we couldn't do so using just a single subquery.
--(Try it and see the error you get). Add another correlated subquery to your query on the previous part so that your result shows not just the teamid but also the number of wins by that team.

--show both teamid and wins
SELECT DISTINCT lgid AS league, --select leagues
    (
        SELECT teamid, w --select both team and wins
        FROM teams --from teams
        WHERE teams.lgid = winners.lgid  --where league is the most wins
          AND teams.yearid = 2016  --only for 2016
        ORDER BY teams.w DESC  --order by wins
        LIMIT 1 --limit to top team only
    ) AS most_wins  --this causes an error because subquery returns more than one column
FROM teams AS winners --indicate the top winners
WHERE yearid = 2016;  --only for 2016
--ERROR:  subquery must return only one column

--show both teamid and wins with no errors
SELECT DISTINCT lgid AS league,  --get leagues
    (
        SELECT teamid  --select top team
        FROM teams --from teams
        WHERE teams.lgid = winners.lgid --where league is the most wins
          AND teams.yearid = 2016 --only for 2016
        ORDER BY teams.w DESC --order by wins
        LIMIT 1 --limit to top team only
    ) AS most_wins, --show most wins
    (
        SELECT w  --get wins
        FROM teams --from teams
        WHERE teams.lgid = winners.lgid --limit to top team only
          AND teams.yearid = 2016 --only for 2016
        ORDER BY teams.w DESC --order by wins
        LIMIT 1 --limit to top team only
    ) AS wins
FROM teams AS winners --show most wins
WHERE yearid = 2016;  --only 2016 data


--1c. If you are interested in pulling in the top (or bottom) values by group, you can also use the DISTINCT ON expression (https://www.postgresql.org/docs/9.5/sql-select.html#SQL-DISTINCT). 
--Rewrite your previous query into one which uses DISTINCT ON to return the top team by league in terms of number of wins in 2016. 
--Your query should return the league, the teamid, and the number of wins.
--1c. Use DISTINCT ON to get top team by league

--get top team by league
SELECT DISTINCT ON (lgid) --distinct first row per league
    lgid AS league, --league
    teamid, --teamid
    w AS wins --wins
FROM teams --from teams
WHERE yearid = 2016 --only for 2016
ORDER BY lgid, w DESC; --sort by league and wins


--1d. If we want to pull in more than one column in our correlated subquery, another way to do it is to make use of the LATERAL keyword (https://www.postgresql.org/docs/9.4/queries-table-expressions.html#QUERIES-LATERAL). 
--This allows you to write subqueries in FROM that make reference to columns from previous FROM items. This gives us the flexibility to pull in or calculate multiple columns or multiple rows (or both). 
--Rewrite your previous query using the LATERAL keyword so that your result shows the teamid and number of wins for the team with the most wins from each league in 2016. 

--get team and wins using lateral
SELECT --select
    leagues.lgid AS league,  --league
    winners.teamid,  --teamid
    winners.w AS wins  --wins
FROM  --from
    (SELECT DISTINCT lgid  --get distinct leagues
     FROM teams --from teams
     WHERE yearid = 2016) AS leagues --only for 2016
JOIN LATERAL  --join queries using lateral
    (
        SELECT teamid, w  --select team and wins
        FROM teams --from teams
        WHERE yearid = 2016 --only for 2016
          AND lgid = leagues.lgid  --select league
        ORDER BY w DESC  --sort by wins
        LIMIT 1  --top team only
    ) AS winners
ON TRUE;  --connect subquery


--1e. Finally, another advantage of the LATERAL keyword over using correlated subqueries is that you return multiple result rows. 
--(Try to return more than one row in your correlated subquery from above and see what type of error you get). 
--Rewrite your query on the previous problem sot that it returns the top 3 teams from each league in term of number of wins. 
--Show the teamid and number of wins.

--get top 3 teams from each league based on wins in 2016
SELECT 
    leagues.lgid AS league, --league
    top_teams.teamid, --team
    top_teams.w AS wins --number of wins
FROM 
    (SELECT DISTINCT lgid --get distinct leagues
     FROM teams  --from the teams table
     WHERE yearid = 2016) AS leagues  --only for the 2016 season
JOIN LATERAL --lateral join to pull top 3 teams per league based on wins
    (
        SELECT 
            teamid, --select team
            w --select number of wins
        FROM teams --from the teams table
        WHERE yearid = 2016 --only for the 2016 season
        AND lgid = leagues.lgid --filter by league
        ORDER BY w DESC --order by wins in descending order
        LIMIT 3 --return top 3 teams per league
    ) AS top_teams 
ON TRUE --connect the lateral subquery
ORDER BY 
    leagues.lgid, --order by league
    top_teams.w DESC; --order by wins within each league


