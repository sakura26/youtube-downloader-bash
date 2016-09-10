#!/bin/bash
# Youtube video downloader CLI version
# Ethen@VSSecurity.com.tw 2016/09/10

# input
#$1=qLhpgVR_iCY
#$2=playlist
#$3=number

# set resolution here
# 22=720p, 18=360p, 36=240p, 17=144p, 43=360p(webm)
video_res=18
useragent='User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:32.0) Gecko/20100101 Firefox/32.0'

if [ -z "$2" ] 
then
  head=""
else
  head=$2"/"$3-
fi
curl -L -A "$useragent" "http://www.youtube.com/get_video_info?video_id=$1" > get_video_info
title=`cat get_video_info | sed 's/%26/&/g'| tr '&' '\n' | grep title= | cut -c 7- | python urldecode.py |sed 's/ //g'|sed 's/\///g'`
cat get_video_info | sed 's/%26/&/g'| tr '&' '\n' | grep url_encoded_fmt_stream_map | python urldecode.py |  sed 's/url\=/\&/g' | tr '&' '\n' | python urldecode.py | grep http > /tmp/urls.tmp
cat /tmp/urls.tmp | grep itag=$video_res > urls.txt
cat /tmp/urls.tmp | grep -v itag=$video_res >> urls.txt
#url=`cat get_video_info | sed 's/%26/&/g'| tr '&' '\n' | grep url_encoded_fmt_stream_map | python urldecode.py |  sed 's/url\=/\&/g' | tr '&' '\n' | grep itag%3D$video_res | python urldecode.py`
#echo $url > url.txt  #debug
for fn in `cat urls.txt`; do
  echo $fn  #debug
  status=`curl -L -A "$useragent" -w "%{http_code}" -o "$head$1.mp4" "$fn"`
  #status="404"
  #echo $status  #debug
  if [ $status -eq "403" ]
    then
    echo "403-try next"
    else
    echo "get"
    break
  fi
done
mv "$head$1.mp4" "$head$1-$title.mp4"