//What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value

SELECT
PLAN_NAME
,COUNT(DISTINCT CUSTOMER_ID)
,DATE_TRUNC('month',start_date) AS MONTH
FROM PLANS AS P
INNER JOIN SUBSCRIPTIONS AS S
ON P.PLAN_ID = S.PLAN_ID
WHERE PLAN_NAME = 'trial'
GROUP BY PLAN_NAME
,MONTH
