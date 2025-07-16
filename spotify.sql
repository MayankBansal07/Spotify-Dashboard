Create database spotify;
use spotify;
ALTER TABLE spotify_data
RENAME COLUMN ï»¿Track TO Track;

-- Top 15 tracks by Spotify streams
CREATE TABLE top_tracks_by_streams AS
SELECT 
    `Track`,
    SUM(`Spotify Streams`) AS total_streams
FROM spotify_data
GROUP BY `Track`
ORDER BY total_streams DESC
LIMIT 15;

-- Number of tracks released by month/year (for heatmap or bar)
CREATE TABLE monthly_release_counts AS
SELECT 
    YEAR(STR_TO_DATE(`Release Date`, '%m/%d/%Y')) AS release_year,
    MONTH(STR_TO_DATE(`Release Date`, '%m/%d/%Y')) AS release_month,
    COUNT(*) AS total_releases
FROM spotify_data
WHERE STR_TO_DATE(`Release Date`, '%m/%d/%Y') IS NOT NULL
GROUP BY release_year, release_month
ORDER BY release_year, release_month;

-- Tracks grouped by explicit content flag (0/1)
CREATE TABLE explicit_content_split AS
SELECT 
    `Explicit Track` AS is_explicit,
    COUNT(*) AS track_count
FROM spotify_data
GROUP BY `Explicit Track`;

-- Global metrics for Power BI KPI cards
CREATE table v_kpis_summary AS
SELECT
    COUNT(DISTINCT `Track`) AS total_tracks,
    COUNT(DISTINCT `Artist`) AS unique_artists,
    SUM(`Spotify Streams`) AS total_spotify_streams,
    SUM(`YouTube Views`) AS total_youtube_views,
    SUM(`TikTok Views`) AS total_tiktok_views,
    AVG(`Spotify Streams`) AS avg_spotify_streams,
    MAX(`Spotify Streams`) AS top_track_streams
FROM spotify_data;

-- Total streams/views grouped by platform columns
CREATE VIEW v_streams_by_platform AS
SELECT
    'Spotify' AS platform, SUM(`Spotify Streams`) AS total_streams FROM spotify_data
UNION ALL
SELECT 'YouTube', SUM(`YouTube Views`) FROM spotify_data
UNION ALL
SELECT 'TikTok', SUM(`TikTok Views`) FROM spotify_data
UNION ALL
SELECT 'Soundcloud', SUM(`Soundcloud Streams`) FROM spotify_data
UNION ALL
SELECT 'Pandora', SUM(`Pandora Streams`) FROM spotify_data;

-- Top 10 artists by total Spotify streams
CREATE VIEW v_top_artists_by_streams AS
SELECT 
    `Artist`,
    SUM(`Spotify Streams`) AS total_streams
FROM spotify_data
GROUP BY `Artist`
ORDER BY total_streams DESC
LIMIT 10;

-- Streams by release year (for trend line)
CREATE VIEW v_streams_by_year AS
SELECT 
    YEAR(STR_TO_DATE(`Release Date`, '%Y-%m-%d')) AS release_year,
    SUM(`Spotify Streams`) AS total_streams
FROM spotify_data
GROUP BY release_year
ORDER BY release_year;


