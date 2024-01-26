# Variables

$SOURCE = "\\lsa-chem.m.storage.umich.edu\lsa-chem\dept\Teaching Lab\bt_nmr\upstairs"
$Destination = "\\lsa-chem.m.storage.umich.edu\lsa-chem\dept\Teaching Lab\bt_nmr\upstairs\Archive"
$FileAge = $(Get-Date).AddMinutes(-5)
$FileArchiveAge = $(Get-Date).AddDays(-60)

# SMTP Client
$SMTPServer = "mail-relay.itd.umich.edu"
$msgFrom = "chem-tl-do-not-reply@umich.edu"
$msgReplyTo = "chem-tl-do-not-reply@umich.edu"
$msgSubject = "LSA Chemistry NMR Results - $(Get-Date)"
$msgBody = "This is automated email. Please do not reply."

# smtp client
$SMTP = New-Object Net.Mail.SmtpClient("$($SMTPServer)")

# Script Main
            $files = Get-ChildItem $SOURCE -File
				#### Check if Files Were Found

				Write-Host "$($files.Count) file(s) were found."
				If ($Files.Count -gt 0) {			
					ForEach ($File in $Files) {
						Write-Host "Processing $($File)..."
                                #### Check Sample Data is Older than 5 Minutes
                                If (($($File) | Select -ExpandProperty LastWriteTime) -le $FileAge) {
                                    Write-Host "File $($File) has a date modified time of $($File | Select -ExpandProperty LastWriteTime) and is older than $($FileAge)"

                                    #### Info for email address
                                    $uniqname = ("$((Split-Path $File -Leaf).Split("_")[0])")
                                    $umich = "@umich.edu"
                                    $email = "$($uniqname)$($umich)"
                                    write-host "$($email)"
                                    
                                    #### File Locations
                                    $filepath = "$($Source)\$($File)"
                                    $rename = Get-Date -Format fffffff
                                    $archivepath = "$($Destination)\$($rename)$($File)"
                                    
                                    ##### Send File to Student
							        # smtp message
							        $MSG = new-object Net.Mail.MailMessage
							        # email parameters
							        $MSG.To.Add("$($email)")
							        $MSG.From = "$($msgFrom)"
							        $MSG.ReplyTo = "$($msgFrom)" 
							        $attFile = New-Object System.Net.Mail.Attachment("$($filepath)")
							        $MSG.Attachments.Add($attFile)
							        $MSG.IsBodyHTML = $True
							        $MSG.Subject = "$($msgSubject)"
							        $MSG.Body = "$($msgBody)"
							        $MSG.Send
							        $SMTP.Send($MSG)
							        $attFile.Dispose()
							        $MSG.Dispose()
							        Sleep 2
                                    #### Move File to Archive Folder
                                    move-item -Path $($filepath) -Destination "$($archivepath)"
                                }  #end if block checking for time and emailing
                        }  #end ForEach loop going through all files in $Source
                    }   #end if block checking that there are files
                
#Post main-script
            $archivefiles = Get-ChildItem $Destination -File
            Write-Host "$($archivefiles.Count) file(s) were found."
            If ($archivefiles.Count -gt 0) {
                ForEach ($File in $archivefiles) {
                    #### Checkes if files are older than FileArchiveAge and if so, it deletes them

                    #### archive file location (for easier edits)
                    $archivefile = "$($Destination)\$($File)"
                    If ($(Get-Item $($archivefile) | Select -ExpandProperty LastWriteTime) -le $FileArchiveAge) {				
							Write-Host "File $($File) has a date modified time of $(Get-Item $File | Select -ExpandProperty LastWriteTime) and is older than $($FileArchiveAge)"

							# Delete File
							Remove-Item "$($archivefile)" -Force
                    }   # ends if block
                }   # ends ForEach loop
            }   # Ends if block