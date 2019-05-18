echo -e "Downloading Altbet v2.0.0.2"
cd /tmp
wget -N https://github.com/altbet/abet/releases/download/v.2.0.0.2/altbet-v2.0.0.2-ubu1604.tar.gz
tar xvzf altbet-v2.0.0.2-ubu1604.tar.gz
clear
echo -e "Updating Altbet to the latest version"
systemctl stop altbet
mv altbetd altbet-cli /usr/local/bin
rm altbet-v2.0.0.2-ubu1604.tar.gz
clear
echo -e "Preparing Altbet for latest bootstrap"
cd /root/.altbet
mv wallet.dat walletold1.dat
rm -r {budget.dat,fee_estimates.dat,peers.dat,chainstate,sporks,backups,db.log,mncache.dat,wallet.dat,blocks,debug.log,mnpayments.dat,zerocoin} >/dev/null 2>&1
wget -q https://github.com/altbet/bootstraps/releases/download/279208/bootstrap.zip -O bootstrap.zip
unzip bootstrap.zip
rm bootstrap.zip >/dev/null 2>&1
cd - >/dev/null 2>&1
clear
echo -e "Starting Altbet daemon, please be patient"
systemctl start altbet
clear
sleep 3
altbet-cli addnode 45.77.59.229:2238 onetry
sleep 1
altbet-cli addnode 185.92.222.6:2238 onetry
sleep 1
altbet-cli addnode 80.211.255.112:2238 onetry
sleep 1
altbet-cli addnode 138.68.74.13:2238 onetry
sleep 1
altbet-cli getinfo
echo -e "Update completed, have a nice day :)"
