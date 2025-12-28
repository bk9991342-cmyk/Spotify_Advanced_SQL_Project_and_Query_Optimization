CREATE DATABASE Spotify_db;
USE Spotify_db;

CREATE TABLE shofify_dataset (
  track_id BIGINT AUTO_INCREMENT PRIMARY KEY,

    artist_name VARCHAR(255) NOT NULL,
    track_name VARCHAR(255) NOT NULL,
    album_name VARCHAR(255),
    album_type VARCHAR(50),

    danceability DECIMAL(5,3),
    energy DECIMAL(5,3),
    loudness DECIMAL(6,2),
    speechiness DECIMAL(5,3),
    acousticness DECIMAL(5,3),
    instrumentalness DECIMAL(5,3),
    liveness DECIMAL(5,3),
    valence DECIMAL(5,3),
    tempo DECIMAL(6,2),
    duration_min DECIMAL(6,2),

    youtube_title VARCHAR(255),
    youtube_channel VARCHAR(255),
    views BIGINT,
    likes BIGINT,
    comments BIGINT,

    licensed BOOLEAN,
    official_video BOOLEAN,

    streams BIGINT,
    energy_liveness DECIMAL(6,3),
    most_played_on VARCHAR(50),

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

SELECT * FROM shofify_dataset;

SELECT COUNT(DISTINCT artist) FROM shofify_dataset;

-- Easy Level
-- 1. Retrieve the names of all tracks that have more than 1 billion streams.
SELECT track_name
FROM spotify
WHERE streams > 1000000000;

-- 2. List all albums along with their respective artists.
SELECT DISTINCT
    album_name,
    artist_name
FROM spotify
WHERE album_name IS NOT NULL;

-- 3. Get the total number of comments for tracks where licensed = TRUE.
SELECT 
    SUM(comments) AS total_comments
FROM spotify
WHERE licensed = TRUE;

-- 4. Find all tracks that belong to the album type single.
SELECT 
   track_name,
   artist_name,
   album_name
FROM spotify
WHERE album_type = 'single';
-- 5. Count the total number of tracks by each artist.
SELECT 
    artist_name,
    COUNT(track_name) AS total_tracks
FROM spotify
GROUP BY artist_name
ORDER BY total_tracks DESC;

-- Medium Level
-- 6. Calculate the average danceability of tracks in each album.
SELECT
    album_name,
    AVG(danceability) AS avg_danceability
FROM spotify
WHERE album_name IS NOT NULL
GROUP BY album_name
ORDER BY avg_danceability DESC;

-- 7. Find the top 5 tracks with the highest energy values.
SELECT
    track_name,
    artist_name,
    energy
FROM spotify
ORDER BY energy DESC
LIMIT 5;

-- 8. List all tracks along with their views and likes where official_video = TRUE.
SELECT
    track_name,
    views,
    likes
FROM spotify
WHERE official_video = TRUE;

-- 9. For each album, calculate the total views of all associated tracks.
SELECT
    album_name,
    SUM(views) AS total_views
FROM spotify
WHERE album_name IS NOT NULL
GROUP BY album_name
ORDER BY total_views DESC;

-- 10. Retrieve the track names that have been streamed on Spotify more than YouTube.
SELECT
    track_name
FROM spotify
WHERE streams IS NOT NULL
  AND views IS NOT NULL
  AND streams > views;
  
-- Advanced Level
-- 11. Find the top 3 most-viewed tracks for each artist using window functions.
SELECT
    artist_name,
    track_name,
    views
FROM (
    SELECT
        artist_name,
        track_name,
        views,
        ROW_NUMBER() OVER (
            PARTITION BY artist_name
            ORDER BY views DESC
        ) AS rn
    FROM spotify
    WHERE views IS NOT NULL
) ranked_tracks
WHERE rn <= 3
ORDER BY artist_name, views DESC;

-- 12. Write a query to find tracks where the liveness score is above the average.
SELECT
    track_name,
    artist_name,
    liveness
FROM spotify
WHERE liveness > (
    SELECT AVG(liveness)
    FROM spotify
    WHERE liveness IS NOT NULL
);

-- 13. Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.
WITH album_energy AS (
    SELECT
        album_name,
        MAX(energy) AS max_energy,
        MIN(energy) AS min_energy
    FROM spotify
    WHERE album_name IS NOT NULL
      AND energy IS NOT NULL
    GROUP BY album_name
)
SELECT
    album_name,
    max_energy,
    min_energy,
    (max_energy - min_energy) AS energy_difference
FROM album_energy
ORDER BY energy_difference DESC;

-- 14. Find tracks where the energy-to-liveness ratio is greater than 1.2.
SELECT
    track_name,
    artist_name,
    energy,
    liveness,
    (energy / liveness) AS energy_liveness_ratio
FROM spotify
WHERE liveness IS NOT NULL
  AND liveness > 0
  AND energy IS NOT NULL
  AND (energy / liveness) > 1.2;
  
  -- 15. Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.
  SELECT
    track_name,
    artist_name,
    views,
    likes,
    SUM(likes) OVER (
        ORDER BY views DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_likes
FROM spotify
WHERE likes IS NOT NULL
  AND views IS NOT NULL
ORDER BY views DESC;