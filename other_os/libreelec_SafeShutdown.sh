function stop_kodi() {
    systemctl is-active kodi > /dev/null 2>&1 && systemctl stop kodi
}

function start_kodi() {
    !systemctl is-active kodi > /dev/null 2>&1 && systemctl start kodi
}

function is_kodi_run() {
    systemctl is-active kodi > /dev/null 2>&1 && echo 1
}

# ---- MAINS ----
case ${1} in
    --kodistop|--shutdown)
        stop_kodi
        if [[ "$1" == "--shutdown" ]]; then
            sleep 3
            shutdown -h now
        fi
    ;;

    --kodirun)
        is_kodi_run
    ;;

    --restart)
        stop_kodi
        start_kodi
    ;;

    *)
        echo -e "Please parse parameters to this script! \n
                  --kodirun will check if Kodi is running
                  --restart will RESTART Kodi only
                  --shutdown will SHUTDOWN whole system
                  --kodistop to exit kodi only"
    ;;

esac
