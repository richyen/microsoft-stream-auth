#!/bin/bash

# This script takes output from get_collection_assets.sh and attempts to map Iconik Asset IDs with their MS Stream counterparts
# This script assumes that the Iconik assets have the MS Stream UUID in the filename (not title)

for i in `ls collections_info`; do
  cat collections_info/${i} | jq -r ".objects[] | [.id,.file_names[0]] | @csv" >> iconik_to_msstream_mappings.csv
done
