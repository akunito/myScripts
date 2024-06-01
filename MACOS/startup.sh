#!/bin/bash
# =======================================================================================
# ============================================================ startup script for MacOS
# =======================================================================================

# include VARIABLES.sh
SELF_PATH=$(dirname "$(readlink -f "$(which "$0")")")
source $SELF_PATH/VARIABLES.sh

echo "base path:                       $BASE_PATH"
echo "killAPPs path:                   $killAPPs_path"
echo "countExternalMonitors path:      $countExternalMonitors_path"
echo "startup_InternalMonitor path:    $startup_InternalMonitor_path"
echo "startup_ExternalMonitor path:    $startup_ExternalMonitor_path"


# =======================================================================================
# ============================================================ start services
sleep 0.5
# start yabai, if started, restart.
if pgrep -x "yabai" > /dev/null
then
    echo "yabai is running"
    # restart yabai
    yabai --restart-service
else
    echo "yabai is not running"
    # start yabai
    yabai --start-serviceDoc
fi

sleep 0.5

# start skhd, if started, restart. | used to switch spaces on scripts
if pgrep -x "skhd" > /dev/null
then
    echo "skhd is running"
    # restart yabai
    skhd --restart-service
else
    echo "skhd is not running"
    # start yabai
    skhd --start-service
fi

sleep 2

# =======================================================================================
# ============================================================ Quit apps
# Ask user by osascript if they want to quit the apps
resultQuit=$(osascript -e "display dialog \"Quit all the apps?\" buttons {\"Yes\", \"No\"} default button 1")

if [ "$resultQuit" == "button returned:Yes" ]; then
    echo "The user selected Yes."
    bash $killAPPs_path
else
    echo "The user selected No."
fi


# =======================================================================================
# ============================================================ Count External Monitors
# Store result of $countExternalMonitors_path
externalMonitorCount=$(bash $countExternalMonitors_path)
echo "$externalMonitorCount External Monitors Connected"


# =======================================================================================
# ============================================================ Ask to User
# Use AppleScript to ask user
result=$(osascript -e "display dialog \"$externalMonitorCount. Start programs?\" buttons {\"Yes\", \"No\", \"Restart Script\"} default button 2")

echo "result: $result"

# Check the result and set the variable
case $result in
    "button returned:Yes")
        echo "The user selected Yes."
        startupSwitch=1
        ;;
    "button returned:No")
        echo "The user selected No."
        startupSwitch=0
        ;;
    *)
        echo "The user selected Restart Script."
        startupSwitch=0
        bash "($script_path/startup.sh)"
        break
        ;;
esac


# =======================================================================================
# ============================================================ Startup logic
# Cast $externalMonitorCount to int
externalMonitorCount=$(echo "$externalMonitorCount" | tr -dc '[:digit:]')

# if $startup is true, check second condition in a case
if [ "$startupSwitch" = "1" ]; then
    if [ "$externalMonitorCount" -eq 0 ]; then
        bash "$startup_InternalMonitor_path"
    else
        if [ "$externalMonitorCount" -gt 0 ]; then
            bash "$startup_ExternalMonitor_path"
        else
            echo "script countExternalMonitors_.sh has failed?"
        fi
    fi
fi

