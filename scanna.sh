#!/bin/bash

file_hash=$1             # file containing the hashes to check
file_md5=$2              # file containing the filenames
file_json='curl.out'     # curl output
file_200='hash-find.txt' # list of hashes on VT
apikey=`cat apikey.vt`   # Reads the VT API kei

# @todo: check input files
if [ $# -ne 2 ]; then
    echo
    echo "Usage: scanna.sh <hash file> <filename/md5 file>"
    echo 
    exit -1
elif [ ! -f "$1" ] 
then
    echo
    echo "The file $1 does not exists"
    echo 
    exit -2
elif [ ! -f "$2" ] 
then
    echo
    echo "The file $2 does not exists"
    echo 
    exit -3
fi

while read hash; do

    # calls the API, saves the return code in a variable 
    # and writes the output in a file
    code=`curl --request GET \
         --silent \
         --output ${file_json} \
         --write-out '%{response_code}' \
         --url https://www.virustotal.com/api/v3/files/${hash} \
         --header 'x-apikey: '${apikey}`

     # print the hash and the code returned by VT
     echo "$hash = $code"

     # if the file has been analyzed by VT, reads and prints the data
     if [ $code == '200' ]; then

         # reads the name associated with the hash
         grep=`cat "$file_md5" | grep "$hash"`

         # reads the filename and the analysis results from the output file
         filename=$(cat "$file_json" | jq -r '.data.attributes.meaningful_name')
         malicious=$(cat "$file_json" | jq -r '.data.attributes.last_analysis_stats.malicious')
         suspicious=$(cat "$file_json" | jq -r '.data.attributes.last_analysis_stats.suspicious')

         # print the analysis results
         echo "\t$grep"
         echo "\tfilename:  \t$filename"
         echo "\tmalicious: \t$malicious"
         echo "\tsuspicious:\t$suspicious"

         # writes the hash and the results on the output file
         echo "$hash\t$suspicious\t$malicious\t$filename" >> $file_200
     fi

done < $file_hash
