-- Calculate the average order amount for each country.

SELECT country, AVG(quantityOrdered * priceEach) AS avg_order_value
FROM classicmodels.orders AS orders

INNER JOIN classicmodels.customers AS customers
	ON orders.customerNumber = customers.customerNumber 
INNER JOIN classicmodels.orderdetails AS details
	ON orders.orderNumber = details.orderNumber

GROUP BY country
ORDER BY 2 DESC;

-- Calculate the total sales amount for each product line
SELECT productLine, SUM(priceEach * quantityOrdered) AS Sum
FROM classicmodels.orderdetails AS odetails

INNER JOIN classicmodels.products AS products 
	ON odetails.productCode = products.productCode

GROUP BY productLine;

-- List the top 10 best selling products based on total quantity sold.

SELECT products.productName, SUM(odetails.quantityOrdered) AS unit_sold
FROM classicmodels.orderdetails AS odetails
INNER JOIN classicmodels.products AS products
	ON odetails.productCode = products.productCode
GROUP BY products.productName
ORDER BY 2 DESC
LIMIT 10;

-- Evaluate the sales performance of each sales representative
SELECT emp.employeeNumber, emp.firstName, emp.lastName, 
	SUM(orddet.quantityOrdered * orddet.priceEach) AS total_sales, emp.jobTitle
FROM classicmodels.employees AS emp
LEFT JOIN classicmodels.customers AS cus 
	ON emp.employeeNumber = cus.salesRepEmployeeNumber
INNER JOIN classicmodels.orders AS ord
	ON cus.customerNumber = ord.customerNumber
INNER JOIN classicmodels.orderdetails AS orddet
	ON ord.orderNumber = orddet.orderNumber
GROUP BY emp.employeeNumber
ORDER BY 4 DESC;

-- Calculate the average number of orders placed by each customer
SELECT COUNT(ord.orderNumber)/ COUNT(DISTINCT(cus.customerNumber)) AS avg_num_ord_each
FROM classicmodels.customers AS cus
INNER JOIN classicmodels.orders AS ord
	ON cus.customerNumber = ord.customerNumber;
    
-- Calculate the percentage of orders that were shipped on time
	SELECT SUM(CASE WHEN ord.shippedDate <= requiredDate THEN 1 ELSE 0 END) / COUNT(ord.orderNumber) * 100
	FROM classicmodels.orders AS ord;

-- Calculate the profit margin for each product by subtracting the cost of goods sold (COGS) from the sales revenue.
SELECT prod.productName, SUM((orddet.quantityOrdered * orddet.priceEach) - 
	(prod.buyPrice * orddet.quantityOrdered)) AS profit
FROM classicmodels.products AS prod
INNER JOIN classicmodels.orderdetails AS orddet
	ON prod.productCode = orddet.productCode
GROUP BY prod.productName
ORDER BY 2 DESC;

-- Segment customers based on their total purchase amount
WITH total_purchase AS (
	SELECT cus.customerNumber, cus.customerName, SUM(orddet.priceEach * orddet.quantityOrdered) AS total_purchase
	FROM classicmodels.customers AS cus
	INNER JOIN classicmodels.orders AS ord 
		ON cus.customerNumber = ord.customerNumber
	INNER JOIN classicmodels.orderdetails AS orddet
		ON ord.orderNumber = orddet.orderNumber
	GROUP BY cus.customerNumber
	ORDER BY 3 DESC
)
SELECT customerNumber, customerName,
	CASE WHEN  total_purchase > 100000 THEN 'high_value' 
	WHEN total_purchase BETWEEN 50000 AND 100000 THEN 'medium_value'
    WHEN total_purchase < 50000 THEN 'low_value' 
    ELSE 'other' END AS customer_segment
FROM total_purchase AS total;

-- Identify frequently co-purchased products to understand cross-selling opportunities.
SELECT orddet.productCode, prod.productName, orddet2.productCode, prod2.productName, COUNT(*) AS purchased_together
FROM classicmodels.orderdetails AS orddet
INNER JOIN classicmodels.orderdetails orddet2
	ON orddet.ordernumber = orddet2.orderNumber AND orddet.productCode <> orddet2.productCode
INNER JOIN classicmodels.products prod
	ON prod.productCode = orddet.productCode
INNER JOIN classicmodels.products prod2
	ON prod2.productCode = orddet2.productCode

GROUP BY orddet.productCode, prod.productName, orddet2.productCode, prod2.productName
ORDER BY purchased_together DESC;
    
    





