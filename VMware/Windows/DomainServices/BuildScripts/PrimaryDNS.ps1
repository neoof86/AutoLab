#configure DNS
$DomainName = "AutoLabDomain.com"

do {
  sleep -seconds 5
  $ScavengeServer = @(Get-ADDomainController).IPv4Address
  write-host "Waiting For DNS to be ready" -nonewline
  } while ( @(Get-ADDomainController).IPv4Address -like $null.Count -gt 0)


#  do {
#   sleep -seconds 5
#   $SetDNS = Set-DnsServerScavenging -ApplyOnAllZones -ScavengingState $True -ScavengingInterval 7.00:00:00 -RefreshInterval 7.00:00:00 -NoRefreshInterval 7.00:00:00
#   write-host "Waiting For DNS to be set" -nonewline
#   } while ((@($SetDNS) -like "*This operation*").Count -gt 0)


Set-DnsServerScavenging `
-ApplyOnAllZones `
-ScavengingState $True `
-ScavengingInterval 7.00:00:00 `
-RefreshInterval 7.00:00:00 `
-NoRefreshInterval 7.00:00:00

Set-DnsServerPrimaryZone -Name $DomainName -ReplicationScope "Forest"

Set-DnsServerPrimaryZone -Name $DomainName -DynamicUpdate "Secure"



Set-DnsServerZoneAging -Name $DomainName -Aging $True -ScavengeServers $ScavengeServer -RefreshInterval 7.00:00:00 -NoRefreshInterval 7.00:00:00


Set-DnsServerForwarder -Confirm:$False -IPAddress 1.1.1.1,8.8.8.8,8.8.4.4 -UseRootHint $True

ForEach($Subnet in $Subnets.Keys)
{
    Add-DnsServerPrimaryZone -NetworkID $Subnets[$Subnet] -ReplicationScope "Forest" -DynamicUpdate "Secure"
}

Get-DnsServerZone | Where-Object {$_.IsAutoCreated -eq $False} | Set-DnsServerZoneAging -Aging $True -ScavengeServers $ScavengeServer -RefreshInterval 7.00:00:00 -NoRefreshInterval 7.00:00:00
