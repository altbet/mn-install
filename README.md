# [altbet](https://altbet.io) - Revolutionary mutual betting platform based on our original cryptocurrency.

Shell script to install a Altbet Masternode on a Linux server running Ubuntu 16.04. Use it on your own risk.
***

## VPS installation for version **1.3**
```
wget -N https://raw.githubusercontent.com/altbet/mn-install/master/mn-install.sh
bash mn-install.sh
```
***

## Desktop wallet setup

After the Masternode is up and running, you need to configure the desktop wallet accordingly. Here are the steps:
1. Open the altbet Desktop Wallet.
2. Go to RECEIVE and create a New Address: **MN1**
3. Send **1000** ABET to **MN1**. You need to send all 1000 coins in one single transaction.
4. Wait for 16 confirmations.
5. Go to **Help -> "Debug Window - Console"**
6. Type the following command: **masternode outputs**
7. Go to  **Tools -> "Open Masternode Configuration File"**
8. Add the following entry:
```
Alias Address Privkey TxHash TxIndex
```
* Alias: **MN1**
* Address: **VPS_IP:PORT**
* Privkey: **Masternode Private Key**
* TxHash: **First value from Step 6**
* TxIndex:  **Second value from Step 6**
9. Save and close the file.
10. Go to **Masternode Tab**. If you tab is not shown, please enable it from: **Settings - Options - Wallet - Show Masternodes Tab**
11. Click **Update status** to see your node. If it is not shown, close the wallet and start it again. Make sure the wallet is unlocked.
12. Select your MN and click **Start Alias** to start it.
13. Alternatively, open **Debug Console** and type:
```
startmasternode alias false MN1
```
14. Login to your VPS and check your masternode status by running the following command to confirm your MN is running:
```
altbet-cli masternode status
```
***

## Usage:
```
altbet-cli masternode status
altbet-cli getinfo
altbet-cli mnsync status
```
Also, if you want to check/start/stop **altbet**, run one of the following commands as **root**:

```
systemctl status altbet #To check if altbet service is running
systemctl start altbet #To start altbet service
systemctl stop altbet #To stop altbet service
systemctl is-enabled altbet #To check if altbet service is enabled on boot
```
***

## Masternode update:
In order to update your Altbet Masternode to version 1.3, please run the following commands:
```
cd /tmp
wget -N https://github.com/altbet/abet/releases/download/v1.3/altbet-v1.3-ubu1604.tar.gz
tar xvzf altbet-v1.3-ubu1604.tar.gz
systemctl stop altbet
mv altbetd altbet-cli /usr/local/bin
systemctl start altbet
rm altbet-v1.3-ubu1604.tar.gz
altbet-cli getinfo
```
Open your desktop wallet and start the node from there.
***

## Credits
https://github.com/zoldur
