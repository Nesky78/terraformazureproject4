terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.27.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "tomiRG" {
  name     = "tomiterraformRG"
  location = "West Europe"
}

resource "azurerm_virtual_network" "tomiVnet" {
  name                = "tomiVnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.tomiRG.location
  resource_group_name = azurerm_resource_group.tomiRG.name
}

resource "azurerm_subnet" "tomisubnet" {
  name                 = "tomisubnet"
  resource_group_name  = azurerm_resource_group.tomiRG.name
  virtual_network_name = azurerm_virtual_network.tomiVnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "tomiNIC" {
  name                = "tomiNIC"
  location            = azurerm_resource_group.tomiRG.location
  resource_group_name = azurerm_resource_group.tomiRG.name

  ip_configuration {
    name                          = "tomiNIC"
    subnet_id                     = azurerm_subnet.tomisubnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "tomiVM" {
  name                = "tomiVM-machine"
  resource_group_name = azurerm_resource_group.tomiRG.name
  location            = azurerm_resource_group.tomiRG.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.tomiNIC.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}
