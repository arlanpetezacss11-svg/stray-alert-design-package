-- Stray Alert MVP Database Schema
-- This file contains the SQL schema for the Stray Alert system
-- Database: SQLite
-- Generated from SQLAlchemy models

CREATE TABLE owners (
    owner_id INTEGER PRIMARY KEY AUTOINCREMENT,
    full_name VARCHAR(30) NOT NULL,
    email VARCHAR(30) NOT NULL UNIQUE,
    contact_number VARCHAR(15) NOT NULL,
    address VARCHAR(30) NOT NULL,
    password_hash VARCHAR(20) NOT NULL,
    is_admin BOOLEAN DEFAULT 0 NOT NULL
    registered_date DATE NOT NULL DEFAULT CURRENT_DATE,
    CONSTRAINT chk_owners_name  CHECK (length(trim(full_name)) > 0),
    CONSTRAINT chk_owners_email CHECK (email LIKE '%_@_%._%')
);

CREATE TABLE pets (
    pet_id INTEGER PRIMARY KEY AUTOINCREMENT,
    owner_id INTEGER NOT NULL,
    pet_name VARCHAR(10) NOT NULL,
    species VARCHAR(10) NOT NULL,
    sex VARCHAR(10),
    breed VARCHAR(10),
    color_markings VARCHAR(10),
    age_years INTEGER,
    description TEXT,
    photo VARCHAR(255),
    is_vaccinated BOOLEAN NOT NULL DEFAULT 0,
    vaccine_name VARCHAR(20),
    last_vaccination_date DATE,
    registered_date DATE NOT NULL DEFAULT CURRENT_DATE,
    CONSTRAINT fk_pets_owner
        FOREIGN KEY (owner_id) REFERENCES owners(owner_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    
CONSTRAINT chk_pets_name       CHECK (length(trim(pet_name)) > 0),
    CONSTRAINT chk_pets_species    CHECK (species IN ('Dog', 'Cat')),
    CONSTRAINT chk_pets_sex        CHECK (sex IS NULL OR sex IN ('Male', 'Female')),
    CONSTRAINT chk_pets_age        CHECK (age_years IS NULL OR age_years >= 0),
    CONSTRAINT chk_pets_vaccinated CHECK (is_vaccinated IN (0, 1)),
    CONSTRAINT chk_pets_vaccine    CHECK (
        is_vaccinated = 1
        OR (vaccine_name IS NULL AND last_vaccination_date IS NULL)
    )
);


CREATE TABLE qr_tags (
    tag_id INTEGER PRIMARY KEY AUTOINCREMENT,
    pet_id INTEGER NOT NULL UNIQUE,          
    qr_code VARCHAR(16) NOT NULL UNIQUE,
    issued_date DATE NOT NULL DEFAULT CURRENT_DATE,
    CONSTRAINT fk_qr_tags_pet
        FOREIGN KEY (pet_id) REFERENCES pets(pet_id)
        ON DELETE CASCADE ON UPDATE CASCADE


CREATE TABLE reports (
    report_id INTEGER PRIMARY KEY AUTOINCREMENT,
    pet_id INTEGER,                          
    report_type VARCHAR(10) NOT NULL,
    reporter_name VARCHAR(20),
    reporter_contact VARCHAR(15),
    location VARCHAR(30) NOT NULL,
    event_date DATE NOT NULL,
    description TEXT,
    photo VARCHAR(255),
    report_date DATE NOT NULL DEFAULT CURRENT_DATE,
    report_status VARCHAR(10) NOT NULL DEFAULT 'Open',
    resolved_date DATE,
    CONSTRAINT fk_reports_pet
        FOREIGN KEY (pet_id) REFERENCES pets(pet_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
  

CONSTRAINT fk_reports_owner
        FOREIGN KEY (filed_by) REFERENCES owners(owner_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_reports_type     CHECK (report_type IN ('Lost', 'Found')),
    CONSTRAINT chk_reports_status   CHECK (report_status IN ('Open', 'Resolved')),
    CONSTRAINT chk_reports_location CHECK (length(trim(location)) > 0),
    registered pet
    CONSTRAINT chk_reports_lost     CHECK (
        report_type = 'Found'
        OR (pet_id IS NOT NULL AND filed_by IS NOT NULL)
    ),


CONSTRAINT chk_reports_finder   CHECK (
        filed_by IS NOT NULL
        OR (reporter_name IS NOT NULL AND reporter_contact IS NOT NULL)
    ),
    CONSTRAINT chk_reports_resolved CHECK (
        (report_status = 'Open' AND resolved_date IS NULL)
        OR (report_status = 'Resolved' AND resolved_date IS NOT NULL)
    ),
    CONSTRAINT chk_reports_dates    CHECK (
        event_date <= report_date
        AND (resolved_date IS NULL OR resolved_date >= report_date)
    )
);