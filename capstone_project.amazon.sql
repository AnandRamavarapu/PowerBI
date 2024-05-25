use capstone_project;
show tables;
describe amazon;
SELECT * FROM capstone_project.amazon;
select distinct city from amazon;
select distinct product_line from amazon;
select count(product_line) from amazon;
select distinct branch from amazon;
select distinct Customer_type from amazon;
select distinct payment from amazon;
# Data Wrangling for amazon dataset 
#df=pd.read_csv("/content/Amazon.csv")
#df.ndim = 2
#df.shape = (1000, 17)
#df.isnull() = no null values in this dataset
#df.info()
/*<class 'pandas.core.frame.DataFrame'>
RangeIndex: 1000 entries, 0 to 999
Data columns (total 17 columns):
 #   Column                   Non-Null Count  Dtype  
---  ------                   --------------  -----  
 0   Invoice ID               1000 non-null   object 
 1   Branch                   1000 non-null   object 
 2   City                     1000 non-null   object 
 3   Customer type            1000 non-null   object 
 4   Gender                   1000 non-null   object 
 5   Product line             1000 non-null   object 
 6   Unit price               1000 non-null   float64
 7   Quantity                 1000 non-null   int64  
 8   Tax 5%                   1000 non-null   float64
 9   Total                    1000 non-null   float64
 10  Date                     1000 non-null   object 
 11  Time                     1000 non-null   object 
 12  Payment                  1000 non-null   object 
 13  cogs                     1000 non-null   float64
 14  gross margin percentage  1000 non-null   float64
 15  gross income             1000 non-null   float64
 16  Rating                   1000 non-null   float64
dtypes: float64(7), int64(1), object(9)
memory usage: 132.9+ KB'''
#df.describe()
	'''Unit price	Quantity	Tax 5%	Total	cogs	gross margin percentage	gross income	Rating
count	1000.000000	1000.000000	1000.000000	1000.000000	1000.00000	1000.000000	1000.000000	1000.00000
mean	55.672130	5.510000	15.379369	322.966749	307.58738	4.761905	15.379369	6.97270
std	26.494628	2.923431	11.708825	245.885335	234.17651	0.000000	11.708825	1.71858
min	10.080000	1.000000	0.508500	10.678500	10.17000	4.761905	0.508500	4.00000
25%	32.875000	3.000000	5.924875	124.422375	118.49750	4.761905	5.924875	5.50000
50%	55.230000	5.000000	12.088000	253.848000	241.76000	4.761905	12.088000	7.00000
75%	77.935000	8.000000	22.445250	471.350250	448.90500	4.761905	22.445250	8.50000
max	99.960000	10.000000	49.650000	1042.650000	993.00000	4.761905	49.650000	10.00000*/

# 1.What is the count of distinct cities in the dataset?
select count(distinct city) from amazon;
select distinct city from amazon;
#2.For each branch, what is the corresponding city?

select distinct Branch,city from amazon;
#3.What is the count of distinct product lines in the dataset?

SELECT COUNT(DISTINCT product_line) AS distinct_product_lines FROM amazon;

#4.Which payment method occurs most frequently?
SELECT payment, COUNT(*) AS frequency FROM amazon GROUP BY payment ORDER BY frequency DESC LIMIT 1;

#5.Which product line has the highest sales?
SELECT product_line, COUNT(*) AS highest_sales FROM amazon GROUP BY product_line ORDER BY highest_sales DESC LIMIT 1;

#6.How much revenue is generated each month?
SELECT 
    DATE_FORMAT(date, '%M') AS month,
    SUM(Total) AS revenue
FROM 
    amazon
GROUP BY 
    DATE_FORMAT(date, '%M')
ORDER BY 
    month Desc;

#7.In which month did the cost of goods sold reach its peak?
SELECT 
    DATE_FORMAT(date, '%M') AS month,
    SUM(cogs) AS total_cogs
FROM 
    amazon
GROUP BY 
    DATE_FORMAT(date, '%M')
ORDER BY 
    total_cogs DESC
LIMIT 1;
#8.Which product line generated the highest revenue?

SELECT 
    product_line,
    SUM(Total) AS total_revenue
FROM 
    amazon
GROUP BY 
    product_line
ORDER BY 
    total_revenue DESC
LIMIT 1;
#9.In which city was the highest revenue recorded?
SELECT 
    city,
    SUM(Total) AS total_revenue
FROM 
    amazon
GROUP BY 
    city
ORDER BY 
    total_revenue DESC
LIMIT 1;

#10.Which product line incurred the highest Value Added Tax?
SELECT 
    product_line,
    SUM(VAT) AS total_vat
FROM 
    amazon
GROUP BY 
    product_line
ORDER BY 
    total_vat DESC
LIMIT 1;

#11.For each product line, add a column indicating "Good" if its sales are above average, otherwise "Bad."
WITH AvgSales AS (
    SELECT 
        product_line,
        AVG(Total) AS avg_sales
    FROM 
        amazon
    GROUP BY 
        product_line
)
SELECT 
    a.product_line,
    a.Total, 
    CASE 
        WHEN a.Total > avg_sales THEN 'Good'
        ELSE 'Bad'
    END AS sales_category
FROM 
    amazon a
JOIN 
    AvgSales ag ON a.product_line = a.product_line;
    
    
#12.Identify the branch that exceeded the average number of products sold.
select branch, sum(quantity)
from amazon group by Branch 
having sum(quantity) > (select avg(quantity) from amazon)

#13.Which product line is most frequently associated with each gender?
SELECT  gender,
    product_line,
    COUNT(*) AS frequency
FROM 
    amazon
GROUP BY 
    gender, product_line
ORDER BY 
     gender, frequency DESC;
 #14.Calculate the average rating for each product line.   
    SELECT 
    product_line,
    AVG(rating) AS average_rating
FROM 
    amazon
GROUP BY 
    product_line;
#15.Count the sales occurrences for each time of day on every weekday.

           SELECT 
    DAYNAME(Date) AS weekday,
    TIME(Time) AS time_of_day,
    COUNT(*) AS count_of_sale 
FROM 
    amazon 
WHERE 
    DAYNAME(Date) NOT IN ('Saturday', 'Sunday') 
GROUP BY 
    weekday, time_of_day;
*/ORDER BY 
    weekday , count_of_sale ;*/

#16.Identify the customer type contributing the highest revenue.
SELECT 
    customer_type,
    SUM(total) AS total_revenue
FROM 
    amazon
GROUP BY 
    customer_type
ORDER BY 
    total_revenue DESC
LIMIT 1;

#17.Determine the city with the highest VAT percentage.
WITH CityVAT AS (
    SELECT 
        city,
        SUM(Tax_five_percent) AS total_vat,
        SUM(Total) AS total_sales_amount
    FROM 
        amazon
    GROUP BY 
        city
)
SELECT 
    city,
    (total_vat /total_sales_amount) * 100 AS vat_percentage
FROM 
    CityVAT
ORDER BY 
    vat_percentage DESC
LIMIT 3;
#18.Identify the customer type with the highest VAT payments.
WITH CustomerTypeVAT AS (
    SELECT 
        customer_type,
        SUM(Tax_five_percent) AS total_vat
    FROM 
        amazon
    GROUP BY 
        customer_type
)
SELECT 
    customer_type,
    total_vat
FROM 
    CustomerTypeVAT
ORDER BY 
    total_vat DESC
LIMIT 1;
#19.What is the count of distinct customer types in the dataset?
SELECT COUNT(DISTINCT customer_type) AS distinct_customer_types
FROM amazon;

#20.What is the count of distinct payment methods in the dataset?
SELECT COUNT(DISTINCT payment) AS distinct_payment_methods
FROM amazon;

#21.Which customer type occurs most frequently?
SELECT customer_type, COUNT(*) AS frequency
FROM amazon
GROUP BY customer_type
ORDER BY frequency DESC
LIMIT 1;

#22.Identify the customer type with the highest purchase frequency.
SELECT 
    customer_type, 
    COUNT(*) AS purchase_frequency
FROM 
    amazon
GROUP BY 
    customer_type
ORDER BY 
    purchase_frequency DESC
LIMIT 1;
#23.Determine the predominant gender among customers.
SELECT 
    gender, 
    COUNT(*) AS gender_count
FROM 
    amazon
GROUP BY 
    gender
ORDER BY 
    gender_count DESC
LIMIT 1;
#24.Examine the distribution of genders within each branch.
SELECT 
    branch,
    gender,
    COUNT(*) AS gender_count
FROM 
    amazon
GROUP BY 
    branch, gender
ORDER BY 
    branch, gender;
#25.Identify the time of day when customers provide the most ratings.

SELECT 
    CASE 
        WHEN HOUR(time) >= 5 AND HOUR(time) < 12 THEN 'Morning'
        WHEN HOUR(time) >= 12 AND HOUR(time) < 17 THEN 'Afternoon'
        WHEN HOUR(time) >= 17 AND HOUR(time) < 21 THEN 'Evening'
        ELSE 'Night'
    END AS time_of_day,
    COUNT(*) AS rating_count
FROM 
    amazon
GROUP BY 
    time_of_day
ORDER BY 
    rating_count DESC
LIMIT 3 ;
#26.Determine the time of day with the highest customer ratings for each branch.
SELECT 
    branch,
    CASE 
        WHEN HOUR(time) >= 5 AND HOUR(time) < 12 THEN 'Morning'
        WHEN HOUR(time) >= 12 AND HOUR(time) < 17 THEN 'Afternoon'
        WHEN HOUR(time) >= 17 AND HOUR(time) < 21 THEN 'Evening'
        ELSE 'Night'
    END AS time_of_day,
    COUNT(*) AS rating_count
FROM 
    amazon
GROUP BY 
    branch, time_of_day
ORDER BY 
    branch, rating_count DESC;
#27.Identify the day of the week with the highest average ratings.
SELECT 
    DAYNAME(date) AS day_of_week,
    AVG(rating) AS average_rating
FROM 
     amazon
GROUP BY 
    day_of_week
ORDER BY 
    average_rating DESC
LIMIT 1;
#28.Determine the day of the week with the highest average ratings for each branch.
SELECT 
    branch,
    DAYNAME(date) AS day_of_week,
    AVG(rating) AS average_rating
FROM 
    amazon
GROUP BY 
    branch, day_of_week
ORDER BY 
    branch, average_rating DESC;
