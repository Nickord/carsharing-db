-- Каршеринг: структура базы данных
-- Команда 16, PostgreSQL

BEGIN TRANSACTION;

DROP TABLE IF EXISTS bonus_accounts CASCADE;
DROP TABLE IF EXISTS cars CASCADE;
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

CREATE TABLE bonus_accounts (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL UNIQUE,   
    balance DECIMAL(10, 2) NOT NULL DEFAULT 0,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_bonus_accounts_user FOREIGN KEY (user_id) REFERENCES users(id),
    CONSTRAINT chk_bonus_accounts_balance CHECK (balance >= 0)
);

CREATE TABLE cars (
    id SERIAL PRIMARY KEY,
    brand VARCHAR(50) NOT NULL,
    license_plate VARCHAR(20) NOT NULL UNIQUE,
    category VARCHAR(20) NOT NULL,
    fuel_level_percent INTEGER NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'available',
    latitude DECIMAL(10, 8) NOT NULL,
    longitude DECIMAL(11, 8) NOT NULL,
    CONSTRAINT chk_cars_category CHECK (category IN ('economy', 'comfort', 'business')),
    CONSTRAINT chk_cars_fuel CHECK (fuel_level_percent BETWEEN 0 AND 100),
    CONSTRAINT chk_cars_status CHECK (status IN ('available', 'rented', 'maintenance', 'blocked')),
    CONSTRAINT chk_cars_latitude CHECK (latitude BETWEEN -90 AND 90),
    CONSTRAINT chk_cars_longitude CHECK (longitude BETWEEN -180 AND 180)
);

CREATE INDEX idx_cars_status ON cars(status);

COMMIT;
