#!/bin/sh

# Requires cmus, cmusfm and ffmpeg

INFO=$(cmus-remote -Q 2> /dev/null)
ARTIST=$(printf "$INFO" | awk -F " " '/tag artist/{print substr($0, index($0, $3))}')
TITLE=$(printf "$INFO" | awk -F " " '/tag title/{print substr($0, index($0, $3))}')
POSITION=$(printf "$INFO" | grep position | cut -d " " -f 2)
ALBUM=$(printf "$INFO" | awk '/album/{print substr($0, index($0, $3))}' | head -1)
FILE=$(cmus-remote -Q | awk '/file/{print substr($0, index($0, $2))}')
COVER="/tmp/$ALBUM.png"

if [ "$STATUS" = "paused" ] || [ "$STATUS" = "stopped" ]
then
    echo
else
    if [ "$POSITION" -le 5 ]
    then
	if [ -f "$COVER" ]
	then
	    notify-send -u low -i "$COVER" "Now playing" "$ARTIST - $TITLE\n$ALBUM"
	    cmusfm "$@"
	else
	    if `ffmpeg -nostats -loglevel 0 -y -i "$FILE" "$COVER"`
	    then
		notify-send -u low -i "$COVER" "Now playing" "$ARTIST - $TITLE\n$ALBUM"
		cmusfm "$@"
	    else
		notify-send -u low "Now playing" "$ARTIST - $TITLE\n$ALBUM"
		cmusfm "$@"
	    fi
	fi
    fi
fi
