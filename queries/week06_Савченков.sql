-- Неделя 6. Подзапросы и табличные выражения
-- Савченков Кирилл

-- 1. Какие оплаты аренды больше любого сделанного возврата?
SELECT id, rental_id, amount
FROM payments
WHERE payment_type = 'charge'
  AND amount > ALL (SELECT amount FROM payments WHERE payment_type = 'refund')
ORDER BY amount DESC;

-- 2. В каких арендах был хотя бы один инцидент?
SELECT r.id, r.user_id, r.car_id, r.total_cost
FROM rentals r
WHERE EXISTS (
    SELECT 1
    FROM incidents i
    WHERE i.rental_id = r.id
)
ORDER BY r.id;

-- 3. В каких статусах средняя сумма платежа больше 30 BYN?
SELECT t.payment_status, t.avg_amount
FROM (
    SELECT payment_status, AVG(amount) AS avg_amount
    FROM payments
    GROUP BY payment_status
) AS t
WHERE t.avg_amount > 30
ORDER BY t.avg_amount DESC;

-- 4. Сколько было возвратов и на какую сумму?
WITH refunds AS (
    SELECT rental_id, amount
    FROM payments
    WHERE payment_type = 'refund'
)
SELECT COUNT(*) AS refunds_count, SUM(amount) AS refunds_sum, AVG(amount) AS avg_refund
FROM refunds;

-- 5. Сколько денег реально поступило по каждому тарифу?
WITH paid AS (
    SELECT r.tariff_type, p.amount
    FROM payments p
    INNER JOIN rentals r ON p.rental_id = r.id
    WHERE p.payment_type = 'charge'
      AND p.payment_status = 'completed'
)
SELECT tariff_type, COUNT(*) AS payments_count, SUM(amount) AS paid_sum
FROM paid
GROUP BY tariff_type
ORDER BY paid_sum DESC;
