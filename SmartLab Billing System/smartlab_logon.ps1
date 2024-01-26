# Load .NET Class(es)
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 

# Define Vars
$ver = "1.0"
$BillingHome = "C:\ProgramData\BioPhysics\SmartLab\data\"
$BillingFile = "$($BillingHome)smartlab_billing.log"
$AdminUser = "crashcart"
$SID = "$Env:Username$(Get-Date -f yyyyMMddHHmmss)"

# Define Windows Form
$objForm = New-Object System.Windows.Forms.Form 
$objForm.Text = "Data Entry Form"
$DisW = [System.Windows.Forms.Screen]::AllScreens[0].Bounds.Width
$DisH = [System.Windows.Forms.Screen]::AllScreens[0].Bounds.Height
$objForm.Size = New-Object System.Drawing.Size($DisW,$DisH)
$objForm.StartPosition = "CenterScreen"
$objForm.FormBorderStyle = "None"
$objForm.Topmost = $True

# Define Windows Form Handler(s) and Event(s)
$objForm.KeyPreview = $True
# Handler for {ENTER} key
$objForm.Add_KeyDown({if ($_.KeyCode -eq "Enter") {
	$OKButton.PerformClick();
}})
# Handler for {ESC} key
$objForm.Add_KeyDown({if ($_.KeyCode -eq "Escape") {
	$CancelButton.PerformClick();
}})
# Event for Form Load 
$objForm.add_Load({
	# Check for billing directory, if not found create directory
	If (!(Test-Path "$($BillingHome)")) {
		New-Item "$($BillingHome)" -Type Directory
		$ACL = Get-ACL "$($BillingHome)"
		$Rule = New-Object System.Security.AccessControl.FileSystemAccessRule("Users","Modify", "ContainerInherit, ObjectInherit", "None", "Allow")
		$ACL.AddAccessRule($Rule)
		Set-ACL "$($BillingHome)" $ACL
	}
	
	# Check for data file, if not found create a new file
	If (!(Test-Path "$($BillingFile)")) { New-Item "$($BillingFile)" -Type File }

	# Search for recent event 6008 to detect crashes which may cause issues in the billing report
	$UnexpectedShutdownEvent = Get-WinEvent -MaxEvents 1 -FilterHashTable @{LogName='System';ID=6008}

	# If an event is found only look at the most recent event
	If ($UnexpectedShutdownEvent.Count -gt 0) {
		# If the event found was created on the same day at runtime, log for reference
		If ((New-TimeSpan -Start $UnexpectedShutdownEvent.TimeCreated -End (Get-Date)).Days -eq 0) {
			# Add User billing info to data file
			Add-Content "$($BillingFile)" "$(Get-Date),,,,$($UnexpectedShutdownEvent.Message),UNEXPECTED_SHUTDOWN_EVENT"
		}
	}
}) 

# Event for Form Closing
$objForm.add_Closing({
	If (($lblUserbox.Text -eq "") -Or ($txtShortcode.Text -eq "") -Or ($txtFaculty.Text -eq "")) {
		If (($txtFaculty.Text.ToLower() -eq "$($AdminUser)") -Or ($Env:Username[-1] -match '^[0-9]$')) {
			Write-Host "LSA IT Admin Logon - Abort logoff trigger..."
			[System.Windows.Forms.MessageBox]::Show("Exiting scripting with no modifications to data file." , "Admin Override Exit");
		} Else {
			Write-Host "Null Values Found LOG OFF USER!!!";
			[System.Windows.Forms.MessageBox]::Show("Logging off user session due to lack of billing information." , "Billing Data Required.");

			# Sleep for 3 seconds
			Sleep 3

			# Logoff user (4-force, 0-normal)
			(Get-WMIObject win32_operatingsystem).Win32Shutdown(4);
		}
	}
})

# Create Label(s) for User Name Information
$lblTitle = New-Object System.Windows.Forms.Label
$lblUser = New-Object System.Windows.Forms.Label
$lblUser.Size = New-Object System.Drawing.Size(120,20)
$lblTitle.Text = "Smart Lab Billing v$($ver)"
$lblTitle.Font = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Bold)
$lblTitle.TextAlign = "MiddleCenter"
$lblTitle.Size = New-Object System.Drawing.Size(280,20)
$lblUser.Text = "User Uniqname:"
$lblUserbox = New-Object System.Windows.Forms.Label
$lblUserbox.BorderStyle = "Fixed3D"
$lblUserbox.Size = New-Object System.Drawing.Size(160,20)
$lblUserbox.Text = "$Env:Username"

# Position & Add Label(s) for User Name Information on Windows Form
$lblTitle.Location = New-Object System.Drawing.Size((($DisW/2)-($lblTitle.Size.Width/2)),(($DisH/2)-60))
$objForm.Controls.Add($lblTitle)
$lblUser.Location = New-Object System.Drawing.Size((($DisW/2)-(($lblUser.Size.Width+$lblUserbox.Size.Width)/2)),(($DisH/2)-20))
$objForm.Controls.Add($lblUser)
$lblUserbox.Location = New-Object System.Drawing.Size((($DisW/2)-((($lblUser.Size.Width+$lblUserbox.Size.Width)/2)-$lblUser.Size.Width)),(($DisH/2)-20))
$objForm.Controls.Add($lblUserbox)

# Create Label(s) and Texbox(es) for Shortcode Information
$lblShortcode = New-Object System.Windows.Forms.Label
$lblShortcode.Size = New-Object System.Drawing.Size(120,20)
$lblShortcode.Text = "Shortcode:"
$txtShortcode = New-Object System.Windows.Forms.TextBox
$txtShortcode.Size = New-Object System.Drawing.Size(160,20)
$txtShortcode.MaxLength = 6

# Position & Add Label(s) and Texbox(es) for Shortcode Information on Windows Form
$lblShortcode.Location = New-Object System.Drawing.Size((($DisW/2)-(($lblShortcode.Size.Width+$txtShortcode.Size.Width)/2)),($DisH/2))
$objForm.Controls.Add($lblShortcode)
$txtShortcode.Location = New-Object System.Drawing.Size((($DisW/2)-((($lblShortcode.Size.Width+$txtShortcode.Size.Width)/2)-$lblShortcode.Size.Width)),($DisH/2))
$objForm.Controls.Add($txtShortcode)

# Create Label(s) and Textbox(es) for Faculty Information
$lblFaculty = New-Object System.Windows.Forms.Label
$lblFaculty.Size = New-Object System.Drawing.Size(120,20)
#$lblFaculty.Text = "Faculty Uniqname:"
$lblFaculty.Text = "PI Uniqname:"
$txtFaculty = New-Object System.Windows.Forms.TextBox
$txtFaculty.Size = New-Object System.Drawing.Size(160,20)
$txtFaculty.MaxLength = 8

# Position & Add Label(s) and Textbox(es) for Faculty Information on Windows Form
$lblFaculty.Location = New-Object System.Drawing.Size((($DisW/2)-(($lblFaculty.Size.Width+$txtFaculty.Size.Width)/2)),(($DisH/2)+20))
$objForm.Controls.Add($lblFaculty)
$txtFaculty.Location = New-Object System.Drawing.Size((($DisW/2)-((($lblFaculty.Size.Width+$txtFaculty.Size.Width)/2)-$lblFaculty.Size.Width)),(($DisH/2)+20))
$objForm.Controls.Add($txtFaculty)

# Create & Position OK Button on Windows Form
$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Size = New-Object System.Drawing.Size(75,23)
$OKButton.Location = New-Object System.Drawing.Size((($DisW/2)+((($lblShortcode.Size.Width+$txtShortcode.Size.Width)/2)-$OKButton.Size.Width)),(($DisH/2)+50))
$OKButton.Text = "OK"
$OKButton.Add_Click({
	# Close and do nothing if Admin User
	If (($txtFaculty.Text.ToLower() -eq "$($AdminUser)") -Or ($Env:Username[-1] -match '^[0-9]$')) {
		# Save admin mode information in windows user session for log off
		[Environment]::SetEnvironmentVariable("SmartLab_SID", "ADMIN", "User")
		[Environment]::SetEnvironmentVariable("SmartLab_User", "$NULL", "User")
		[Environment]::SetEnvironmentVariable("SmartLab_PI", "$NULL", "User")
		[Environment]::SetEnvironmentVariable("SmartLab_Shortcode", "$NULL", "User")

		# Close form
		$objForm.Close();
	} Else {
		# Check for Null Values
		If (($lblUserbox.Text -eq "") -Or ($txtShortcode.Text -eq "") -Or ($txtFaculty.Text -eq "")) {
			If ($txtShortcode.Text -eq "") { $lblShortcode.ForeColor = "Red" };
			If ($txtFaculty.Text -eq "") { $lblFaculty.ForeColor = "Red" };
			[System.Windows.Forms.MessageBox]::Show("Shortcode and Faculty Uniqname fields are required." , "Required Fields");
		# Check for Valid Shortcode
		} ElseIf (($txtShortcode.Text.Length -ne 6) -Or ($txtShortcode.Text -NotMatch "^([0-9][0-9][0-9][0-9][0-9][0-9])$")) {
			$lblShortcode.ForeColor = "Red";
			[System.Windows.Forms.MessageBox]::Show("A valid Shortcode must be 6 characters in length and numbers only." , "Shortcode Not Valid");
		# Record user, shortcode, faculty, and time
		} Else {
			# Reset form
			$lblShortcode.ForeColor = "Black";
			$lblFaculty.ForeColor = "Black";

			# Add User billing information to windows user session vars to use at logoff
			[Environment]::SetEnvironmentVariable("SmartLab_SID", "$($SID)", "User")
			[Environment]::SetEnvironmentVariable("SmartLab_User", "$($Env:Username)", "User")
			[Environment]::SetEnvironmentVariable("SmartLab_PI", "$($txtFaculty.Text)", "User")
			[Environment]::SetEnvironmentVariable("SmartLab_Shortcode", "$($txtShortcode.Text)", "User")
	
			# Add User billing info to data file
			Add-Content "$($BillingFile)" "$(Get-Date),$($SID),$($lblUserbox.Text),$($txtShortcode.Text),$($txtFaculty.Text),LOGON"

			# Close form
			$objForm.Close();
		}
	}
})
$objForm.Controls.Add($OKButton)

# Create & Position Cancel Button on Windows Form
$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Size = New-Object System.Drawing.Size(75,23)
$CancelButton.Location = New-Object System.Drawing.Size((($DisW/2)+((($lblShortcode.Size.Width+$txtShortcode.Size.Width)/2)-(($CancelButton.Size.Width*2)+10))),(($DisH/2)+50))
$CancelButton.Text = "Cancel"
$CancelButton.Add_Click({
	$LogOff = [System.Windows.Forms.MessageBox]::Show("Are you sure you want to cancel and log off?", "Confirm", [System.Windows.Forms.MessageBoxButtons]::YesNo)
	If ($LogOff -eq "Yes") {
		# Close form to initiate log off option
		# Add User billing information to windows user session vars to use at logoff
		[Environment]::SetEnvironmentVariable("SmartLab_SID", "CANCEL", "User")

		# Close form
		$objForm.Close();
	}
})
$objForm.Controls.Add($CancelButton)

# Show Windows Form
$objForm.Add_Shown({$objForm.Activate()})
[void] $objForm.ShowDialog()