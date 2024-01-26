#run as sudo
chmod 777 /etc/paths

if(!(grep -q /opt/local/bin /etc/paths))
then
echo /opt/local/bin >> /etc/paths
fi


if(!(grep -q /opt/local/sbin /etc/paths))
then
echo /opt/local/sbin >> /etc/paths
fi


chmod a-rwx /etc/paths
chmod a+r /etc/paths
chmod u+w /etc/paths

echo "your bidding is done master"