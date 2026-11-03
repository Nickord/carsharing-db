-- Неделя 7. Манипулирование данными, транзакции, представления
-- Руденко Никита

-- DML 1. Регистрация нового клиента
INSERT INTO users (first_name, last_name, email, phone_number, date_of_birth,
                   driver_license_issue_date, driver_license_expiry_date)
VALUES ('Илья', 'Ковалёв', 'ilya.kovalev@example.com', '+375291000101',
        '1999-03-14', '2018-05-20', '2028-05-20');

-- DML 2. Клиент сменил номер телефона и продлил водительские права
UPDATE users
SET phone_number = '+375291000201',
    driver_license_expiry_date = '2038-05-20'
WHERE email = 'ilya.kovalev@example.com';

-- DML 3. Клиент удалил аккаунт, так и не совершив ни одной аренды
DELETE FROM users
WHERE email = 'ilya.kovalev@example.com';

-- Транзакция. Завершение аренды 131: закрыть аренду, освободить машину, провести оплату.
-- Три шага выполняются только вместе. В конце ROLLBACK: изменения проверяются и отменяются.
BEGIN TRANSACTION;

UPDATE rentals
SET end_time = '2026-10-02 15:05:00',
    total_cost = 120.00,
    status = 'completed'
WHERE id = 131
  AND status = 'active';

UPDATE cars
SET status = 'available'
WHERE id = 72;

INSERT INTO payments (rental_id, payment_type, amount, payment_status)
VALUES (131, 'charge', 120.00, 'completed');

SELECT r.id, r.status, r.total_cost, c.status AS car_status
FROM rentals r
INNER JOIN cars c ON r.car_id = c.id
WHERE r.id = 131;

ROLLBACK;

-- Представление 1. Активные аренды: кто, на какой машине, с какого времени
DROP VIEW IF EXISTS v_active_rentals;

CREATE VIEW v_active_rentals AS
SELECT r.id AS rental_id, u.last_name, u.first_name, u.phone_number,
       c.brand, c.license_plate, c.category, r.tariff_type, r.start_time
FROM rentals r
INNER JOIN users u ON r.user_id = u.id
INNER JOIN cars c ON r.car_id = c.id
WHERE r.status = 'active';

SELECT * FROM v_active_rentals ORDER BY start_time;

-- Представление 2. Сводка по клиенту: число завершённых аренд, траты и долг по штрафам
DROP VIEW IF EXISTS v_client_summary;

CREATE VIEW v_client_summary AS
SELECT u.id AS user_id, u.last_name, u.first_name,
       COUNT(r.id) AS completed_rentals,
       SUM(r.total_cost) AS total_spent,
       (SELECT SUM(i.fine_amount)
        FROM incidents i
        INNER JOIN rentals r2 ON i.rental_id = r2.id
        WHERE r2.user_id = u.id
          AND i.is_paid = FALSE) AS unpaid_fines
FROM users u
LEFT JOIN rentals r ON r.user_id = u.id AND r.status = 'completed'
GROUP BY u.id, u.last_name, u.first_name;

SELECT * FROM v_client_summary
WHERE unpaid_fines > 0
ORDER BY unpaid_fines DESC;
