# Modules
Import-Module ActiveDirectory

# Variables
$searchBase = "OU=RSN,OU=Workstations,OU=LSA,OU=Organizations,OU=UMICH,DC=adsroot,DC=itcs,DC=umich,DC=edu"
$oldProfiles = @("bio-probity","chemadm1","nuitadm1","nuit-admin","nuitadmin","crashcart")
$Username = "rsnadm1"
$cntComputer = 0
$Computers = $FailedComputers = @()
$Output = ""
$NewLine = "`r`n"
$PWS_DONT_EXP = [INT]65536
$ENABLE_ACC = [INT]512
$scriptPath = Split-Path -parent $MyInvocation.MyCommand.Definition
$scriptName = (Split-Path -leaf $MyInvocation.MyCommand.Definition).Replace(".ps1","")
$File = New-Item -Type File "$($scriptPath)\$($scriptName).log" -Force

# Functions
Function deleteOldProfiles($Computer, $oldProfiles) {
	# Get list of profiles
	$Profiles = Get-WmiObject -Class Win32_UserAccount -Namespace "root\cimv2" -Filter "LocalAccount='$True'" -ComputerName $Computer -ErrorAction Stop

	# Search for old profiles
	ForEach ($Profile in $Profiles) {
		Try {
		ForEach ($oldProfile in $oldProfiles) {
				If ($oldProfile -eq $Profile.Name){
					[ADSI]$delConnection = "WinNT://$Computer"
					$delConnection.Delete("user",$Profile.Name)
				}
			}
		} Catch {
			# Nothing
		}
	}
}

# Main Sub
# Prompt user for password to set on computers
#$Password = Read-Host "Password" -AsSecureString
$Password = Read-Host "Password"

# Generate list of computers for scope
$Computers = Get-ADComputer -SearchBase "$($searchBase)" -Filter '*' | Select-Object -ExpandProperty Name

# Process lit of computers
ForEach ($Computer in $Computers) {
	# Count
	$cntComputer++

	# Report Status
	Write-Host "Processing Computer $($cntComputer) of $($Computers.Count)..."

	# Test connection
	If (Test-Connection $Computer -Count 1 -Quiet) {
		Try {
			# Change password
			$User = [ADSI]"WinNT://$Computer/$Username,user"
			$User.SetPassword($Password)
			$User.userflags = ($PWS_DONT_EXP+$ENABLE_ACC)
			$User.SetInfo()

			# Delete old profiles
			If ($oldProfiles.Count -gt 0) {
				deleteOldProfiles $Computer $oldProfiles
			}
		} Catch {
			# Log failed attempt
			$FailedComputers += $Computer
		}
	} Else {
		# Log failed attempt
		$FailedComputers += $Computer
	}
}

# Generate output
$Output = "$($Output)Failed Count: $($FailedComputers.Count)$($NewLine)"
$Output = "$($Output)Success Count: $($cntComputer)$($NewLine)"
$Output = "$($Output)$($NewLine)"
$Output = "$($Output)Failed Computers:$($NewLine)"
$FailedComputers | % {$Output = "$($Output)$($_)$($NewLine)"}
$Output = "$($Output)$($NewLine)"
$Output = "$($Output)Copy and paste for next run to populate array:$($NewLine)"
$FailedComputers | % {$Output = "$($Output)`"$($_)`","}
$Output = $Output.SubString(0, $Output.length-1)

# Commit output
Add-Content $File "$($Output)"

# Finished
Remove-Variable Password
Write-Host "Finished. Check $($File) for additional details."