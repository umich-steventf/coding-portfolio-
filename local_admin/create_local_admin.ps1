#########################################################################################################
### script: create_local_admin										#
### Author: Steven Flack										#
### Company: University of Michigan									#
### Organization: LSA Information Technology 								#
### Created: 09/25/2014 										#
### Purpose: Makes local account for lab users, sets a password, and adds it to the admin group         #
#########################################################################################################

$new_admin = "foo"
$password = "Brain2mr!"
$computer = @('chem-2UA4290QWW.adsroot.itcs.umich.edu')

ForEach($Object in $computer)
{
	If(Test-Connection $Object)
	{
		Write-Host "$(Get-Date -Format s) - [$($computer)] Attempting to update $($new_admin)." -foregroundcolor "green"
		
		try{
			# makes new_admin and sets the password
			$Local_Admin = [adsi]"WinNT://$computer"
			$user = $Local_Admin.Create("User", $new_admin)
			$user.SetPassword($password)
			$user.SetInfo()

			# adds the new_admin to the administrators group
			$group = [ADSI]("WinNT://$computer/administrators,group")
			$group.add("WinNT://$new_admin,user")

			Write-Host "$(Get-Date -Format s) - [$($Computer)] Finished updating $($User)."
		} catch {
			Write-Host "$(Get-Date -Format s) - [$($Computer)] Failed to update $($User)." -foregroundcolor "red"
		}
	} Else {
		Write-Host "$(Get-Date -Format s) - [$($Computer)] Failed to connect." -foregroundcolor "red"
	}
}











###$Local_Admin = [adsi]"WinNT://$computer"
###$user = $Local_Admin.Create("User", $new_admin)
###$user.SetPassword($password)
###$user.SetInfo()

###$group = [ADSI]("WinNT://$computer/administrators,group")
###$group.add("WinNT://$new_admin,user")