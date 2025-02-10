-- It is thought that since left-handed pitchers are more rare, causing batters to face them less often, that they are more effective. Investigate this claim and present evidence to either support or dispute this claim.
-- First, determine just how rare left-handed pitchers are compared with right-handed pitchers. 

SELECT COUNT(DISTINCT playerid)
FROM people
WHERE throws = 'L';

SELECT COUNT(DISTINCT playerid)
FROM people;

-- 19.12% is the answer I want

WITH lh AS (
	SELECT DISTINCT playerid
	FROM people
	WHERE throws = 'L'
	)
SELECT ROUND((COUNT(lh.playerid)::numeric/COUNT(DISTINCT people.playerid)::numeric)*100, 2) AS percent_left_handed
FROM people
LEFT JOIN lh
USING (playerid);


-- Are left-handed pitchers more likely to win the Cy Young Award?

SELECT COUNT(*)
	FROM people
	JOIN awardsplayers
	USING (playerid)
	WHERE throws = 'L' AND awardid = 'Cy Young Award';

SELECT COUNT(*)
	FROM awardsplayers
	WHERE awardid = 'Cy Young Award';

-- 33.04% is the answer I want

WITH lh_cy AS (
	SELECT *
	FROM people
	JOIN awardsplayers
	USING (playerid)
	WHERE throws = 'L' AND awardid = 'Cy Young Award'
	)
SELECT ROUND((COUNT(lh_cy)::numeric/COUNT(cy)::numeric)*100, 2) AS percent_leftie_winners
FROM (SELECT *
	FROM awardsplayers
	WHERE awardid = 'Cy Young Award') AS cy
LEFT JOIN lh_cy
USING (playerid, yearid);

-- About a third of all Cy Young Award wins are left-handed players. We know that only about 19% of players are left-handed, so I would say yes, left-handed players have a higher chance of winning the Cy Young Award.


-- Are they more likely to make it into the hall of fame?

SELECT COUNT(DISTINCT playerid)
FROM halloffame
JOIN people
USING (playerid)
WHERE throws = 'L';

SELECT COUNT(DISTINCT playerid)
FROM halloffame;

-- 19.76% is the answer I'm looking for

WITH lh_hof AS (
	SELECT *
	FROM halloffame
	LEFT JOIN people
	USING (playerid)
	WHERE throws = 'L'
	)
SELECT ROUND((COUNT(DISTINCT lh_hof.playerid)::numeric/COUNT(DISTINCT hof.playerid)::numeric)*100, 2) AS percent_lefties_hof
FROM halloffame AS hof
LEFT JOIN lh_hof
USING (playerid, yearid);

-- No. There is no significant difference in the percentage of left-handed players overall and the percentage of left-handed players in the hall of fame.