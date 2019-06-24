# Check the computer model to work out the the hypervisor for the correct tools...
$computerModel = Get-WmiObject Win32_ComputerSystem | Select-Object -ExpandProperty Model;

# Check if the tools are intalled before trying, so we don't try and reboot again if they are already installed
if ( ( choco list -localonly -exact vmware-tools | Select-Object -Last 1 ) -eq "0 packages installed." -and 
     ( $computerModel -like "VMWare*" ) ){
    choco install -y vmware-tools --cacheLocation "$env:userprofile\AppData\Local\Temp\chocolatey\";
    Invoke-Reboot;
}

# TODO: Add VirtualBox etc using the smae pattern...

