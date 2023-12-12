// 6. What is the number and percentage of customer plans after their initial free trial?

WITH CTE AS (
SELECT CUSTOMER_ID
,PLAN_NAME
,ROW_NUMBER() OVER(PARTITION BY CUSTOMER_ID ORDER BY START_DATE) AS ROW_NUMBER
FROM SUBSCRIPTIONS AS S 
INNER JOIN PLANS AS P 
ON S.PLAN_ID = P.PLAN_ID
)
SELECT 
PLAN_NAME
,COUNT(CUSTOMER_ID) AS CUSTOMER_COUNT
,ROUND(COUNT(CUSTOMER_ID) / (SELECT COUNT(DISTINCT CUSTOMER_ID) FROM SUBSCRIPTIONS)*100,1) AS PERCENT_RATE
FROM CTE
WHERE ROW_NUMBER = 2
GROUP BY PLAN_NAME