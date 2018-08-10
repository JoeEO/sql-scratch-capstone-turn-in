--Count campaigns
SELECT COUNT (DISTINCT utm_campaign) AS 'Campaign Count'
FROM page_visits;
--Count sources
SELECT COUNT (DISTINCT utm_source) AS 'Source Count'
FROM page_visits;

SELECT DISTINCT utm_campaign AS 'Campaigns', 
	utm_source AS Sources
  FROM page_visits; 
--Find unique pages that are on the website
SELECT DISTINCT page_name AS 'Page Name'
FROM page_visits;
--Count first touches here
--Temp table finding first touch
WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) AS first_touch_at
    FROM page_visits
    GROUP BY user_id),
ft_attr AS (
SELECT ft.user_id,
    	ft.first_touch_at,
   		 pv.utm_source,
        pv.utm_campaign
FROM first_touch ft
JOIN page_visits pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp
)
--Another temp table first touch
SELECT ft_attr.utm_source AS Source,
       ft_attr.utm_campaign AS Campaign,
       COUNT(*) AS COUNT
FROM ft_attr
GROUP BY 1, 2
ORDER BY 3 DESC;
--Temp table to find last touch
WITH last_touch AS (
	SELECT user_id,
		MAX(timestamp) AS last_touch_at
FROM page_visits
	GROUP BY user_id),
--Another temp table joins table data
ft_attr AS (
		SELECT lt.user_id,
						lt.last_touch_at,
						pv.utm_source,
						pv.utm_campaign
		FROM last_touch lt
		JOIN page_visits pv
			ON lt.user_id = pv.user_id
			AND lt.last_touch_at = pv.timestamp
)
SELECT ft_attr.utm_source AS Source,
				ft_attr.utm_campaign AS Campaign,
        COUNT(*) AS Count
FROM ft_attr
GROUP BY 1, 2
ORDER BY 3 DESC;
--Unique visitors that made a purchase from page 4
SELECT COUNT(DISTINCT user_id) AS 'Customers that purchase'
	FROM page_visits
  WHERE page_name = '4 - purchase';
--Last touch per campaign that led to a purchase
--Find last touches by user id
WITH last_touch AS (
	SELECT user_id,
		MAX(timestamp) AS last_touch_at
FROM page_visits
  WHERE page_name = '4 - purchase'
  GROUP BY user_id),
ft_attr AS (
SELECT lt.user_id,
  		lt.last_touch_at,
  		pv.utm_source,
  		pv.utm_campaign
  FROM last_touch lt
  JOIN page_visits pv
  	ON lt.user_id = pv.user_id
  	AND lt.last_touch_at = pv.timestamp
)
--select and count rows where first touch is with a campaign and source
SELECT ft_attr.utm_source AS Source,
			ft_attr.utm_campaign AS Campaign,
      COUNT(*) AS Count
FROM ft_attr
GROUP BY 1, 2
ORDER BY 3 DESC;
