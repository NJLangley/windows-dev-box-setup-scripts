# Description: Boxstarter Script
# Author: Niall Langley
# Demo or lightning talk. Only installs components that can download in time...

Disable-UAC

# Get the base URI path from the ScriptToCall value
$bstrappackage = "-bootstrapPackage"
$helperUri = $Boxstarter['ScriptToCall']
$strpos = $helperUri.IndexOf($bstrappackage)
$helperUri = $helperUri.Substring($strpos + $bstrappackage.Length)
$helperUri = $helperUri.TrimStart("'", " ")
$helperUri = $helperUri.TrimEnd("'", " ")
$helperUri = $helperUri.Substring(0, $helperUri.LastIndexOf("/"))
$helperUri += "/scripts"
write-host "helper script base URI is $helperUri"

function executeScript {
    Param ([string]$script)
    write-host "executing $helperUri/$script ..."
	iex ((new-object net.webclient).DownloadString("$helperUri/$script"))
}

# Set the window to be maximized so that it is not half off the screen in a VM with a small defualt screen size!
executeScript "SetWindowStyle.ps1";

#--- Setting up Windows ---
executeScript "SystemConfiguration.ps1";
executeScript "FileExplorerSettings.ps1";
executeScript "Browsers.ps1";
executeScript "RemoveDefaultApps.ps1";
executeScript "CommonDevTools.ps1";

#executeScript "DatabaseTools.ps1";
executeScript "NiallsConfiguration.ps1";

#--- re-enabling critial items ---
#executeScript "WindowsUpdate.ps1";
Enable-UAC
