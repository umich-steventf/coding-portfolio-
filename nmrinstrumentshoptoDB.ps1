# steventf
## MYSQL Connection
## This requires mysql connector net

## All variables will need changing to suit your environment
$server= "www.chem.lsa.umich.edu"
$username= "recharge"
$password= "ch3mR3c@rg3!"
$database= "nmrshop"

## The path will need to match the mysql connector you downloaded
[void][system.reflection.Assembly]::LoadFrom("C:\Program Files (x86)\MySQL\MySQL Connector Net 5.2.7\MySQL.Data.dll")

function global:Set-SqlConnection ( $server = $(Read-Host "SQL Server Name"), $username = $(Read-Host "Username"), $password = $(Read-Host "Password"), $database = $(Read-Host "Default Database") ) {
	$SqlConnection.ConnectionString = "server=$server;user id=$username;password=$password;database=$database;pooling=false;Allow Zero Datetime=True;"
}
function global:Get-SqlDataTable( $Query = $(if (-not ($Query -gt $null)) {Read-Host "Query to run"}) ) {
	if (-not ($SqlConnection.State -like "Open")) { $SqlConnection.Open() }
	$SqlCmd = New-Object MySql.Data.MySqlClient.MySqlCommand $Query, $SqlConnection
	$SqlAdapter = New-Object MySql.Data.MySqlClient.MySqlDataAdapter
	$SqlAdapter.SelectCommand = $SqlCmd
	$DataSet = New-Object System.Data.DataSet
	$SqlAdapter.Fill($DataSet) | Out-Null 
#	$SqlConnection.Close()
	return $DataSet.Tables[0]
}

Set-Variable SqlConnection (New-Object MySql.Data.MySqlClient.MySqlConnection) -Scope Global -Option AllScope -Description "Personal variable for Sql Query functions"
Set-SqlConnection $server $username $password $database
$SqlConnection.Open()
$cmd = New-Object MySql.Data.MySqlClient.MySqlCommand
$cmd.Connection  = $SqlConnection

# smtp configuration
$SMTP = New-Object Net.Mail.SmtpClient("mail-relay.itd.umich.edu")
$MSG = new-object Net.Mail.MailMessage
#$MSG.To.Add("chem-nmrshop@umich.edu")
$MSG.To.Add("brita@umich.edu")

$MSG.From = "chem-nmrshop@umich.edu"
$MSG.ReplyTo = "chem-nmrshop@umich.edu"
$MSG.IsBodyHTML = $True

# list of files
# $fileDirectory = "\\lsa-rsn.m.storage.umich.edu\lsa-rsn\Chemistry\LSA Chemistry Recharge\Rita's scripts\Files"
$fileDirectory = "\\lsa-depts.m.storage.umich.edu\lsa-chem\dept\Departmental Operations\Recharge\NMR Instrument Shop"

# $archiveDirectory = "\\lsa-rsn.m.storage.umich.edu\lsa-rsn\Chemistry\LSA Chemistry Recharge\Rita's scripts\Archive"
$archiveDirectory = "\\lsa-depts.m.storage.umich.edu\lsa-chem\dept\Departmental Operations\Recharge\NMR Instrument Shop\Archive" 


$logfilePath = split-path -parent $MyInvocation.MyCommand.Definition
$logfile = "$($logfilePath)\LogFile.txt"
# $logfile = "C:\Users\brita1\Documents\Rita's scripts\LogFile.txt"

# check if there is a log file in the directory

if (!(Test-Path $logfile)) {
     New-Item -Path "$($logfilePath)" -name LogFile.txt -type "file"
     Write-Host "create logfile"
}

# check if there are any files in the directory

If (!(Test-Path $fileDirectory\* -PathType Leaf))
{
  Write-Host "No new files"
  "'r'nNo new files" | Out-File "$($logfile)" -Append -Force
  exit
}

$date = Get-Date

"`r`n$date" | Out-File "$($logfile)" -Append -Force

$HTML = "$date<br>"

$date = '{0:yyyy-MM-dd}' -f $date

#create a folder for exported files

$archiveDirectory = $archiveDirectory + "\" + $date

if (!(Test-Path $archiveDirectory)) {
    New-Item -ItemType directory -Path "$archiveDirectory"
}



Write-Host $fileDirectory

# Use a foreach to loop through all the files in a directory.
foreach($file in Get-ChildItem -path $fileDirectory -File)
{
    Write-Host "`nFile name: " $file 
    $content = Get-Content $file.FullName
    # $name - instrument's name, the same as a name in the wo_categories table   
    $name = [System.IO.Path]::GetFileNameWithoutExtension($file)

  #  Write-Host $name
    $name = [System.IO.Path]::GetFileNameWithoutExtension($name)
      
  #  Write-Host $name
     
    # find id, rate (to put later into wo_requests table) for an instrument
    $sql = "SELECT id, rate from wo_categories where (name = '" + $name + "'" + " AND " + '`' + "group" + '`' + " = 'internal')"  
    $getcat = Get-SqlDataTable $sql
  # Write-Host $getcat
  
    if($getcat) {
        $cat_int = $getcat.id
       Write-Host $cat_int
        $rate_int = $getcat.rate
        $sql = "SELECT id, rate from wo_categories where (name = '" + $name + "'" + " AND " + '`' + "group" + '`' + " = 'external')"
        
        $getcat = Get-SqlDataTable $sql
        
        if($getcat) {        
        
          $cat_ext = $getcat.id
          $rate_ext = $getcat.rate
       
          $sql = "SELECT id, rate from wo_categories where (name = '" + $name + "'" + " AND " + '`' + "group" + '`' + " = 'non-UM academia')"
          $getcat = Get-SqlDataTable $sql
          if($getcat) {        
              $cat_noum = $getcat.id
              $rate_noum = $getcat.rate
          } 
        }    
        foreach ($line in $content)
        {
             $fields = $line -split '\t'
                 $contact = $fields[0]

                 $account_holder = $fields[5]
                 if ($account_holder -eq "") {
                    $account_holder = $contact
                 }     
                 [DateTime]$open_date = $fields[2]

                 [String]$open_date = '{0:yyyy-MM-dd hh:mm:ss}' -f $open_date

                 [string]$account = $fields[1]
# Write-Host $account

                 [int]$account_ext = $fields[1] 
# Write-Host $account_ext
                 $seconds = $fields[4]
# Write-Host $seconds
                 $hours = (New-TimeSpan -Seconds $seconds).TotalHours
# Write-Host $hours
                              
                 if  (($account_ext -ge 100) -and ($account_ext -le 199)) {
                    $cat = $cat_ext
                    $rate = $rate_ext      
                 }
                 elseif (($account_ext -ge 200) -and ($account_ext -le 299))  {
                      $cat = $cat_noum
                      $rate = $rate_noum 
                 }
                 else {
                    $cat = $cat_int
                    $rate = $rate_int 
                 }

   
                 $sql = "INSERT INTO wo_requests (summary, contact, account, account_holder, submit_date, open_date, close_date, category, labor) "
                 $sql = $sql + "VALUES('" +$name + "', '" + $contact + "', '" + $account + "', '" + $account_holder + "', '" + $date +"', '" + $open_date + "', '" + $date + "', '" + $cat + "', '" + $rate + "')"
 # Write-Host $sql    
                 $cmd.CommandText = $sql
              
                 $ok = $cmd.ExecuteNonQuery()
     
                 if (!$ok) {
                    Write-Host "Error executing MySQL query - Error 1"
                    "Error executing MySQL query - Error 1" >> $logfile
                    $HTML = "$($HTML)<br>Error executing MySQL query - Error 1<br>"
                    exit 
                 }
                 $getlastid = Get-SqlDataTable 'SELECT last_insert_id()'
                 $lastid = $getlastid.'last_insert_id()'
       
                 if ($account_holder -eq 'No-charge') {
                   $charge = 0 
                 }
                 else {
                    $charge = 1
                 }        
                 $sql = "INSERT INTO wo_timeline (id, time, name, hours, charge) "
                 $sql = $sql + "VALUES('" + $lastid + "', '" + $date + "', '" + $submitter + "', '" + $hours + "', '" + $charge + "')"
                 
 # Write-Host $sql          
 
                 $cmd.CommandText = $sql
                 $ok = $cmd.ExecuteNonQuery()
       
                 if (!$ok) {
                    Write-Host "Error executing MySQL query - Error 2"
                    "Error executing MySQL query - Error 2" >> $logfile
                    $HTML = "$($HTML)<br>Error executing MySQL query - Error 2<br>"
                    exit 
                 } 

                 if ($account -eq 'EXTERN') {
                        $sql = "SELECT wo_external.id as eid, name, company, address, phone, po_info, ap_contact FROM wo_external JOIN wo_requests ON wo_external.id = wo_requests.id  WHERE contact = '" + $contact + "' and name <> '' LIMIT 1"
                        $get_external = Get-SqlDataTable $sql
                        if ($get_external) {
                            $ex_id = $get_external.eid
                            $ex_name = $get_external.name
                            $ex_company = $get_external.company
                            $ex_address = $get_external.address
                            $ex_phone = $get_external.phone
                            $ex_po_info = $get_external.po_info
                            $ex_ap_contact = $get_external.ap_contact
                            $sql = "INSERT INTO wo_external (id, name, company, address, phone, po_info, ap_contact) VALUES ('" + $lastid + "', '" + $ex_name + "', '" + $ex_company + "', '" + $ex_address + "', '" + $ex_phone + "', '" + $ex_po_info + "', '" + $ex_ap_contact + "')"
                        } 
                        else {
                             $sql = "INSERT INTO wo_external (id) VALUES('" + $lastid + "')"
                        }
                                        
                        $cmd.CommandText = $sql
                        $ok = $cmd.ExecuteNonQuery()
                        if (!$ok) {
                        Write-Host "Error executing MySQL query - Error 3"
                        "Error executing MySQL query - Error 3" >> $logfile
                        $HTML = "$($HTML)<br>Error executing MySQL query - Error 3<br>"
                        exit 
                        }
                     }
                      
                }
        Write-Host $name " - data is exported to the database" 
	"$name  - data is exported to the database" | Out-File $logfile -Append -Force
	$HTML = "$($HTML)<br>$name  - data is exported to the database<br>"
        #move file to the archive
        Move-Item -path "$fileDirectory\$file" -Destination $archiveDirectory -Force
    }
    else {
        Write-Host $name " - no instrument with this name" -foregroundcolor "red"
	"ERROR - $name  - no instrument with this name" | Out-File $logfile -Append -Force
	$HTML = "$($HTML)<br><FONT COLOR='red'>ERROR</FONT> - $name  - no instrument with this name<br>"
    }
        
}
$SqlConnection.Close()
# Send Email
	$MSG.Subject = "MSSHOP - Report for instruments- $(Get-Date)"
	$MSG.Body = $HTML
	$SMTP.Send($MSG)



