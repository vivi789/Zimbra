#!/bin/bash
su - zimbra -c 'zmprov ms `zmhostname` zimbraMtaRelayHost ""'
su - zimbra -c 'zmprov ms `zmhostname` zimbraMtaFallbackRelayHost ""'

a=$(su - zimbra -c 'postconf -n | grep -E "relayhost" | cut -d "=" -f 2')
b=$(su - zimbra -c 'postconf -n | grep -E "smtp_fallback_relay" | cut -d "=" -f 2')

sleep 60

if [ -z $a ] && [ -z $b ]
then
        echo "disable relay successfully"
        su - zimbra -c 'postfix reload'
else
        echo "disable relay failed"
        su - zimbra -c 'postconf -n | grep "relay"'
fi
