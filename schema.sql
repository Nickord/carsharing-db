-- Каршеринг: структура базы данных
-- Команда 16, PostgreSQL

BEGIN TRANSACTION;

DROP TABLE IF EXISTS users CASCADE;

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone_number VARCHAR(20) NOT NULL UNIQUE,
    date_of_birth DATE NOT NULL,
    driver_license_issue_date DATE NOT NULL,
    driver_license_expiry_date DATE NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_users_email CHECK (email LIKE '%@%'),
    CONSTRAINT chk_users_phone CHECK (phone_number LIKE '+375%'),
    CONSTRAINT chk_users_birth CHECK (date_of_birth < CURRENT_DATE),
    CONSTRAINT chk_users_license_issue CHECK (driver_license_issue_date > date_of_birth AND driver_license_issue_date <= CURRENT_DATE),
    CONSTRAINT chk_users_license_expiry CHECK (driver_license_expiry_date > driver_license_issue_date)
);

COMMIT;
