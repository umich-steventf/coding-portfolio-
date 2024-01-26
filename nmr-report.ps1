# steventf - sourced from Dan St. Pierre's script
# Vars
$Source = "\\lsa-biop.m.storage.umich.edu\lsa-biop\Biophysics NMR Center (Vivek)\Bruker 500 solution & solids\Recharge Data\"
$Archive = "\\lsa-biop.m.storage.umich.edu\lsa-biop\Biophysics NMR Center (Vivek)\Bruker 500 solution & solids\Recharge Data\Archive\"
$Computer = "biop-500-4008.biop.lsa.umich.edu"
$Instrument = "500 NMR Bruker Solution (#858)"

# SMTP Configuration
$SMTP = New-Object Net.Mail.SmtpClient("mail-relay.itd.umich.edu")
$MSG = new-object Net.Mail.MailMessage
#$MSG.To.Add("dstpierr@umich.edu")
$MSG.To.Add("brd-nmr-recharge@umich.edu")
$MSG.From = "lsa.it.rsn.biophysics@umich.edu"
$MSG.ReplyTo = "lsa.it.rsn.biophysics@umich.edu"
$MSG.IsBodyHTML = $True
If (Test-Path "$($Source)") {
	$Files = Get-ChildItem -Path "$($Source)" -Filter "*.csv" | Select -ExpandProperty Name
	If ($Files.Count -gt 0) {
		ForEach ($File in $Files) {
			$RechargeFile = $HTML = $Month = $Year = ""

			$RechargeFile = Import-CSV "$($Source)$($File)" -Header DATETIME, USER, SHORTCODE, PI, STARTDATETIME, ENDDATETIME, DURATION
			$Month = (Get-Culture).DateTimeFormat.GetMonthName($File.Replace(".csv","").Split(".")[-1].Substring(5))
			$Year = $File.Replace(".csv","").Split(".")[-1].Substring(0,4)

			# build html report
			#$HTML = "$($HTML)<font size=`"4`"><b><u>LSA BioPhysics NMR Recharge Report</b></u></font><br><small>for </small>$($Computer) - $($Instrument) - $(Get-Date -f "MMMM yyyy")<br><br>"
			$HTML = "$($HTML)<font size=`"4`"><b><u>LSA BioPhysics NMR Recharge Report</b></u></font><br><small>for </small>$($Computer) - $($Instrument) - $($Month) $($Year)<br><br>"
		
			$RechargeFile | % { 
				$_.DATETIME = [DATETIME]$_.DATETIME
				$_.SHORTCODE = [INT32]$_.SHORTCODE
				$_.STARTDATETIME = [DATETIME]$_.STARTDATETIME
				$_.ENDDATETIME = [DATETIME]$_.ENDDATETIME
				$_.DURATION = [MATH]::Round([DECIMAL]$_.DURATION,2)
			}

			# sort array by shortcode then date\time
			$RechargeFile = $RechargeFile | Sort-Object SHORTCODE, DATETIME
	
			# loop through monthly event to bill array to build HTML report
			$SHORTCODE = ""
			$TOTALHOURS = $HOURS = $Counter = 0
			$RechargeFile | % {
				Write-Host $_
				If ($_.SHORTCODE -ne $SHORTCODE) {
					If ($SHORTCODE -ne "") {
						$HTML = "$($HTML)</table><b>Total Hours for Shortcode: $($HOURS)</b><br><br>"
						$TOTALHOURS = $TOTALHOURS + $HOURS
						$HOURS = 0
					}
					$HTML = "$($HTML)<b>Shortcode: $($_.SHORTCODE)</b>`
						<table bgcolor=`"#dddddd`" border=1><tr>`
						<th><b>Shortcode</b></th>`
						<th><b>User</b></th>`
						<th><b>Primary Investigator</b></th>`
						<th><b>Start Date\Time</b></th>`
						<th><b>End Date\Time</b></th>`
						<th><b>Duration (hrs)</b></th>`
						</tr>"
				}
			
				# add events to body of table
				$HTML = "$($HTML)<tr><td>$($_.SHORTCODE)</td><td>$($_.USER)</td><td>$($_.PI)</td><td>$($_.STARTDATETIME)</td><td>$($_.ENDDATETIME)</td><td>$($_.DURATION)</td></tr>"
				$SHORTCODE = $_.SHORTCODE
				$HOURS = $HOURS + $_.DURATION
				$Counter++
				
				# clean up if end of for loop (last item in array)
				If ($Counter -eq ($RechargeFile | Measure).Count) {
					$HTML = "$($HTML)</table><b>Total Hours for Shortcode: $($HOURS)</b><br><br>"
					$TOTALHOURS = $TOTALHOURS + $HOURS
					$HOURS = 0
				}
			}
		
			# Send Email
			$MSG.Subject = "LSA BioPhysics NMR Recharge Report for $($Computer) - $($Instrument) - $($Month) $($Year)"
			$MSG.Body = $HTML
			$SMTP.Send($MSG)

			# Move File
			Move-Item "$($Source)$($File)" "$($Archive)" -Force
		} # End ForEach $File in $Files
	} Else {
		# Exit script no files found
		Write-Host "No Source Files Found."
		Exit
	}
}