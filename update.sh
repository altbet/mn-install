echo -e "Downloading Altbet v2.0.0.1"
cd /tmp
wget -N https://github.com/altbet/abet/releases/download/v.2.0.0.1/altbet-v2.0.0.1-ubu1604.tar.gz
tar xvzf altbet-v2.0.0.1-ubu1604.tar.gz
clear
echo -e "Updating Altbet to the latest version"
systemctl stop altbet
mv altbetd altbet-cli /usr/local/bin
rm altbet-v2.0.0.1-ubu1604.tar.gz
clear
echo -e "Preparing Altbet for latest bootstrap"
cd /root/.altbet
mv wallet.dat walletold1.dat
rm -r {budget.dat,fee_estimates.dat,peers.dat,chainstate,sporks,backups,db.log,mncache.dat,wallet.dat,blocks,debug.log,mnpayments.dat,zerocoin} >/dev/null 2>&1
wget -q https://github.com/altbet/bootstraps/releases/download/242100/bootstrap.zip -O bootstrap.zip
unzip bootstrap.zip
rm bootstrap.zip >/dev/null 2>&1
cd - >/dev/null 2>&1
clear
echo -e "Starting Altbet daemon, please be patient"
systemctl start altbet
clear
sleep 5
altbet-cli addnode 8.9.36.49:2238 onetry
sleep 2
altbet-cli addnode 45.32.87.111:2238 onetry
sleep 2
altbet-cli getinfo
echo -e "Update completed, have a nice day :)"
