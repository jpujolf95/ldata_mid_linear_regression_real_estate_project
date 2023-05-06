#1 Create a database called house_price_regression

CREATE DATABASE house_price_regression;

#2 Create a table house_price_data with the same columns as given in the csv file. Please make sure you use the correct data types for the columns.
##HERE WE USE THE IMPORT WIZARD :) 

USE house_price_regression;

#4 Select all the data from table house_price_data to check if the data was imported correctly

SELECT * FROM house_price_data;

#5 Use the alter table command to drop the column date from the database, as we would not use it in the analysis with SQL. Select all the data from the table to verify if the command worked. Limit your returned results to 10.
##RIGHT CLICK ON house_price_data AND CHOOSE 'alter table' -> right click on 'date' and remove -> then apply changes

SELECT * FROM house_price_data
LIMIT 10;

#6 Use sql query to find how many rows of data you have.

SELECT COUNT(id) FROM house_price_data;

#7 Now we will try to find the unique values in some of the categorical columns:
# a) What are the unique values in the column bedrooms?
# b) What are the unique values in the column bathrooms?
# c) What are the unique values in the column floors?
# d) What are the unique values in the column condition?
# e) What are the unique values in the column grade?

SELECT DISTINCT bedrooms, bathrooms, floors, `condition`, grade FROM house_price_data;

#8 Arrange the data in a decreasing order by the price of the house. Return only the IDs of the top 10 most expensive houses in your data.

SELECT id FROM house_price_data
ORDER BY price DESC
LIMIT 10;

#9 What is the average price of all the properties in your data?

SELECT AVG(price) FROM house_price_data;

#10 In this exercise we will use simple group by to check the properties of some of the categorical variables in our data
# a) What is the average price of the houses grouped by bedrooms? The returned result should have only two columns, bedrooms and Average of the prices. Use an alias to change the name of the second column.
# b) What is the average sqft_living of the houses grouped by bedrooms? The returned result should have only two columns, bedrooms and Average of the sqft_living. Use an alias to change the name of the second column.

SELECT bedrooms, ROUND(AVG(price),2) AS avg_price, ROUND(AVG(sqft_living),2) AS avg_living FROM house_price_data
GROUP BY bedrooms
ORDER BY bedrooms ASC;

# c) What is the average price of the houses with a waterfront and without a waterfront? The returned result should have only two columns, waterfront and Average of the prices. Use an alias to change the name of the second column.

SELECT waterfront, ROUND(AVG(price),2) AS average_price
FROM house_price_data
GROUP BY waterfront;

# d) Is there any correlation between the columns condition and grade? You can analyse this by grouping the data by one of the variables and then aggregating the results of the other column. Visually check if there is a positive correlation or negative correlation or no correlation between the variables.

SELECT `condition`, AVG(grade) FROM house_price_data
GROUP BY `condition`
ORDER BY `condition` ASC
;
#Grade is not correlated to Condition

SELECT grade, AVG(`condition`) FROM house_price_data
GROUP BY grade
ORDER BY grade ASC
;
#Condition has a negative correlation to grade. As grade increases in value, condition decreases.


#11. One of the customers is only interested in the following houses:

# Number of bedrooms either 3 or 4
# Bathrooms more than 3
# One Floor
# No waterfront
# Condition should be 3 at least
# Grade should be 5 at least
# Price less than 300000

# For the rest of the things, they are not too concerned. Write a simple query to find what are the options available for them?

SELECT * FROM house_price_data
WHERE bedrooms IN(3, 4)
AND bathrooms > 3
AND floors = 1 
AND waterfront = 0 
AND `condition` >= 3 
AND grade >= 5 
AND price < 300000;
# NO HOUSE WHERE FOUND WITH THIS CONDITION (REMEMBER DATA SET IS NOT FULL!)

#12. Your manager wants to find out the list of properties whose prices are twice more than the average of all the properties in the database. Write a query to show them the list of such properties. You might need to use a sub query for this problem.

SELECT * FROM house_price_data
WHERE price > (
	SELECT 2 * AVG(price) FROM house_price_data)
;

#13. Since this is something that the senior management is regularly interested in, create a view of the same query.

CREATE VIEW properties_2times_higher_average_price AS
SELECT * FROM house_price_data
WHERE price > (
	SELECT 2 * AVG(price) FROM house_price_data)
;

#14. Most customers are interested in properties with three or four bedrooms. What is the difference in average prices of the properties with three and four bedrooms?

SELECT
ROUND(AVG(CASE WHEN bedrooms = 4 THEN price END) - AVG(CASE WHEN bedrooms = 3 THEN price END),2) AS price_difference
FROM house_price_data
WHERE bedrooms IN (3, 4)  ;

#15. What are the different locations where properties are available in your database? (distinct zip codes)

SELECT DISTINCT zipcode FROM house_price_data;

#16. Show the list of all the properties that were renovated.

SELECT DISTINCT id FROM house_price_data
WHERE yr_renovated != 0;

#17. Provide the details of the property that is the 11th most expensive property in your database.

SELECT *
FROM (
  SELECT *,
    ROW_NUMBER() OVER (ORDER BY price DESC) AS row_num
  FROM house_price_data
) AS ranked
WHERE row_num = 11;
