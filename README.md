# Data_With_Danny_Foodie-Fi-Sections-AandB

#### Link to Challenge

https://8weeksqlchallenge.com/case-study-3/

#### SQL Techniques Used

- CTEs
- Table Joins
- Aggregation
- Group By
- Where Clause
- Case Statement
- Round Function

## Questions

### Question 1 - How many customers has Foodie-Fi ever had?

```
SELECT 
    COUNT(DISTINCT CUSTOMER_ID) AS CUSTOMER_COUNT
        FROM SUBSCRIPTIONS

```

### Question 2 - What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value

```
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

```

### Question 3 - What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name

```
SELECT 
    COUNT(PLAN_NAME) AS EVENTS
    ,PLAN_NAME
        FROM PLANS AS P
            INNER JOIN SUBSCRIPTIONS AS S
            ON P.PLAN_ID = S.PLAN_ID
                WHERE YEAR(START_DATE) > 2020
                    GROUP BY PLAN_NAME

```

### Question 4 - What is the customer count and percentage of customers who have churned rounded to 1 decimal place?

```
SELECT 
    (SELECT COUNT(DISTINCT CUSTOMER_ID) FROM SUBSCRIPTIONS) AS CUSTOMER_COUNT
    ,ROUND(COUNT (DISTINCT CUSTOMER_ID)/(SELECT COUNT (DISTINCT CUSTOMER_ID) FROM SUBSCRIPTIONS)*100,1)AS CHURN_RATE
        FROM SUBSCRIPTIONS 
            WHERE PLAN_ID = 4

```

### Question 5 - How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?

```
  
SELECT 
    CUSTOMER_ID
    ,PLAN_NAME
    ,ROW_NUMBER() OVER(PARTITION BY CUSTOMER_ID ORDER BY START_DATE) AS ROW_NUMBER
        FROM SUBSCRIPTIONS AS S 
            INNER JOIN PLANS AS P 
            ON S.PLAN_ID = P.PLAN_ID)
SELECT 
    COUNT (DISTINCT CUSTOMER_ID) AS CHURNED_STRAIGHT_AWAY
    ,ROUND(COUNT (DISTINCT CUSTOMER_ID) / (SELECT COUNT (DISTINCT CUSTOMER_ID) FROM SUBSCRIPTIONS)*100,0)AS IMMEDIATE_CHURN_RATE
        FROM CTE
            WHERE ROW_NUMBER = 2
            AND PLAN_NAME = 'churn'

```

### Question 6 - What is the number and percentage of customer plans after their initial free trial?

```
  
WITH CTE AS (
  
SELECT 
    CUSTOMER_ID
    ,PLAN_NAME
    ,ROW_NUMBER() OVER(PARTITION BY CUSTOMER_ID ORDER BY START_DATE) AS ROW_NUMBER
        FROM SUBSCRIPTIONS AS S 
            INNER JOIN PLANS AS P 
            ON S.PLAN_ID = P.PLAN_ID)
SELECT 
    PLAN_NAME
    ,COUNT(CUSTOMER_ID) AS CUSTOMER_COUNT
    ,ROUND(COUNT(CUSTOMER_ID) / (SELECT COUNT(DISTINCT CUSTOMER_ID) FROM SUBSCRIPTIONS)*100,1) AS PERCENT_RATE
        FROM CTE
            WHERE ROW_NUMBER = 2
                GROUP BY PLAN_NAME

```

### Question 7 - What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?

```
  
WITH CTE AS( 
  
SELECT 
    * 
    ,ROW_NUMBER() OVER(PARTITION BY CUSTOMER_ID ORDER BY START_DATE DESC)  AS ROW_NUMBER 
        FROM SUBSCRIPTIONS 
            WHERE START_DATE <= '2020-12-31')
SELECT 
    COUNT(CUSTOMER_ID) AS CUSTOMER_COUNT
    ,PLAN_NAME
    ,(SELECT COUNT(DISTINCT CUSTOMER_ID) FROM SUBSCRIPTIONS) AS TOTAL_CUSTOMERS
    ,ROUND(COUNT(CUSTOMER_ID) / (SELECT COUNT(DISTINCT CUSTOMER_ID) FROM SUBSCRIPTIONS)*100,1) AS PERCENTAGE
        FROM CTE
            INNER JOIN PLANS AS P 
            ON CTE.PLAN_ID = P.PLAN_ID
                WHERE ROW_NUMBER = 1
                    GROUP BY PLAN_NAME

```

### Question 8 - How many customers have upgraded to an annual plan in 2020?

```
  
SELECT 
    COUNT(CUSTOMER_ID) AS UPGRADED
        FROM SUBSCRIPTIONS AS S
            INNER JOIN PLANS AS P 
            ON P.PLAN_ID = S.PLAN_ID
                WHERE DATE_PART('year',START_DATE) = 2020
                AND PLAN_NAME = 'pro annual'


```

### Question 9 - How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?

```
  
WITH TRIAL_TABLE AS(

SELECT 
    CUSTOMER_ID
    ,START_DATE AS TRIAL_START_DATE
        FROM SUBSCRIPTIONS
            WHERE PLAN_ID = 0)
    ,ANNUAL_TABLE AS(
SELECT 
    CUSTOMER_ID
    ,START_DATE AS ANNUAL_START_DATE
        FROM SUBSCRIPTIONS AS S
            WHERE PLAN_ID = 3)
SELECT 
    ROUND(AVG(DATEDIFF('day',TRIAL_START_DATE,ANNUAL_START_DATE)),2) AS AVG_DAYS_DIFF
        FROM TRIAL_TABLE AS T
            INNER JOIN ANNUAL_TABLE AS A
            ON T.CUSTOMER_ID = A.CUSTOMER_ID


```

### Question 10 - Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)

```
  
WITH TRIAL_TABLE AS(
  
SELECT 
    CUSTOMER_ID
    ,START_DATE AS TRIAL_START_DATE
        FROM SUBSCRIPTIONS
            WHERE PLAN_ID = 0)
    ,ANNUAL_TABLE AS(
SELECT 
    CUSTOMER_ID
    ,START_DATE AS ANNUAL_START_DATE
        FROM SUBSCRIPTIONS
            WHERE PLAN_ID = 3)
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

```

### Question 11 - How many customers downgraded from a pro monthly to a basic monthly plan in 2020?

```
  
WITH PRO_MONTHLY AS (  
  
SELECT 
    CUSTOMER_ID
    ,START_DATE AS PRO_START_DATE
        FROM subscriptions
            WHERE plan_id = 2)
    ,BASIC_MONTHLY AS (
SELECT 
    CUSTOMER_ID
    ,START_DATE AS BASIC_START_DATE
        FROM subscriptions
            WHERE plan_id = 1)
SELECT 
    * 
        FROM PRO_MONTHLY AS P 
            INNER JOIN BASIC_MONTHLY AS B
            ON P.CUSTOMER_ID = B.CUSTOMER_ID
                WHERE PRO_START_DATE < BASIC_START_DATE

```



