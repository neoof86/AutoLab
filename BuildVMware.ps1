#Terraform VMware Build
$RootDir = pwd

#Windows AD
Write-Host "Building AD Servers"
cd ./VMware/
cd ./Windows/
cd ./DomainServices/
cp $RootDir/VMware/vars.tf .
terraform init
terraform apply -auto-approve
cd $RootDir


#Windows CA
Write-Host "Building CA Server"
$RootDir = pwd
cd ./VMware/
cd ./Windows/
cd ./CertificateAuth/
cp $RootDir/VMware/vars.tf .
terraform init
terraform apply -auto-approve
cd $RootDir

#RunecastAnalyzer
Write-Host "Building Runecast Analyzer"
$RootDir = pwd
cd ./VMware/
cd ./OVA/
cd ./Runecast/
cp $RootDir/VMware/vars.tf .
terraform init
terraform apply -auto-approve
cd $RootDir
