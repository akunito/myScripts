#!/bin/bash

# Enable or disable logging
LOGGING_ENABLED=true

# Function for logging messages
log_message() {
  local message="$1"
  if [ "$LOGGING_ENABLED" == true ]; then
    echo "$message" >> ~/yabai_result
  fi
}

check_attribute() {
  local app_name="$1"
  local attribute="$2"

  local attribute_is=$(yabai -m query --windows | jq ".[] | select(.app == \"$app_name\") | .[\"$attribute\"]")
  echo "$attribute_is"
}

get_id() {
  local app_name="$1"
  echo "$(yabai -m query --windows | jq ".[] | select(.app == \"$app_name\").id")"
}

make_float_and_sticky() {
  local app_name="$1"
  local app_id="$2"

  if [ $(check_attribute "$app_name" "is-floating") == "false" ]; then
    yabai -m window $app_id --toggle float
  fi 
  if [ $(check_attribute "$app_name" "is-sticky") == "false" ]; then
    yabai -m window $app_id --toggle sticky
  fi 

  log_message "end of make_float"
}

set_floating_windows() {
  # Make the window sticky
  # and config the grid
  local app_name="$1"
  local grid="$2"
  local app_id=$(get_id "$app_name")

  log_message "set_floating_windows"
  log_message "app_name: $app_name"
  log_message "grid: $grid"

  # make the app float and sticky
  make_float_and_sticky "$app_name" "$app_id"

  # set grid
  yabai -m window $app_id --grid "$grid"
}

set_windows_externalMonitors() {
  set_floating_windows "kitty" "20:20:9:3:6:15"
}

# First message to clean the file
if [ "$LOGGING_ENABLED" == true ]; then
  echo "===================== $1 $2" > ~/yabai_result
fi

log_message() {
  local message="$1"
  if [ "$LOGGING_ENABLED" == true ]; then
    echo "$message" >> ~/yabai_result
  fi
}

set_windows_externalMonitors

# app_name="kitty"
# app_id=$(get_id "$app_name")

# if [ $(check_attribute "kitty" "is-floating") == "false" ]; then
#   yabai -m window $app_id --toggle float
# fi 
# if [ $(check_attribute "kitty" "is-sticky") == "false" ]; then
#   yabai -m window $app_id --toggle sticky
# fi 
# if [ $(check_attribute "kitty" "is-minimized") == "false" ]; then
#   yabai -m window $app_id --toggle minimize
# fi 

