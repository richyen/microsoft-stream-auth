#!/bin/bash

# This script gets all assets belonging to a collection and stores those assets' info in JSON format

for c in `cat collections.txt`; do

  IFS=',' read -r -a array <<< "$c"
  collection_id=${array[0]}

  echo "Getting info for ${collection_id}"
  curl -sX GET "https://app.iconik.io/API/assets/v1/collections/${collection_id}/contents/?object_types=assets&per_page=500" -H "accept: application/json" -H "App-ID: ${ICONIK_APP_ID}" -H "Auth-Token: ${ICONIK_AUTH_TOKEN}" >> collections_info/${collection_id}.json
done
