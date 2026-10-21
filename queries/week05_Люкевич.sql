-- Неделя 5. JOIN и операции над выборками
-- Люкевич Григорий

-- 1. На каких машинах сейчас идут активные аренды?
SELECT r.id, c.brand, c.license_plate, r.start_time
FROM rentals r
INNER JOIN cars c ON r.car_id = c.id
WHERE r.status = 'active'
ORDER BY r.start_time;

-- 2. Какие машины ни разу не арендовали?
SELECT c.id, c.brand, c.license_plate, c.status
FROM cars c
LEFT JOIN rentals r ON r.car_id = c.id
WHERE r.id IS NULL
ORDER BY c.id;

-- 3. Какой бонусный баланс у каждого клиента?
SELECT u.id, u.last_name, u.first_name, b.balance
FROM users u
FULL JOIN bonus_accounts b ON b.user_id = u.id
ORDER BY b.balance DESC, u.id;

-- 4. Кто сейчас ездит на машинах бизнес-класса?
SELECT u.last_name, u.first_name, c.brand, c.license_plate, r.start_time
FROM rentals r
INNER JOIN users u ON r.user_id = u.id
INNER JOIN cars c ON r.car_id = c.id
WHERE r.status = 'active'
  AND c.category = 'business'
ORDER BY r.start_time;

-- 5. Каких марок есть машины и в аренде, и на обслуживании одновременно?
SELECT brand FROM cars WHERE status = 'rented'
INTERSECT
SELECT brand FROM cars WHERE status = 'maintenance'
ORDER BY brand;
