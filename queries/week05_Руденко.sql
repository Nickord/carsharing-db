-- Неделя 5. JOIN и операции над выборками
-- Руденко Никита

-- 1. Кто совершил 10 самых дорогих завершённых аренд и на какой машине?
SELECT r.id, u.last_name, u.first_name, c.brand, c.category, r.tariff_type, r.total_cost
FROM rentals r
INNER JOIN users u ON r.user_id = u.id
INNER JOIN cars c ON r.car_id = c.id
WHERE r.status = 'completed'
ORDER BY r.total_cost DESC, r.id
LIMIT 10;

-- 2. Какие штрафы не оплачены: кто был за рулём, на какой машине и на какую сумму?
SELECT i.id, u.last_name, u.phone_number, c.brand, c.license_plate, i.description, i.fine_amount
FROM incidents i
INNER JOIN rentals r ON i.rental_id = r.id
INNER JOIN users u ON r.user_id = u.id
INNER JOIN cars c ON r.car_id = c.id
WHERE i.is_paid = FALSE
ORDER BY i.fine_amount DESC;

-- 3. Сколько завершённых аренд у каждого клиента, включая тех, кто ещё ни разу не ездил?
SELECT u.id, u.last_name, u.first_name, COUNT(r.id) AS rentals_count
FROM users u
LEFT JOIN rentals r ON r.user_id = u.id AND r.status = 'completed'
GROUP BY u.id, u.last_name, u.first_name
ORDER BY rentals_count, u.id;

-- 4. Какая машина сейчас в активной аренде и у кого, а какая свободна (полный список автопарка)?
SELECT c.id, c.brand, c.license_plate, c.status, r.id AS active_rental_id, r.user_id, r.start_time
FROM rentals r
RIGHT JOIN cars c ON r.car_id = c.id AND r.status = 'active'
ORDER BY c.status, c.id;

-- 5. Каким клиентам нужно позвонить: у кого есть неоплаченный штраф или неуспешный платёж?
SELECT r.user_id, 'неоплаченный штраф' AS reason
FROM incidents i
INNER JOIN rentals r ON i.rental_id = r.id
WHERE i.is_paid = FALSE
UNION
SELECT r.user_id, 'неуспешный платёж' AS reason
FROM payments p
INNER JOIN rentals r ON p.rental_id = r.id
WHERE p.payment_status = 'failed'
ORDER BY user_id, reason;
