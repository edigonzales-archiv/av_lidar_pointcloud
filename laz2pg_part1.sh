#!/bin/bash

BASEPATH=/home/stefan/Downloads/laz/

for FILE in ${BASEPATH}*.laz
do
  BASENAME=$(basename $FILE .laz)
  echo "Processing: $FILE"
  
  laszip.exe -i $FILE -o ${BASEPATH}/${BASENAME}.las 
  sed s/MY_LAZ_FILE/${BASENAME}.las/g laz2pg_part1_template.xml > laz2pg_part1.xml
  pdal pipeline laz2pg_part1.xml
  rm laz2pg_part1.xml
  rm ${BASEPATH}/${BASENAME}.las

done
