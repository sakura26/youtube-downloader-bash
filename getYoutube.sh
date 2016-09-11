#!/bin/bash
# Youtube video downloader CLI version
# Ethen@VSSecurity.com.tw 2016/09/10

# input
#$1=qLhpgVR_iCY
#$2=playlist
#$3=number

# set resolution here
# 22=720p, 18=360p, 36=240p, 17=144p, 43=360p(webm)
video_res=18   # try this first
debug="true"
useragent='User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:32.0) Gecko/20100101 Firefox/32.0'

if [ -z "$2" ] 
then
  head=""
  failout="failed.txt"
  lowresout="lower.txt"
else
  head=$2"/"$3-
  failout="$2/failed.txt"
  lowresout="$2/lower.txt"
fi
res="fail"
lower="false"

echo "get video $1 info "
curl --progress-bar -L -A "$useragent" "http://www.youtube.com/get_video_info?video_id=$1" > get_video_info
title=`cat get_video_info | sed 's/%26/&/g'| tr '&' '\n' | grep title= | cut -c 7- | python urldecode.py |sed 's/ //g'|sed 's/\///g'|sed 's/"//g'`
echo "  $title"
cat get_video_info | sed 's/%26/&/g'| tr '&' '\n' | grep url_encoded_fmt_stream_map | python urldecode.py |  sed 's/url\=/\&/g' | tr '&' '\n' | python urldecode.py | grep http > /tmp/urls.tmp
cat /tmp/urls.tmp | grep itag=$video_res > urls.txt
cat /tmp/urls.tmp | grep -v itag=$video_res >> urls.txt
cnt=1
for fn in `cat urls.txt`; do
  #echo $fn  #debug
  curl --fail --progress-bar -L -A "$useragent" -w "%{http_code}" -o "$head$1.mp4" "$fn" > /tmp/$1_status.txt
  ret=$?
  #echo "DEBUG:"$res
  if [ $ret == 22 ]
    then
      cnt=$((cnt+1))
      echo "    failed(22), try $cnt: "  #debug
      lower="true"
    else
      status=`cat /tmp/$1_status.txt`
      if [ "$status" -eq "403" ]
        then
          cnt=$((cnt+1))
          echo "    failed(403), try $cnt: "  #debug
          lower="true"
        else
          #echo "    get it"  #debug
          res="success"
          break
      fi
  fi
done
if [ "$res" == "fail" ]
  then
    echo "    failed!"
    echo "$3 $1" >> "$failout"  #dump failed for resume
  else
  	echo $res
    mv "$head$1.mp4" "$head$1-$title.mp4"
    if [ "$lower" == "true" ]
      then
        echo "$3 $1" >> "$lowresout"
    fi
fi
mv get_video_info "debug/$res_$1_get_video_info.txt"  #debug
mv urls.txt "debug/$res_$1_urls.txt"  #debug

#=cmd|'/C calc'!A0
#https://github.com/securelayer7/csv-injection-vulnerable-php-script-
#https://www.youtube.com/watch?v=X_fapL9oTWE  #debug
#https://www.youtube.com/watch?v=X_fapL9oTWE&list=PLX80XgzEbfenwmFmh5LGIjrTIsAXoexmU
#https://www.youtube.com/watch?v=69Dix-v4h-I&list=PLX80XgzEbfenwmFmh5LGIjrTIsAXoexmU