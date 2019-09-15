DROP VIEW IF EXISTS q0, q1i, q1ii, q1iii, q1iv, q2i, q2ii, q2iii, q3i, q3ii, q3iii, q4i, q4ii, q4iii, q4iv, q4v, yeah, dude, const, basis, histogramcounts, ranges;

-- Question 0
CREATE VIEW q0(era) 
AS
  SELECT MAX(era)
  FROM pitching
;

-- Question 1i
CREATE VIEW q1i(namefirst, namelast, birthyear)
AS
	SELECT namefirst, namelast, birthyear
	FROM people
	WHERE weight > 300
;

-- Question 1ii
CREATE VIEW q1ii(namefirst, namelast, birthyear)
AS
	SELECT namefirst, namelast, birthyear
	FROM people
	WHERE namefirst ~ '.+\s.+'
;

-- Question 1iii
CREATE VIEW q1iii(birthyear, avgheight, count)
AS
	SELECT birthyear, AVG(height), COUNT(*)
	FROM people
	GROUP BY birthyear
	ORDER BY birthyear ASC
;

-- Question 1iv
CREATE VIEW q1iv(birthyear, avgheight, count)
AS
	SELECT birthyear, AVG(height), COUNT(*)
	FROM people
	GROUP BY birthyear
	HAVING AVG(height) > 70
	ORDER BY birthyear ASC
;

-- Question 2i
CREATE VIEW q2i(namefirst, namelast, playerid, yearid)
AS
	SELECT namefirst, namelast, h.playerid, yearid
	FROM halloffame h LEFT JOIN people p
	ON h.playerid = p.playerid
	WHERE inducted ~ 'Y' 
	ORDER BY h.yearid DESC
;

-- Question 2ii
CREATE VIEW q2ii(namefirst, namelast, playerid, schoolid, yearid)
AS
	SELECT namefirst, namelast, h.playerid, c.schoolid, h.yearid
	FROM halloffame h, people p, collegeplaying c, schools s
	WHERE inducted ~ 'Y' and h.playerid = c.playerid and c.schoolid = s.schoolid
	and h.playerid = p.playerid and s.schoolstate ~ 'CA'
	ORDER BY h.yearid DESC, c.schoolid, playerid ASC
;

-- Question 2iii
CREATE VIEW q2iii(playerid, namefirst, namelast, schoolid)
AS
	SELECT h.playerid, namefirst, namelast, schoolid
	FROM halloffame h, people p LEFT JOIN collegeplaying c
	ON p.playerid = c.playerid
	WHERE inducted ~ 'Y' and p.playerid = h.playerid
	ORDER BY h.playerid DESC, schoolid ASC
;

-- Question 3i
CREATE VIEW q3i(playerid, namefirst, namelast, yearid, slg)
AS
	SELECT p.playerid, namefirst, namelast, yearid, CAST(((h-(h2b+h3b+hr)) + 2*h2b + 3*h3b + 4*hr) AS float) / CAST(ab AS float)
	FROM batting b, people p
	WHERE p.playerid = b.playerid and b.ab > 50
	ORDER BY 5 DESC, b.yearid ASC, playerid ASC 
	LIMIT 10 
;

-- Question 3ii
CREATE VIEW q3ii(playerid, namefirst, namelast, lslg)
AS
	SELECT p.playerid, namefirst, namelast, CAST(( (SUM(h)-(SUM(h2b)+SUM(h3b)+SUM(hr))) + 2*SUM(h2b) + 3*SUM(h3b) + 4*SUM(hr)) AS float) / CAST(SUM(ab) AS float)
	FROM batting b, people p
	WHERE p.playerid = b.playerid
	GROUP BY p.playerid
	HAVING SUM(ab) > 50
	ORDER BY 4 DESC, playerid ASC 
	LIMIT 10
;

-- Question 3iii
CREATE VIEW yeah(namefirst, namelast, lslg)
AS
	SELECT namefirst, namelast, CAST(( (SUM(h)-(SUM(h2b)+SUM(h3b)+SUM(hr))) + 2*SUM(h2b) + 3*SUM(h3b) + 4*SUM(hr)) AS float) / CAST(SUM(ab) AS float)
	FROM batting b, people p
	WHERE p.playerid = b.playerid
	GROUP BY p.playerid
	HAVING SUM(ab) > 50
;

CREATE VIEW dude(lslg)
AS
	SELECT CAST(((SUM(h)-(SUM(h2b)+SUM(h3b)+SUM(hr))) + 2*SUM(h2b) + 3*SUM(h3b) + 4*SUM(hr)) AS float) / CAST(SUM(ab) AS float)
	FROM batting b, people p
	WHERE p.playerid = b.playerid and p.playerid ~ 'mayswi01'
	GROUP BY p.playerid
	HAVING SUM(ab) > 50
;

CREATE VIEW q3iii(namefirst, namelast, lslg)
AS
	SELECT namefirst, namelast, y.lslg
	FROM yeah y, dude d
	WHERE y.lslg > d.lslg
;

-- Question 4i
CREATE VIEW q4i(yearid, min, max, avg, stddev)
AS
	SELECT yearid, MIN(salary), MAX(salary), AVG(salary), STDDEV(salary)
	FROM salaries
	GROUP BY yearid
	ORDER BY yearid ASC
;

-- Question 4ii
CREATE VIEW const(min, max, stepsize)
AS
	SELECT min, max, (max-min)/10
	FROM q4i
	WHERE yearid = 2016
;

CREATE VIEW basis(series)
AS
	SELECT * FROM generate_series(0, 9)
;

CREATE VIEW ranges(binid, low, high)
AS
	SELECT series, min+(series*stepsize), min+((1+series)*stepsize)
	FROM const c, basis b
;

CREATE VIEW histogramcounts(playerid, bucket)
AS
	SELECT p.playerid, binid
	FROM people p, salaries s, ranges r, const c
	WHERE p.playerid = s.playerid AND salary >= r.low AND (CASE WHEN salary=c.max THEN salary <= r.high ELSE salary < r.high END) AND yearid = 2016
;

CREATE VIEW q4ii(binid, low, high, count)
AS
	SELECT bucket, AVG(r.low), AVG(r.high), COUNT(bucket)
	FROM ranges r, histogramcounts h
	WHERE r.binid = h.bucket
	GROUP BY bucket
	ORDER BY bucket ASC
;

-- Question 4iii
CREATE VIEW q4iii(yearid, mindiff, maxdiff, avgdiff)
AS
  SELECT 1, 1, 1, 1 -- replace this line
;

-- Question 4iv
CREATE VIEW q4iv(playerid, namefirst, namelast, salary, yearid)
AS
	SELECT p.playerid, namefirst, namelast, salary, yearid
	FROM people p, salaries s
	WHERE salary = (SELECT MAX(salary) from salaries WHERE yearid=2000) and p.playerid = s.playerid and yearid=2000
	UNION
	SELECT p.playerid, namefirst, namelast, salary, yearid
	FROM people p, salaries s
	WHERE salary = (SELECT MAX(salary) from salaries WHERE yearid=2001) and p.playerid = s.playerid and yearid=2001
;
-- Question 4v
CREATE VIEW q4v(team, diffAvg) AS
  SELECT 1, 1 -- replace this line
;

