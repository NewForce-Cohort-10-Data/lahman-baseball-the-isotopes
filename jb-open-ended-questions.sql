-- 11. Is there any correlation between number of wins and team salary? Use data from 2000 and later to answer this question. As you do this analysis, keep in mind that salaries across the whole league tend to increase together, so you may want to look on a year-by-year basis.
--join teams and salaries tables to compare wins and total team salary from 2000 onwards

-- rank teams by wins and total salary within each year
SELECT 
    teams.yearid,  --select year from teams
    teams.teamid,  --select team from teams
    teams.w AS wins,  --select wins from teams
    (SUM(salaries.salary)::numeric)::MONEY AS total_salary  --sum salaries
FROM teams  --from teams table
JOIN salaries  --join salaries table
ON teams.teamid = salaries.teamid  --on teamid
AND teams.yearid = salaries.yearid  --match years between teams and salaries
WHERE teams.yearid >= 2000  --filter for years 2000 and later
GROUP BY teams.yearid, teams.teamid, teams.w  --group by year, team, and wins
ORDER BY teams.yearid DESC, teams.teamid;  --order by year and team
--this gets a list comparing total wins and salaries, but it's hard to sort in a way to see a clear coorelation. 


--rank wins and salaries to see a correlation
WITH team_salary_totals AS (
    SELECT 
        salaries.yearid,  --select year
        salaries.teamid,  --select teamid
        SUM(salaries.salary) AS total_salary  --sum salaries per team per year
    FROM salaries  --from salaries table
    WHERE salaries.yearid > 2000  --year greater than 2000
    GROUP BY salaries.yearid, salaries.teamid  --group by salaries
), 
team_wins_totals AS (
    SELECT 
        teams.yearid,  
        teams.teamid,  
        SUM(teams.w) AS total_wins  --sum wins
    FROM teams  
    WHERE teams.yearid > 2000  
    GROUP BY teams.yearid, teams.teamid  
), 
salary_rankings AS (
    SELECT 
        team_salary_totals.yearid,  
        team_salary_totals.teamid,  
        team_salary_totals.total_salary,  
        (SELECT COUNT(*) + 1  --count teams with a higher salary
         FROM team_salary_totals AS comparison_teams
         WHERE comparison_teams.yearid = team_salary_totals.yearid  
         AND comparison_teams.total_salary > team_salary_totals.total_salary) AS salary_rank  
    FROM team_salary_totals  
),
win_rankings AS (
    SELECT 
        team_wins_totals.yearid,  
        team_wins_totals.teamid,  
        team_wins_totals.total_wins,  
        (SELECT COUNT(*) + 1  --count teams with more wins
         FROM team_wins_totals AS comparison_teams
         WHERE comparison_teams.yearid = team_wins_totals.yearid  
         AND comparison_teams.total_wins > team_wins_totals.total_wins) AS win_rank  
    FROM team_wins_totals  
)
SELECT 
    salary_rankings.yearid,  
    salary_rankings.teamid,  
    salary_rankings.total_salary,  
    salary_rankings.salary_rank,  
    win_rankings.total_wins,  
    win_rankings.win_rank  
FROM salary_rankings  
JOIN win_rankings 
ON salary_rankings.yearid = win_rankings.yearid AND salary_rankings.teamid = win_rankings.teamid  
ORDER BY salary_rankings.yearid DESC, salary_rankings.salary_rank, win_rankings.win_rank;



--12. In this question, you will explore the connection between number of wins and attendance.
--Does there appear to be any correlation between attendance at home games and number of wins?
--Do teams that win the world series see a boost in attendance the following year? 
--What about teams that made the playoffs?
--Making the playoffs means either being a division winner or a wild card winner.


--average home attendance and wins per year
SELECT 
    teams.yearid,  --year
    ROUND(AVG(teams.w), 2) AS average_wins,  --average wins
    ROUND(AVG(homegames.attendance), 2) AS average_home_attendance  --average home game attendance
FROM teams
JOIN homegames ON teams.teamid = homegames.team 
AND teams.yearid = homegames.year
WHERE homegames.attendance IS NOT NULL
AND teams.yearid BETWEEN 2000 AND 2016
GROUP BY teams.yearid
ORDER BY teams.yearid DESC;


--compare wins and attendance change from previous year
SELECT 
    current_year.yearid,  --select yearid
    current_year.name AS team_name,  --select teamid use team name this time
	current_year.w AS current_year_wins,
	previous_year.w AS previous_year_wins,
    current_year.attendance AS current_year_attendance,  --select attendace
    previous_year.attendance AS previous_year_attendance,  --previous year attendance
    (current_year.attendance - previous_year.attendance) AS attendance_change  --difference
	
FROM teams current_year
LEFT JOIN teams previous_year  --join with previous year
ON current_year.teamid = previous_year.teamid 
AND current_year.yearid = previous_year.yearid + 1  
WHERE current_year.yearid BETWEEN 2000 AND 2016
ORDER BY current_year.yearid DESC;


--show attendance changes for world series winners
SELECT 
    current_year.yearid,  --year
    current_year.name AS world_series_winner,  --team
    current_year.attendance AS current_year_attendance,  --attendance for world series winners
    previous_year.attendance AS previous_year_attendance,  --previous years attendance
    (current_year.attendance - previous_year.attendance) AS attendance_change  --difference
FROM teams current_year
LEFT JOIN teams previous_year  --join with previous year
ON current_year.teamid = previous_year.teamid 
AND current_year.yearid = previous_year.yearid + 1  
WHERE current_year.wswin = 'Y'  --filter for World Series winners
AND current_year.yearid BETWEEN 2000 AND 2016
ORDER BY current_year.yearid DESC;


--show attendance change for playoff teams
SELECT 
    current_year.yearid,  --year
    current_year.name AS playoff_team,  --team name
    current_year.attendance AS current_year_attendance,  --current year attendance
    previous_year.attendance AS previous_year_attendance,  --previous year attendance
    (current_year.attendance - previous_year.attendance) AS attendance_change  --difference
FROM teams current_year --current years teams
LEFT JOIN teams previous_year --join to previus year
ON current_year.teamid = previous_year.teamid 
AND current_year.yearid = previous_year.yearid + 1  --join with previous year
WHERE current_year.divwin = 'Y' OR current_year.wcwin = 'Y'  --filter for playoff teams
AND current_year.yearid BETWEEN 2000 AND 2016
ORDER BY current_year.yearid DESC;



--13. It is thought that since left-handed pitchers are more rare, causing batters to face them less often,
--that they are more effective. Investigate this claim and present evidence to either support or dispute this claim. 
--First, determine just how rare left-handed pitchers are compared with right-handed pitchers. 
--Are left-handed pitchers more likely to win the Cy Young Award? 
--Are they more likely to make it into the hall of fame?

--count left handed vs. right handed pitchers
SELECT 
    people.throws AS throwing_hand,  --throwing hand (L or R)
    COUNT(*) AS pitcher_count  --total number of pitchers
FROM pitching  
JOIN people --join to people
ON pitching.playerid = people.playerid  --match players
WHERE people.throws IN ('L', 'R')  --filter for L and R pitchers
GROUP BY people.throws  
ORDER BY pitcher_count DESC;


--find percentage of left-handed pitchers
SELECT 
    (SELECT COUNT(*) FROM pitching 
     JOIN people ON pitching.playerid = people.playerid 
     WHERE people.throws = 'L') * 100.0 
     / COUNT(*) AS percentage_left_handed  
FROM pitching  
JOIN people  
ON pitching.playerid = people.playerid  
WHERE people.throws IN ('L', 'R');


--count Cy Young award winners by throwing hand
SELECT 
    people.throws AS throwing_hand,  
    COUNT(*) AS cy_young_wins  
FROM awardsplayers  
JOIN people  
ON awardsplayers.playerid = people.playerid  
WHERE awardsplayers.awardid = 'Cy Young Award'  
AND people.throws IN ('L', 'R')  
GROUP BY people.throws  
ORDER BY cy_young_wins DESC;


--percentage of inductees by throwing hand
SELECT 
    people.throws AS throwing_hand,  
    COUNT(*) AS hall_of_fame_inductions,  
    COUNT(*) * 100.0 / (SELECT COUNT(*) FROM people WHERE throws = people.throws) AS induction_percentage
FROM halloffame  
JOIN people  
ON halloffame.playerid = people.playerid  
WHERE halloffame.inducted = 'Y'  
AND people.throws IN ('L', 'R')  
GROUP BY people.throws  
ORDER BY hall_of_fame_inductions DESC;

