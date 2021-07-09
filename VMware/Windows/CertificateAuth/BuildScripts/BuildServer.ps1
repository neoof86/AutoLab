#setup new AD Forest/Domain

do {
   sleep -seconds 5
   write-host "Waiting For Windows Options to install" -nonewline
   $WinOpts = Install-WindowsFeature ADCS-Cert-Authority, Telnet-Client, ADCS-Web-Enrollment -IncludeManagementTools
   } while ((@($WinOpts.ExitCode) -like '*Fail*').Count -gt 0)


   Install-AdcsCertificationAuthority `
   -ValidityPeriod Years `
   -ValidityPeriodUnits 10 `
   -CACommonName "AutoLabDomain CA Root" `
   -CAType EnterpriseRootCA `
   -KeyLength 2048 `
   -HashAlgorithmName SHA256 `
   -Force

   Install-AdcsWebEnrollment -Force

   New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\CertSvc\Configuration\AutoLabDomain CA Root" `
   -Name 'ValidityPeriodUnits' `
   -Value 10 `
   -PropertyType DWORD `
   -Force

   Stop-Service -Name "certsvc"
   Start-Service -Name "certsvc"
