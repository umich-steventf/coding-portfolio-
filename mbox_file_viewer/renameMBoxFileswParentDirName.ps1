#Author: Steven Flack
#Purpose: Rename nested MBox files browsing within mboxview application.

Do {
	$Root_Dir = Read-Host "Please enter absolute path of master dir"
} While ($Root_Dir -eq "")

if ($Root_Dir[-1] -eq "\") {$Root_Dir = $Root_Dir.Substring(0,($Root_Dir.Length - 1))}

# Rename Files
Get-ChildItem $Root_Dir -Recurse | ?{$_.PSIsContainer} | % {
	$Parent_Dir = $(($_.FullName).Substring($Root_Dir.Length+1)).Replace(" ","-").Replace("\","-")
	$Parent_Dir
	Get-ChildItem "$($_.FullName)" | ?{!$_.PSIsContainer} | % {
		$FileName = "$($_.Name)"
		Write-Host "Rename file: $($_.FullName) to: $($Parent_Dir)-$($FileName)"
		Rename-Item "$($_.FullName)" "$($Parent_Dir)-$($FileName)" -Force
	}
}

# Move Files to new app
Get-ChildItem $Root_Dir -Recurse | ?{$_.PSIsContainer} | % {
	$Parent_Dir = $(($_.FullName).Substring($Root_Dir.Length+1)).Replace(" ","-").Replace("\","-")
	$Parent_Dir
	Get-ChildItem "$($_.FullName)" | ?{!$_.PSIsContainer} | % {
		$FileName = "$($_.Name)"
		Write-Host "Moving file: $($_.FullName) to $($Root_Dir)\"
		Move-Item "$($_.FullName)" "$($Root_Dir)\" -Force
	}
}

# Delete Empty Folders on old app
Get-ChildItem $Root_Dir -Recurse | Where {$_.PSIsContainer -and @(Get-ChildItem -LiteralPath $_.Fullname -Recurse | Where {!$_.PSIsContainer}).Length -eq 0} | Remove-Item -Recurse