-- Неделя 6. Подзапросы и табличные выражения
-- Люкевич Григорий

-- 1. Какие машины хотя бы раз брали по посуточному тарифу?
SELECT id, brand, license_plate
FROM cars
WHERE id IN (SELECT car_id FROM rentals WHERE tariff_type = 'daily')
ORDER BY id;

-- 2. У каких клиентов сейчас нет активной аренды?
SELECT u.id, u.last_name, u.first_name
FROM users u
WHERE NOT EXISTS (
    SELECT 1
    FROM rentals r
    WHERE r.user_id = u.id
      AND r.status = 'active'
)
ORDER BY u.id;

-- 3. Сколько раз арендовали каждую машину бизнес-класса?
SELECT c.id, c.brand, c.license_plate,
       (SELECT COUNT(*) FROM rentals r WHERE r.car_id = c.id) AS rentals_count
FROM cars c
WHERE c.category = 'business'
ORDER BY rentals_count DESC, c.id;

-- 4. Сколько свободных машин в каждой категории и какой у них средний уровень топлива?
WITH available_cars AS (
    SELECT category, fuel_level_percent
    FROM cars
    WHERE status = 'available'
)
SELECT category, COUNT(*) AS cars_count, AVG(fuel_level_percent) AS avg_fuel
FROM available_cars
GROUP BY category
ORDER BY avg_fuel;

-- 5. Какие 5 марок принесли больше всего выручки?
WITH brand_revenue AS (
    SELECT c.brand, COUNT(*) AS rentals_count, SUM(r.total_cost) AS revenue
    FROM rentals r
    INNER JOIN cars c ON r.car_id = c.id
    WHERE r.status = 'completed'
    GROUP BY c.brand
)
SELECT brand, rentals_count, revenue
FROM brand_revenue
ORDER BY revenue DESC
LIMIT 5;
