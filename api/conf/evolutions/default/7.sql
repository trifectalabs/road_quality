# Traffic colours and new colour function names

# --- !Ups
ALTER TABLE colours ADD COLUMN layer text NOT NULL DEFAULT 'surface_quality';
ALTER TABLE colours DROP CONSTRAINT colours_pkey ;
ALTER TABLE colours ADD primary key (level, layer);

INSERT INTO colours (level, red, green, blue, layer) VALUES (0, 110, 32, 32, 'traffic');
INSERT INTO colours (level, red, green, blue, layer) VALUES (1, 200, 3, 15, 'traffic');
INSERT INTO colours (level, red, green, blue, layer) VALUES (2, 150, 23, 88, 'traffic');
INSERT INTO colours (level, red, green, blue, layer) VALUES (3, 100, 42, 160, 'traffic');
INSERT INTO colours (level, red, green, blue, layer) VALUES (4, 64, 54, 198, 'traffic');
INSERT INTO colours (level, red, green, blue, layer) VALUES (5, 27, 65, 236, 'traffic');

DROP FUNCTION ratingcolour ( double precision );

CREATE OR REPLACE FUNCTION surfaceRatingColour(rating double precision)
RETURNS TABLE (t text) AS $$
BEGIN
	RETURN QUERY
		WITH
			startVal AS (SELECT CASE
				WHEN rating < 1.8 THEN (SELECT (c.red, c.green, c.blue)::rgb FROM colours c WHERE level = 0 AND layer = 'surface_quality')
				WHEN rating < 2.6 THEN (SELECT (c.red, c.green, c.blue)::rgb FROM colours c WHERE level = 1 AND layer = 'surface_quality')
				WHEN rating < 3.4 THEN (SELECT (c.red, c.green, c.blue)::rgb FROM colours c WHERE level = 2 AND layer = 'surface_quality')
				WHEN rating < 4.2 THEN (SELECT (c.red, c.green, c.blue)::rgb FROM colours c WHERE level = 3 AND layer = 'surface_quality')
				ELSE (SELECT (c.red, c.green, c.blue)::rgb FROM colours c WHERE level = 4 AND layer = 'surface_quality')
			END),
			endVal AS (SELECT CASE
				WHEN rating < 1.8 THEN (SELECT (c.red, c.green, c.blue)::rgb FROM colours c WHERE level = 1 AND layer = 'surface_quality')
				WHEN rating < 2.6 THEN (SELECT (c.red, c.green, c.blue)::rgb FROM colours c WHERE level = 2 AND layer = 'surface_quality')
				WHEN rating < 3.4 THEN (SELECT (c.red, c.green, c.blue)::rgb FROM colours c WHERE level = 3 AND layer = 'surface_quality')
				WHEN rating < 4.2 THEN (SELECT (c.red, c.green, c.blue)::rgb FROM colours c WHERE level = 4 AND layer = 'surface_quality')
				ELSE (SELECT (c.red, c.green, c.blue)::rgb FROM colours c WHERE level = 5 AND layer = 'surface_quality')
			END),
			normRating AS (SELECT CASE
				WHEN rating < 1.8 THEN (rating - 1) / 0.8
				WHEN rating < 2.6 THEN (rating - 1.8) / 0.8
				WHEN rating < 3.4 THEN (rating - 2.6) / 0.8
				WHEN rating < 4.2 THEN (rating - 3.4) / 0.8
				ELSE (rating - 4.2) / 0.8
			END),
			red AS (SELECT blend((SELECT * FROM startVal).r, (SELECT * from endVal).r, (SELECT * FROM normRating))),
			green AS (SELECT blend((SELECT * from startVal).g, (SELECT * from endVal).g, (SELECT * FROM normRating))),
			blue AS (SELECT blend((SELECT * from startVal).b, (SELECT * from endVal).b, (SELECT * FROM normRating)))
			SELECT '#' || lpad(to_hex(re.blend), 2, '0') || lpad(to_hex(gr.blend), 2, '0') || lpad(to_hex(bl.blend), 2, '0')
			FROM (SELECT * FROM red) as re, (SELECT * FROM green) as gr, (SELECT * FROM blue) as bl;;
END;;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION trafficRatingColour(rating double precision)
RETURNS TABLE (t text) AS $$
BEGIN
	RETURN QUERY
		WITH
			startVal AS (SELECT CASE
				WHEN rating < 1.8 THEN (SELECT (c.red, c.green, c.blue)::rgb FROM colours c WHERE level = 0 AND layer = 'traffic')
				WHEN rating < 2.6 THEN (SELECT (c.red, c.green, c.blue)::rgb FROM colours c WHERE level = 1 AND layer = 'traffic')
				WHEN rating < 3.4 THEN (SELECT (c.red, c.green, c.blue)::rgb FROM colours c WHERE level = 2 AND layer = 'traffic')
				WHEN rating < 4.2 THEN (SELECT (c.red, c.green, c.blue)::rgb FROM colours c WHERE level = 3 AND layer = 'traffic')
				ELSE (SELECT (c.red, c.green, c.blue)::rgb FROM colours c WHERE level = 4 AND layer = 'traffic')
			END),
			endVal AS (SELECT CASE
				WHEN rating < 1.8 THEN (SELECT (c.red, c.green, c.blue)::rgb FROM colours c WHERE level = 1 AND layer = 'traffic')
				WHEN rating < 2.6 THEN (SELECT (c.red, c.green, c.blue)::rgb FROM colours c WHERE level = 2 AND layer = 'traffic')
				WHEN rating < 3.4 THEN (SELECT (c.red, c.green, c.blue)::rgb FROM colours c WHERE level = 3 AND layer = 'traffic')
				WHEN rating < 4.2 THEN (SELECT (c.red, c.green, c.blue)::rgb FROM colours c WHERE level = 4 AND layer = 'traffic')
				ELSE (SELECT (c.red, c.green, c.blue)::rgb FROM colours c WHERE level = 5 AND layer = 'traffic')
			END),
			normRating AS (SELECT CASE
				WHEN rating < 1.8 THEN (rating - 1) / 0.8
				WHEN rating < 2.6 THEN (rating - 1.8) / 0.8
				WHEN rating < 3.4 THEN (rating - 2.6) / 0.8
				WHEN rating < 4.2 THEN (rating - 3.4) / 0.8
				ELSE (rating - 4.2) / 0.8
			END),
			red AS (SELECT blend((SELECT * FROM startVal).r, (SELECT * from endVal).r, (SELECT * FROM normRating))),
			green AS (SELECT blend((SELECT * from startVal).g, (SELECT * from endVal).g, (SELECT * FROM normRating))),
			blue AS (SELECT blend((SELECT * from startVal).b, (SELECT * from endVal).b, (SELECT * FROM normRating)))
			SELECT '#' || lpad(to_hex(re.blend), 2, '0') || lpad(to_hex(gr.blend), 2, '0') || lpad(to_hex(bl.blend), 2, '0')
			FROM (SELECT * FROM red) as re, (SELECT * FROM green) as gr, (SELECT * FROM blue) as bl;;
END;;
$$ LANGUAGE plpgsql;



# --- !Downs

ALTER TABLE users DROP COLUMN layer;

DELETE FROM colours WHERE layer = 'traffic';
