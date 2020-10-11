#!/bin/bash
#
# Script for RecalBox to terminate every emulator instance
# Control script to give feedback about state of EmulationStation and
# active EMULATORS
# by cyperghost aka crcerror // 18.03.2019
# Recalbox / Batocera versions // 04.06.2019
# Added sigterm level, added second parameter to activate sigterm during smart_wait function

# Get all childpids from calling process
function getcpid() {
    local cpids="$(pgrep -P $1)"
    for cpid in $cpids; do
        pidarray+=($cpid)
        getcpid $cpid
    done
}

# Get a sleep while process is active in background
# if PID is still active then use kill -9 switch
function smart_wait() {
    local PID=$2
    local disablekill9=$1
    local watchdog=0
    sleep 1
    while [[ -e /proc/$PID ]]; do
        sleep 0.25
        ((watchdog++))
        [[ $disablekill9 -eq 1 ]] && [[ watchdog -gt 12 ]] && kill -9 $PID
    done
}

# Kodi running?
function check_kodi() {
    local KODI="$(systemctl status kodi | grep running)"
    echo $KODI
}

# ---- MAINS ----

case ${1,,} in
    # --restart)
    #     /etc/init.d/S31emulationstation stop
    #     ES_PID=$(check_esrun)
    #     [[ -z $ES_PID ]] || smart_wait 0 $ES_PID 
    #     /etc/init.d/S31emulationstation start
    # ;;

    --kodistop|--shutdown)
        KODI_PID=$(check_kodi)
        if [[ -n $KODI_PID ]]; then
            getcpid $KODI_PID
            for ((z=${#pidarray[*]}-1; z>-1; z--)); do
                systemctl stop kodi
                smart_wait 1 ${pidarray[z]}
            done
            unset pidarray
        fi
        if [[ "$1" == "--shutdown" ]]; then
            sleep 3
            shutdown -h now
        fi
    ;;

    # --kodi)
    #     ES_PID=$(check_esrun)
    #     kill $ES_PID
    #     smart_wait 0 $ES_PID
    #     /etc/init.d/S31emulationstation stop
    #     /recalbox/scripts/kodilauncher.sh &
    #     wait $!
    #     exitcode=$?
    #     [[ $exitcode -eq 0 ]] && /etc/init.d/S31emulationstation start
    #     [[ $exitcode -eq 10 ]] && shutdown -r now
    #     [[ $exitcode -eq 11 ]] && shutdown -h now
    # ;;

    *)
        echo -e "Please parse parameters to this script! \n
                  --restart will RESTART Kodi only
                  --shutdown will SHUTDOWN whole system
                  --kodistop to exit kodi only"
    ;;

esac
