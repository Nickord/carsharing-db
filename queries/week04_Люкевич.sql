-- Неделя 4. Фильтрация, сортировка, группировка
-- Люкевич Григорий

-- 1. Какие 10 машин арендовали чаще всего?
SELECT car_id, COUNT(*) AS rentals_count
FROM rentals
GROUP BY car_id
ORDER BY rentals_count DESC, car_id
LIMIT 10;

-- 2. Сколько машин каждой категории находится в каждом статусе?
SELECT category, status, COUNT(*) AS cars_count
FROM cars
GROUP BY category, status
ORDER BY category, status;

-- 3. Сколько бонусов всего на счетах клиентов, какой средний, минимальный и максимальный баланс?
SELECT COUNT(*) AS accounts_count,
       SUM(balance) AS total_balance,
       AVG(balance) AS avg_balance,
       MIN(balance) AS min_balance,
       MAX(balance) AS max_balance
FROM bonus_accounts;

-- 4. Сколько свободных машин в каждой категории?
SELECT category, COUNT(*) AS available_cars
FROM cars
WHERE status = 'available'
GROUP BY category
ORDER BY available_cars DESC;

-- 5. Каких марок в автопарке 4 машины и больше?
SELECT brand, COUNT(*) AS cars_count
FROM cars
GROUP BY brand
HAVING COUNT(*) >= 4
ORDER BY brand;
