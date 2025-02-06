--5. Find the average number of strikeouts per game by decade since 1920.
--Round the numbers you report to 2 decimal places.
--Do the same for home runs per game. Do you see any trends?

--so = total strikeouts; hr = total homeruns; g = games played

SELECT 
    CASE
        WHEN yearid BETWEEN 1920 AND 1929 THEN 1920
        WHEN yearid BETWEEN 1930 AND 1939 THEN 1930
        WHEN yearid BETWEEN 1940 AND 1949 THEN 1940
        WHEN yearid BETWEEN 1950 AND 1959 THEN 1950
        WHEN yearid BETWEEN 1960 AND 1969 THEN 1960
        WHEN yearid BETWEEN 1970 AND 1979 THEN 1970
        WHEN yearid BETWEEN 1980 AND 1989 THEN 1980
        WHEN yearid BETWEEN 1990 AND 1999 THEN 1990
        WHEN yearid BETWEEN 2000 AND 2009 THEN 2000
        WHEN yearid BETWEEN 2010 AND 2019 THEN 2010
        WHEN yearid BETWEEN 2020 AND 2029 THEN 2020
        ELSE NULL
    END AS decade,
    
    ROUND(SUM(so)::numeric / SUM(g), 2) AS avg_strikeouts_per_game, --used ::numeric since intergers don't use decimal places
    ROUND(SUM(hr)::numeric / SUM(g), 2) AS avg_home_runs_per_game

FROM teams
WHERE yearid >= 1920
GROUP BY decade
ORDER BY decade;


--Do you see any trends?:
--There is a trend of both strikeouts and home runs gradually increasing over the decades overall.
--What factors might have lead to this gradual increase?
--Could this be the results of better and more rigerous athletic training?
--Could this be the results of rule changes and better equipment?
