--6. Find the player who had the most success stealing bases in 2016, where __success__ is measured as the percentage of stolen base attempts which are successful.
--(A stolen base attempt results either in a stolen base or being caught stealing.)
--Consider only players who attempted _at least_ 20 stolen bases.

--battingtable sb = stolen bases, cs = caught stealing
--Only players who have attempted at least 20 stolen bases from 2016 (sb + cs) ≥ 20.

SELECT DISTINCT
    people.namefirst,
    people.namelast,
    batting.sb AS stolen_bases,
    batting.cs AS caught_stealing,
    (batting.sb + batting.cs) AS attempts
FROM batting
JOIN people ON batting.playerid = people.playerid
WHERE batting.yearid = 2016
  AND (batting.sb + batting.cs) >= 20
ORDER BY attempts DESC, namelast, namefirst;
--There were 47 players that attempted to steal bases in 2016.


--Here I used a CTE with the same results.

WITH stolen_base_stats AS (
    SELECT 
        people.namefirst,
        people.namelast,
        batting.sb AS stolen_bases,
        batting.cs AS caught_stealing,
        (batting.sb + batting.cs) AS attempts
    FROM batting
    JOIN people ON batting.playerid = people.playerid
    WHERE batting.yearid = 2016
)
SELECT DISTINCT
    namefirst,
    namelast,
    stolen_bases,
    caught_stealing,
    attempts
FROM stolen_base_stats
WHERE attempts >= 20
ORDER BY attempts DESC, namelast, namefirst;
