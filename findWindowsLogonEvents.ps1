# Check if powershell session has elevated privileges
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] “Administrator”)) {
    Write-Warning “You do not have Administrator rights to run this script!`nPlease re-run this script as an Administrator!”
    Break
}

# Create array to save logon event data
$events = @()

# Prompt for computername
$ComputerName = Read-Host "Enter the FQDN of the host you want to query security event logs for"
If ($ComputerName -eq "" -Or $ComputerName -eq $Null) {
	$ComputerName = "$env:ComputerName.$env:UserDNSDomain"
}

If (Test-Connection $ComputerName) {
	# Get all security logon events
	$logs = Get-EventLog -ComputerName $ComputerName -LogName Security -InstanceId 4624
	
	ForEach ($log in $logs) {
		# Get user from event
		if ($log.message -match "New Logon:\s*Security ID:\s*.*\s*Account Name:\s*(\w+)") {
			$user = $matches[1]
			remove-variable matches
		}
	
		# Get event datetime stamp
		$timestamp = $log.TimeGenerated
	
		# Create powershell object to record events
		$logonevent = New-Object PSObject -Property @{
			UserName = $user
			TimeStamp = $timestamp
		}
	
		# Add object to array
		$events += $logonevent
	
		remove-variable user, timestamp, log
	}
	
	# Sort array
	#$events | Sort-Object -Property UserName, @{Expression = {$_.TimeStamp}; Ascending = $false}
	
	# Output column headers for results
	Write-Host "UserName, # of Logons, Last Logon DateTime Stamp"
	
	# Get list of usernames from array and output last logon timestamp and # of logons
	ForEach ($user in ($events | Select -ExpandProperty "UserName" -Unique)) {
		# Count number of logons
		$logon_count = ($events | Select UserName | Where UserName -eq "$user" | Measure).Count
	
		# Sort array and get last logon timestamp
		$last_logon = ($events | Sort-Object -Property UserName, @{Expression = {$_.TimeStamp}; Ascending = $false} | Select UserName, TimeStamp | Where UserName -eq "$user")[0].TimeStamp
	
		# Output results
		Write-Host "$user, $logon_count, $last_logon"
	
		remove-variable logon_count, last_logon, user
	}
} Else {
	Write-Host "Failed to connect to $ComputerName."
}