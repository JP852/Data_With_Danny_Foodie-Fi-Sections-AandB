//What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name

SELECT COUNT(PLAN_NAME) AS EVENTS
,PLAN_NAME
FROM PLANS AS P
INNER JOIN SUBSCRIPTIONS AS S
ON P.PLAN_ID = S.PLAN_ID
WHERE YEAR(START_DATE) > 2020
GROUP BY 
PLAN_NAME
