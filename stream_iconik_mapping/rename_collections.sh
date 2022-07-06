#!/bin/bash

# This script will rename collection titles to their proper collection name
# This script is necessary because in the MS Stream export, channels were exported by UUID, not by title
# This script will use the channel-to-uuid mapping and rename the collection to match the channel name

# collections.csv was created externally, and has the format:
# Column 1 -- MS Stream Channel UUID
# Column 2 -- Iconik Collection UUID
# Column 3 -- MS Stream Channel Title
# Note the title had spaces replaced with "____" to work around bash's default IFS/delimiter, which is a space

for c in `cat collections.csv`; do

  IFS=',' read -r -a array <<< "$c"
  ms_stream_id=${array[0]}
  collection_id=${array[1]}
  new_title=`echo ${array[2]} | sed "s/____/ /g"`

  echo "Going to rename ${collection_id} to ${new_title}"
  curl -sX PUT "https://app.iconik.io/API/assets/v1/collections/${collection_id}/" -H "accept: application/json" -H "App-ID: ${ICONIK_APP_ID}" -H "Auth-Token: ${ICONIK_APP_TOKEN}" -H "Content-Type: application/json" -d "{ \"title\": \"${new_title}\"}"
done
