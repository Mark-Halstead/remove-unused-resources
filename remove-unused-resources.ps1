# This script will check for unused resources and prompt for deletion
$unusedPublicIPs = Get-AzPublicIpAddress | Where-Object { $_.IpConfiguration -eq $null }
$unattachedNICs = Get-AzNetworkInterface | Where-Object { $_.VirtualMachine -eq $null }
$unattachedDisks = Get-AzDisk | Where-Object { $_.ManagedBy -eq $null }

# List unused Public IPs
if ($unusedPublicIPs.Count -gt 0) {
    Write-Host "Found unused Public IP Addresses:"
    $unusedPublicIPs | ForEach-Object { Write-Host $_.Name }
} else {
    Write-Host "No unused Public IP Addresses found."
}

# List unattached NICs
if ($unattachedNICs.Count -gt 0) {
    Write-Host "Found unattached Network Interfaces:"
    $unattachedNICs | ForEach-Object { Write-Host $_.Name }
} else {
    Write-Host "No unattached Network Interfaces found."
}

# List unattached Disks
if ($unattachedDisks.Count -gt 0) {
    Write-Host "Found unattached Disks:"
    $unattachedDisks | ForEach-Object { Write-Host $_.Name }
} else {
    Write-Host "No unattached Disks found."
}

# Confirm Deletion
$confirmDelete = Read-Host -Prompt "Do you want to delete these resources? (Y/N)"
if ($confirmDelete -eq "Y") {
    # Deleting unused Public IPs
    if ($unusedPublicIPs.Count -gt 0) {
        Write-Host "Deleting unused Public IP Addresses..."
        $unusedPublicIPs | ForEach-Object { Remove-AzPublicIpAddress -Name $_.Name -ResourceGroupName $_.ResourceGroupName -Force }
    }

    # Deleting unattached NICs
    if ($unattachedNICs.Count -gt 0) {
        Write-Host "Deleting unattached Network Interfaces..."
        $unattachedNICs | ForEach-Object { Remove-AzNetworkInterface -Name $_.Name -ResourceGroupName $_.ResourceGroupName -Force }
    }

    # Deleting unattached Disks
    if ($unattachedDisks.Count -gt 0) {
        Write-Host "Deleting unattached Disks..."
        $unattachedDisks | ForEach-Object { Remove-AzDisk -ResourceGroupName $_.ResourceGroupName -DiskName $_.Name -Force }
    }

    Write-Host "Unused resources deleted successfully."
} else {
    Write-Host "Resource deletion aborted."
}
