#!/bin/bash

file_hash=$1            # file containing the hashes to check
file_md5=$s             # file containing the filenames
file_json='curl.out'    # curl output
file_200='hash.200'     # list of hashes on VT

# @todo: check input files

while read hash; do

    # calls the API and saves the return code in a variable
    code=`curl --request GET \
         --silent \
         --output ${file_json} \
         --write-out '%{response_code}' \
         --url https://www.virustotal.com/api/v3/files/${hash} \
         --header 'x-apikey: 74d6672d4a83cc3fa3877f2f582e0c9508a38e3886529f6bdf6c0264760736cb'`

     # print the hash and the code returned by VT
     echo "$hash = $code"

     # if the file has been analyzed by VT, reads and prints the data
     if [ $code == '200' ]; then

         # reads the name associated with the hash
         cat "$file_md5" | grep "$hash"

         # reads the filename and the analysis results
         filename=$(cat "$file_json" | jq -r '.data.attributes.meaningful_name')
         malicious=$(cat "$file_json" | jq -r '.data.attributes.last_analysis_stats.malicious')
         suspicious=$(cat "$file_json" | jq -r '.data.attributes.last_analysis_stats.suspicious')

         # print the analysis results
         echo "filename:\t$filename"
         echo "malicious:\t$malicious"
         echo "suspicious:\t$suspicious"

         # writes the hash and the results on the output file
         echo "$hash\t$suspicious\t$malicious\t$filename" >> $file_200
     fi

done < $file_hash
