data "azurerm_key_vault_secret" "password"{
  name = "vmpassword"
  key_vault_id = var.key_vault_id
}
data "azurerm_key_vault_secret" "clientsecret"{
  name = "clientsecret-tf"
  key_vault_id = var.key_vault_id
}
data "azuread_service_principal" "sprincipal"{
  display_name = "terraform-app"

}
data "azurerm_client_config" "tenantid"{

}

resource "azurerm_linux_virtual_machine" "linuxvm" {
  name                = var.virtual_machine_name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_B1s"
  admin_username      = "adminuser"
  admin_password = data.azurerm_key_vault_secret.password.value
  network_interface_ids = [
    var.vnet_interface_ids
  ]

 disable_password_authentication = false
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  #custom_data =filebase64("./compute/scripts.sh")
}
resource "null_resource" "apacheconfig" {
    provisioner "remote-exec" {
    inline = [
    # Update package lists
      "sudo apt-get update",

      # Install Apache
      "sudo apt-get install -y apache2",

      # Install prerequisites for .NET
      "sudo apt-get install -y wget",

      # Download and install Microsoft package signing key
      "wget https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb -O packages-microsoft-prod.deb",
      "sudo dpkg -i packages-microsoft-prod.deb",

      # Install the .NET SDK
      "sudo apt-get update",
      "sudo apt-get install -y apt-transport-https",
      "sudo apt-get update",
      "sudo apt-get install -y dotnet-sdk-8.0",  # Adjust the version as needed

      # Enable and start Apache
      "sudo systemctl enable apache2",
      "sudo systemctl start apache2",

      # Configure Apache to reverse proxy to the ASP.NET Core application
      "sudo a2enmod proxy",
      "sudo a2enmod proxy_http",
      "echo  '<VirtualHost *:80>\n         ProxyPreserveHost On\n        ProxyPass / http://localhost:5000/\n        ProxyPassReverse / http://localhost:5000/\n      </VirtualHost>' | sudo tee /etc/apache2/sites-available/000-default.conf",

      # Restart Apache to apply changes
      "sudo systemctl restart apache2"
    ]
  }
 connection {
      type        = "ssh"
      user        = "adminuser"
      password    = data.azurerm_key_vault_secret.password.value
      host        = var.public_ip_address
    }
depends_on = [ azurerm_linux_virtual_machine.linuxvm ]
      
}

resource "null_resource" "serviceconf" {
    provisioner "file" {
    source      = "./compute/webapplication/"  # Local path to your web application
    destination = "/tmp/webapp"              # Temporary directory on VM
  }
  provisioner "remote-exec" {
    inline = [ 
        "sudo cp -r /tmp/webapp/* /var/www/html/", 
        "sudo chown -R adminuser:adminuser /var/www/html/", 
    "echo '[Unit]\n  Description=Simple ASP.NET Core Application\n  [Service]\n WorkingDirectory=/var/www/html\n ExecStart=/usr/bin/dotnet /var/www/html/WebApplication1.dll\n Restart=on-failure\n  RestartSec=10\n SyslogIdentifier=dotnet-webapplication\n User=adminuser\n Environment=ASPNETCORE_ENVIRONMENT=Production\n [Install]\n WantedBy=multi-user.target' | sudo tee /etc/systemd/system/webapp.service",
         # Reload systemd to apply the new service
      "sudo systemctl daemon-reload",

      # Enable and start your application service
      "sudo systemctl enable webapp.service",
      "sudo systemctl start webapp.service"
     ]
    
  }
connection {
      type        = "ssh"
      user        = "adminuser"
      password    = data.azurerm_key_vault_secret.password.value
      host        = var.public_ip_address
    }
depends_on = [ azurerm_linux_virtual_machine.linuxvm,
null_resource.apacheconfig ]
}

resource "null_resource" "cliinstall" {
    provisioner "remote-exec" {
        inline = [ 
        "sudo curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash",
        
        "az login --service-principal -u ${data.azuread_service_principal.sprincipal.client_id} -p ${data.azurerm_key_vault_secret.clientsecret.value}  --tenant ${data.azurerm_client_config.tenantid.tenant_id}",
       
        #!/bin/bash

        # Variables
        "LOCAL_DIRECTORY=/var/www/html/",
        "BACKUP_NAME=backup-$(date +%Y%m%d%H%M%S).tar.gz",

        # Create a backup of the Apache web content
        "tar -czf /tmp/$BACKUP_NAME -C $LOCAL_DIRECTORY .",  

        # Upload the backup to Azure Blob Storage
        "az storage blob upload --account-name ${var.storage_account_name} --container-name ${var.container_name} --name $BACKUP_NAME --file /tmp/$BACKUP_NAME --auth-mode login"
 
        ]
       
    }

  connection {
      type        = "ssh"
      user        = "adminuser"
      password    = data.azurerm_key_vault_secret.password.value
      host        = var.public_ip_address
    }
depends_on = [ azurerm_linux_virtual_machine.linuxvm,
null_resource.apacheconfig,
null_resource.serviceconf ]
}




