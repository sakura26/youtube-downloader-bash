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

if [ -z "$2" ] 
then
  head=""
else
  head=$2-$3-
fi
curl http://www.youtube.com/get_video_info?video_id=$1 > get_video_info
title=`cat get_video_info | sed 's/%26/&/g'| tr '&' '\n' | grep title | cut -c 7- | gawk -vRS='%[0-9a-fA-F]{2}' 'RT{sub("%","0x",RT);RT=sprintf("%c",strtonum(RT))} {gsub(/\+/," ");printf "%s", $0 RT}'|sed 's/ //g'|sed 's/\///g'`
url=`cat get_video_info | sed 's/%26/&/g'| tr '&' '\n' | grep url_encoded_fmt_stream_map |gawk -vRS='%[0-9a-fA-F]{2}' 'RT{sub("%","0x",RT);RT=sprintf("%c",strtonum(RT))} {gsub(/\+/," ");printf "%s", $0 RT}'|  sed 's/url\=/\&/g' | tr '&' '\n' | grep itag%3D$video_res | gawk -vRS='%[0-9a-fA-F]{2}' 'RT{sub("%","0x",RT);RT=sprintf("%c",strtonum(RT))} {gsub(/\+/," ");printf "%s", $0 RT}'`
echo $url > url.txt  #debug
curl "$url" > "$1.mp4"
mv "$1.mp4" "$head$1-$title.mp4"