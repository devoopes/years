fullpath="/Users/sean/git/seanleftbelow"

CREATE TABLE music2016 music2017 music2018
(
  id serial NOT NULL,
  artist character varying(100),
  track character varying(200)
);

COPY music2012(artist,track) FROM '$fullpath/years/music/2012.csv' DELIMITER ',' CSV HEADER;
COPY music2013(artist,track) FROM '$fullpath/years/music/2013.csv' DELIMITER ',' CSV HEADER;
COPY music2014(artist,track) FROM '$fullpath/years/music/2014.csv' DELIMITER ',' CSV HEADER;
COPY music2015(artist,track) FROM '$fullpath/years/music/2015.csv' DELIMITER ',' CSV HEADER;
COPY music2016(artist,track) FROM '$fullpath/years/music/2016.csv' DELIMITER ',' CSV HEADER;
COPY music2017(artist,track) FROM '$fullpath/years/music/2017.csv' DELIMITER ',' CSV HEADER;
COPY music2018(artist,track) FROM '$fullpath/years/music/2018.csv' DELIMITER ',' CSV HEADER;


DO increace_years
BEGIN
   FOR counter IN 2012..2018 LOOP
 -- RAISE NOTICE 'Counter: %', counter;
 -- http://www.postgresqltutorial.com/plpgsql-loop-statements/
 COPY music'counter'(artist,track) FROM '$fullpath/years/music/','counter','.csv' DELIMITER ',' CSV HEADER
   END LOOP;
END; increace_years
