#!/usr/bin/env bash
# ---------- Colors ----------#
BASE='\033[0m'
BLACK='\033[0;30m'
WHITE='\033[1;37m'
LGREY='\033[0;37m'
DGREY='\033[1;30m'
RED='\033[0;31m'
LRED='\033[1;31m'
GREEN='\033[0;32m'
LGREEN='\033[1;32m'
BROWN='\033[0;33m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
LBLUE='\033[1;34m'
PURPLE='\033[0;35m'
LPURPLE='\033[1;35m'
CYAN='\033[0;36m'
LCYAN='\033[1;36m'

# ---------- Static Variables ---------- #
DATE=`date`
DIMENSIONS=(85 1)
L_MARGIN=8
CORNER_CHAR="*"
CORNER_COLOR=$LPURPLE
TB_CHAR="-"
TB_COLOR=$LCYAN
LR_CHAR="|"
LR_COLOR=$LCYAN
MENU_COLOR=$LGREY

# ---------- Menus ---------- #
TITLE=""
MAIN=("REALLY COOL SETTINGS EDITOR" "MAIN MENU" "" "[S]ettings" "[M]ain menu" "[D]ynamic menu example" "[H]elp" "[C]credits" "[Q]uit")
CREDITS=("REALLY COOL SETTINGS EDITOR" "Author : Rebel Rae Brown" "Version : 0.0.2" "Date : $DATE" "" "[M]ain menu")
HELP=("HELP" "Here is another sample menu" "" "[M]ain menu")
SETTINGS_WIZARD=("SETTINGS WIZARD" "Let's edit your settings" "" "Press any key to continue")
CURRENT_MENU=()

# ---------- Routines ---------- #
assignMenu(){
    temp="$1[@]"
    arr=("${!temp}")
    CURRENT_MENU=()
    for ((I = 0; I < ${#arr[@]}; I++))
    do
        if (( $I == 0 ))
        then
            TITLE=${arr[$I]}
        else
            CURRENT_MENU[$I-1]=${arr[$I]}
        fi
    done
    menu
}
menu(){
    clear
    # Measure
    MENU_HEIGHT=$(( ${#CURRENT_MENU[@]}+2 ))
    if (( $MENU_HEIGHT < ${DIMENSIONS[1]} ))
    then
        MENU_HEIGHT=${DIMENSIONS[1]}
    fi
    TITLE="| $TITLE |"
    MENU_MIDDLE=$(( ${DIMENSIONS[0]}/2 ))
    TITLE_MIDDLE=$(( ${#TITLE}/2 ))
    TITLE_OFFSET=$(( $MENU_MIDDLE-$TITLE_MIDDLE ))

    MENU_TB="${CORNER_COLOR}$CORNER_CHAR${TB_COLOR}"
    MENU_BOTTOM="${CORNER_COLOR}$CORNER_CHAR${TB_COLOR}"
    for (( I=0; I<${DIMENSIONS[0]}; I++ ))
    do
        if (( $I > $TITLE_OFFSET-1 )) && (( $I < $TITLE_OFFSET + ${#TITLE} ))
        then
            MENU_TB+=${TITLE:(( $I-$TITLE_OFFSET )):1}
        else
            MENU_TB+=$TB_CHAR
        fi
        MENU_BOTTOM+=$TB_CHAR
    done
    MENU_TB+="${CORNER_COLOR}$CORNER_CHAR${LR_COLOR}"
    MENU_BOTTOM+="${CORNER_COLOR}$CORNER_CHAR${LR_COLOR}"
    echo -e "$MENU_TB"

    for (( I=0; I<$MENU_HEIGHT; I++ ))
    do
        # 
        LINE_STR=""
        LEN=0
        if (( $(($I-1)) < ${#CURRENT_MENU[@]} )) && (( $(($I-1)) >= 0 ))
        then
            LINE_STR="${CURRENT_MENU[$(($I-1))]}"
            LEN=${#LINE_STR}
        fi
        # 
        MENU_LR="${LR_COLOR}$LR_CHAR${MENU_COLOR}"
        for (( J=0; J<${DIMENSIONS[0]}; J++ ))
        do
            if (( $J >= $L_MARGIN )) && (( $J < $LEN+$L_MARGIN ))
            then
                MENU_LR+=${LINE_STR[$(($J-$L_MARGIN))]}
            else
                MENU_LR+=" "
            fi
        done
        MENU_LR+="${LR_COLOR}$LR_CHAR"
        echo -e "$MENU_LR"
    done

    echo -e "$MENU_BOTTOM${BASE}"
}
loadSettings(){
    SETTINGS=()
    while read LINE
    do
        if (( ${#LINE} > 0 ))
        then
        SET=$(echo "$LINE" | grep -o  '^.*=' |  tr -d '=')
        VAL=$(echo "$LINE" | grep -o  '\".*\"' |  sed "s/\"//g")
        SETTINGS[$SET]="$VAL"
        fi
    done < "SETTINGS"
}
saveSettings(){
    SETTINGS_STRING=""
    echo -n "" > "SETTINGS"
    for key in "${!SETTINGS[@]}"
    do
        echo "${key}=\"${SETTINGS[$key]}\"" >> "SETTINGS"
    done
}