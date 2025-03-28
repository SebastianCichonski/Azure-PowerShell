# subnets parameters
$publicSubnetParams = @{
    'Name' = 'PublicSubnet'
    'AddressPrefix' = '10.0.0.0/24'
}

$privateSubnetParams = @{
    'Name' = 'PrivateSubnet'
    'AddressPrefix' = '10.0.1.0/24'
}

$dmzSubnetParams = @{
    'Name' = 'DMZSubnet'
    'AddressPrefix' = '10.0.2.0/24'
}

$vNetLab1Params = @{
    'Name' = 'vNetLab1'
    'ResourceGroupName' = 'Lab_RG1'
    'Location' = 'polandcentral'
    'AddressPrefix' = '10.0.0.0/16'
}

# podsieci
$PublicSubnet = New-AzVirtualNetworkSubnetConfig @publicSubnetParams
$PrivateSubnet = New-AzVirtualNetworkSubnetConfig @privateSubnetParams
$DMZSubnet = New-AzVirtualNetworkSubnetConfig @dmzSubnetParams

# sieć
$vnet = New-AzVirtualNetwork @vNetLab1Params -Subnet $PublicSubnet, $PrivateSubnet, $dmzSubnet

# trasa
$route01 = New-AzRouteConfig -Name 'Route01' -AddressPrefix 10.0.1.0/24 -NextHopType 'VirtualAppliance' -NextHopIpAddress '10.0.2.4'

# tabela tras
New-AzRouteTable -Name "PublicTable" -ResourceGroupName 'Lab_RG1' -DisableBgpRoutePropagation $false -Route $route01

# skojażenie tabeli tras z podsiecią
Set-AzVirtualNetworkSubnetConfig -Name 'PublicSubnet' -RouteTable 'PublicTable' -VirtualNetwork 'vNetLab1' -ResourceGroupName 'Lab_RG1' 