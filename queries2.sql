/*
CREATE TABLE av_lidar_2014_work.fixpunktekategorie__lfp AS
SELECT * FROM av_mopublic.fixpunktekategorie__lfp;

ALTER TABLE av_lidar_2014_work.fixpunktekategorie__lfp
  OWNER TO stefan;
GRANT ALL ON TABLE av_lidar_2014_work.fixpunktekategorie__lfp TO stefan;
GRANT SELECT ON TABLE av_lidar_2014_work.fixpunktekategorie__lfp TO mspublic;

ALTER TABLE av_lidar_2014_work.fixpunktekategorie__lfp ADD PRIMARY KEY (ogc_fid);

CREATE INDEX idx_lidar_fixpunktekategorie__lfp_geometrie
  ON av_lidar_2014_work.fixpunktekategorie__lfp
  USING gist
  (geometrie);

ALTER TABLE av_lidar_2014_work.fixpunktekategorie__lfp ALTER COLUMN geometrie SET not null;   
CLUSTER idx_lidar_fixpunktekategorie__lfp_geometrie ON av_lidar_2014_work.fixpunktekategorie__lfp; 

ALTER TABLE av_lidar_2014_work.fixpunktekategorie__lfp ADD COLUMN h_lidar real;
ALTER TABLE av_lidar_2014_work.fixpunktekategorie__lfp ADD COLUMN diff real;
*/



UPDATE av_lidar_2014_work.fixpunktekategorie__lfp SET h_lidar = elevs.z
FROM (
 WITH patches AS (
  SELECT 
   ogc_fid AS fixpunkte_id,
   id AS lidar_id,
   pa
   FROM av_lidar_2014.lidar
   JOIN 
   (
    SELECT ogc_fid, ST_Buffer(geometrie, 0.2) as geometrie FROM av_lidar_2014_work.fixpunktekategorie__lfp
    --WHERE geometrie && ST_GeomFromText('POLYGON((607000 229000,610000 229000, 610000 231000, 607000 231000, 607000 229000))', 21781)
  --AND ST_Intersects(geometrie, ST_GeomFromText('POLYGON((607000 229000,610000 229000, 610000 231000, 607000 231000, 607000 229000))', 21781))
  --AND ST_Distance(geometrie, ST_GeomFromText('POLYGON((607000 229000,610000 229000, 610000 231000, 607000 231000, 607000 229000))', 21781)) = 0
  --AND ST_Within(geometrie, ST_GeomFromText('POLYGON((607000 229000,610000 229000, 610000 231000, 607000 231000, 607000 229000))', 21781))
    WHERE ogc_fid = 72013
   ) as a
   ON PC_Intersects(pa, geometrie)
  ),
  pa_pts AS (
   SELECT fixpunkte_id, PC_Explode(pa) AS pts FROM patches
  )
  SELECT
   fixpunkte_id,
   Avg(PC_Get(pts, 'z')) AS z
  FROM pa_pts
  JOIN av_lidar_2014_work.fixpunktekategorie__lfp
  ON ogc_fid = fixpunkte_id
  WHERE ST_Intersects(ST_Buffer(av_lidar_2014_work.fixpunktekategorie__lfp.geometrie, 0.2), pts::geometry)
  GROUP BY fixpunkte_id
 ) as elevs
 WHERE elevs.fixpunkte_id = ogc_fid


  
/*

WITH
fixpunkte AS (
  SELECT nummer, kategorie, ST_Buffer(geometrie, 0.2) as geometrie FROM av_mopublic.fixpunktekategorie__lfp
  WHERE ogc_fid = 72013
  --WHERE ST_Intersects(geometrie, ST_GeomFromText('POLYGON((607000 229000,610000 229000, 610000 231000, 607000 231000, 607000 229000))', 21781))
),
patches AS (
  SELECT pa FROM av_lidar_2014.lidar
  JOIN fixpunkte ON PC_Intersects(pa, geometrie)
),
pa_pts AS (
  SELECT PC_Explode(pa) AS pts FROM patches
),
fixpunkte_pts AS (
  SELECT pts FROM pa_pts JOIN fixpunkte
  ON ST_Intersects(geometrie, pts::geometry)
)
SELECT
  Avg(PC_Get(pts, 'z')) AS lidar_meters
FROM fixpunkte_pts;
*/




