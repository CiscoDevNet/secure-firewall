
#########################################################################################################################
# Virtual Network and Subnet Creation
#########################################################################################################################

resource "azurerm_virtual_network" "ftdv" {
  count               = var.vn_name == "" ? 1 : 0
  name                = "${var.prefix}-network"
  location            = var.location
  resource_group_name = var.rg_name
  address_space       = [var.vn_cidr]
  tags                = var.tags
}


resource "azurerm_subnet" "subnets" {
  for_each             = local.subnet_list
  name                 = "${var.prefix}-${each.key}"
  resource_group_name  = var.rg_name
  virtual_network_name = local.vn_name
  address_prefixes     = var.subnets == [] ? [cidrsubnet(local.vn_cidr, local.subnet_newbits, each.value + 2)] : [var.subnets[each.value]]
}

################################################################################################################################
# Route Table Creation and Route Table Association
################################################################################################################################

resource "azurerm_route_table" "ftdv_rt" {
  for_each            = local.subnet_list
  name                = "${var.prefix}-rt-${each.key}"
  location            = var.location
  resource_group_name = var.rg_name
}

resource "azurerm_subnet_route_table_association" "ftdv_rta" {
  for_each       = local.subnet_list
  depends_on     = [azurerm_route_table.ftdv_rt, azurerm_subnet.subnets]
  subnet_id      = azurerm_subnet.subnets[each.key].id
  route_table_id = azurerm_route_table.ftdv_rt[each.key].id
}

################################################################################################################################
# Network Security Group Creation
################################################################################################################################

resource "azurerm_network_security_group" "allow-all" {
  name                = "${var.prefix}-allow-all"
  location            = var.location
  resource_group_name = var.rg_name

  security_rule {
    name                       = "TCP-Allow-All"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "Outbound-Allow-All"
    priority                   = 1002
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_group" "ilb-allow-all" {
  name                = "${var.prefix}-ilb-allow-all"
  location            = var.location
  resource_group_name = var.rg_name

  security_rule {
    name                       = "TCP-Allow-All-Internal-Inbound"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "TCP-Allow-All-Internal-Outbound"
    priority                   = 1001
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_group" "elb-allow-all" {
  name                = "${var.prefix}-elb-allow-all"
  location            = var.location
  resource_group_name = var.rg_name

  security_rule {
    name                       = "TCP-Allow-All-External-Inbound"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "TCP-Allow-All-External-Outbound"
    priority                   = 1001
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}


################################################################################################################################
# Network Interface Creation, Public IP Creation and Network Security Group Association
################################################################################################################################

resource "azurerm_public_ip" "ftdv-mgmt-interface" {
  name                = "${var.prefix}-instance-public-ip%{if var.instances > 1}-${count.index}%{endif}"
  count               = var.instances
  location            = var.location
  sku                 = "Standard" 
  resource_group_name = var.rg_name
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "ftdv-mgmt" {
  depends_on          = [azurerm_subnet.subnets]
  name                = "${var.prefix}-management%{if var.instances > 1}-${count.index}%{endif}"
  count               = var.instances
  location            = var.location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "management%{if var.instances > 1}-${count.index}%{endif}"
    subnet_id                     = azurerm_subnet.subnets["management"].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.ftdv-mgmt-interface[count.index].id
  }
}


resource "azurerm_network_interface_security_group_association" "FTDv_MGMT_NSG" {
  count                     = var.instances
  network_interface_id      = azurerm_network_interface.ftdv-mgmt[count.index].id
  network_security_group_id = azurerm_network_security_group.allow-all.id
}

resource "azurerm_network_interface" "ftdv-diagnostic" {
  depends_on          = [azurerm_subnet.subnets]
  name                = "${var.prefix}-diagnostic%{if var.instances > 1}-${count.index}%{endif}"
  count               = var.instances
  location            = var.location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "Diagnostic%{if var.instances > 1}-${count.index}%{endif}"
    subnet_id                     = azurerm_subnet.subnets["management"].id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface_security_group_association" "FTDv_DIAG_NSG" {
  count                     = var.instances
  network_interface_id      = azurerm_network_interface.ftdv-diagnostic[count.index].id
  network_security_group_id = azurerm_network_security_group.allow-all.id
}

resource "azurerm_network_interface" "ftdv-outside" {
  depends_on          = [azurerm_subnet.subnets]
  name                = "${var.prefix}-outside%{if var.instances > 1}-${count.index}%{endif}"
  count               = var.instances
  location            = var.location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "Outside%{if var.instances > 1}-${count.index}%{endif}"
    subnet_id                     = azurerm_subnet.subnets["outside"].id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface_security_group_association" "FTDv_Outside_NSG" {
  count                     = var.instances
  network_interface_id      = azurerm_network_interface.ftdv-outside[count.index].id
  network_security_group_id = azurerm_network_security_group.elb-allow-all.id
}

resource "azurerm_network_interface" "ftdv-inside" {
  depends_on          = [azurerm_subnet.subnets]
  name                = "${var.prefix}-inside%{if var.instances > 1}-${count.index}%{endif}"
  count               = var.instances
  location            = var.location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "Inside%{if var.instances > 1}-${count.index}%{endif}"
    subnet_id                     = azurerm_subnet.subnets["inside"].id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface_security_group_association" "FTDv_Inside_NSG" {
  count                     = var.instances
  network_interface_id      = azurerm_network_interface.ftdv-inside[count.index].id
  network_security_group_id = azurerm_network_security_group.ilb-allow-all.id
}
