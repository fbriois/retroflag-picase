# Kodi running?
function stop_kodi() {
    if [[ systemctl is-active --quiet kodi == "active" ]]; then
        systemctl stop kodi
    fi
}

function start_kodi() {
    if [[ systemctl is-active --quiet kodi == "inactive" ]]; then
        systemctl start kodi
    fi
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

    --restart)
        stop_kodi
        start_kodi
    ;;

    *)
        echo -e "Please parse parameters to this script! \n
                  --restart will RESTART Kodi only
                  --shutdown will SHUTDOWN whole system
                  --kodistop to exit kodi only"
    ;;

esac
