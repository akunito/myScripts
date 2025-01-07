#!/bin/bash

# Ensure dialog is installed
if ! command -v dialog &>/dev/null; then
    echo "The 'dialog' utility is not installed. Please install it and run this script again."
    exit 1
fi

SELF_PATH=$(dirname "$(readlink -f "$(which "$0")")")
source $SELF_PATH/menu_functions.sh

get_hash() {
    local hash_type="$1"
    
    case $hash_type in
        "bcrypt")
            echo -e "\n======================== getting hash by bcrypt =========================="
            python3 -m venv $SELF_PATH/functions/bcrypt_py_env/myenv
            source $SELF_PATH/functions/bcrypt_py_env/myenv/bin/activate
            python3 $SELF_PATH/functions/bcrypt_py_env/gen-pass.py
            deactivate
            ;;
        "openssl")
            echo -e "\n======================== getting hash by openssl =========================="
            $SELF_PATH/functions/hash_password_generator.sh
            ;;
    esac
}

get_hash_menu() {
    local choice

    while true; do
        choice=$(dialog --clear --backtitle "Get Pass Hash" --title "Pass Hash Menu" \
                        --menu "Choose an option" 15 50 3 \
                        1 "by bcrypt" \
                        2 "by openssl" \
                        Q "Quit/Back" \
                        3>&1 1>&2 2>&3)

        case $choice in
            1)
                get_hash "bcrypt"
                wait_for_user_input
                ;;
            2)
                get_hash "openssl"
                ;;
            Q|q)
                break
                ;;
            *)
                show_dialog_message msgbox "Invalid option"
                ;;
        esac
    done
}

get_hash_menu