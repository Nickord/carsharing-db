-- Неделя 3. Выборка из одной таблицы
-- Руденко Никита

-- 1. Каким клиентам нельзя выдавать машину или нужен особый контроль:
--    права истекают в 2026 году или это молодой водитель с правами с 2021 года?
SELECT id, last_name, date_of_birth, driver_license_issue_date, driver_license_expiry_date
FROM users
WHERE driver_license_expiry_date BETWEEN '2026-01-01' AND '2026-12-31'
   OR (date_of_birth > '2000-12-31' AND driver_license_issue_date >= '2021-01-01')
ORDER BY driver_license_expiry_date;

-- 2. Какой кэшбэк 5% начислить по завершённым арендам с почасовым и посуточным тарифом?
SELECT id, user_id, tariff_type, total_cost,
       total_cost * 0.05 AS cashback
FROM rentals
WHERE status = 'completed'
  AND tariff_type IN ('hourly', 'daily')
ORDER BY cashback DESC;

-- 3. В каких сочетаниях категории и статуса встречаются машины с топливом ниже 30%?
SELECT DISTINCT category, status
FROM cars
WHERE fuel_level_percent < 30
ORDER BY category, status;

-- 4. Какие повреждения автомобилей клиенты ещё не оплатили?
SELECT id, rental_id, description, fine_amount
FROM incidents
WHERE (description LIKE 'Повреждение%' OR description LIKE 'Царапина%')
  AND is_paid = FALSE
ORDER BY fine_amount DESC;

-- 5. Какие 5 машин дольше всех находятся в аренде и до сих пор не возвращены?
SELECT id, user_id, car_id, start_time, tariff_type
FROM rentals
WHERE end_time IS NULL
  AND status = 'active'
ORDER BY start_time
LIMIT 5;
