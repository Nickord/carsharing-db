-- Неделя 5. JOIN и операции над выборками
-- Савченков Кирилл

-- 1. По каким арендам и тарифам были неуспешные платежи?
SELECT p.id, p.rental_id, r.tariff_type, p.amount
FROM payments p
INNER JOIN rentals r ON p.rental_id = r.id
WHERE p.payment_status = 'failed'
ORDER BY p.amount DESC;

-- 2. Какие завершённые аренды прошли без инцидентов?
SELECT r.id, r.user_id, r.total_cost
FROM rentals r
LEFT JOIN incidents i ON i.rental_id = r.id
WHERE i.id IS NULL
  AND r.status = 'completed'
ORDER BY r.id;

-- 3. Есть ли платежи по отменённым арендам?
SELECT r.id AS rental_id, r.status, p.id AS payment_id, p.amount
FROM payments p
RIGHT JOIN rentals r ON p.rental_id = r.id
WHERE r.status = 'cancelled'
ORDER BY r.id;

-- 4. Каким клиентам и на какую сумму сделаны возвраты?
SELECT u.last_name, u.first_name, p.rental_id, p.amount, p.processed_at
FROM payments p
INNER JOIN rentals r ON p.rental_id = r.id
INNER JOIN users u ON r.user_id = u.id
WHERE p.payment_type = 'refund'
ORDER BY p.processed_at;

-- 5. Какие клиенты ни разу не брали машину?
SELECT id FROM users
EXCEPT
SELECT user_id FROM rentals
ORDER BY id;
