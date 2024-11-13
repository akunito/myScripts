#!/bin/bash

# Get directory of VARIABLES.sh (/mySCRTIPTS/MACOS)
# BASE_PATH=$(dirname "$(readlink -f "$(which "$0")")")

# =========================================================
# ====================== DIRECTORIES ==========================

SYNCTHING_PATH="/Users/$USER/syncthing"

MYLIBRARY_PATH=$SYNCTHING_PATH/myLibrary
OBSIDIANNOTES_PATH=$SYNCTHING_PATH/myLibrary/MyDocuments

MYSCRIPTS_PATH="$SYNCTHING_PATH/git_repos/mySCRIPTS"


# =========================================================
# ====================== SCRIPTS ==========================
# /mySCRIPTS ($MYSCRIPTS_PATH)
  NETWORK_SH=$MYSCRIPTS_PATH/NETWORK.sh
  # /MACOS
    MENU_SH="$MYSCRIPTS_PATH/MACOS/menu.sh"
    STARTUP_SH="$MYSCRIPTS_PATH/MACOS/startup.sh"
    MENU_FUNCTIONS_SH="$MYSCRIPTS_PATH/MACOS/menu_functions.sh"
    # /AppleScript
    # /audioControl
      # microphone.sh
    # /functions
      TIMEOUT_SH="$MYSCRIPTS_PATH/MACOS/functions/timeout.sh"
    # /powerControl
      # lock_screen.sh
      # powerControlMenu.sh
      # reboot.sh
      # shutdown.sh
      # sleep.sh
    # /ssh
      SSH_STARTER_SH=$MYSCRIPTS_PATH/MACOS/ssh/ssh_starter.sh
    # /sshfs
      SSHFS_SH=$MYSCRIPTS_PATH/MACOS/sshfs/SSHFS.sh
    # /startupSource
      COUNTEXTERNALMONITORS_SH="$MYSCRIPTS_PATH/MACOS/startupSource/countExternalMonitors.sh"
      KILLAPPS_SH="$MYSCRIPTS_PATH/MACOS/startupSource/killAPPs.sh"
      STARTUP_EXTMONITOR_SH="$MYSCRIPTS_PATH/MACOS/startupSource/startup_ExternalMonitor.sh"
      STARTUP_INTMONITOR_SH="$MYSCRIPTS_PATH/MACOS/startupSource/startup_InternalMonitor.sh"

# /.config
  YABAIRC_PATH="/Users/akunito/.config/yabai/yabairc"
  YABAI_FUNCTIONS_PATH="/Users/akunito/.config/yabai/yabai_functions.sh"