#!/bin/bash
# Youtube playlist downloader CLI Version
# Ethen@VSSecurity.com.tw 2016/09/10

# input
#$1=PLX80XgzEbfekiH5r_kAGfsEq6enwol_Km
useragent='User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:32.0) Gecko/20100101 Firefox/32.0'

echo "get playlist..."
curl --progress-bar -L -A "$useragent" "https://www.youtube.com/playlist?list=$1" > list.html
title=`cat list.html | grep '<title>' | cut -d'>' -f 2 | sed 's/ //g'|sed 's/\///g'`
cat list.html | grep pl-video-title-link | sed 's/v=/*/g' | cut -d'*' -f 2 | cut -d'&' -f 1 > list.txt
echo "folder: $1-$title"
mkdir "$1"
cnt=1
echo "generate playlist.html..."
echo "<html><body><h1>playlist($1) $title</h1>" > "$1/playlist.html"
for fn in `cat list.txt`; do
    echo "<a href='https://www.youtube.com/watch?v=$fn'>$cnt - $fn</a><br>" >> "$1/playlist.html"
    cnt=$((cnt+1))
done
cnt=1
echo "</body></html>" >> "$1/playlist.html"
echo "=downloading videos="
for fn in `cat list.txt`; do
    bash getYoutube.sh $fn "$1" `printf "%03d\n" $cnt`
    cnt=$((cnt+1))
done
mv list.txt "$1"
mv "$1" "$1-$title"
echo "=playlist done="