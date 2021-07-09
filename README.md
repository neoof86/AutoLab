# AutoLab
A way of creating a Lab automatically

# Usage
For now the following ISOs were used in testing
* Windows 2022 - 20348.1.210507-1500.fe_release_SERVER_EVAL_x64FRE_en-us.iso
* Ubuntu - ubuntu-20.04.2-live-server-amd64.iso

OVA's Used
* Runecast - https://portal.runecast.com/registration

To get started you will need to configure the following files with your credentials, datastores, networks and folders
/variables.json
/VMware/vars.tf

After this to create the templates run PackMeUp.ps1

Once this completes successfully run BuildVMware.ps1

This was tested on a Mac and in each of the folders you may need to amend the .tf files from PWSH to Powershell if using Windows.

