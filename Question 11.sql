11. How many customers downgraded from a pro monthly to a basic monthly plan in 2020?

WITH PRO_MONTHLY AS (
SELECT CUSTOMER_ID
,START_DATE AS PRO_START_DATE
FROM subscriptions
WHERE plan_id = 2
)
, BASIC_MONTHLY AS (
SELECT CUSTOMER_ID
,START_DATE AS BASIC_START_DATE
FROM subscriptions
WHERE plan_id = 1
)
SELECT * FROM PRO_MONTHLY AS P 
INNER JOIN BASIC_MONTHLY AS B
ON P.CUSTOMER_ID = B.CUSTOMER_ID
WHERE PRO_START_DATE < BASIC_START_DATE
