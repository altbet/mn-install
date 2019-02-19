echo -e "Downloading Altbet v1.3.1.0"
cd /tmp
wget -N https://github.com/altbet/abet/releases/download/v1.3.1.0/altbet-v1.3.1.0-ubu1604.tar.gz
tar xvzf altbet-v1.3.1.0-ubu1604.tar.gz
clear
echo -e "Updating Altbet to the latest version"
systemctl stop altbet
mv altbetd altbet-cli /usr/local/bin
rm altbet-v1.3.1.0-ubu1604.tar.gz
clear
echo -e "Preparing Altbet for latest bootstrap"
cd /root/.altbet
mv wallet.dat walletold1.dat
rm -r {budget.dat,db.log,debug.log,fee_estimates.dat,mnpayments.dat,mncache.dat,peers.dat,wallet.dat,blocks,chainstate} >/dev/null 2>&1
wget -q https://github.com/altbet/bootstraps/releases/download/179660/bootstrap.zip -O bootstrap.zip
unzip bootstrap.zip
rm bootstrap.zip >/dev/null 2>&1
cd - >/dev/null 2>&1
clear
echo -e "Starting Altbet daemon, please be patient"
systemctl start altbet
clear
sleep 10
altbet-cli getinfo
echo -e "Update completed, have a nice day :)"
