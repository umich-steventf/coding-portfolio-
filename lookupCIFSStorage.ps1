$uniqname = $Path = ""
$CIFS_SHARE_MAX = 100

Write-Host "Path Lookup for CIFS Storage by uniqname Script"
Write-Host ""

Do {
	$uniqname = Read-Host "Enter user uniqname"
} While ($uniqname -eq "")

$start = 1
While ($start -le $CIFS_SHARE_MAX) {
	If ($start.length -eq 1) {
		$Number = $("{0:D2}" -f $start)
	} Else {
		$Number = $start
	}

	$TEMP = "\\lsa-research$($Number).m.storage.umich.edu\lsa-research$($Number)\$($uniqname)\"
	If (Test-Path $TEMP) {
		#DFS Path \\dfs.lsa.umich.edu\lsa\research\uniqname
		$Path = $TEMP
		Write-Host "Found CIFS Storage for $($uniqname)."
		Write-Host "Windows: $($Path)"
		Write-Host "Mac: CIFS:$($Path.Replace("\","/"))"
		#Break
	}
	$TEMP = "\\lsa-research$($Number).m.storage.umich.edu\lsa-research$($Number)\$($uniqname)-group\"
	If (Test-Path $TEMP) {
		#DFS Path \\dfs.lsa.umich.edu\lsa\research\uniqname-group
		$Path = $TEMP
		Write-Host "CIFS Storage found for $($uniqname)."
		Write-Host "Windows mount path: $($Path)"
		Write-Host "Mac mount path: CIFS:$($Path.Replace("\","/"))"
		#Break
	}

	$start++
}

If ($Path -eq "") {
	Write-Host "CIFS Storage not found for $($uniqname)."
}


Write-Host "Press any key to continue ..."
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")