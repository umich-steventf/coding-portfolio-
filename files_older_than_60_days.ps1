$time = (Get-Date).AddDays(-60)
$user = $env:USERNAME
$Path1 = "\\ls-rs-hoffj.locker.arc-ts.umich.edu\ls-rs-hoffj\users"

Get-ChildItem $Path1 -Recurse |   `
  Where-Object {$_.LastWriteTime -lt $time} | Out-File -FilePath .\older-than-60.txt