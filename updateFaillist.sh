#!/bin/bash
# resolve failed downloads
# Ethen@VSSecurity.com.tw 2016/09/11

# input
#$1=<location_of_privous_download_folder>
useragent='User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:32.0) Gecko/20100101 Firefox/32.0'

echo "process faillist..."
echo "=downloading videos="
mv "$1/failed.txt" failed.txt
IFS=$'\n'
for fn in `cat failed.txt`; do
	sn=`echo $fn|cut -d' ' -f2`
	cnt=`echo $fn|cut -d' ' -f1`
	#echo $fn  #debug
    bash getYoutube.sh $sn "$1" $cnt
done
echo "=update done="