# youtube-downloader-bash
A youtube video/playlist downloader in CLI
You can download entire playlist to mp4 files,
files will shows in folder like `<playlist_sn>-<playlist_title>/<number>-<video_sn>-<video_title>.mp4`
or you can just download a single video too.

## Requirement
Require bash/python/curl
Develop under mac, but should works well on linux.

## Usage
Video downloader usage:
`$ bash getYoutube.sh <video_sn>`
Playlist downloader usage:
`$ bash getPlaylist.sh <playlist_sn>`

## Example
`https://www.youtube.com/watch?v=ztCcJhJS8Q8&list=PLBSg1sI2PFmGdjI6x-iehbCzoXmjMCCOW&index=23`
Video:
`$ bash getYoutube.sh ztCcJhJS8Q8`
Playlist
`$ bash getPlaylist.sh PLBSg1sI2PFmGdjI6x-iehbCzoXmjMCCOW`

## Known Bug 
* zero size mp4 file
sometime we will get 403 from googlevideo.com, still don't know why
