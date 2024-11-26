-- Create the database
CREATE DATABASE CampingPlatform;

-- Use the database
USE CampingPlatform;

-- Users table for managing user information and login
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- CampingSpots table for camping spot details
CREATE TABLE CampingSpots (
    spot_id INT AUTO_INCREMENT PRIMARY KEY,
    owner_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    location VARCHAR(255),
    price DECIMAL(10, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (owner_id) REFERENCES Users(user_id)
);

-- Bookings table for booking camping spots
CREATE TABLE Bookings (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    spot_id INT NOT NULL,
    booking_date DATE NOT NULL,
    status ENUM('Pending', 'Confirmed', 'Cancelled') DEFAULT 'Pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (spot_id) REFERENCES CampingSpots(spot_id)
);

-- User information changes log
CREATE TABLE UserChanges (
    change_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    change_description TEXT NOT NULL,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- Filters table for specific needs (optional for expansion)
CREATE TABLE Filters (
    filter_id INT AUTO_INCREMENT PRIMARY KEY,
    filter_name VARCHAR(50) NOT NULL,
    description TEXT
);

-- Linking filters to camping spots
CREATE TABLE SpotFilters (
    spot_filter_id INT AUTO_INCREMENT PRIMARY KEY,
    spot_id INT NOT NULL,
    filter_id INT NOT NULL,
    FOREIGN KEY (spot_id) REFERENCES CampingSpots(spot_id),
    FOREIGN KEY (filter_id) REFERENCES Filters(filter_id)
);

-- Owner camping spot management
CREATE TABLE OwnerCampingSpots (
    owner_camping_id INT AUTO_INCREMENT PRIMARY KEY,
    owner_id INT NOT NULL,
    spot_id INT NOT NULL,
    FOREIGN KEY (owner_id) REFERENCES Users(user_id),
    FOREIGN KEY (spot_id) REFERENCES CampingSpots(spot_id)
);

-- Voeg ontbrekende kolommen toe
ALTER TABLE Users
ADD COLUMN phone VARCHAR(15) AFTER email,
ADD COLUMN country VARCHAR(50) AFTER phone;

-- Verander de naam van 'full_name' naar 'name' als dit je doel is
ALTER TABLE Users
CHANGE COLUMN full_name name VARCHAR(100);

-- Zorg dat `birth_date` correct is ingesteld (als deze kolom nog niet bestaat)
ALTER TABLE Users
MODIFY COLUMN birth_date DATE;

-- Voeg een default-waarde toe voor `country` als dat gewenst is
ALTER TABLE Users
MODIFY COLUMN country VARCHAR(50) DEFAULT 'Unknown';

-- Zorg ervoor dat de kolommen email en username uniek blijven
ALTER TABLE Users
ADD UNIQUE KEY (email),
ADD UNIQUE KEY (username);

