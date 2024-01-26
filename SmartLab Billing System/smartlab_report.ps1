#Define Vars
$ver = "1.0"
$BillingHome = "C:\ProgramData\BioPhysics\SmartLab\data\"
$BillingFile = "$($BillingHome)smartlab_billing1.log"
$BillingArchive = "\\lsa-rsn.m.storage.umich.edu\lsa-rsn\Biophysics\SmartLab\Billing\data\"

# smtp configuration
$SMTP = New-Object Net.Mail.SmtpClient("mail-relay.itd.umich.edu")
$MSG = new-object Net.Mail.MailMessage
$MSG.To.Add("biop-smartlab-recharge@umich.edu")
#$MSG.To.Add("dstpierr@umich.edu")
$MSG.From = "lsa.it.rsn.biophysics@umich.edu"
$MSG.ReplyTo = "lsa.it.rsn.biophysics@umich.edu"
$MSG.IsBodyHTML = $True

$ComputerList = @(`
"biop-smartlab1",`
"biop-smartlab2",`
"biop-smartlab3",`
"biop-smartlab4",`
"biop-smartlab5"`
)

$ComputerList | % {

	$Computer = "$($_)"
	$MonthlyEvents = $MonthlyEventsToBill = @()
	$HTML = $RechargeFile = ""
	
	# archive data file, get contents, and rest data file
	If (Test-Path "\\$Computer\$($BillingFile.Replace('C:\','C$\'))") {
	
		$File = Get-Item "\\$Computer\$($BillingFile.Replace('C:\','C$\'))"
		Copy-Item "$($File.FullName)" "\\$Computer\$($BillingHome.Replace('C:\','C$\'))$($Computer)-$(Get-Date -f yyyy)$(Get-Date -f MM)-$($File.name)" -Force
		Copy-Item "$($File.FullName)" "$($BillingArchive)$($Computer)-$(Get-Date -f yyyy)$(Get-Date -f MM)-$($File.name)" -Force
		$RechargeFile = Get-Content $File
		Clear-Content $File
		
		$RechargeFile | % {
			$Event = New-Object PSObject -Property @{
				DATETIME = $_.Split(',')[0]
				SID = $_.Split(',')[1]
				USER = $_.Split(',')[2]
				SHORTCODE = $_.Split(',')[3]
				PI = $_.Split(',')[4]
				EVENT = $_.Split(',')[5]
			}
						
			# add information into events array
			$MonthlyEvents += $Event
		}
	
		# sort array by date\time
		$MonthlyEvents = $MonthlyEvents | Sort-Object DATETIME

		# calc time durations
		# calc partial billing for begining of the month (if needed)
		# get date time of first log off event
		$DATETIME = Get-Date ($MonthlyEvents | Where {$_.EVENT -eq "LOGOFF"} | Sort DATETIME)[0].DateTime
		# search for a log on event before the first log off event
		$LogOnEvent = ($MonthlyEvents | Where {$_.EVENT -eq "LOGON"} | Where {$_.DATETIME -lt $DATETIME} | Sort DATETIME)
		If (($LogOnEvent | Measure).Count -le 0) {
			# calc partial billing for start of the month
			$EventDuration = "{0:N4}" -f (New-TimeSpan –Start $(Get-Date -f "MM/01/yyyy 00:00:01") –End $LogOnEvent.DATETIME).TotalHours
			$Event = New-Object PSObject -Property @{
				STARTDATETIME = $(Get-Date -f "MM/01/yyyy 00:00:01")
				ENDDATETIME = $LogOnEvent.DATETIME
				USER = $LogOnEvent.USER
				SHORTCODE = $LogOnEvent.SHORTCODE
				PI = $LogOnEvent.PI
				DURATION = $EventDuration
				ERRORS = "Partial"
			}
			# add information into events array
			$MonthlyEventsToBill += $Event
		}

		# calc time duration for all remaining events
		($MonthlyEvents | Where {$_.EVENT -eq "LOGON"} | Sort DATETIME) | % {
			# get SID and DATETIME for logon event
			$SID = $DATETIME = $LogOnEvent = $LogOffEvent = $Match = $LogOffEventCrashDate = $LogOffEventCrashTime = $EventDuration = ""
			$SID = $_.SID
			$DATETIME = Get-Date $_.DATETIME
	
			# search for matching SID for logoff event
			$LogOffEvent = ($MonthlyEvents | Where {$_.SID -eq $SID} | Where {$_.EVENT -eq "LOGOFF"} | Sort DATETIME)
		
			If (($LogOffEvent | Measure).Count -gt 0) {
				# found log off event, now find duration of session (log off - logon events)
				$EventDuration = "{0:N4}" -f (New-TimeSpan –Start $_.DATETIME –End $LogOffEvent[0].DATETIME).TotalHours
		
				# save information in new array
				$Event = New-Object PSObject -Property @{
					STARTDATETIME = $_.DATETIME
					ENDDATETIME = $LogOffEvent[0].DATETIME
					USER = $_.USER
					SHORTCODE = $_.SHORTCODE
					PI = $_.PI
					DURATION = $EventDuration
					ERRORS = $False
				}
			} Else {
				# no log off event found. search for matching SID for UNEXPECTED_SHUTDOWN_EVENT
				$LogOffEvent = ($MonthlyEvents | Where {$_.EVENT -eq "UNEXPECTED_SHUTDOWN_EVENT"} | Where {$_.DATETIME -gt $DATETIME} | Sort DATETIME)
		
				If (($LogOffEvent | Measure).Count -gt 0) {
					# found log off event, now find duration of session (log off - logon events)
					$LogOffEvent.PI.Replace('?','') -match ".* (\d+/\d+/\d+) .*" | Out-Null
					$LogOffEventCrashDate = $Matches[1]
					$LogOffEvent.PI -match ".* (\d+:\d+:\d+ [AP]M) .*" | Out-Null
					$LogOffEventCrashTime = $Matches[1]
					$EventDuration = "{0:N4}" -f (New-TimeSpan –Start $_.DATETIME –End $(Get-Date "$LogOffEventCrashDate $LogOffEventCrashTime" -f "MM/dd/yyyy HH:mm:ss")).TotalHours
		
					# save information in new array
					$Event = New-Object PSObject -Property @{
						STARTDATETIME = $_.DATETIME
						ENDDATETIME = "$(Get-Date "$LogOffEventCrashDate $LogOffEventCrashTime" -f "MM/dd/yyyy HH:mm:ss")"
						USER = $_.USER
						SHORTCODE = $_.SHORTCODE
						PI = $_.PI
						DURATION = $EventDuration
						ERRORS = $True
					}
				} Else {
					# missing crash event and logoff event for SID
					# save information in new array
					$LogOnEvent = ($MonthlyEvents | Where {$_.EVENT -eq "LOGON"} | Where {$_.DATETIME -gt $DATETIME} | Sort DATETIME)
					If (($LogOnEvent | Measure).Count -le 0) {
						# calc partial billing for end of the month
						$EventDuration = "{0:N4}" -f (New-TimeSpan –Start $_.DATETIME –End $(Get-Date -f "MM/dd/yyyy HH:mm:ss")).TotalHours
						$Event = New-Object PSObject -Property @{
							STARTDATETIME = $_.DATETIME
							ENDDATETIME = $(Get-Date -f "MM/dd/yyyy HH:mm:ss")
							USER = $_.USER
							SHORTCODE = $_.SHORTCODE
							PI = $_.PI
							DURATION = $EventDuration 
							ERRORS = "Partial"
						}
					} Else {
						# unknown error
						$Event = New-Object PSObject -Property @{
							STARTDATETIME = $_.DATETIME
							ENDDATETIME = $Null
							USER = $_.USER
							SHORTCODE = $_.SHORTCODE
							PI = $_.PI
							DURATION = $Null
							ERRORS = $True
						}
					}
				}			
			}
			# add information into events array
			$MonthlyEventsToBill += $Event
		}
	
		# sort array by shortcode then date\time
		$MonthlyEventsToBill = $MonthlyEventsToBill | Sort SHORTCODE, STARTDATETIME
	
		# build html report
		$HTML = "$($HTML)<font size=`"4`"><b><u>LSA BioPhysics SmartLab Recharge Report</b></u></font><br><small>for </small>$($Computer) - $(Get-Date -f "MMMM yyyy")<br><br>"
	
		# loop through monthly event to bill array to build HTML report
		$SHORTCODE = ""
		$TOTALHOURS = $HOURS = $Counter = 0
		$MonthlyEventsToBill | % {
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
					<th><b>Error Correction?</b></th>`
					</tr>"
			}
		
			# add events to body of table
			$HTML = "$($HTML)<tr><td>$($_.SHORTCODE)</td><td>$($_.USER)</td><td>$($_.PI)</td><td>$($_.STARTDATETIME)</td><td>$($_.ENDDATETIME)</td><td>$($_.DURATION)</td><td>$($_.ERRORS)</td></tr>"
			$SHORTCODE = $_.SHORTCODE
			$HOURS = $HOURS + $_.DURATION
			$Counter++
			
			# clean up if end of for loop (last item in array)
			If ($Counter -eq ($MonthlyEventsToBill | Measure).Count) {
				$HTML = "$($HTML)</table><b>Total Hours for Shortcode: $($HOURS)</b><br><br>"
				$TOTALHOURS = $TOTALHOURS + $HOURS
				$HOURS = 0
			}
		}
		$HTML = "$($HTML)<b>Total Hours for $($Computer): $($TOTALHOURS)</b>"
	} Else {
		$HTML = "No data file found for $($Computer). Missing file path: \\$Computer\$($BillingFile.Replace('C:\','C$\'))"
	}
	
	# Send Email
	$MSG.Subject = "LSA BioPhysics SmartLab Recharge Report for $($Computer) - $(Get-Date)"
	$MSG.Body = $HTML
	$SMTP.Send($MSG)

	Sleep 5
}