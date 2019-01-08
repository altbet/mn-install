#!/bin/bash

TMP_FOLDER=$(mktemp -d)
CONFIG_FILE='altbet.conf'
CONFIGFOLDER='/root/.altbet'
COIN_DAEMON='altbetd'
COIN_CLI='altbet-cli'
COIN_PATH='/usr/local/bin/'
COIN_TGZ='https://github.com/altbet/abet/releases/download/v1.1/altbet-v1.1-ubu1604.tar.gz'
COIN_ZIP=$(echo $COIN_TGZ | awk -F'/' '{print $NF}')
COIN_NAME='altbet'
COIN_PORT=2238
RPC_PORT=2239
COIN_BLOCKS='https://github.com/altbet/bootstraps/releases/download/120185/bootstrap.tar.gz'

NODEIP=$(curl -s4 icanhazip.com)


RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

function sync_node() {
  echo -e "Syncing the node. This might take a while, depending on your internet connection!"
  cd $CONFIGFOLDER >/dev/null 2>&1
  rm -r {blocks,database,fee_estimates.dat,mnpayments.dat,altbetd.pid,budget.dat,db.log,peers.dat,chainstate,debug.log,mncache.dat} >/dev/null 2>&1
  wget -q $COIN_BLOCKS -O bootstrap.tar.gz
  tar xvzf bootstrap.tar.gz >/dev/null 2>&1
  rm bootstrap.tar.gz >/dev/null 2>&1
  cd - >/dev/null 2>&1
}

function download_node() {
  echo -e "Preparing to download ${GREEN}$COIN_NAME${NC}."
  cd $TMP_FOLDER >/dev/null 2>&1
  wget -q $COIN_TGZ
  compile_error
  tar xvzf $COIN_ZIP -C $COIN_PATH >/dev/null 2>&1
  cd - >/dev/null 2>&1
  rm -rf $TMP_FOLDER >/dev/null 2>&1
  clear
}


function configure_systemd() {
  cat << EOF > /etc/systemd/system/$COIN_NAME.service
[Unit]
Description=$COIN_NAME service
After=network.target

[Service]
User=root
Group=root

Type=forking
#PIDFile=$CONFIGFOLDER/$COIN_NAME.pid

ExecStart=$COIN_PATH$COIN_DAEMON -daemon -prune=100 -conf=$CONFIGFOLDER/$CONFIG_FILE -datadir=$CONFIGFOLDER
ExecStop=-$COIN_PATH$COIN_CLI -conf=$CONFIGFOLDER/$CONFIG_FILE -datadir=$CONFIGFOLDER stop

Restart=always
PrivateTmp=true
TimeoutStopSec=60s
TimeoutStartSec=10s
StartLimitInterval=120s
StartLimitBurst=5

[Install]
WantedBy=multi-user.target
EOF

  systemctl daemon-reload
  sleep 3
  systemctl start $COIN_NAME.service
  systemctl enable $COIN_NAME.service >/dev/null 2>&1

  if [[ -z "$(ps axo cmd:100 | egrep $COIN_DAEMON)" ]]; then
    echo -e "${RED}$COIN_NAME is not running${NC}, please investigate. You should start by running the following commands as root:"
    echo -e "${GREEN}systemctl start $COIN_NAME.service"
    echo -e "systemctl status $COIN_NAME.service"
    echo -e "less /var/log/syslog${NC}"
    exit 1
  fi
}


function create_config() {
  mkdir $CONFIGFOLDER >/dev/null 2>&1
  RPCUSER=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w10 | head -n1)
  RPCPASSWORD=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w22 | head -n1)
  cat << EOF > $CONFIGFOLDER/$CONFIG_FILE
rpcuser=$RPCUSER
rpcpassword=$RPCPASSWORD
rpcport=$RPC_PORT
rpcallowip=127.0.0.1
listen=1
server=1
debug=0
daemon=1
port=$COIN_PORT
EOF
}

function create_key() {
  echo -e "Enter your ${RED}$COIN_NAME Masternode Private Key${NC}. Leave it blank to generate a new ${RED}Masternode Private Key${NC} for you:"
  read -e COINKEY
  if [[ -z "$COINKEY" ]]; then
  $COIN_PATH$COIN_DAEMON -daemon
  sleep 30
  if [ -z "$(ps axo cmd:100 | grep $COIN_DAEMON)" ]; then
   echo -e "${RED}$COIN_NAME server couldn not start. Check /var/log/syslog for errors.{$NC}"
   exit 1
  fi
  COINKEY=$($COIN_PATH$COIN_CLI masternode genkey)
  if [ "$?" -gt "0" ];
    then
    echo -e "${RED}Wallet not fully loaded. Let us wait and try again to generate the Private Key${NC}"
    sleep 30
    COINKEY=$($COIN_PATH$COIN_CLI masternode genkey)
  fi
  $COIN_PATH$COIN_CLI stop
fi
clear
}

function update_config() {
  sed -i 's/daemon=1/daemon=0/' $CONFIGFOLDER/$CONFIG_FILE
  cat << EOF >> $CONFIGFOLDER/$CONFIG_FILE
logintimestamps=1
maxconnections=64
#bind=$NODEIP
masternode=1
externalip=$NODEIP:$COIN_PORT
masternodeprivkey=$COINKEY
printtodebug=0
printtoconsole=0

#Altbet addnodes
addnode=185.206.146.209:2238
addnode=185.206.147.210:2238
addnode=185.206.144.217:2238
addnode=185.141.61.104:2238
addnode=35.197.130.246:2238
addnode=35.195.47.136:2238
addnode=108.61.218.19:2238
addnode=35.247.153.240:2238
addnode=95.216.38.5:2238
addnode=139.180.218.176:2238
addnode=35.237.81.253:2238
addnode=149.28.62.212:2238
addnode=178.63.96.14:2238
addnode=95.216.44.81:2238
addnode=95.216.37.61:2238
addnode=95.216.119.114:2238
addnode=46.4.182.99:2238
addnode=78.141.101.196:2238
addnode=83.170.202.34:2238
addnode=46.101.170.138:2238
addnode=95.179.231.127:2238
addnode=45.76.123.22:2238
addnode=112.162.233.135:2238
addnode=108.61.198.31:2238
addnode=188.162.86.204:2238
addnode=142.93.153.214:2238
addnode=95.216.33.78:2238
addnode=95.216.42.182:2238
addnode=77.34.134.80:2238
addnode=109.240.97.226:2238
addnode=45.32.76.33:2238
addnode=185.88.156.13:2238
addnode=35.229.125.118:2238
addnode=138.68.251.41:2238
addnode=71.198.226.62:2238
addnode=86.139.204.102:2238
addnode=123.114.187.29:2238
addnode=221.37.194.27:2238
addnode=95.216.68.52:2238
addnode=178.128.99.42:2238
addnode=207.246.76.102:2238
addnode=185.141.61.104:2238
addnode=108.61.117.253:2238
addnode=144.202.18.59:2238
addnode=45.63.96.121:2238
addnode=95.179.177.103:2238
addnode=45.32.232.172:2238
addnode=149.28.205.231:2238
addnode=95.179.176.148:2238
addnode=202.80.213.16:2238
addnode=45.32.217.246:2238
addnode=217.61.61.213:2238
addnode=217.163.23.38:2238
addnode=185.206.147.210:2238
addnode=159.65.122.61:2238
addnode=95.216.37.13:2238
addnode=159.69.72.247:2238
addnode=108.61.188.217:2238
addnode=95.179.176.160:2238
addnode=149.28.53.143:2238
addnode=138.197.151.112:2238
addnode=95.216.42.190:2238
EOF
}


function enable_firewall() {
  echo -e "Installing and setting up firewall to allow ingress on port ${GREEN}$COIN_PORT${NC}"
  ufw allow $COIN_PORT/tcp comment "$COIN_NAME MN port" >/dev/null
  ufw allow ssh comment "SSH" >/dev/null 2>&1
  ufw limit ssh/tcp >/dev/null 2>&1
  ufw default allow outgoing >/dev/null 2>&1
  echo "y" | ufw enable >/dev/null 2>&1
}


function get_ip() {
  declare -a NODE_IPS
  for ips in $(netstat -i | awk '!/Kernel|Iface|lo/ {print $1," "}')
  do
    NODE_IPS+=($(curl --interface $ips --connect-timeout 2 -s4 icanhazip.com))
  done

  if [ ${#NODE_IPS[@]} -gt 1 ]
    then
      echo -e "${GREEN}More than one IP. Please type 0 to use the first IP, 1 for the second and so on...${NC}"
      INDEX=0
      for ip in "${NODE_IPS[@]}"
      do
        echo ${INDEX} $ip
        let INDEX=${INDEX}+1
      done
      read -e choose_ip
      NODEIP=${NODE_IPS[$choose_ip]}
  else
    NODEIP=${NODE_IPS[0]}
  fi
}


function compile_error() {
if [ "$?" -gt "0" ];
 then
  echo -e "${RED}Failed to compile $COIN_NAME. Please investigate.${NC}"
  exit 1
fi
}


function checks() {
if [[ $(lsb_release -d) != *16.04* ]]; then
  echo -e "${RED}You are not running Ubuntu 14.04. Installation is cancelled.${NC}"
  exit 1
fi

if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}$0 must be run as root.${NC}"
   exit 1
fi

if [ -n "$(pidof $COIN_DAEMON)" ] || [ -e "$COIN_DAEMOM" ] ; then
  echo -e "${RED}$COIN_NAME is already installed.${NC}"
  exit 1
fi
}

function prepare_system() {
echo -e "Prepare the system to install ${GREEN}$COIN_NAME${NC} master node."
apt-get update >/dev/null 2>&1
DEBIAN_FRONTEND=noninteractive apt-get update > /dev/null 2>&1
DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" -y -qq upgrade >/dev/null 2>&1
apt install -y software-properties-common >/dev/null 2>&1
echo -e "${GREEN}Adding bitcoin PPA repository"
apt-add-repository -y ppa:bitcoin/bitcoin >/dev/null 2>&1
echo -e "Installing required packages, it may take some time to finish.${NC}"
apt-get update >/dev/null 2>&1
apt-get install -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" make software-properties-common \
build-essential libtool autoconf libssl-dev libboost-dev libboost-chrono-dev libboost-filesystem-dev libboost-program-options-dev \
libboost-system-dev libboost-test-dev libboost-thread-dev sudo automake git wget curl unzip libdb4.8-dev bsdmainutils libdb4.8++-dev \
libminiupnpc-dev libgmp3-dev ufw pkg-config libzmq3-dev libevent-dev >/dev/null 2>&1
if [ "$?" -gt "0" ];
  then
    echo -e "${RED}Not all required packages were installed properly. Try to install them manually by running the following commands:${NC}\n"
    echo "apt-get update"
    echo "apt -y install software-properties-common"
    echo "apt-add-repository -y ppa:bitcoin/bitcoin"
    echo "apt-get update"
    echo "apt install -y make build-essential libtool software-properties-common autoconf libssl-dev libboost-dev libboost-chrono-dev libboost-filesystem-dev \
libboost-program-options-dev libboost-system-dev libboost-test-dev libboost-thread-dev sudo automake git curl unzip libdb4.8-dev \
bsdmainutils libdb4.8++-dev libminiupnpc-dev libgmp3-dev ufw pkg-config libzmq3-dev libevent-dev"
 exit 1
fi
clear
}

function important_information() {
  echo -e "================================================================================================================================"
  echo -e "$COIN_NAME Masternode is up and running listening on port ${RED}$COIN_PORT${NC}."
  echo -e "Configuration file is: ${RED}$CONFIGFOLDER/$CONFIG_FILE${NC}"
  echo -e "Start: ${RED}systemctl start $COIN_NAME.service${NC}"
  echo -e "Stop: ${RED}systemctl stop $COIN_NAME.service${NC}"
  echo -e "VPS_IP:PORT ${RED}$NODEIP:$COIN_PORT${NC}"
  echo -e "MASTERNODE PRIVATEKEY is: ${RED}$COINKEY${NC}"
  echo -e "Please check ${RED}$COIN_NAME${NC} daemon is running with the following command: ${RED}systemctl status $COIN_NAME.service${NC}"
  echo -e "Use ${RED}$COIN_CLI masternode status${NC} to check your MN."
  if [[ -n $SENTINEL_REPO  ]]; then
  echo -e "${RED}Sentinel${NC} is installed in ${RED}$CONFIGFOLDER/sentinel${NC}"
  echo -e "Sentinel logs is: ${RED}$CONFIGFOLDER/sentinel.log${NC}"
  fi
  echo -e "================================================================================================================================"
}

function setup_node() {
  get_ip
  create_config
  sync_node
  create_key
  update_config
  enable_firewall
  important_information
  configure_systemd
}


##### Main #####
clear

checks
prepare_system
download_node
setup_node
