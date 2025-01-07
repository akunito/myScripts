#!/bin/bash

SELF_PATH=$(dirname "$(readlink -f "$(which "$0")")")
source $SELF_PATH/../menu_functions.sh

# ask user for password
ask_for_password() {
    local password
    local password_confirm

    while true; do
        password=$(dialog --clear --backtitle "Password Generator" --title "Password Generator" \
                        --insecure --passwordbox "Enter your password" 10 50 3>&1 1>&2 2>&3)
        password_confirm=$(dialog --clear --backtitle "Password Generator" --title "Password Generator" \
                        --insecure --passwordbox "Confirm your password" 10 50 3>&1 1>&2 2>&3)

        if [ "$password" == "$password_confirm" ]; then
            echo "$password"
            break
        else
            show_dialog_message msgbox "Passwords do not match. Please try again."
        fi
    done
}

# generate a hash from a given password
hash_password_sha256sum() {
    local password="$1"
    local hash

    hash=$(echo -n "$password" | sha256sum | awk '{print $1}')
    echo "$hash"
}
hash_password_openssl() {
    local password="$1"
    local hash

    # Use openssl with UTF-8 encoded input
    hash=$(echo -n "$password" | LC_CTYPE=UTF-8 openssl enc -base64 | openssl dgst -sha256 | awk '{print $2}')
    echo "$hash"
}

# ask user for password and generate a hash
hash_password_generator() {
    local password
    local hash

    password=$(ask_for_password)
    hash=$(hash_password_openssl "$password")

    echo "Password: $password"
    echo "Hash: $hash"
}

hash_password_generator

# wait for user input before leaving
wait_for_user_input