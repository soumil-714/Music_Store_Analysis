-- Command To Use Database

USE music_store;

-- 1. album → artist
ALTER TABLE album
ADD CONSTRAINT fk_album_artist
FOREIGN KEY (artist_id)
REFERENCES artist(artist_id)
ON DELETE CASCADE;

-- 2. customer → employee
ALTER TABLE customer
ADD CONSTRAINT fk_customer_employee
FOREIGN KEY (support_rep_id)
REFERENCES employee(employee_id)
ON DELETE CASCADE;

-- 3. employee → employee
ALTER TABLE employee
ADD CONSTRAINT fk_employee_manager
FOREIGN KEY (reports_to)
REFERENCES employee(employee_id)
ON DELETE CASCADE;

-- 4. invoice → customer
ALTER TABLE invoice
ADD CONSTRAINT fk_invoice_customer
FOREIGN KEY (customer_id)
REFERENCES customer(customer_id)
ON DELETE CASCADE;

-- 5. invoice_line → invoice
ALTER TABLE invoice_line
ADD CONSTRAINT fk_invoice_line_invoice
FOREIGN KEY (invoice_id)
REFERENCES invoice(invoice_id)
ON DELETE CASCADE;

-- 6. invoice_line → track
ALTER TABLE invoice_line
ADD CONSTRAINT fk_invoice_line_track
FOREIGN KEY (track_id)
REFERENCES track(track_id)
ON DELETE CASCADE;

-- 7. playlist_track → playlist
ALTER TABLE playlist_track
ADD CONSTRAINT fk_playlist_track_playlist
FOREIGN KEY (playlist_id)
REFERENCES playlist(playlist_id)
ON DELETE CASCADE;

-- 8. playlist_track → track
ALTER TABLE playlist_track
ADD CONSTRAINT fk_playlist_track_track
FOREIGN KEY (track_id)
REFERENCES track(track_id)
ON DELETE CASCADE;


-- 9. track → album
ALTER TABLE track
ADD CONSTRAINT fk_track_album
FOREIGN KEY (album_id)
REFERENCES album(album_id)
ON DELETE CASCADE;

-- 10. track → genre
ALTER TABLE track
ADD CONSTRAINT fk_track_genre
FOREIGN KEY (genre_id)
REFERENCES genre(genre_id)
ON DELETE CASCADE;

-- 11. track → media_type
ALTER TABLE track
ADD CONSTRAINT fk_track_media_type
FOREIGN KEY (media_type_id)
REFERENCES media_type(media_type_id)
ON DELETE CASCADE;
