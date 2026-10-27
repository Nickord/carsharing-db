-- Неделя 6. Подзапросы и табличные выражения
-- Руденко Никита

-- 1. У каких клиентов есть неоплаченный штраф крупнее среднего штрафа по сервису?
SELECT id, last_name, first_name, phone_number
FROM users
WHERE id IN (
    SELECT r.user_id
    FROM incidents i
    INNER JOIN rentals r ON i.rental_id = r.id
    WHERE i.is_paid = FALSE
      AND i.fine_amount > (SELECT AVG(fine_amount) FROM incidents)
)
ORDER BY last_name;

-- 2. Какие машины хотя бы раз получали повреждения и требуют осмотра?
SELECT c.id, c.brand, c.license_plate, c.status
FROM cars c
WHERE EXISTS (
    SELECT 1
    FROM rentals r
    INNER JOIN incidents i ON i.rental_id = r.id
    WHERE r.car_id = c.id
      AND i.incident_type = 'damage'
)
ORDER BY c.id;

-- 3. Какие завершённые аренды обошлись дороже среднего по своему тарифу?
SELECT r.id, r.tariff_type, r.total_cost, t.avg_cost
FROM rentals r
INNER JOIN (
    SELECT tariff_type, AVG(total_cost) AS avg_cost
    FROM rentals
    WHERE status = 'completed'
    GROUP BY tariff_type
) AS t ON r.tariff_type = t.tariff_type
WHERE r.status = 'completed'
  AND r.total_cost > t.avg_cost
ORDER BY r.tariff_type, r.total_cost DESC;

-- 4. Сколько клиентов в каждом сегменте по сумме трат на аренду?
WITH client_spend AS (
    SELECT user_id, SUM(total_cost) AS total_spent
    FROM rentals
    WHERE status = 'completed'
    GROUP BY user_id
)
SELECT CASE
           WHEN total_spent >= 500 THEN 'VIP'
           WHEN total_spent >= 100 THEN 'активный'
           ELSE 'редкий'
       END AS segment,
       COUNT(*) AS clients_count,
       SUM(total_spent) AS segment_revenue
FROM client_spend
GROUP BY CASE
             WHEN total_spent >= 500 THEN 'VIP'
             WHEN total_spent >= 100 THEN 'активный'
             ELSE 'редкий'
         END
ORDER BY segment_revenue DESC;

-- 5. Какая выручка и какая доля неоплаченных штрафов от выручки в каждой категории машин?
WITH revenue AS (
    SELECT c.category, COUNT(*) AS rentals_count, SUM(r.total_cost) AS revenue
    FROM rentals r
    INNER JOIN cars c ON r.car_id = c.id
    WHERE r.status = 'completed'
    GROUP BY c.category
),
unpaid AS (
    SELECT c.category, SUM(i.fine_amount) AS unpaid_fines
    FROM incidents i
    INNER JOIN rentals r ON i.rental_id = r.id
    INNER JOIN cars c ON r.car_id = c.id
    WHERE i.is_paid = FALSE
    GROUP BY c.category
)
SELECT rv.category, rv.rentals_count, rv.revenue, u.unpaid_fines,
       u.unpaid_fines * 100.0 / rv.revenue AS unpaid_percent
FROM revenue rv
LEFT JOIN unpaid u ON u.category = rv.category
ORDER BY rv.revenue DESC;
