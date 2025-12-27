# Spotify_Advanced_SQL_Project_and_Query_Optimization
Advanced SQL Project
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
4. Get the total number of comments for tracks where `licensed = TRUE`.
5. Find all tracks that belong to the album type `single`.
6. Count the total number of tracks by each artist.
