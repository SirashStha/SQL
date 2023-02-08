select * FROM Account

SELECT	artist_id,
		sales_price,
		LAG(sales_price, 1, 0) OVER( ORDER BY sales_price) as previous_sales_price,
		LEAD(sales_price, 1, 10000) OVER( ORDER BY sales_price) as next_sales_price
	FROM Account