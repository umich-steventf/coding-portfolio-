#Get List of Computers
$Computers = Get-ADComputer -Filter * -SearchBase "OU=5501,OU=Lab,OU=Geological Sciences,OU=RSN,OU=Workstations,OU=LSA,OU=Organizations,OU=UMICH,DC=adsroot,DC=itcs,DC=umich,DC=edu" | Select DNSHostName -ExpandProperty DNSHostName

#Reboot Computer
ForEach ($Computer in $Computers) {
	c:\WINDOWS\system32\shutdown.exe /m \\$Computer /r /f
	Sleep 2
}