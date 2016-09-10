#!/bin/bash
# Youtube playlist downloader CLI Version
# Ethen@VSSecurity.com.tw 2016/09/10

# input
#$1=PLX80XgzEbfekiH5r_kAGfsEq6enwol_Km

curl "https://www.youtube.com/playlist?list=$1" > list.html
title=`cat list.html | grep '<title>' | cut -d'>' -f 2 | sed 's/ //g'|sed 's/\///g'`
cat list.html | grep pl-video-title-link | sed 's/v=/*/g' | cut -d'*' -f 2 | cut -d'&' -f 1 > list.txt
cnt=1
for fn in `cat list.txt`; do
    bash getYoutube.sh $fn "$1-$title" $cnt
    cnt=$((cnt+1))
done
