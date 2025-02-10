-- 8. Using the attendance figures from the homegames table, 
-- find the teams and parks which had the top 5 average attendance per game in 2016 (where average attendance is defined as total attendance divided by number of games).
-- Only consider parks where there were at least 10 games played.
-- Report the park name, team name, and average attendance. 
-- Repeat for the lowest 5 average attendance.

SELECT team, park, (sum(attendance)/sum(games)) AS average_attendance
FROM homegames
WHERE year = 2016
GROUP BY park, team
HAVING sum(games) >=10
ORDER BY average_attendance DESC
LIMIT 5;

SELECT team, park, (sum(attendance)/sum(games)) AS average_attendance
FROM homegames
WHERE year = 2016
GROUP BY park, team
HAVING sum(games) >=10
ORDER BY average_attendance ASC
LIMIT 5;



