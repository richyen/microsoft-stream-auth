#!/bin/bash

mstream_home="/volume1/mstream/output"
outputdir="/volume1/mstream/final_structure"
log_file="process.log"

# Get list of channels and relevant data for channel creation
cat "${mstream_home}/channels.json" | jq '.[] | "\(.id),\(.name),\(.description),\(.created),\(.group.id),\(.group.privacyMode),\(.creator.mail)"' > ${outputdir}/channels.csv

channel_list=$( ls ${mstream_home}/channels | cut -f1 -d'.' )
for i in ${channel_list}; do
  # Make channel directory
  mkdir -p ${outputdir}/${i}

  # Generate relevant video metadata per channel
  cat "${mstream_home}/channels/${i}.json" | jq '.[] | "\(.id),\(.name),\(.description),\(.duration),\(.created),\(.privacyMode),\(.metrics.likes),\(.metrics.views),\(.creator.mail)"' > ${outputdir}/${i}/channel_metadata.csv

  # Get list of video UUIDs for channel
  video_uuids=$( cat ${mstream_home}/channels/${i}.json | jq '.[] | "\(.id)"' | sed 's/"//g' )

  for v in ${video_uuids}; do
    # Find file name and path
    N=$( find ${mstream_home} -name "${v}*" )
    if [[ -z ${N} ]]; then
      echo "ERROR: Failed to find file for ${v}" >> ${log_file}
    else
      # Create hard link to final structure
      echo "ln ${N} ${outputdir}/${i}/"
      ln ${N} ${outputdir}/${i}/
      if [[ $? -eq 0 ]]; then
        echo "LOG: Successfully linked ${v}" >> ${log_file}
      else
        echo "ERROR: Error linking ${v}" >> ${log_file}
      fi
    fi
  done
done


# Handle videos without channels
nochannel_file='FILL ME IN'
nochannel_dir=${outputdir}/no_channel
mkdir -p ${nochannel_dir}
cat /dev/null > ${nochannel_dir}/channel_metadata.csv

for i in $( cat ${nochannel_file} ); do
  # Find file name and path
  N=$( find ${mstream_home} -name "${i}*" )
  if [[ -z ${N} ]]; then
    echo "ERROR: Failed to find file for ${i}" >> ${log_file}
  else
    # Get the video info
    # Ugly hack: video info file happens to be videos.json
    infofile="$( dirname ${N} ).json"
    echo $infofile

    cat ${infofile} | jq ".[] | select(.id == \"$i\") | \"\(.id),\(.name),\(.description),\(.duration),\(.created),\(.privacyMode),\(.metrics.likes),\(.metrics.views),\(.creator.mail)\"" | tee -a ${nochannel_dir}/channel_metadata.csv

    # Create hard link to final structure
    echo "ln ${N} ${nochannel_dir}/"
    ln ${N} ${nochannel_dir}/
    if [[ $? -eq 0 ]]; then
      echo "LOG: Successfully linked ${i}" >> ${log_file}
    else
      echo "ERROR: Error linking ${i}" >> ${log_file}
    fi
  fi
done
