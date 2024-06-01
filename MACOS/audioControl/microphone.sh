#!/bin/bash

# Get the current input volume
CURRENT_VOLUME=$(osascript -e "input volume of (get volume settings)")

TITLE="Microphone"
MUTEDMESSAGE="is MUTED"
UNMUTEDMESSAGE="is ON"
VOLUME_ON="80"
VOLUME_OFF="0"

# Show a notification using the MacOS notification center
notifyctl="import com.apple.notificationcenter.osx"
eval "$notifyctl" -message "Microphone Volume: $CURRENT_VOLUME" -title "Microphone" -sound name "Submarine" -timeout 5

if [ $CURRENT_VOLUME -eq 0 ]; then
    # If the current volume is 0 (microphone is muted), unmute the microphone
    osascript -e "set volume input volume \"$VOLUME_ON\""
    osascript -e "display notification \"$UNMUTEDMESSAGE\" with title \"$TITLE\""
    echo "$UNMUTEDMESSAGE"
else
    # If the current volume is not 0 (microphone is not muted), mute the microphone
    osascript -e "set volume input volume \"$VOLUME_OFF\""
    osascript -e "display notification \"$MUTEDMESSAGE\" with title \"$TITLE\""
    echo "$UNMUTEDMESSAGE"
fi

