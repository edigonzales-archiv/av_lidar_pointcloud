
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



-> Table  -> Cluster...



CREATE TABLE av_lidar_2014.lidar_patches AS
SELECT
  pa::geometry(Polygon, 21781) AS geom,
  PC_PatchAvg(pa, 'Z') AS elev_avg,
  PC_PatchMax(pa, 'Z') AS elev_max,
  PC_PatchMin(pa, 'Z') AS elev_min,
  id
FROM av_lidar_2014.lidar;


ALTER TABLE av_lidar_2014.lidar_patches ADD PRIMARY KEY (id);

ALTER TABLE av_lidar_2014.lidar_patches OWNER TO stefan;
GRANT ALL ON av_lidar_2014.lidar_patches TO stefan;
GRANT SELECT ON av_lidar_2014.lidar_patches TO mspublic;


CREATE INDEX idx_av_lidar_2014_lidar_patches_id
  ON av_lidar_2014.lidar_patches
  USING btree
  (id);


CREATE INDEX idx_av_lidar_2014_lidar_patches_geom
  ON av_lidar_2014.lidar_patches
  USING gist
  (geom);


ALTER TABLE av_lidar_2014.lidar_patches ALTER COLUMN geom SET not null;   
CLUSTER idx_av_lidar_2014_lidar_patches_geom ON av_lidar_2014.lidar_patches; 
