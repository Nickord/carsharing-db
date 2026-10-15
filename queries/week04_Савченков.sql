-- Неделя 4. Фильтрация, сортировка, группировка
-- Савченков Кирилл

-- 1. Сколько платежей в каждом статусе?
SELECT payment_status, COUNT(*) AS payments_count
FROM payments
GROUP BY payment_status
ORDER BY payments_count DESC;

-- 2. Сколько платежей и на какую сумму по каждому сочетанию типа и статуса?
SELECT payment_type, payment_status,
       COUNT(*) AS payments_count,
       SUM(amount) AS total_amount
FROM payments
GROUP BY payment_type, payment_status
ORDER BY payment_type, payment_status;

-- 3. Какой средний, минимальный и максимальный размер штрафа?
SELECT COUNT(*) AS incidents_count,
       AVG(fine_amount) AS avg_fine,
       MIN(fine_amount) AS min_fine,
       MAX(fine_amount) AS max_fine
FROM incidents;

-- 4. Какая сумма неоплаченных штрафов по каждому виду инцидентов?
SELECT incident_type, SUM(fine_amount) AS unpaid_sum
FROM incidents
WHERE is_paid = FALSE
GROUP BY incident_type
ORDER BY unpaid_sum DESC;

-- 5. По каким арендам было больше одного платежа?
SELECT rental_id, COUNT(*) AS payments_count
FROM payments
GROUP BY rental_id
HAVING COUNT(*) > 1
ORDER BY rental_id;
