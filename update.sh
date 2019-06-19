echo -e "Downloading lastest Altbet version"
cd /tmp
wget -N https://github.com/altbet/abet/releases/download/v.2.0.0.3/altbet-v2.0.0.3-ubu1604.tar.gz
tar xvzf altbet-v2.0.0.3-ubu1604.tar.gz
clear
echo -e "Updating to the lastest Altbet version"
systemctl stop altbet
mv altbetd altbet-cli /usr/local/bin
rm altbet-v2.0.0.3-ubu1604.tar.gz
clear
echo -e "Downloading latest bootstrap"
cd /root/.altbet
mv wallet.dat walletold1.dat
rm -r {banlist.dat,budget.dat,fee_estimates.dat,peers.dat,chainstate,sporks,backups,db.log,mncache.dat,wallet.dat,blocks,debug.log,mnpayments.dat,zerocoin} >/dev/null 2>&1
wget -q -4 https://github.com/altbet/bootstraps/releases/download/350450/bootstrap.zip -O bootstrap.zip
unzip bootstrap.zip
sleep 1
rm bootstrap.zip >/dev/null 2>&1
cd - >/dev/null 2>&1
clear
echo -e "Starting new Altbet daemon, please be patient"
systemctl start altbet
clear
sleep 3
altbet-cli addnode 185.206.146.209:2238 onetry
sleep 1
altbet-cli addnode 185.206.147.210:2238 onetry
sleep 1
altbet-cli addnode 185.206.144.217:2238 onetry
sleep 1
altbet-cli addnode 185.141.61.104:2238 onetry
sleep 1
altbet-cli addnode 173.199.70.37:2238 onetry
sleep 1
altbet-cli addnode 95.216.79.247:2238 onetry
sleep 1
altbet-cli addnode 188.40.177.100:2238 onetry
sleep 1
altbet-cli addnode 46.4.178.72:2238 onetry
sleep 1
altbet-cli getinfo
echo -e "Update completed, have a nice day :)"
