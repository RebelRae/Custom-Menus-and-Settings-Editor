#!/usr/local/bin/bash

# ---------- Inclue ---------- #
source ROUTINES.sh

# ---------- Init ---------- #
SUBDOMAINS=("$DOMAIN www" "ftp" "api" "mail")
declare -A SETTINGS
loadSettings
assignMenu MAIN

# ---------- Application ---------- #
while read -n1 -s -r KEY
do
    if [[ $KEY == q ]]
    then
        break
    fi
    case $KEY in
        c) assignMenu CREDITS ;;
        m) assignMenu MAIN ;;
        h) assignMenu HELP ;;
        d)
            DATE=`date`
            DATE_MENU=("DYNAMIC DATE" "This is how you make a menu dynamically" "" "The current time is" "$DATE" "" "[M]ain menu")
            assignMenu DATE_MENU
        ;;
        s)
            assignMenu SETTINGS_WIZARD
            loadSettings
            read -s
            for key in "${!SETTINGS[@]}"
            do
                SETTINGS_WIZARD=("SETTINGS WIZARD"
                    "Enter new values below"
                    "Press return key to accept current value" ""
                    "${key}: ${SETTINGS[$key]}"
                )
                assignMenu SETTINGS_WIZARD
                SETTINGS[$key]="${SETTINGS[$key]}"
                while read -r REPLY
                do
                    if (( ${#REPLY} > 0 ))
                    then
                        SETTINGS[$key]=$REPLY
                    fi
                    break
                done
            done
            saveSettings
            SETTINGS_WIZARD=("SETTINGS WIZARD" "All done!" "Press any key to continue")
            assignMenu SETTINGS_WIZARD
            SETTINGS_WIZARD=("SETTINGS WIZARD" "Let's edit your settings" "" "Press any key to continue")
            read -s
            assignMenu MAIN
        ;;
        *) ;;
    esac
done
clear