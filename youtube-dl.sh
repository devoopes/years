#!/bin/bash

year=2020
playlist="https://www.youtube.com/playlist?list=PLEVVO3zRKfv_XK06fOi41FQVATxgOHs6o"
source_directory="2020Lockout"
dest_directory=$year
sourcefile="evernote-list.txt"
destfile="final-list.txt"
# Paylists
# 2019: https://www.youtube.com/playlist?list=PLhEVvej0BBEI3YMccR3_CLDiBSNvGFv5I
# 2002: https://www.youtube.com/playlist?list=PLEVVO3zRKfv_XK06fOi41FQVATxgOHs6o

# Sanitize Data Input
echo -n "Before starting, copy list from Evernote to evernote-list.txt"
pause

echo -n "Removing all lines that start with #'s"
# Remove all lines that start with #
sed '/^#.*\n/d' $sourcefile > $destfile
# Replace all " - " with ","'s'
sed ' - /d' $destfile > "music/$year.csv"
# Remove all Quotation Marks
while read input; do
  sed 's/\"//g' "$input"
  sed "s/\'//g" "$input"
done <"music/$year.csv"

# Youtube Download
echo -n "Upgrade youtube-dl? (y/n)? "
read answer
if [ "$answer" != "${answer#[Yy]}" ] ;then
    brew update

    brew install youtube-dl
    brew install ffmpeg

    brew upgrade youtube-dl
    brew upgrade ffmpegelse
else
  printf "Skipping Homebrew Update"
fi

wait 2
youtube-dl -i  -c --download-archive downloaded.txt \
  --extract-audio \
  --audio-format mp3 \
  --audio-quality 0 \
  --default-search "ytsearch" \
  -o '%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s' \
  --no-overwrites \
  --yes-playlist $playlist
  #--output "2020/%(title)s.%(ext)s" \

# Check Directory Counts Match
echo -n "Check directory count vs count in final-list.txt"
finallist=$(wc -l final-list.txt)
dirlist=$(ls -l $year |wc -l)
echo -n "Final list count="$finallist
echo -n "Directory list count="$dirlist
if (( $finallist = $dirlist ))
then
  echo -n "The counts match."
  diff $finallist $dirlist
else
  echo -n "The counts do not match."
  diff $finallist $dirlist
  exit 1
fi

# Rename files
for file in ./$source_directory/*.mp3;do
   read line
   cp -v "${file}" "$dest_directory/${line}.mp3" >> rename.log
done < $destfile.txt

# Cleanup
echo -n "Move folder to Dropbox? (y/n)? "
read answer
if [ "$answer" != "${answer#[Yy]}" ] ;then
  mv $year ~/Dropbox/music/
else
  printf "Skipping"
fi

wait 2
echo -n "Cleanup? (y/n)? "
read answer
if [ "$answer" != "${answer#[Yy]}" ] ;then
  rm -y downloaded.txt
  rm -y final-list.txt
  rm -y ./*.zip
else
  printf "Skipping"
fi
