-- Неделя 3. Выборка из одной таблицы
-- Люкевич Григорий

-- 1. Какие марки есть в бизнес-классе автопарка?
SELECT DISTINCT brand
FROM cars
WHERE category = 'business'
ORDER BY brand;

-- 2. Какие машины сейчас на обслуживании или заблокированы?
SELECT id, brand, license_plate, status
FROM cars
WHERE status IN ('maintenance', 'blocked')
ORDER BY status, brand;

-- 3. Сколько процентов бака не хватает до полного у машин с топливом от 40 до 60%?
SELECT id, brand, fuel_level_percent,
       100 - fuel_level_percent AS percent_to_full
FROM cars
WHERE fuel_level_percent BETWEEN 40 AND 60
ORDER BY fuel_level_percent;

-- 4. Какие машины марок на букву M или H есть в автопарке?
SELECT id, brand, license_plate, category
FROM cars
WHERE brand LIKE 'M%' OR brand LIKE 'H%'
ORDER BY brand;

-- 5. Какие брони были отменены без поездки?
SELECT id, user_id, car_id, start_time
FROM rentals
WHERE end_time IS NULL
  AND status = 'cancelled'
ORDER BY start_time;
