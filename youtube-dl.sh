#!/bin/bash

# Paylists
# 2019: https://www.youtube.com/playlist?list=PLhEVvej0BBEI3YMccR3_CLDiBSNvGFv5I
# 2002: https://www.youtube.com/playlist?list=PLEVVO3zRKfv_XK06fOi41FQVATxgOHs6o

year=2020
playlist="https://www.youtube.com/playlist?list=PLEVVO3zRKfv_XK06fOi41FQVATxgOHs6o"
source_directory="2020Lockout"
dest_directory="2020"

### Santatize Data Input ###
echo -n "Before starting, copy list from Evernote to evernote-list.txt"
pause

echo -n "Removing all lines that start with #'s"
# Remove all lines that start with #
while read input; do
  sed '/^#.*/d' "$input"
done <evernote-list.txt
cp evernote-list.txt final-list.txt

# replace all " - " with ","'s'
while read input; do
  sed '/^#.*/d' "$input"
done <final-list.txt > years/$year.csv

#TODO ##############################
# remove all quotation marks




while read input; do
  sed  's/ - /,/g' "$input"
  sed 's/\"//g' "$input"
  sed "s/\'//g" "$input"
done <input.txt

### Youtube Download ###
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

pause

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
else
  echo -n "The counts do not match."
  exit
fi

# Rename files
for file in ./$source_directory/*.mp3;do
       read line
       cp -v "${file}" "$dest_directory/${line}.mp3" >> rename.log
done < final-list.txt

echo -n "Move folder to Dropbox? (y/n)? "
read answer
if [ "$answer" != "${answer#[Yy]}" ] ;then
  mv $year ~/Dropbox/music
else
  printf "Skipping"
fi

echo -n "Cleanup? (y/n)? "
read answer
if [ "$answer" != "${answer#[Yy]}" ] ;then
  rm -y downloaded.txt
  rm -y final-list.txt
  rm -y ./*.zip
  rm -rf ./$year*
else
  printf "Skipping"
fi
