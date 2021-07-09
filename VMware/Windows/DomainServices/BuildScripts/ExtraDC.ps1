
net user administrator Aut0L@b!
net user administrator /passwordreq:yes
Set-DNSClientServerAddress -InterfaceIndex ((Get-NetAdapter -name Ethernet0).ifIndex) -ServerAddresses ("192.168.70.21","192.168.70.22")
#add a domain controller


do {
   sleep -seconds 5
   write-host "Waiting For AD to install" -nonewline
   $ADExists = Install-WindowsFeature AD-Domain-Services, RSAT-AD-PowerShell, RSAT-ADDS, RSAT-AD-AdminCenter, RSAT-ADDS-Tools, Telnet-Client
   } while ((@($ADExists.ExitCode) -like '*Fail*').Count -gt 0)

$DomainName = "AutoLabDomain.com"
$NetbiosName = "AutoLab"
$SafeModePwd = ConvertTo-SecureString 'Aut0L@b!' -AsPlainText -Force


$domainadmin = 'administrator' + '@' + $DomainName
$cred = New-Object -typename System.Management.Automation.PSCredential -argumentlist $domainadmin,$SafeModePwd

Install-ADDSDomainController `
-Confirm:$False `
-Credential $cred `
-DomainName $DomainName `
-InstallDns `
-SafeModeAdministratorPassword $SafeModePwd

#new dc reboots
