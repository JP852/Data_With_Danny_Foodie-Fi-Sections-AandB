//10. Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)

WITH TRIAL_TABLE AS(
SELECT 
CUSTOMER_ID
,START_DATE AS TRIAL_START_DATE
FROM SUBSCRIPTIONS
WHERE PLAN_ID = 0
)
,ANNUAL_TABLE AS(
SELECT 
CUSTOMER_ID
,START_DATE AS ANNUAL_START_DATE
FROM SUBSCRIPTIONS
WHERE PLAN_ID = 3
)
SELECT
CASE 
WHEN DATEDIFF('day',TRIAL_START_DATE,ANNUAL_START_DATE) <= 30 THEN '0-30'
WHEN DATEDIFF('day',TRIAL_START_DATE,ANNUAL_START_DATE) <= 60 THEN '31-60'
WHEN DATEDIFF('day',TRIAL_START_DATE,ANNUAL_START_DATE) <= 90 THEN '61-90'
WHEN DATEDIFF('day',TRIAL_START_DATE,ANNUAL_START_DATE) <= 120 THEN '91-120'
WHEN DATEDIFF('day',TRIAL_START_DATE,ANNUAL_START_DATE) <= 150 THEN '121-150'
WHEN DATEDIFF('day',TRIAL_START_DATE,ANNUAL_START_DATE) <= 180 THEN '151-180'
WHEN DATEDIFF('day',TRIAL_START_DATE,ANNUAL_START_DATE) <= 210 THEN '181-210'
WHEN DATEDIFF('day',TRIAL_START_DATE,ANNUAL_START_DATE) <= 240 THEN '121-240'
WHEN DATEDIFF('day',TRIAL_START_DATE,ANNUAL_START_DATE) <= 270 THEN '241-270'
WHEN DATEDIFF('day',TRIAL_START_DATE,ANNUAL_START_DATE) <= 300 THEN '271-300'
WHEN DATEDIFF('day',TRIAL_START_DATE,ANNUAL_START_DATE) <= 330 THEN '301-330'
WHEN DATEDIFF('day',TRIAL_START_DATE,ANNUAL_START_DATE) <= 360 THEN '331-360'
END AS DIFF_BIN
,COUNT(T.customer_id) AS CUSTOMER_COUNT
FROM TRIAL_TABLE AS T
INNER JOIN ANNUAL_TABLE AS A
ON T.CUSTOMER_ID = A.CUSTOMER_ID
GROUP BY 1