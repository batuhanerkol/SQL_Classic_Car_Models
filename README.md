# SQL_Classic_Car_Models

# Introduction
In this project I dived into classic car models data. This project answers some questions like "What are the total sales amount for each product line ?" and "Segment customers based on their total purchase amount.
"

This project's data sourse cames from Graeme Gordon Udemy course and guided by tha same sourse.

# Tools I Used
For my deep dive into the layoofs data, I harnessed the power of several key tools:

- SQL: The backbone of my analysis, allowing me to query the database and unearth critical insights.
- MySQL: The chosen database management system, ideal for handling the job posting data.
- Git & GitHub: Essential for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking.

# The Analysis 
Each query for this project aimed at investigating specific aspects of classic car models data. Here’s how I approached each question:

-- What are the average order amount for each country ? 

```sql
SELECT country, AVG(quantityOrdered * priceEach) AS avg_order_value
FROM classicmodels.orders AS orders

INNER JOIN classicmodels.customers AS customers
	ON orders.customerNumber = customers.customerNumber 
INNER JOIN classicmodels.orderdetails AS details
	ON orders.orderNumber = details.orderNumber

GROUP BY country
ORDER BY 2 DESC;
``` 
| Country        | Average Order Value (USD) |
|----------------|----------------------------|
| Switzerland    | 3508.97                    |
| Denmark        | 3476.11                    |
| Austria        | 3428.00                    |
| Philippines    | 3364.17                    |
| Singapore      | 3341.74                    |
| Sweden         | 3291.90                    |
| USA            | 3260.24                    |
| Japan          | 3229.04                    |
| Spain          | 3214.59                    |
| France         | 3208.20                    |
| Finland        | 3208.15                    |
| New Zealand    | 3200.32                    |
| Norway         | 3186.43                    |
| Germany        | 3168.89                    |
| Ireland        | 3118.64                    |
| Australia      | 3040.99                    |
| UK             | 3034.36                    |
| Belgium        | 3032.39                    |
| Italy          | 2980.30                    |
| Canada         | 2941.60                    |
| Hong Kong      | 2842.55                    |


-- What are the total sales amount for each product line ?
```sql
SELECT productLine, SUM(priceEach * quantityOrdered) AS Sum
FROM classicmodels.orderdetails AS odetails

INNER JOIN classicmodels.products AS products 
	ON odetails.productCode = products.productCode

GROUP BY productLine;
```
| Product Line           | Sum (USD)    |
|------------------------|--------------|
| Classic Cars           | 3,853,922.49 |
| Vintage Cars           | 1,797,559.63 |
| Trucks and Buses       | 1,024,113.57 |
| Motorcycles            | 1,121,426.12 |
| Planes                 | 954,637.54   |
| Ships                  | 663,998.34   |
| Trains                 | 188,532.92   |

-- What are the top 10 best selling products based on total quantity sold ?
```sql
SELECT products.productName, SUM(odetails.quantityOrdered) AS unit_sold
FROM classicmodels.orderdetails AS odetails
INNER JOIN classicmodels.products AS products
	ON odetails.productCode = products.productCode
GROUP BY products.productName
ORDER BY 2 DESC
LIMIT 10;
```
| Product Name                                | Units Sold |
|---------------------------------------------|------------|
| 1992 Ferrari 360 Spider red                 | 1808       |
| 1937 Lincoln Berline                        | 1111       |
| American Airlines: MD-11S                   | 1085       |
| 1941 Chevrolet Special Deluxe Cabriolet     | 1076       |
| 1930 Buick Marquette Phaeton                | 1074       |
| 1940s Ford truck                            | 1061       |
| 1969 Harley Davidson Ultimate Chopper       | 1057       |
| 1957 Chevy Pickup                           | 1056       |
| 1964 Mercedes Tour Bus                      | 1053       |
| 1956 Porsche 356A Coupe                     | 1052       |


-- Evaluate the sales performance of each sales representative
```sql
SELECT emp.jobTitle, emp.employeeNumber, emp.firstName, emp.lastName, 
	SUM(orddet.quantityOrdered * orddet.priceEach) AS total_sales
FROM classicmodels.employees AS emp
LEFT JOIN classicmodels.customers AS cus 
	ON emp.employeeNumber = cus.salesRepEmployeeNumber
INNER JOIN classicmodels.orders AS ord
	ON cus.customerNumber = ord.customerNumber
INNER JOIN classicmodels.orderdetails AS orddet
	ON ord.orderNumber = orddet.orderNumber
GROUP BY emp.employeeNumber
ORDER BY 5 DESC;
```
| Job Title | Employee Number | First Name | Last Name  | Total Sales (USD) |
|-----------|-----------------|------------|-------------|--------------------|
| Sales Rep  | 1370            | Gerard     | Hernandez   | 1,258,577.81       |
| Sales Rep  | 1165            | Leslie     | Jennings    | 1,081,530.54       |
| Sales Rep  | 1401            | Pamela     | Castillo    | 868,220.55         |
| Sales Rep  | 1501            | Larry      | Bott        | 732,096.79         |
| Sales Rep  | 1504            | Barry      | Jones       | 704,853.91         |
| Sales Rep  | 1323            | George     | Vanauf      | 669,377.05         |
| Sales Rep  | 1612            | Peter      | Marsh       | 584,593.76         |
| Sales Rep  | 1337            | Loui       | Bondur      | 569,485.75         |
| Sales Rep  | 1611            | Andy       | Fixter      | 562,582.59         |
| Sales Rep  | 1216            | Steve      | Patterson   | 505,875.42         |
| Sales Rep  | 1286            | Foon Yue   | Tseng       | 488,212.67         |
| Sales Rep  | 1621            | Mami       | Nishi       | 457,110.07         |
| Sales Rep  | 1702            | Martin     | Gerard      | 387,477.47         |
| Sales Rep  | 1188            | Julie      | Firrelli    | 386,663.20         |
| Sales Rep  | 1166            | Leslie     | Thompson    | 347,533.03         |



-- What are the average number of orders placed by each customer ?
```sql
SELECT COUNT(ord.orderNumber)/ COUNT(DISTINCT(cus.customerNumber)) AS avg_num_ord_each
FROM classicmodels.customers AS cus
INNER JOIN classicmodels.orders AS ord
	ON cus.customerNumber = ord.customerNumber;
```
3.3265
    
-- What are the percentage of orders that were shipped on time
```sql
	SELECT SUM(CASE WHEN ord.shippedDate <= requiredDate THEN 1 ELSE 0 END) / COUNT(ord.orderNumber) * 100
	FROM classicmodels.orders AS ord;
```
95.3988

-- What are the profit margin for each product by subtracting the cost of goods sold (COGS) from the sales revenue.
```sql
SELECT prod.productName, SUM((orddet.quantityOrdered * orddet.priceEach) - 
	(prod.buyPrice * orddet.quantityOrdered)) AS profit
FROM classicmodels.products AS prod
INNER JOIN classicmodels.orderdetails AS orddet
	ON prod.productCode = orddet.productCode
GROUP BY prod.productName
LIMIT 10
ORDER BY 2 DESC;
```
| Product Name                                     | Profit (USD)   |
|--------------------------------------------------|----------------|
| 1992 Ferrari 360 Spider red                      | 135,996.78     |
| 1952 Alpine Renault 1300                         | 95,282.58      |
| 2001 Ferrari Enzo                                | 93,349.65      |
| 2003 Harley-Davidson Eagle Drag Bike             | 81,031.30      |
| 1968 Ford Mustang                                | 72,579.26      |
| 1969 Ford Falcon                                 | 72,399.77      |
| 1928 Mercedes-Benz SSK                           | 68,423.18      |
| 2002 Suzuki XREO                                 | 67,641.47      |
| 1980 Black Hawk Helicopter                       | 64,599.11      |
| 1948 Porsche Type 356 Roadster                   | 62,725.78      |

-- Segment customers based on their total purchase amount
```sql
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
```
| customerNumber | customerName                      | customer_segment |
|----------------|-----------------------------------|------------------|
| 141            | Euro+ Shopping Channel            | high_value       |
| 124            | Mini Gifts Distributors Ltd.      | high_value       |
| 114            | Australian Collectors, Co.        | high_value       |
| 151            | Muscle Machine Inc                | high_value       |
| 119            | La Rochelle Gifts                 | high_value       |
| 148            | Dragon Souveniers, Ltd.           | high_value       |
| 323            | Down Under Souveniers, Inc        | high_value       |
| 131            | Land of Toys Inc.                 | high_value       |
| 187            | AV Stores, Co.                    | high_value       |
| 450            | The Sharp Gifts Warehouse         | high_value       |
| 382            | Salzburg Collectables             | high_value       |
| 496            | Kelly's Gift Shop                 | high_value       |
| 276            | Anna's Decorations, Ltd           | high_value       |
| 282            | Souveniers And Things Co.         | high_value       |
| 321            | Corporate Gift Ideas Co.          | high_value       |
| 146            | Saveley & Henriot, Co.            | high_value       |
| 145            | Danish Wholesale Imports          | high_value       |
| 278            | Rovelli Gifts                     | high_value       |
| 353            | Reims Collectables                | high_value       |
| 386            | L'ordine Souveniers               | high_value       |
| 448            | Scandinavian Gift Ideas           | high_value       |
| 363            | Online Diecast Creations Co.      | high_value       |
| 458            | Corrida Auto Replicas, Ltd        | high_value       |
| 298            | Vida Sport, Ltd                   | high_value       |
| 166            | Handji Gifts& Co                  | high_value       |
| 201            | UK Collectables, Ltd.             | high_value       |
| 398            | Tokyo Collectables, Ltd           | high_value       |
| 161            | Technics Stores Inc.              | high_value       |
| 157            | Diecast Classics Inc.             | high_value       |
| 121            | Baane Mini Imports                | high_value       |
| 334            | Suominen Souveniers               | high_value       |
| 320            | Mini Creations Ltd.               | high_value       |
| 167            | Herkku Gifts                      | medium_value     |
| 311            | Oulu Toy Supplies, Inc.           | medium_value     |
| 186            | Toys of Finland, Co.              | medium_value     |
| 175            | Gift Depot Inc.                   | medium_value     |
| 357            | GiftsForHim.com                   | medium_value     |
| 205            | Toys4GrownUps.com                 | medium_value     |
| 286            | Marta's Replicas Co.              | medium_value     |
| 412            | Extreme Desk Decorations, Ltd     | medium_value     |
| 227            | Heintze Collectables              | medium_value     |
| 259            | Toms Spezialitäten, Ltd           | medium_value     |
| 462            | FunGiftIdeas.com                  | medium_value     |
| 385            | Cruz & Sons Co.                   | medium_value     |
| 172            | La Corne D'abondance, Co.         | medium_value     |
| 406            | Auto Canal+ Petit                 | medium_value     |
| 362            | Gifts4AllAges.com                 | medium_value     |
| 249            | Amica Models & Co.                | medium_value     |
| 328            | Tekni Collectables Inc.           | medium_value     |
| 324            | Stylish Desk Decors, Co.          | medium_value     |
| 239            | Collectable Mini Designs Co.      | medium_value     |
| 112            | Signal Gift Stores                | medium_value     |
| 319            | Mini Classics                     | medium_value     |
| 486            | Motor Mint Distributors Inc.      | medium_value     |
| 128            | Blauer See Auto, Co.              | medium_value     |
| 209            | Mini Caravy                       | medium_value     |
| 379            | Collectables For Less Inc.        | medium_value     |
| 181            | Vitachrome Inc.                   | medium_value     |
| 240            | giftsbymail.co.uk                 | medium_value     |
| 350            | Marseille Mini Autos              | medium_value     |
| 314            | Petit Auto                        | medium_value     |
| 455            | Super Scale Inc.                  | medium_value     |
| 202            | Canadian Gift Exchange Network    | medium_value     |
| 424            | Classic Legends Inc.              | medium_value     |
| 299            | Norway Gifts By Mail, Co.         | medium_value     |
| 233            | Québec Home Shopping Network      | medium_value     |
| 216            | Enaco Distributors                | medium_value     |
| 250            | Lyon Souveniers                   | medium_value     |
| 260            | Royal Canadian Collectables, Ltd. | medium_value     |
| 129            | Mini Wheels Co.                   | medium_value     |
| 144            | Volvo Model Replicas, Co          | medium_value     |
| 495            | Diecast Collectables              | medium_value     |
| 177            | Osaka Souveniers Co.              | medium_value     |
| 171            | Daedalus Designs Imports          | medium_value     |
| 242            | Alpha Cognac                      | medium_value     |
| 256            | Auto Associés & Cie.              | medium_value     |
| 339            | Classic Gift Ideas, Inc           | medium_value     |
| 471            | Australian Collectables, Ltd      | medium_value     |
| 204            | Online Mini Collectables          | medium_value     |
| 333            | Australian Gift Network, Co       | medium_value     |
| 452            | Mini Auto Werke                   | medium_value     |
| 484            | Iberia Gift Imports, Corp.        | medium_value     |
| 447            | Gift Ideas Corp.                  | low_value        |
| 189            | Clover Collections, Co.           | low_value        |
| 344            | CAF Imports                       | low_value        |
| 211            | King Kong Collectables, Co.       | low_value        |
| 475            | West Coast Collectables Co.       | low_value        |
| 487            | Signal Collectibles Ltd.          | low_value        |
| 347            | Men 'R' US Retailers, Ltd.        | low_value        |
| 173            | Cambridge Collectables Co.        | low_value        |
| 415            | Bavarian Collectables Imports, Co.| low_value        |
| 489            | Double Decker Gift Stores, Ltd    | low_value        |
| 456            | Microscale Inc.                   | low_value        |
| 381            | Royale Belge                      | low_value        |
| 473            | Frau da Collezione                | low_value        |
| 103            | Atelier graphique                 | low_value        |
| 198            | Auto-Moto Classics Inc.           | low_value        |
| 219            | Boards & Toys Co.                 | low_value        |

-- Identify frequently co-purchased products to understand cross-selling opportunities.
```sql
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
```
| Product Code | Product Name                          | Partner Product Code | Partner Product Name                       | Purchased Together |
|--------------|---------------------------------------|-----------------------|-------------------------------------------|--------------------|
| S50_1341     | 1930 Buick Marquette Phaeton           | S700_1691             | American Airlines: B767-300               | 28                 |
| S700_1691    | American Airlines: B767-300            | S50_1341              | 1930 Buick Marquette Phaeton              | 28                 |
| S18_3232     | 1992 Ferrari 360 Spider red            | S18_2319              | 1964 Mercedes Tour Bus                    | 27                 |
| S18_2957     | 1934 Ford V8 Coupe                     | S18_3136              | 18th Century Vintage Horse Carriage       | 27                 |
| S700_2047    | HMS Bounty                             | S72_1253              | Boeing X-32A JSF                          | 27                 |
| S18_3136     | 18th Century Vintage Horse Carriage    | S18_2957              | 1934 Ford V8 Coupe                        | 27                 |
| S18_2319     | 1964 Mercedes Tour Bus                 | S18_3232              | 1992 Ferrari 360 Spider red               | 27                 |
| S72_1253     | Boeing X-32A JSF                       | S700_2047             | HMS Bounty                                | 27                 |
| S24_3420     | 1937 Horch 930V Limousine              | S24_2841              | 1900s Vintage Bi-Plane                    | 27                 |
| S24_2841     | 1900s Vintage Bi-Plane                 | S24_3420              | 1937 Horch 930V Limousine                 | 27                 |
| S700_4002    | American Airlines: MD-11S              | S24_3949              | Corsair F4U ( Bird Cage)                  | 27                 |
| S24_3949     | Corsair F4U ( Bird Cage)               | S700_4002             | American Airlines: MD-11S                 | 27                 |
| S12_3990     | 1970 Plymouth Hemi Cuda                | S12_1099              | 1968 Ford Mustang                         | 26                 |
| S32_4485     | 1974 Ducati 350 Mk3 Desmo              | S50_4713              | 2002 Yamaha YZR M1                        | 26                 |
| S700_3962    | The Queen Mary                         | S72_3212              | Pont Yacht                                | 26                 |
| S12_1099     | 1968 Ford Mustang                      | S12_3990              | 1970 Plymouth Hemi Cuda                   | 26                 |
| S18_2325     | 1932 Model A Ford J-Coupe              | S24_1937              | 1939 Chevrolet Deluxe Coupe               | 26                 |
| S18_2625     | 1936 Harley Davidson El Knucklehead    | S10_2016              | 1996 Moto Guzzi 1100i                     | 26                 |
| S10_2016     | 1996 Moto Guzzi 1100i                  | S18_2625              | 1936 Harley Davidson El Knucklehead       | 26                 |
| S24_1937     | 1939 Chevrolet Deluxe Coupe            | S18_2325              | 1932 Model A Ford J-Coupe                 | 26                 |

# Conclusion
### Insights
From the analysis, some general insights came out:

1. Classic cars are the majority of sales.
2. Gerard Hernandez and Leslie Jennings reached best selling numbers.
3. There is a solid success of shipping products on time. (95.3988)
4. Classic cars before 2000 provides best profit.
5. Number of product that sold together is critual, there are solid potential for cross-selling opportunities.

### Closing Thoughts
Focusing on classic cars which are before 2000, and trying to sell them together based on cross-selling table could be beneficial for sales. 


