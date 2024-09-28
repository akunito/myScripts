#!/bin/bash
# =======================================================================================
# ============================================================ startup script for MacOS
# =======================================================================================

# include VARIABLES.sh
SELF_PATH=$(dirname "$(readlink -f "$(which "$0")")")
source $SELF_PATH/VARIABLES.sh

# ============================================================ Helper Functions
prompt_user() {
    local prompt_message="$1"
    osascript -e "display dialog \"$prompt_message\" buttons {\"Yes\", \"No\"} default button 1"
}

output_message() {
    local message="$1"
    echo "============== $message ================"
}

source_variables() {
    echo "base path:                       $BASE_PATH"
    echo "killAPPs path:                   $KILLAPPS_SH"
    echo "countExternalMonitors path:      $COUNTEXTERNALMONITORS_SH"
    echo "startup_InternalMonitor path:    $STARTUP_INTMONITOR_SH"
    echo "startup_ExternalMonitor path:    $STARTUP_EXTMONITOR_SH"
}

handle_services() {
    launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist
    sleep 0.5

    for service in yabai skhd; do
        if pgrep -x "$service" > /dev/null; then
            echo "$service is running"
            "$service" --restart-service
        else
            echo "$service is not running"
            "$service" --start-service
        fi
        sleep 0.5
    done
    sleep 2
}

# Main script execution
source_variables

output_message "0. UPGRADE SYSTEM?"
resultQuit=$(prompt_user "0. UPGRADE SYSTEM?")

if [ "$resultQuit" == "button returned:Yes" ]; then
    echo "The user selected Yes."
    bash $MENU_SH "update_system"
else
    echo "The user selected No."
fi

output_message "1. SSHFS"
resultQuit=$(prompt_user "1. Mount SSHFS?")

if [ "$resultQuit" == "button returned:Yes" ]; then
    echo "The user selected Yes."
    bash $MENU_SH "mount_all"
else
    echo "The user selected No."
fi

output_message "2. SERVICES"
handle_services

output_message "3. QUIT APPS?"
resultQuit=$(prompt_user "3. Quit all the apps?")

if [ "$resultQuit" == "button returned:Yes" ]; then
    echo "The user selected Yes."
    bash $KILLAPPS_SH
else
    echo "The user selected No."
fi

output_message "Count External Monitors"
externalMonitorCount=$(bash $COUNTEXTERNALMONITORS_SH)
echo "$externalMonitorCount External Monitors Connected"

output_message "4. START PROGRAMS?"
result=$(osascript -e "display dialog \"4. $externalMonitorCount. Start programs?\" buttons {\"Yes\", \"No\", \"Restart Script\"} default button 2")

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
        bash "$STARTUP_SH"
        exit 0
        ;;
esac

output_message "5. STARTUP"

externalMonitorCount=$(echo "$externalMonitorCount" | tr -dc '[:digit:]')

if [ "$startupSwitch" = "1" ]; then
    if [ "$externalMonitorCount" -eq 0 ]; then
        bash "$STARTUP_INTMONITOR_SH"
    elif [ "$externalMonitorCount" -gt 0 ]; then
        bash "$STARTUP_EXTMONITOR_SH"
    else
        echo "script countExternalMonitors_.sh has failed?"
    fi
fi

