# [altbet](https://altbet.io) - The revolutionary mutual betting platform with provably fair odds

Shell script to install a Altbet Masternode on a Linux server running Ubuntu 16.04. Use it on your own risk.
***

## VPS installation for version **3.4.0.0**
```
wget -N https://raw.githubusercontent.com/altbet/mn-install/master/mn-install.sh
bash mn-install.sh
```
***

## Desktop wallet setup

After the Masternode is up and running, you need to configure the desktop wallet accordingly. Here are the steps:
1. Open the ABET Desktop Wallet.
2. Go to RECEIVE and create a New Address: **MN1**
3. Send **1000** ABET to **MN1**. You need to send all 1000 coins in one single transaction.
4. Wait for 16 confirmations.
5. Go to **Help -> "Debug Window - Console"**
6. Type the following command: **getmasternodeoutputs**
7. Go to  **Tools -> "Open Masternode Configuration File"**
8. Add the following entry:
```
Format: alias VPS_IP:port masternodeprivkey collateral_output_txid collateral_output_index

Example: mn1 127.0.0.2:8322 93HaYBVUCYjEMeeH1Y4sBGLALQZE1Yc1K64xiqgX37tGBDQL8Xg 2bcd3c84c84f87eaa86e4e56834c92927a07f9e18718810b92e0d0324456a67c 0
```
9. Save and close the file.
10. Go to **Masternode Tab**. If you tab is not shown, please enable it from: **Settings - Options - Wallet - Show Masternodes Tab**
11. Click **Update status** to see your node. If it is not shown, close the wallet and start it again. Make sure the wallet is unlocked.
12. Select your MN and click **Start Alias** to start it.
13. Alternatively, open **Debug Console** and type:
```
startmasternode "alias" "0" "MN1"
```
14. Login to your VPS and check your masternode status by running the following command to confirm your MN is running:
```
abet-cli getmasternodestatus
```
***

## Usage:
```
abet-cli getmasternodestatus
abet-cli getinfo
abet-cli mnsync status
```
Also, if you want to check/start/stop **abet**, run one of the following commands as **root**:

```
systemctl status abet #To check if abet service is running
systemctl start abet #To start abet service
systemctl stop abet #To stop abet service
systemctl is-enabled abet #To check if abet service is enabled on boot
```

