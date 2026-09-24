-- Каршеринг: структура базы данных
-- Команда 16, PostgreSQL

BEGIN TRANSACTION;

DROP TABLE IF EXISTS incidents CASCADE;
DROP TABLE IF EXISTS payments CASCADE;
DROP TABLE IF EXISTS rentals CASCADE;
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

CREATE TABLE rentals (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    car_id INTEGER NOT NULL,
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP,
    tariff_type VARCHAR(20) NOT NULL,
    total_cost DECIMAL(10, 2),
    status VARCHAR(20) NOT NULL,
    CONSTRAINT fk_rentals_user FOREIGN KEY (user_id) REFERENCES users(id),
    CONSTRAINT fk_rentals_car FOREIGN KEY (car_id) REFERENCES cars(id),
    CONSTRAINT chk_rentals_tariff CHECK (tariff_type IN ('per_minute', 'hourly', 'daily')),
    CONSTRAINT chk_rentals_status CHECK (status IN ('active', 'completed', 'cancelled')),
    CONSTRAINT chk_rentals_times CHECK (end_time IS NULL OR end_time > start_time),
    CONSTRAINT chk_rentals_cost CHECK (total_cost >= 0),
    CONSTRAINT chk_rentals_state CHECK (
        (status = 'active' AND end_time IS NULL AND total_cost IS NULL)
        OR (status = 'completed' AND end_time IS NOT NULL AND total_cost IS NOT NULL)
        OR (status = 'cancelled' AND end_time IS NULL AND total_cost IS NOT NULL AND total_cost = 0)
    )
);

CREATE TABLE payments (
    id SERIAL PRIMARY KEY,
    rental_id INTEGER NOT NULL,
    payment_type VARCHAR(20) NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    payment_status VARCHAR(20) NOT NULL,
    processed_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_payments_rental FOREIGN KEY (rental_id) REFERENCES rentals(id),
    CONSTRAINT chk_payments_type CHECK (payment_type IN ('charge', 'refund')),
    CONSTRAINT chk_payments_status CHECK (payment_status IN ('pending', 'completed', 'failed')),
    CONSTRAINT chk_payments_amount CHECK (amount > 0)
);

CREATE TABLE incidents (
    id SERIAL PRIMARY KEY,
    rental_id INTEGER NOT NULL,
    incident_type VARCHAR(30) NOT NULL,
    description VARCHAR(255),
    fine_amount DECIMAL(10, 2) NOT NULL,
    is_paid BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_incidents_rental FOREIGN KEY (rental_id) REFERENCES rentals(id),
    CONSTRAINT chk_incidents_type CHECK (incident_type IN
        ('traffic_fine', 'parking_violation', 'damage', 'cleaning', 'smoking', 'late_return', 'accident')),
    CONSTRAINT chk_incidents_amount CHECK (fine_amount > 0)
);

CREATE INDEX idx_cars_status ON cars(status);
CREATE INDEX idx_rentals_user_id ON rentals(user_id);
CREATE INDEX idx_rentals_car_id ON rentals(car_id);
CREATE INDEX idx_rentals_status ON rentals(status);
CREATE INDEX idx_payments_rental_id ON payments(rental_id);
CREATE INDEX idx_incidents_rental_id ON incidents(rental_id);

COMMIT;
