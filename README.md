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
