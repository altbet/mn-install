#!/bin/bash
systemctl stop abet
abet-cli stop
cd /usr/local/bin
rm -r {abet-cli,abetd,abet-tx,abet-qt}
wget https://github.com/altbet/abet/releases/download/v3.4.1.0/abet-v3.4.1.0-linux.tar.gz
tar xvzf abet-v3.4.1.0-linux.tar.gz
cd
cd .abet/
rm -r {budget.dat,fee_estimates.dat,peers.dat,backups,chainstate,sporks,banlist.dat,db.log,mncache.dat,blocks,debug.log,mnpayments.dat,zerocoin}
wget https://github.com/altbet/abet/releases/download/v3.4.1.0/bootstrap.tar.gz
tar xvzf bootstrap.tar.gz
cd
systemctl start abet
abetd &
watch abet-cli getinfo
