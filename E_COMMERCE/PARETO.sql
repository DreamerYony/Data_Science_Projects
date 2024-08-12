--파레토 법칙이 어떻게 적용되는지 알아보자

SELECT * FROM ORDER_PRODUCT_ITEMS_CUS;

-- 각 제품 총 매출을 알아보기

SELECT 
    P_PRODUCT_ID, 
    SUM(PRICE) AS TOTAL_REVENUE
FROM 
    ORDER_PRODUCT_ITEMS_CUS
GROUP BY 
    P_PRODUCT_ID;

-- 총 매출에서 비율 계산하기

WITH Product_Revenue AS (
    SELECT 
        P_PRODUCT_ID, 
        SUM(PRICE) AS TOTAL_REVENUE
    FROM 
        ORDER_PRODUCT_ITEMS_CUS
    GROUP BY 
        P_PRODUCT_ID
),
Total_Revenue AS (
    SELECT 
        SUM(TOTAL_REVENUE) AS GRAND_TOTAL
    FROM 
        Product_Revenue
)
SELECT 
    P_PRODUCT_ID,
    TOTAL_REVENUE,
    TOTAL_REVENUE / GRAND_TOTAL * 100 AS REVENUE_PERCENTAGE
FROM 
    Product_Revenue, 
    Total_Revenue
ORDER BY 
    REVENUE_PERCENTAGE DESC;

-- 상위 20%의 제품이 전체 매출에서 차지하는 비율 계산하기 : 결과는 74.7%. 파레토 법칙에 근사함.

WITH Product_Revenue AS (
    SELECT 
        P_PRODUCT_ID, 
        SUM(PRICE) AS TOTAL_REVENUE
    FROM 
        ORDER_PRODUCT_ITEMS_CUS
    GROUP BY 
        P_PRODUCT_ID
),
Total_Revenue AS (
    SELECT 
        SUM(TOTAL_REVENUE) AS GRAND_TOTAL
    FROM 
        Product_Revenue
),
Revenue_Percentage AS (
    SELECT 
        P_PRODUCT_ID,
        TOTAL_REVENUE,
        TOTAL_REVENUE / GRAND_TOTAL * 100 AS REVENUE_PERCENTAGE,
        ROW_NUMBER() OVER (ORDER BY TOTAL_REVENUE DESC) AS RN,
        COUNT(*) OVER () AS TOTAL_PRODUCTS
    FROM 
        Product_Revenue, 
        Total_Revenue
)
SELECT 
    SUM(REVENUE_PERCENTAGE) AS TOP_20_PERCENT_REVENUE
FROM 
    Revenue_Percentage
WHERE 
    RN <= 0.2 * TOTAL_PRODUCTS;