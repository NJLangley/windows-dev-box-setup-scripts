

#--- Enable developer mode on the system ---
Set-ItemProperty -Path HKLM:\Software\Microsoft\Windows\CurrentVersion\AppModelUnlock -Name AllowDevelopmentWithoutDevLicense -Value 1

# Allow the current user to execute scripts for PowerShell development
Update-ExecutionPolicy -Policy Unrestricted

# Add the PowerShell Gallery as a trusted provider for modules
if ( $null -eq ( Get-PackageProvider | Where-Object -Property Name -EQ NuGet ) ){
    Install-PackageProvider -Name NuGet -Force;
    Set-PackageSource -Name PSGallery -Trusted;
}

# Make sure PowerShell get is up to date, it's out of date on Windows 10 1809
Install-Module PowerShellGet -Force;

# Disable defrag because I have an SSD 
Get-ScheduledTask -TaskName *defrag* | Disable-ScheduledTask 