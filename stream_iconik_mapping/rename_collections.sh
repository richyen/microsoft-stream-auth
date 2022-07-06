#!/bin/bash

# This script will rename collection titles to their proper collection name
# This script is necessasry because in the MS Stream export, channels were exported by UUID, not by title
# This script will use the channel-to-uuid mapping and rename the collection to match the channel name

for c in `cat collections.txt`; do

  IFS=',' read -r -a array <<< "$c"
  collection_id=${array[0]}
  new_title=`echo ${array[1]} | sed "s/____/ /g"`

  echo "Going to rename ${collection_id} to ${new_title}"
  curl -sX PUT "https://app.iconik.io/API/assets/v1/collections/${collection_id}/" -H "accept: application/json" -H "App-ID: ${ICONIK_APP_ID}" -H "Auth-Token: ${ICONIK_APP_TOKEN}" -H "Content-Type: application/json" -d "{ \"title\": \"${new_title}\"}"
done
