$hosttarget = $args[0]
$port = $args[1]

if ($args[0] -eq $null) {Write-Host "Oops you forgot to set a host or IP to connect to" ; exit }
if ($args[1] -eq $null) {Write-Host "Oops you forgot to set a port to connect to" ; exit }

$wintest  = if (([System.Environment]::OSVersion.Platform) -like '*win*') {Write-Output Windows}

Write-Host 'Running against target ' $hosttarget
Write-Host 'With port ' $port


if ($IsWindows -or $ENV:OS -or $wintest) {
    Write-Host "OS is Windows"
do {
    Start-Sleep -s 5
$PortTest = Test-NetConnection -ComputerName $hosttarget -Port $port
If ($PortTest.TcpTestSucceeded -like '*false*') {$PortResult = $NULL
Write-Host 'Connection Failed.... Waiting 5 Seconds'} 
If ($PortTest.TcpTestSucceeded -like '*true*') {$PortResult = 'True'}

} while (!$PortResult)
Write-Host "Connection Successful"
Start-Sleep -s 5
} else {
    Write-Host "OS is Not Windows"
do {
    Start-Sleep -s 5
$PortTest = (nc -v -z -w 3 $hosttarget $port) 2>&1
If ($PortTest -like '*refused*') {$PortResult = $NULL 
Write-Host 'Connection Failed.... Waiting 5 Seconds'} 
If ($PortTest -like '*succeeded*') {$PortResult = 'True'}

} while (!$PortResult)
Write-Host "Connection Successful"
Start-Sleep -s 5

}