echo -e "Downloading lastest Altbet version"
cd /tmp
wget -N https://github.com/altbet/abet/releases/download/v1.0.1.0/altbet-v1.0.1.0-ubu1604.tar.gz
tar xvzf altbet-v1.0.1.0-ubu1604.tar.gz
clear
echo -e "Updating to the lastest Altbet version"
systemctl stop altbet
mv altbetd altbet-cli /usr/local/bin
rm altbet-v1.0.1.0-ubu1604.tar.gz
clear
echo -e "Cleaning files from old release"
cd /root/.altbet
mv wallet.dat walletold1.dat
rm -r {banlist.dat,budget.dat,fee_estimates.dat,chainstate,sporks,backups,db.log,mncache.dat,blocks,debug.log,mnpayments.dat,zerocoin}
cd
clear
echo -e "Starting Altbet daemon"
systemctl start altbet
sleep 5
clear
altbet-cli getinfo
echo -e "Update completed, have a nice day :)"
