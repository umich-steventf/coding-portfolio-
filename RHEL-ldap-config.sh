#!/bin/bash

authconfig --disableldap --disableldapauth --update

mkdir /etc/openldap/cacerts
sudo ln -s /etc/ssl/certs /etc/openldap/cacerts
sudo ln -s /home /users

sudo wget http://crt.comodoca.com/AddTrustExternalCARoot.crt -O /etc/openldap/cacerts/AddTrustExternalCARoot.crt
sudo wget http://crt.comodoca.com/COMODOHigh-AssuranceSecureServerCA.crt -O /etc/openldap/cacerts/COMODOHigh-AssuranceSecureServerCA.crt

sudo openssl x509 -in /etc/openldap/cacerts/AddTrustExternalCARoot.crt -inform DER -out /etc/openldap/cacerts/AddTrustExternalCARoot.pem -outform PEM
sudo openssl x509 -in /etc/openldap/cacerts/COMODOHigh-AssuranceSecureServerCA.crt -inform DER -out /etc/openldap/cacerts/COMODOHigh-AssuranceSecureServerCA.pem -outform PEM

sudo /usr/sbin/cacertdir_rehash /etc/openldap/cacerts

yum -y install pam_ldap.x*
yum -y install nss-pam-ldapd.x*

> /etc/openldap/ldap.conf
cat <<EOT > /etc/openldap/ldap.conf
URI ldap://ldap.umich.edu/
BASE ou=People,dc=umich,dc=edu
TLS_CACERTDIR /etc/openldap/cacerts
EOT

> /etc/pam_ldap.conf
cat <<EOT > /etc/pam_ldap.conf
# LDAP server (MCommunity)
URI ldap://ldap.umich.edu/

# LDAP base DN for user object searches
base ou=People,dc=umich,dc=edu

# Make sure we use the most recent LDAP protocol
ldap_version 3

# Make sure we don't block if the LDAP server (or network) isn't available
bind_policy soft
bind_timelimit 3
timelimit 5

# Use TLS to connect
ssl start_tls
tls_cacertdir /etc/openldap/cacerts
tls_reqcert allow

# Create attribute mappings that are compatible with MCommunity
nss_map_attribute uniqueMember member
nss_map_attribute cn uid
pam_member_attribute member

# Tell nss_ldap where to find groups
nss_base_group ou=User Groups,ou=Groups,dc=umich,dc=edu

# Tell nss_ldap where to find passwords
nss_base_passwd ou=People,dc=umich,dc=edu
nss_base_shadow ou=People,dc=umich,dc=edu
pam_password crypt

# Disable persistent connections (because MCommunity doesn't allow them, so enabling them can cause lots of unwanted noise in /var/log/messages)
nss_connect_policy oneshot

# Limit the number of reconnect attempts (otherwise indefinite LDAP reconnections can occur, and that can lead to console lockout if the network or LDAP service is unavailable)
nss_reconnect_tries 2
nss_reconnect_sleeptime 1
nss_reconnect_maxsleeptime 1
nss_reconnect_maxconntries 2

# Only look for posixAccount user objects, since those are the only objects that Linux can use for login
pam_filter      objectclass=posixAccount

# Use this group to authorize logins
#pam_groupdn cn=msis-access-sesa,ou=User Groups,ou=Groups,dc=umich,dc=edu
EOT

> /etc/nsswitch.conf
cat <<EOT > /etc/nsswitch.conf
passwd:     files sss
shadow:     files sss
group:      files
hosts:      files dns
bootparams: nisplus [NOTFOUND=return] files
ethers:     files
netmasks:   files
networks:   files
protocols:  files
rpc:        files
services:   files
netgroup:   files
publickey:  nisplus
automount:  files ldap
aliases:    files nisplus
EOT

> /etc/nslcd.conf
cat <<EOT > /etc/nslcd.conf
uid nslcd
gid ldap
uri ldap://ldap.umich.edu/
base ou=People,dc=umich,dc=edu
ssl start_tls
tls_cacertdir /etc/openldap/cacerts
EOT

> /etc/sssd/sssd.conf
cat <<EOT > /etc/sssd/sssd.conf
[sssd]
config_file_version = 2
reconnection_retries = 3
sbus_timeout = 30
services = nss, pam
domains = default

[nss]
filter_groups = root
filter_users = root
reconnection_retries = 3

[pam]
reconnection_retries = 3

[domain/default]
auth_provider = ldap
cache_credentials = True
ldap_id_use_start_tls = True
debug_level = 0
ldap_schema = rfc2307
ldap_search_base = ou=People,dc=umich,dc=edu
krb5_realm = UMICH.EDU
chpass_provider = ldap
id_provider = ldap
ldap_uri = ldap://ldap.umich.edu/
krb5_server = kerberos.umich.edu
ldap_tls_cacertdir = /etc/openldap/cacerts
EOT

chmod 600 /etc/sssd/sssd.conf

sudo chkconfig nscd on
sudo /etc/init.d/nscd start
sudo chkconfig sssd on
sudo /etc/init.d/sssd start
sudo chkconfig nslcd on
sudo /etc/init.d/nslcd start
sudo rm /var/lib/sss/db/cache_default.ldb
sudo nscd -i passwd
sudo nscd -i group
sudo /etc/init.d/sssd restart
sudo /etc/init.d/oddjobd restart
sudo /etc/init.d/nslcd restart
sudo /etc/init.d/sshd restart
sudo yum -y install openldap-clients

sudo authconfig --enableldap --enableldapauth --enablelocauthorize --enablemkhomedir --enableldaptls --ldapserver=ldap.umich.edu --ldapbasedn="ou=People,dc=umich,dc=edu" --update
