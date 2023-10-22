#!/bin/sh

VOLUME_MUTE="🔇"
VOLUME_LOW="🔈"
VOLUME_MID="🔉"
VOLUME_HIGH="🔊"
SOUND_LEVEL=$(pamixer --get-volume)
MUTED=$(pamixer --get-mute)

ICON=$VOLUME_MUTE
if [ "$MUTED" = "true" ]
then
    ICON="$VOLUME_MUTE"
else
    if [ "$SOUND_LEVEL" -lt 34 ]
    then
        ICON="$VOLUME_LOW"
    elif [ "$SOUND_LEVEL" -lt 67 ]
    then
        ICON="$VOLUME_MID"
    else
        ICON="$VOLUME_HIGH"
    fi
fi

echo "$ICON" "$SOUND_LEVEL" | awk '{ printf(" %s:%3s%% \n", $1, $2) }'
