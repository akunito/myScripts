#!/bin/bash

# Get directory of VARIABLES.sh (/mySCRTIPTS/MACOS)
BASE_PATH=$(dirname "$(readlink -f "$(which "$0")")")

# ====================== Structure of mySCRIPTS
# /mySCRIPTS
#    /MACOS
#       /AppleScript
#       /audioControl
#            microphone.sh
#       /functions
#       /powerControl
#            lock_screen.sh
#            powerControlMenu.sh
#            reboot.sh
#            shutdown.sh
#            sleep.sh
#       /startupSource
#           countExternalMonitors.sh
            countExternalMonitors_path="$BASE_PATH/startupSource/countExternalMonitors.sh"
#           killAPPs.sh
            killAPPs_path="$BASE_PATH/startupSource/killAPPs.sh"
#           startup_ExternalMonitor.sh
            startup_ExternalMonitor_path="$BASE_PATH/startupSource/startup_ExternalMonitor.sh"
#           startup_InternalMonitor.sh
            startup_InternalMonitor_path="$BASE_PATH/startupSource/startup_InternalMonitor.sh"
#       menu.sh
#       startup.sh
        startup_path="$BASE_PATH/startup.sh"
#       startupRemote.sh
#       testing.sh

# Testing variables
# echo "base path:                       $BASE_PATH"
# echo "killAPPs path:                   $killAPPs_path"
# echo "countExternalMonitors path:      $countExternalMonitors_path"
# echo "startup_InternalMonitor path:    $startup_InternalMonitor_path"
# echo "startup_ExternalMonitor path:    $startup_ExternalMonitor_path"



# ===============================================================================
# ======================================================================= TESTING
# ===============================================================================
echo ""
echo "============================ TESTING ==========================="

# externalMonitorCount=$(bash $countExternalMonitors_path)
# echo "external monitor count: $externalMonitorCount"

echo ""
echo "============================ END VARIABLES.sh ==========================="
echo ""