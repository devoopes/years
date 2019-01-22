A list of song picks for the past few years and sql manipulation.

```brew services start postgresql
createdb music
psql music
```

```
CREATE TABLE music2017
(
  id serial NOT NULL,
  artist character varying(100),
  track character varying(200)
);
```

select * from music2018;

```
-- Import CSV Data into Table
COPY music2017(artist,track) FROM '/Users/dash/git-sean/musicdb/2017.csv' DELIMITER ',' CSV HEADER;

-- Show top music of the year/table
SELECT band, COUNT(track) FROM music2017 GROUP BY band ORDER BY COUNT(track) DESC;

-- Show top music of all the years.
SELECT band,COUNT(track) FROM(
  SELECT artist AS band,track FROM music2017
  UNION
  SELECT band,track FROM music2018
) allmusic
GROUP BY band ORDER BY COUNT(track) DESC;
```
