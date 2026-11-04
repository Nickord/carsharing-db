-- Неделя 7. Манипулирование данными, транзакции, представления
-- Люкевич Григорий

-- DML 1. В автопарк поступила новая машина
INSERT INTO cars (brand, license_plate, category, fuel_level_percent, status, latitude, longitude)
VALUES ('Kia', '1101 DW-7', 'comfort', 40, 'maintenance', 53.90500000, 27.56000000);

-- Транзакция. Приёмка новой машины: заправить до полного бака и выпустить на линию
BEGIN TRANSACTION;

UPDATE cars
SET fuel_level_percent = 100
WHERE license_plate = '1101 DW-7';

UPDATE cars
SET status = 'available'
WHERE license_plate = '1101 DW-7';

COMMIT;

-- DML 2. Машину перегнали на другую парковку
UPDATE cars
SET latitude = 53.91500000,
    longitude = 27.58000000
WHERE license_plate = '1101 DW-7';

-- DML 3. Машину сняли с линии и удалили из автопарка
DELETE FROM cars
WHERE license_plate = '1101 DW-7';

-- Представление 1. Сколько раз арендовали каждую машину
DROP VIEW IF EXISTS v_car_rentals_count;

CREATE VIEW v_car_rentals_count AS
SELECT c.id AS car_id, c.brand, c.license_plate, c.category, COUNT(r.id) AS rentals_count
FROM cars c
LEFT JOIN rentals r ON r.car_id = c.id
GROUP BY c.id, c.brand, c.license_plate, c.category;

SELECT * FROM v_car_rentals_count ORDER BY rentals_count DESC, car_id;

-- Представление 2. Все аренды машин бизнес-класса
DROP VIEW IF EXISTS v_business_rentals;

CREATE VIEW v_business_rentals AS
SELECT r.id AS rental_id, c.brand, c.license_plate, r.tariff_type, r.total_cost, r.status
FROM rentals r
INNER JOIN cars c ON r.car_id = c.id
WHERE c.category = 'business';

SELECT * FROM v_business_rentals ORDER BY rental_id;
