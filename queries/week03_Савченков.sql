-- Неделя 3. Выборка из одной таблицы
-- Савченков Кирилл

-- 1. Какие виды инцидентов встречаются в сервисе?
SELECT DISTINCT incident_type
FROM incidents
ORDER BY incident_type;

-- 2. Какие платежи не прошли или ещё ожидают обработки?
SELECT id, rental_id, amount, payment_status, processed_at
FROM payments
WHERE payment_status IN ('failed', 'pending')
ORDER BY processed_at;

-- 3. Какую комиссию банк берёт с оплат аренды от 20 до 50 BYN (2,5%)?
SELECT id, rental_id, amount,
       amount * 0.025 AS bank_fee
FROM payments
WHERE payment_type = 'charge'
  AND amount BETWEEN 20 AND 50
ORDER BY amount DESC;

-- 4. Какие инциденты связаны с парковкой?
SELECT id, rental_id, description, fine_amount
FROM incidents
WHERE description LIKE '%парковк%'
ORDER BY fine_amount DESC;

-- 5. По каким арендам с поминутным тарифом ещё не рассчитана стоимость?
SELECT id, user_id, car_id, start_time
FROM rentals
WHERE total_cost IS NULL
  AND tariff_type = 'per_minute'
ORDER BY start_time;
