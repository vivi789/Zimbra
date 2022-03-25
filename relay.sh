#/bin/bash
zmhostname=`hostname`
read -p "smtp_server: " srv
read -p "port: " port
read -p "user: " user
read -p "password: " pass
echo $srv $user:$pass > /opt/zimbra/conf/relay_password
su - zimbra -c "postmap /opt/zimbra/conf/relay_password"
su - zimbra -c "postmap -q $srv /opt/zimbra/conf/relay_password"
su - zimbra -c "zmprov ms $zmhostname zimbraMtaSmtpSaslPasswordMaps lmdb:/opt/zimbra/conf/relay_password"
su - zimbra -c "zmprov ms $zmhostname zimbraMtaSmtpSaslAuthEnable yes"
su - zimbra -c "zmprov ms $zmhostname zimbraMtaSmtpCnameOverridesServername no"
su - zimbra -c "zmprov ms $zmhostname zimbraMtaSmtpTlsSecurityLevel may"
su - zimbra -c "zmprov ms $zmhostname zimbraMtaSmtpSaslSecurityOptions noanonymous"
su - zimbra -c "zmprov ms $zmhostname zimbraMtaRelayHost $srv:$port"
su - zimbra -c "postfix reload"
echo "Relay configuration was successful!!!"
