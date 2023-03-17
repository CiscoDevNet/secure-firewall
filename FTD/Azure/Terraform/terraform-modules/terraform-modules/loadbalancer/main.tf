
################################################################################################################################
# Internal LB Creation
################################################################################################################################

resource "azurerm_lb" "ftd-ilb" {
  count               = var.instances > 1 ? 1 : 0
  name                = "FTD-ILB"
  location            = var.location
  resource_group_name = var.rg_name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                          = "InternalIPAddress"
    #subnet_id                     = azurerm_subnet.subnets["inside"].id
    subnet_id                     = var.subnet_id
    private_ip_address            = cidrhost(var.get_private_ip_address, 100)
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_lb_backend_address_pool" "ILB-Backend-Pool" {
  count           = var.instances > 1 ? 1 : 0
  loadbalancer_id = azurerm_lb.ftd-ilb[0].id
  name            = "BackEndAddressPool"
}

resource "azurerm_lb_backend_address_pool_address" "ILB-Backend-Address" {
  count                   = var.instances > 1 ? var.instances : 0
  name                    = "ILB-Backend-Address%{if var.instances > 1}-${count.index}%{endif}"
  backend_address_pool_id = azurerm_lb_backend_address_pool.ILB-Backend-Pool[0].id
  virtual_network_id      = var.virtual_network_id
  ip_address              = element(var.private_ip_address_ext,count.index)
}

resource "azurerm_lb_probe" "FTD-ILB-Probe" {
  count               = var.instances > 1 ? 1 : 0
  resource_group_name = var.rg_name
  loadbalancer_id     = azurerm_lb.ftd-ilb[0].id
  name                = "ssh-running-probe"
  port                = 22
}

resource "azurerm_lb_rule" "ilbrule" {
  count                          = var.instances > 1 ? 1 : 0
  resource_group_name            = var.rg_name
  loadbalancer_id                = azurerm_lb.ftd-ilb[0].id
  name                           = "ILBRule"
  protocol                       = "All"
  frontend_port                  = 0
  backend_port                   = 0
  frontend_ip_configuration_name = "InternalIPAddress"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.ILB-Backend-Pool[0].id
  probe_id                       = azurerm_lb_probe.FTD-ILB-Probe[0].id
}


# ################################################################################################################################
# # External LB Creation
# ################################################################################################################################

resource "azurerm_public_ip" "ELB-PublicIP" {
  count               = var.instances > 1 ? 1 : 0
  name                = "PublicIPForLB"
  location            = var.location
  resource_group_name = var.rg_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_lb" "ftd-elb" {
  count               = var.instances > 1 ? 1 : 0
  name                = "FTD-ELB"
  location            = var.location
  resource_group_name = var.rg_name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "ExternalIPAddress"
    public_ip_address_id = azurerm_public_ip.ELB-PublicIP[0].id
  }
}

resource "azurerm_lb_backend_address_pool" "ELB-Backend-Pool" {
  count           = var.instances > 1 ? 1 : 0
  loadbalancer_id = azurerm_lb.ftd-elb[0].id
  name            = "BackEndAddressPool"
}

resource "azurerm_lb_backend_address_pool_address" "ELB-Backend-Address" {
  count                   = var.instances > 1 ? var.instances : 0
  name                    = "ELB-Backend-Address%{if var.instances > 1}-${count.index}%{endif}"
  backend_address_pool_id = azurerm_lb_backend_address_pool.ELB-Backend-Pool[0].id
  virtual_network_id      = var.virtual_network_id
  ip_address              = element(var.private_ip_address_ext,count.index)

}
                         

resource "azurerm_lb_probe" "FTD-ELB-Probe" {
  count               = var.instances > 1 ? 1 : 0
  resource_group_name = var.rg_name
  loadbalancer_id     = azurerm_lb.ftd-elb[0].id
  name                = "ssh-running-probe"
  port                = 22
}

resource "azurerm_lb_rule" "elbrule" {
  count                          = var.instances > 1 ? 1 : 0
  resource_group_name            = var.rg_name
  loadbalancer_id                = azurerm_lb.ftd-elb[0].id
  name                           = "ELBRule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "ExternalIPAddress"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.ELB-Backend-Pool[0].id
  probe_id                       = azurerm_lb_probe.FTD-ELB-Probe[0].id
}
