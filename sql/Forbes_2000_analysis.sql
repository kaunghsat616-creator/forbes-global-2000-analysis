SELECT * FROM 
`forbes 2000`;

CREATE TABLE forbes_2000_index
LIKE `forbes 2000`;

INSERT INTO forbes_2000_index
SELECT * 
FROM `forbes 2000`;

SELECT * FROM forbes_2000_index;

UPDATE forbes_2000_index SET Industry = 'Health Care Equipment & Services' WHERE Company = 'Medline';

SELECT COUNT(*) FROM forbes_2000_index WHERE Industry IS NULL;

-- Financial Values ranking based on industry 
SELECT 
    Industry,
    SUM(`Sales ($B)`) AS total_sales,
    SUM(`Profit ($B)`) AS total_profit,
    SUM(`Assets ($B)`) AS total_assets,
    SUM(`Market Value ($B)`) AS total_market_value,
    RANK() OVER (ORDER BY SUM(`Sales ($B)`) DESC) AS rank_by_sales,
    RANK() OVER (ORDER BY SUM(`Profit ($B)`) DESC) AS rank_by_profit,
    RANK() OVER (ORDER BY SUM(`Assets ($B)`) DESC) AS rank_by_assets,
    RANK() OVER (ORDER BY SUM(`Market Value ($B)`) DESC) AS rank_by_market_value
FROM forbes_2000_index
GROUP BY Industry
ORDER BY total_sales DESC;

-- countries with most companies headquaters 
SELECT 
    Country,
    COUNT(*) AS company_count,
    RANK() OVER (ORDER BY COUNT(*) DESC) AS rank_by_company_count
FROM forbes_2000_index
GROUP BY Country
ORDER BY company_count DESC;

-- Low Profitability Despite High Assets
SELECT 
    Company,
    Country,
    Industry,
    `Assets ($B)` AS assets,
    `Profit ($B)` AS profit,
    ROUND(`Profit ($B)` / `Assets ($B)`, 4) AS profit_to_assets_ratio
FROM forbes_2000_index
WHERE `Assets ($B)` > 0 
ORDER BY profit_to_assets_ratio ASC, assets DESC
LIMIT 30;

-- Companies with higher profit but lower sales
SELECT 
    Company,
    Country,
    Industry,
    `Sales ($B)` AS sales,
    `Profit ($B)` AS profit,
    ROUND(`Profit ($B)` / `Sales ($B)`, 4) AS profit_to_sales_ratio
FROM forbes_2000_index
WHERE `Sales ($B)` > 0
ORDER BY profit_to_sales_ratio DESC, profit DESC
LIMIT 30;

-- Companies with higher sales but lower profit
SELECT 
    Company,
    Country,
    Industry,
    `Sales ($B)` AS sales,
    `Profit ($B)` AS profit,
    ROUND(`Profit ($B)` / `Sales ($B)`, 4) AS profit_to_sales_ratio
FROM forbes_2000_index
WHERE `Sales ($B)` > 0
ORDER BY profit_to_sales_ratio ASC, sales DESC
LIMIT 30;

-- Undervalued Asset-Heavy Companies
SELECT 
    Company,
    Country,
    Industry,
    `Assets ($B)` AS assets,
    `Market Value ($B)` AS market_value,
    ROUND(`Market Value ($B)` / `Assets ($B)`, 4) AS mv_to_assets_ratio
FROM forbes_2000_index
WHERE `Assets ($B)` > 0
ORDER BY mv_to_assets_ratio ASC, assets DESC
LIMIT 30;

-- Cross-Financial Ratios Analysis
SELECT 
    Company,
    Country,
    Industry,
    `Sales ($B)` AS sales,
    `Profit ($B)` AS profit,
    `Assets ($B)` AS assets,
    `Market Value ($B)` AS market_value,
    ROUND(`Profit ($B)` / `Sales ($B)`, 4) AS profit_to_sales_ratio,
    ROUND(`Profit ($B)` / `Assets ($B)`, 4) AS profit_to_assets_ratio,
    ROUND(`Market Value ($B)` / `Assets ($B)`, 4) AS mv_to_assets_ratio,
    ROUND(`Market Value ($B)` / `Sales ($B)`, 4) AS mv_to_sales_ratio,
    ROUND(`Market Value ($B)` / `Profit ($B)`, 4) AS mv_to_profit_ratio
FROM forbes_2000_index
WHERE `Sales ($B)` > 0 
  AND `Assets ($B)` > 0 
  AND `Profit ($B)` > 0
ORDER BY profit_to_sales_ratio DESC
LIMIT 30;



