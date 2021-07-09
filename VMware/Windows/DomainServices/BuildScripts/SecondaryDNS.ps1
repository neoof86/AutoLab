
#configure DNS
$computer = "$($env:ComputerName)"

do {
  sleep -seconds 5
  $ScavengeServer = @(Get-ADDomainController).IPv4Address
  write-host "Waiting For DNS to be ready" -nonewline
  } while ( @(Get-ADDomainController).IPv4Address -like $null.Count -gt 0)


Set-DnsServerScavenging `
-ComputerName $ScavengeServer `
-ApplyOnAllZones `
-ScavengingState $True `
-ScavengingInterval 7.00:00:00 `
-RefreshInterval 7.00:00:00 `
-NoRefreshInterval 7.00:00:00

Set-DnsServerForwarder -ComputerName $computer -Confirm:$False -IPAddress 1.1.1.1,8.8.8.8,8.8.4.4 -UseRootHint $True

write-host "Attempted secondary DNS set" 
