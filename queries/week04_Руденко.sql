-- Неделя 4. Фильтрация, сортировка, группировка
-- Руденко Никита

-- 1. Сколько аренд приходится на каждое сочетание тарифа и статуса?
SELECT tariff_type, status, COUNT(*) AS rentals_count
FROM rentals
GROUP BY tariff_type, status
ORDER BY tariff_type, status;

-- 2. Сколько завершённых аренд, какая выручка и средний чек по каждому тарифу?
SELECT tariff_type,
       COUNT(*) AS rentals_count,
       SUM(total_cost) AS revenue,
       AVG(total_cost) AS avg_check
FROM rentals
WHERE status = 'completed'
GROUP BY tariff_type
ORDER BY revenue DESC;

-- 3. Сколько машин в каждой категории и какой у них средний, минимальный и максимальный уровень топлива?
SELECT category,
       COUNT(*) AS cars_count,
       AVG(fuel_level_percent) AS avg_fuel,
       MIN(fuel_level_percent) AS min_fuel,
       MAX(fuel_level_percent) AS max_fuel
FROM cars
GROUP BY category
ORDER BY avg_fuel;

-- 4. Какие клиенты совершили 3 и более завершённые аренды и сколько каждый из них потратил?
SELECT user_id,
       COUNT(*) AS rentals_count,
       SUM(total_cost) AS total_spent
FROM rentals
WHERE status = 'completed'
GROUP BY user_id
HAVING COUNT(*) >= 3
ORDER BY total_spent DESC;

-- 5. По каким видам инцидентов сумма штрафов превышает 300 BYN?
SELECT incident_type,
       COUNT(*) AS incidents_count,
       SUM(fine_amount) AS total_fines,
       MAX(fine_amount) AS max_fine
FROM incidents
GROUP BY incident_type
HAVING SUM(fine_amount) > 300
ORDER BY total_fines DESC;
