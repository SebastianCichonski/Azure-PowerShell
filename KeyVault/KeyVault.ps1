# Łączenie z kontem Azure
Connect-AzAccount

$RGName = "az801-lab-RG"
$Location = "easteurope"
$KVName = "az801-KV"

# Tworzenie grupy zasobów
New-AzResourceGroup -Name $RGName -Location $Location

# Tworzenie magazynu kluczy

#######
#
# Parametr -EnabledForDiskEncryption
# Umożliwia usłudze Azure Disk Encryption pobieranie wpisów tajnych i rozpakowywanie kluczy z tego magazynu kluczy
#
########

New-AzKeyVault -Name $KVName -ResourceGroupName $RGName -Location $Location -EnabledForDiskEncryption

# Ustawianie zasad dostępu do magazynu kluczy

########
#
# Parametr -EnabledForDeployment 
# Umożliwia dostawcy zasobów Microsoft.Compute pobieranie wpisów tajnych z tego magazynu kluczy, gdy Key Vault jest przywoływany 
# podczas tworzenia zasobów, na przykład podczas tworzenia maszyny wirtualnej
#
# Parametr -EnabledForTemplateDeployment
# Umożliwia usłudze Azure Resource Manager pobieranie wpisów tajnych z tego magazynu kluczy, 
# gdy ten magazyn kluczy jest przywoływany we wdrożeniu szablonu
#
########

Set-AzKeyVaultAccessPolicy -VaultName $KVName -ResourceGroupName $RGName -EnabledForDiskEncryption -EnabledForDeployment -EnabledForTemplateDeployment

# Szyfrowanie maszyny wirtualnej

$KeyVault = Get-AzKeyVault -VaultName $KVName -ResourceGroupName $RGName
Set-AzVMDiskEncryptionExtension -ResourceGroupName $RGName -VMName "VM-1" -DiskEncryptionKeyVaultUrl $KeyVault.VaultUri -DiskEncryptionKeyVaultId $KeyVault.ResourceId
