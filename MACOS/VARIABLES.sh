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
    # /AppleScript
    # /audioControl
      # microphone.sh
    # /functions
    # /powerControl
      # lock_screen.sh
      # powerControlMenu.sh
      # reboot.sh
      # shutdown.sh
      # sleep.sh
    # /sshfs
      SSHFS_SH=$MYSCRIPTS_PATH/MACOS/sshfs/SSHFS.sh
    # /startupSource
      COUNTEXTERNALMONITORS_SH="$MYSCRIPTS_PATH/MACOS/startupSource/countExternalMonitors.sh"
      KILLAPPS_SH="$MYSCRIPTS_PATH/MACOS/startupSource/killAPPs.sh"
      STARTUP_EXTMONITOR_SH="$MYSCRIPTS_PATH/MACOS/startupSource/startup_ExternalMonitor.sh"
      STARTUP_INTMONITOR_SH="$MYSCRIPTS_PATH/MACOS/startupSource/startup_InternalMonitor.sh"

# /.config
  YABAIRC_PATH="$SYNCTHING_PATH/git_repos/.config/yabai/yabairc"
  YAI_FUNCTIONS_PATH="$SYNCTHING_PATH/git_repos/.config/yabai/yabai_functions.sh"