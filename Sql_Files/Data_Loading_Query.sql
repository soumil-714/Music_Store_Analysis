-- Command To Use Database

USE music_store;

-- Loaded CSV Data in ALBUM table 

LOAD DATA LOCAL INFILE '/Users/soumil/Documents/Music_Store_Analysis/Data/album.csv'
INTO TABLE album
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(album_id, title, artist_id);

-- Loaded CSV Data in Artist table

LOAD DATA LOCAL INFILE '/Users/soumil/Documents/Music_Store_Analysis/Data/artist.csv'
INTO TABLE artist
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(artist_id, name); 

LOAD DATA LOCAL INFILE '/Users/soumil/Documents/Music_Store_Analysis/Data/artist.csv'
INTO TABLE artist
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(artist_id, name);

-- Loaded CSV Data in Customer table

LOAD DATA LOCAL INFILE '/Users/soumil/Documents/Music_Store_Analysis/Data/customer.csv'
INTO TABLE customer
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(customer_id, first_name, last_name, company, address, city, state,
 country, postal_code, phone, fax, email, support_rep_id);

-- Loaded CSV Data in Employee table

LOAD DATA LOCAL INFILE '/Users/soumil/Documents/Music_Store_Analysis/Data/employee.csv'
INTO TABLE employee
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
    employee_id,
    last_name,
    first_name,
    title,
    @reports_to,
    levels,
    @birthdate,
    @hire_date,
    address,
    city,
    state,
    country,
    postal_code,
    phone,
    fax,
    email
)
SET
    reports_to = NULLIF(@reports_to, ''),
    birthdate = STR_TO_DATE(@birthdate, '%d-%m-%Y %H:%i'),
    hire_date = STR_TO_DATE(@hire_date, '%d-%m-%Y %H:%i');

-- Loaded CSV Data in Genre table

LOAD DATA LOCAL INFILE '/Users/soumil/Documents/Music_Store_Analysis/Data/genre.csv'
INTO TABLE genre
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(genre_id, name);

-- Loaded CSV Data in Invoice table

LOAD DATA LOCAL INFILE '/Users/soumil/Documents/Music_Store_Analysis/Data/invoice.csv'
INTO TABLE invoice
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
    invoice_id,
    customer_id,
    invoice_date,
    billing_address,
    billing_city,
    billing_state,
    billing_country,
    billing_postal_code,
    total
);

-- Loaded CSV Data in Invoice_line table

LOAD DATA LOCAL INFILE '/Users/soumil/Documents/Music_Store_Analysis/Data/invoice_line.csv'
INTO TABLE invoice_line
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(invoice_line_id, invoice_id, track_id, unit_price, quantity);

-- Loaded CSV Data in Media_Type Table

LOAD DATA LOCAL INFILE '/Users/soumil/Documents/Music_Store_Analysis/Data/media_type.csv'
INTO TABLE media_type
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(media_type_id, name);

-- Loaded CSV Data in Playlsit_Track Table

LOAD DATA LOCAL INFILE '/Users/soumil/Documents/Music_Store_Analysis/Data/playlist_track.csv'
INTO TABLE playlist_track
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(playlist_id, track_id);

-- Loaded CSV Data in Playlist Table

LOAD DATA LOCAL INFILE '/Users/soumil/Documents/Music_Store_Analysis/Data/playlist.csv'
INTO TABLE playlist
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(playlist_id, name);

-- Loaded CSV Data in Track Table

LOAD DATA LOCAL INFILE '/Users/soumil/Documents/Music_Store_Analysis/Data/track.csv'
INTO TABLE track
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
    track_id,
    name,
    album_id,
    media_type_id,
    genre_id,
    composer,
    milliseconds,
    bytes,
    unit_price
);