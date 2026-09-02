-- Copyright (c) 2026 Soumil Jain

-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:

-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.


-- Creating Database 

CREATE DATABASE music_store;

-- Command To Use Database
USE music_store;

-- Creating ALBUM table 

CREATE TABLE album (
    album_id INT NOT NULL,
    title VARCHAR(150),
    artist_id INT,
    PRIMARY KEY (album_id)
);

SELECT * FROM album;

-- Creating Artist table 

CREATE TABLE artist (
    artist_id INT NOT NULL,
    name VARCHAR(150),
    PRIMARY KEY (artist_id)
);

-- ALTER Album Table Due To Mistake

ALTER TABLE album
ADD CONSTRAINT fk_album_artist
FOREIGN KEY (artist_id)
REFERENCES artist(artist_id)
ON DELETE CASCADE;

-- Creating Customer table 

CREATE TABLE customer (
    customer_id INT NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    company VARCHAR(150),
    address VARCHAR(250) NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50),
    country VARCHAR(50) NOT NULL,
    postal_code VARCHAR(30),
    phone VARCHAR(30),
    fax VARCHAR(30),
    email VARCHAR(100) NOT NULL,
    support_rep_id INT NOT NULL,
    PRIMARY KEY (customer_id)
);

-- Creating Employee table  
 
 CREATE TABLE employee (
    employee_id INT NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    title VARCHAR(250) NOT NULL,
    reports_to INT,
    levels VARCHAR(10) NOT NULL,
    birthdate DATETIME NOT NULL,
    hire_date DATETIME NOT NULL,
    address VARCHAR(120) NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50),
    country VARCHAR(30) NOT NULL,
    postal_code VARCHAR(30) NOT NULL,
    phone VARCHAR(30) NOT NULL,
    fax VARCHAR(30) NOT NULL,
    email VARCHAR(100) NOT NULL,
    PRIMARY KEY (employee_id)
);

-- Creating Genre table  

CREATE TABLE genre (
    genre_id INT NOT NULL,
    name VARCHAR(50) NOT NULL,
    PRIMARY KEY (genre_id)
);

-- Creating Invoice table

CREATE TABLE invoice (
    invoice_id INT NOT NULL,
    customer_id INT NOT NULL,
    invoice_date DATETIME NOT NULL,
    billing_address VARCHAR(120) NOT NULL,
    billing_city VARCHAR(50) NOT NULL,
    billing_state VARCHAR(50),
    billing_country VARCHAR(50) NOT NULL,
    billing_postal_code VARCHAR(30),
    total DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (invoice_id)
);

-- Altered invoice total From DECIMAL To DOUBLE

ALTER TABLE invoice
MODIFY total DOUBLE NOT NULL;

-- Creating Invoice_line table 

CREATE TABLE invoice_line (
    invoice_line_id INT NOT NULL,
    invoice_id INT NOT NULL,
    track_id INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    PRIMARY KEY (invoice_line_id)
);

-- Creating Media_Type Table

CREATE TABLE media_type (
    media_type_id INT NOT NULL,
    name VARCHAR(50) NOT NULL,
    PRIMARY KEY (media_type_id)
);

-- Creating Playlist_Track Table

CREATE TABLE playlist_track (
    playlist_id INT NOT NULL,
    track_id INT NOT NULL
);

-- Creating Playlist Table 

CREATE TABLE playlist (
    playlist_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    PRIMARY KEY (playlist_id)
);

-- Creating Track Table

CREATE TABLE track (
    track_id INT NOT NULL,
    name VARCHAR(250) NOT NULL,
    album_id INT NOT NULL,
    media_type_id INT NOT NULL,
    genre_id INT NOT NULL,
    composer VARCHAR(250),
    milliseconds BIGINT NOT NULL,
    bytes INT NOT NULL,
    unit_price DOUBLE NOT NULL,
    PRIMARY KEY (track_id)
);