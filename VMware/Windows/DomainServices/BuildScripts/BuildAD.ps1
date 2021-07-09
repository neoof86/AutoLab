#setup new AD Forest/Domain

do {
   sleep -seconds 5
   write-host "Waiting For AD to install" -nonewline
   $ADExists = Install-WindowsFeature AD-Domain-Services, RSAT-AD-PowerShell, RSAT-ADDS, RSAT-AD-AdminCenter, RSAT-ADDS-Tools, Telnet-Client
   } while ((@($ADExists.ExitCode) -like '*Fail*').Count -gt 0)


$DomainName = "AutoLabDomain.com"
$NetbiosName = "AutoLab"
$SafeModePwd = ConvertTo-SecureString 'Aut0L@b!' -AsPlainText -Force
net user administrator Aut0L@b!
net user administrator /passwordreq:yes
Install-ADDSForest `
-Confirm:$False `
-CreateDnsDelegation:$False `
-DomainMode "WinThreshold" `
-DomainName $DomainName `
-DomainNetbiosName $NetbiosName `
-ForestMode "WinThreshold" `
-SafeModeAdministratorPassword $SafeModePwd

#new DC restarts at this point
