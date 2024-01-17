-- Qual a categoria que possui o produto com o maior número de dias entre a primeira compra da categoria e a sua data limite de entrega?
SELECT
	p.product_category_name,
	p.product_id,
	MIN( DATE(oi.shipping_limit_date)),
	MAX(DATE(o.order_purchase_timestamp)) 
FROM
	products p LEFT JOIN order_items oi ON (p.product_id = oi.product_id)
			   LEFT JOIN  orders o ON (oi.order_id = o.order_id)
WHERE p.product_category_name IS NOT NULL
GROUP BY p.product_category_name

-- Qual o código do pedido da categoria “utilidades domésticas” com 1283 dias entre a primeira compra dessa categoria e a data limite de envio do produto?
SELECT
	oi.order_id,
	MIN( DATE(oi.shipping_limit_date)),
	MAX(DATE(o.order_purchase_timestamp)),
	p.product_category_name 
FROM
	order_items oi LEFT JOIN orders o ON( oi.order_id = o.order_id)
				   LEFT JOIN products p ON (oi.product_id  = p.product_id)
WHERE p.product_category_name = 'utilidades_domesticas'
GROUP BY oi.order_id 

-- Qual a categoria com maior soma dos preços de produtos?
SELECT 
	p.product_category_name ,
	SUM(oi.price) AS TOTAL_PRICE
FROM 
	products p LEFT JOIN order_items oi ON (p.product_id = oi.product_id)
WHERE P.product_category_name IS NOT NULL
GROUP BY p.product_category_name
ORDER BY TOTAL_PRICE DESC

--Qual o código do produto mais caro da categoria agro indústria & comercio?
SELECT
	oi.order_id, 
	p.product_category_name ,
	MAX(oi.price) 
FROM
	products p LEFT JOIN order_items oi ON (p.product_id = oi.product_id) 
WHERE P.product_category_name IS NOT NULL
	AND p.product_category_name = 'agro_industria_e_comercio'
 
-- Qual a ordem correta das 3 categorias com os produtos mais caros?

 --Qual o valor dos produtos mais caros das categorias: bebes, flores e seguros e serviços, respectivamente
SELECT
	p.product_category_name,
	MAX(oi.price)
FROM 
	products p LEFT JOIN order_items oi ON (p.product_id = oi.product_id)
WHERE 
	p.product_category_name in ('bebes', 'flores', 'seguros_e_servicos')
GROUP BY p.product_category_name 

-- Quantos pedidos possuem um único comprador, 3 produtos e o pagamento foi dividido em 10 parcelas

WITH CUSTOMERS AS (
    SELECT
        COUNT(DISTINCT o.customer_id) AS num_customers,
        COUNT(o.order_id) AS num_orders,
        COUNT(DISTINCT oi.product_id) AS num_products,
        op.payment_installments AS max_installments
    FROM
        orders o
        LEFT JOIN order_items oi ON o.order_id = oi.order_id
        LEFT JOIN order_payments op ON o.order_id = op.order_id
   
    GROUP BY
        o.customer_id  
)
SELECT
    COUNT(*)
FROM
    CUSTOMERS
WHERE
	 num_products = 3
    AND max_installments = 10;
   
-- Quantos pedidos foram parcelados em mais de 10 vezes ?
   
  WITH ORDERS AS( SELECT 
  COUNT(OP.order_id),
  op.payment_installments
  FROM order_payments op 
  WHERE op.payment_installments > 10
  GROUP BY op.order_id )
	
	SELECT 
		COUNT(*)
	FROM ORDERS
	
-- Quantos clientes avaliaram o pedido com 5 estrelas?	
	SELECT
		COUNT(OR2.review_score) 
	FROM
		order_reviews or2 
	WHERE 
		or2.review_score = 5
-- Quantos clientes avaliaram o pedido com 4 estrelas?
		SELECT
		COUNT(OR2.review_score) 
	FROM
		order_reviews or2 
	WHERE 
		or2.review_score = 4
-- No dia 2 de Outubro de 2016, qual era o valor da média móvel dos últimos 7 dias?
SELECT	
	DATE(o.order_purchase_timestamp),
	AVG(oi.price) OVER (ORDER BY DATE(o.order_purchase_timestamp)
						ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) AS MEDIA_MOVEL
FROM
	order_items oi LEFT JOIN orders o ON (o.order_id = oi.order_id)
WHERE DATE(o.order_purchase_timestamp) = '2016-10-02' 

--29. Qual o código do produto da categoria artes que está na posição 1 do ranking de produtos mais caros dessa categoria?
SELECT
	p.product_id ,
	p.product_category_name,
	MAX(oi.price)
FROM
	products p LEFT JOIN order_items oi ON (p.product_id - oi.product_id)
WHERE 
	p.product_category_name  = 'artes'

