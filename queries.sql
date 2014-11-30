
SELECT Sum(PC_NumPoints(pa))
FROM av_lidar_2014.lidar;


WITH pts AS (
  SELECT PC_Explode(pa) AS pt
  FROM av_lidar_2014.lidar LIMIT 1
)
SELECT Avg(PC_Get(pt,'Z')) FROM pts;

WITH pts AS (
  SELECT PC_Explode(pa) AS pt
  FROM av_lidar_2014.lidar LIMIT 1
)
SELECT PC_AsText(pt) FROM pts LIMIT 1;

SELECT Count(*)
FROM av_lidar_2014.lidar;


SELECT
  Min(PC_PatchMin(pa, 'z')) AS min,
  Max(PC_PatchMax(pa, 'z')) AS max
FROM av_lidar_2014.lidar;


SELECT st_asewkt(pa::geometry) FROM av_lidar_2014.lidar LIMIT 1;


WITH pts AS (
  SELECT PC_Explode(pa) AS pt
  FROM av_lidar_2014.lidar LIMIT 1
)
SELECT ST_AsEWKT(pt::geometry) FROM pts LIMIT 1;


CREATE VIEW av_lidar_2014.v_lidar_patches AS
SELECT
  pa::geometry(Polygon, 21781) AS geom,
  PC_PatchAvg(pa, 'Z') AS elevation,
  id
FROM av_lidar_2014.lidar;



