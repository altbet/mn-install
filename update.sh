echo -e "Downloading altbet v1.3.0.1"
cd /tmp
wget -N https://github.com/altbet/abet/releases/download/v1.3.0.1/altbet-v1.3.0.1-ubu1604.tar.gz
tar xvzf altbet-v1.3.0.1-ubu1604.tar.gz
clear
echo -e "Updating altbet to the latest version"
systemctl stop altbet
mv altbetd altbet-cli /usr/local/bin
rm altbet-v1.3.0.1-ubu1604.tar.gz
clear
echo -e "Preparing altbet for latest bootstrap"
cd /root/.altbet
mv wallet.dat walletold.dat
rm -r {blocks,database,fee_estimates.dat,mnpayments.dat,altbetd.pid,budget.dat,db.log,peers.dat,chainstate,debug.log,mncache.dat$
wget -q https://github.com/altbet/bootstraps/releases/download/v1.3.0.1-bootstrap/bootstrap.zip -O bootstrap.zip
unzip bootstrap.zip
rm bootstrap.zip >/dev/null 2>&1
cd - >/dev/null 2>&1
clear
echo -e "Starting altbet deamon, please be patient"
systemctl start altbet
clear
sleep 10
altbet-cli getinfo
echo -e "Update completed, have a nice day :)"
