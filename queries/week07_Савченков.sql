-- Неделя 7. Манипулирование данными, транзакции, представления
-- Савченков Кирилл

-- DML 1. По аренде 3 пришёл штраф за парковку
INSERT INTO incidents (rental_id, incident_type, description, fine_amount)
VALUES (3, 'parking_violation', 'Парковка на газоне', 30.00);

-- Транзакция. Клиент пытается оплатить штраф, но оплата не прошла: изменения отменяются
BEGIN TRANSACTION;

UPDATE incidents
SET is_paid = TRUE
WHERE rental_id = 3
  AND description = 'Парковка на газоне';

SELECT id, rental_id, description, is_paid
FROM incidents
WHERE rental_id = 3;

ROLLBACK;

-- DML 2. Сумму штрафа пересчитали
UPDATE incidents
SET fine_amount = 25.00
WHERE rental_id = 3
  AND description = 'Парковка на газоне';

-- DML 3. Штраф отменили после обжалования
DELETE FROM incidents
WHERE rental_id = 3
  AND description = 'Парковка на газоне';

-- Представление 1. Неоплаченные штрафы с информацией об аренде
DROP VIEW IF EXISTS v_unpaid_incidents;

CREATE VIEW v_unpaid_incidents AS
SELECT i.id AS incident_id, i.rental_id, r.user_id, r.tariff_type, i.description, i.fine_amount
FROM incidents i
INNER JOIN rentals r ON i.rental_id = r.id
WHERE i.is_paid = FALSE;

SELECT * FROM v_unpaid_incidents ORDER BY fine_amount DESC;

-- Представление 2. Платежи вместе с тарифом и статусом аренды
DROP VIEW IF EXISTS v_payment_details;

CREATE VIEW v_payment_details AS
SELECT p.id AS payment_id, p.rental_id, r.tariff_type, r.status AS rental_status,
       p.payment_type, p.amount, p.payment_status
FROM payments p
INNER JOIN rentals r ON p.rental_id = r.id;

SELECT * FROM v_payment_details ORDER BY payment_id;
