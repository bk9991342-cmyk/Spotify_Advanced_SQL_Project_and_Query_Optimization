# Spotify_Advanced_SQL_Project_and_Query_Optimizations
![Spotify_img](https://github.com/bk9991342-cmyk/Spotify_Advanced_SQL_Project_and_Query_Optimization/blob/main/spotify_img1.webp)

## Overview
This project focuses on analyzing a Spotify dataset containing detailed information about tracks, albums, and artists using SQL. It demonstrates an end-to-end workflow, starting from normalizing a denormalized dataset into well-structured relational tables, followed by executing SQL queries of varying complexity (basic, intermediate, and advanced). The project also emphasizes query optimization techniques to improve performance. The key objective is to strengthen advanced SQL skills while extracting meaningful insights related to music trends, artist performance, and track characteristics.
```sql
DROP TABLE IF EXISTS spotify;

CREATE TABLE spotify (
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
```
## Project Steps

### 1. Data Exploration
Before diving into SQL, it’s important to understand the dataset thoroughly. The dataset contains attributes such as:
- `Artist`: The performer of the track.
- `Track`: The name of the song.
- `Album`: The album to which the track belongs.
- `Album_type`: The type of album (e.g., single or album).
- Various metrics such as `danceability`, `energy`, `loudness`, `tempo`, and more.

### 4. Querying the Data
After the data is inserted, various SQL queries can be written to explore and analyze the data. Queries are categorized into **easy**, **medium**, and **advanced** levels to help progressively develop SQL proficiency.

#### Easy Queries
- Simple data retrieval, filtering, and basic aggregations.
  
#### Medium Queries
- More complex queries involving grouping, aggregation functions, and joins.
  
#### Advanced Queries
- Nested subqueries, window functions, CTEs, and performance optimization.

### 5. Query Optimization
In advanced stages, the focus shifts to improving query performance. Some optimization strategies include:
- **Indexing**: Adding indexes on frequently queried columns.
- **Query Execution Plan**: Using `EXPLAIN ANALYZE` to review and refine query performance.
## 15 Practice Problems
### Easy Level
1. Retrieve the names of all tracks that have more than 1 billion streams.
```sql
SELECT track_name
FROM spotify
WHERE streams > 1000000000;
```
2. List all albums along with their respective artists.
```sql
SELECT DISTINCT
    album_name,
    artist_name
FROM spotify
WHERE album_name IS NOT NULL;
```
3. Get the total number of comments for tracks where `licensed = TRUE`.
```sql
SELECT 
    SUM(comments) AS total_comments
FROM spotify
WHERE licensed = TRUE;
```
4. Find all tracks that belong to the album type `single`.
 ```sql
SELECT 
    track_name,
    artist_name,
    album_name
FROM spotify
WHERE album_type = 'single';
```
5. Count the total number of tracks by each artist.
```sql
SELECT 
    artist_name,
    COUNT(track_name) AS total_tracks
FROM spotify
GROUP BY artist_name
ORDER BY total_tracks DESC;
```
### Medium Level
6. Calculate the average danceability of tracks in each album.
```sql
SELECT
    album_name,
    AVG(danceability) AS avg_danceability
FROM spotify
WHERE album_name IS NOT NULL
GROUP BY album_name
ORDER BY avg_danceability DESC;
```
7. Find the top 5 tracks with the highest energy values.
```sql
SELECT
    track_name,
    artist_name,
    energy
FROM spotify
ORDER BY energy DESC
LIMIT 5;
```
8. List all tracks along with their views and likes where official_video = TRUE.
```sql
SELECT
    track_name,
    views,
    likes
FROM spotify
WHERE official_video = TRUE;
```
9. For each album, calculate the total views of all associated tracks.
```sql
SELECT
    album_name,
    SUM(views) AS total_views
FROM spotify
WHERE album_name IS NOT NULL
GROUP BY album_name
ORDER BY total_views DESC;
```
10. Retrieve the track names that have been streamed on Spotify more than YouTube.
```sql
SELECT
    track_name
FROM spotify
WHERE streams IS NOT NULL
  AND views IS NOT NULL
  AND streams > views;
```
### Advanced Level
11. Find the top 3 most-viewed tracks for each artist using window functions.
```sql
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
```
12. Write a query to find tracks where the liveness score is above the average.
```sql
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
```
13. Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.
```sql
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
```
14. Find tracks where the energy-to-liveness ratio is greater than 1.2.
```sql
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
```
15. Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.
```sql
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
```
## Query Optimization Technique 
To enhance query performance, we followed a structured optimization process as outlined below:

- **Initial Query Performance Analysis Using `EXPLAIN`**
    - We first evaluated the query execution plan using the `EXPLAIN` command.
    - The query was designed to retrieve track records based on the `artist` column.
    - The observed performance metrics before optimization were:
         - Execution Time (E.T.): **7 ms**
         - Planning Time (P.T.): **0.17 ms**
    - The screenshot below illustrates the EXPLAIN output prior to applying any optimization techniques
      ![EXPLAIN Before Index](https://github.com/bk9991342-cmyk/Spotify_Advanced_SQL_Project_and_Query_Optimization/blob/main/spotify_explain_before_index.png)

- **Index Creation on the `artist` Column**
    - To improve query execution efficiency, an index was created on the `artist` column. This indexing strategy enables faster row lookups when filtering records based on the artist attribute, reducing full table scans.
    - **SQL command** used to create the index:
    ```sql
    CREATE INDEX idx_artist ON spotify_tracks(artist);
    ```

- **Performance Analysis After Index Creation**
    - After creating the index, we ran the same query again and observed significant improvements in performance:
        - Execution time (E.T.): **0.153 ms**
        - Planning time (P.T.): **0.152 ms**
    - Below is the **screenshot** of the `EXPLAIN` result after index creation:
       ![EXPLAIN After Index](https://github.com/bk9991342-cmyk/Spotify_Advanced_SQL_Project_and_Query_Optimization/blob/main/Spotify_explain_after_index.png)

- **Graphical Performance Comparison**
    - A graph illustrating the comparison between the initial query execution time and the optimized query execution time after index creation.
    - **Graph view** shows the significant drop in both execution and planning times:
      ![Performance Graph](https://github.com/bk9991342-cmyk/Spotify_Advanced_SQL_Project_and_Query_Optimization/blob/main/spotify_graphical%20view%201.png)
      ![Performance Graph](https://github.com/bk9991342-cmyk/Spotify_Advanced_SQL_Project_and_Query_Optimization/blob/main/spotify_graphical%20view%202.png)
      ![Performance Graph](https://github.com/bk9991342-cmyk/Spotify_Advanced_SQL_Project_and_Query_Optimization/blob/main/spotify_graphical%20view%203.png)

## Technology Stack
- **Database**: mySQL
- **SQL Queries**: DDL, DML, Aggregations, Joins, Subqueries, Window Functions

## Conclusion
In this project, I analyzed a Spotify dataset using SQL. I cleaned and structured the data, wrote complex queries, and used window functions and CTEs to find insights about songs, artists, and albums. This project helped me improve my advanced SQL skills and understand how SQL is used in real-world data analysis.
