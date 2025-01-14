# modified_tfcode_usecase
# Deploying simple ASP.NET core web application on Linux virtual machine with Apache server

Azure Resources created on this usecase
  1.  Azure Resource Group
  2.  Azure Virtual Network
         subnets, Network Security Groups with ports (22,443,80), Network Interface, Public IP address
  3.  Azure Key Vault
  4.  Azure Storage accounts (To Store terraform state file and to store backup of web content)
  5.  Azure Virtual Machine

What can be achieved
  1. Deploy a Linux VM (Ubuntu) with Apache Web server that hosts a simple ASP.NET core web application , accessible via public IP.
       Web application created using Visual Studio 2022, build and published to the local folder where terraform code files are stored.
     And then copied to the virtual machine using terraform codes. All the necessary packages are installed on virtual machine through terraform codes (used "remote_exec","file" provisioners to achieve this).
  2. set up security using:
        - Network security group allowing only ports 80,443,22
        - key vault to store VM credentials and service principal secrets.
  3. Create a Storage account for keeping web content backups.

