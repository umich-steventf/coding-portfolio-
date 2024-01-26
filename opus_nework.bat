@ECHO OFF
 
set varip=10.10.0.10
set varsm=255.255.255.0
 
ECHO Setting IP Address and Subnet Mask
netsh int ip set address name = "Local Area Connection 2" source = static addr = %varip% mask = %varsm%
 
ECHO Here are the new settings for %computername%:
netsh int ip show config
 
pause
