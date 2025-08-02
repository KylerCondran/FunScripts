# Function to check if system is running in a virtual machine
function Test-IsVirtualMachine {
    [CmdletBinding()]
    param()
    
    $IsVirtual = $false
    $VirtualIndicators = @{
        Manufacturer = $false
        Model = $false
        BIOS = $false
        Services = $false
        Processes = $false
        VMwareTools = $false
        HyperVServices = $false
        VBoxServices = $false
    }

    Write-Host "Checking for VM indicators..." -ForegroundColor Cyan

    # Check System Manufacturer and Model
    $SystemInfo = Get-WmiObject -Class Win32_ComputerSystem
    $Manufacturer = $SystemInfo.Manufacturer
    $Model = $SystemInfo.Model

    Write-Host "`nManufacturer: $Manufacturer"
    Write-Host "Model: $Model"

    # Check common VM manufacturer names
    $VMManufacturers = @('VMware', 'Microsoft Corporation', 'innotek GmbH', 'QEMU', 'Xen', 'Oracle')
    foreach ($VMManufacturer in $VMManufacturers) {
        if ($Manufacturer -match $VMManufacturer) {
            $VirtualIndicators.Manufacturer = $true
            break
        }
    }

    # Check common VM model names
    $VMModels = @('Virtual Machine', 'VMware', 'VirtualBox', 'KVM', 'Xen')
    foreach ($VMModel in $VMModels) {
        if ($Model -match $VMModel) {
            $VirtualIndicators.Model = $true
            break
        }
    }

    # Check BIOS information
    $BIOS = Get-WmiObject -Class Win32_BIOS
    Write-Host "`nBIOS Manufacturer: $($BIOS.Manufacturer)"
    Write-Host "BIOS Version: $($BIOS.Version)"
    Write-Host "BIOS Serial Number: $($BIOS.SerialNumber)"

    # Check for VM BIOS manufacturers
    $VMBiosManufacturers = @('VMware', 'Phoenix', 'American Megatrends', 'Xen', 'innotek GmbH')
    foreach ($VMBiosManufacturer in $VMBiosManufacturers) {
        if ($BIOS.Manufacturer -match $VMBiosManufacturer) {
            $VirtualIndicators.BIOS = $true
            break
        }
    }

    # Check for VM-specific services
    $VMServices = @(
        'vmtools',
        'vboxservice',
        'vmhgfs',
        'vmvss',
        'vmmouse',
        'VMwareTools',
        'xenevtchn',
        'xennet',
        'xenservice',
        'vmicheartbeat',
        'vmicvss',
        'vmicshutdown',
        'vmicexchange'
    )

    $RunningServices = Get-Service | Where-Object { $_.Status -eq 'Running' }
    Write-Host "`nChecking VM-specific services..."
    foreach ($Service in $RunningServices) {
        if ($VMServices -contains $Service.Name) {
            Write-Host "Found VM service: $($Service.Name)" -ForegroundColor Yellow
            $VirtualIndicators.Services = $true
        }
    }

    # Check for VM-specific processes
    $VMProcesses = @(
        'vmtoolsd.exe',
        'vboxservice.exe',
        'vboxtray.exe',
        'vmwareuser.exe',
        'vmwaretray.exe'
    )

    $RunningProcesses = Get-Process
    Write-Host "`nChecking VM-specific processes..."
    foreach ($Process in $RunningProcesses) {
        if ($VMProcesses -contains $Process.Name) {
            Write-Host "Found VM process: $($Process.Name)" -ForegroundColor Yellow
            $VirtualIndicators.Processes = $true
        }
    }

    # Check for VMware Tools specific registry keys
    $VMwareToolsKey = "HKLM:\SOFTWARE\VMware, Inc.\VMware Tools"
    if (Test-Path $VMwareToolsKey) {
        Write-Host "`nVMware Tools registry key found" -ForegroundColor Yellow
        $VirtualIndicators.VMwareTools = $true
    }

    # Check for Hyper-V specific registry keys
    $HyperVKey = "HKLM:\SOFTWARE\Microsoft\Virtual Machine\Guest\Parameters"
    if (Test-Path $HyperVKey) {
        Write-Host "`nHyper-V guest registry key found" -ForegroundColor Yellow
        $VirtualIndicators.HyperVServices = $true
    }

    # Check for VirtualBox specific registry keys
    $VBoxKey = "HKLM:\SOFTWARE\Oracle\VirtualBox Guest Additions"
    if (Test-Path $VBoxKey) {
        Write-Host "`nVirtualBox Guest Additions registry key found" -ForegroundColor Yellow
        $VirtualIndicators.VBoxServices = $true
    }

    # Calculate if this is likely a VM based on indicators
    $TrueIndicators = ($VirtualIndicators.Values | Where-Object { $_ -eq $true }).Count
    $IsVirtual = $TrueIndicators -gt 0

    # Display summary
    Write-Host "`n=== Detection Summary ===" -ForegroundColor Cyan
    $VirtualIndicators.GetEnumerator() | ForEach-Object {
        $Color = if ($_.Value) { 'Yellow' } else { 'Green' }
        Write-Host "$($_.Key): $($_.Value)" -ForegroundColor $Color
    }

    Write-Host "`nFinal Assessment:" -ForegroundColor Cyan
    if ($IsVirtual) {
        Write-Host "This system appears to be a Virtual Machine" -ForegroundColor Yellow
        Write-Host "Confidence: $([math]::Round(($TrueIndicators / $VirtualIndicators.Count) * 100))%" -ForegroundColor Yellow
    } else {
        Write-Host "This system appears to be Physical Hardware" -ForegroundColor Green
    }

    return $IsVirtual
}

# Run the detection
Test-IsVirtualMachine