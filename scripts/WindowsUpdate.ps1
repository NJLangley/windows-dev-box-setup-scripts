Enable-MicrosoftUpdate

# Check to see if Windows is activated before doing any Windows updates, otherwise some of them might not install, but trying
# will cause a reboot, causing a reboot loop...
if ( $null -ne ( Get-CimInstance -ClassName SoftwareLicensingProduct | Where-Object { $_.PartialProductKey } ) ){

    Install-Module PSWindowsUpdate;
    # The BoxStarter command Install-WindowsUpdate confilcts with the one in PSWindowsUpdate. We want to use the BoxStarter one
    Import-Module PSWindowsUpdate -NoClobber;

    # Some updates hae been causing issues by not installing correctly, which causes reboot loops if they require
    # a reboot. Build a list of ones to exclude, then exclude them
    $updatesToHide = @(
                        #"KB4493509",
                        #"KB4494441"
                      );
    Write-Host "Hiding Windows Updates that are explictly excluded"
    foreach ( $updateToHide in $updatesToHide){
        if ( $null -ne ( Get-WUList -KBArticleID $updateToHide ) ){
            Write-Host "Hiding Windows Update $updateToHide";
            Hide-WUUpdate -KBArticleID $updateToHide -Confirm:$false | Out-Null;
        }
    }

    # Check the status of Windows Update installs. If nay have failed more than ($updateMaxRetryCount) times, they may be causing a
    # reboot loop, so we disable them...
    $updateMaxRetryCount = 1;
    Write-Host "Hiding Windows Updates that have failed more than $updateMaxRetryCount time(s)"

    $Session = New-Object -ComObject "Microsoft.Update.Session";
    $Searcher = $Session.CreateUpdateSearcher();
    $historyCount = $Searcher.GetTotalHistoryCount();
    $installedUpdates = @{};
    $Searcher.QueryHistory(0, $historyCount) | Select-Object -ExpandProperty Title | Group-Object | ForEach-Object { $installedUpdates[$_.Name] = $_.Count };
    $pendingUpdateCriteria = "IsHidden=0 and IsInstalled=0 and Type='Software' and BrowseOnly=0";
    Write-Host "Getting pending Windows updates..."
    $pendingUpdates = $Searcher.Search($pendingUpdateCriteria).updates | Select-Object -ExpandProperty Title;
    $failedUpdatesToHide = $pendingUpdates | Where-Object { $installedUpdates[$_] -gt $updateMaxRetryCount };
    Write-Host "Getting available Windows updates..."
    $windowsUpdateList = Get-WUList;
    foreach ( $updateName in $failedUpdatesToHide){
        $windowsUpdateDetails = $windowsUpdateList | Where-Object { $_.Title -eq $updateName };
        if ( $null -ne $windowsUpdateDetails ){
            Write-Host "Hiding Windows Update $($windowsUpdateDetails.KB) after $updateMaxRetryCount failed attempt(s): $updateName";
            Hide-WindowsUpdate -KBArticleID $windowsUpdateDetails.KB -Confirm:$false | Out-Null;
        }
    }

    # Install the updates
    Install-WindowsUpdate -AcceptEula;

    # Unhide the updates not in the $hiddenUpdates array (ie the ones that have been hiiden because they failed), so that windows update
    # can try again sometime...
    Write-Host "Re-enabling Windows updates that were hidden after $updateMaxRetryCount failed intall attempt(s)"
    $hiddenUpdates = Get-WUList -IsHidden;
    $hiddenUpdates | 
        Where-Object { $_.KB -notin $updatesToHide } | 
        ForEach-Object { 
            Write-Host "Re-enabling Windows Update $($_.KB) after hiding it due to $updateMaxRetryCount or more failed attempts: $_";
            Unhide-WindowsUpdate -KBArticleID "$($_.KB)" -Confirm:$false | Out-Null 
        };
} else {
    Write-Host "Skipping Windows Update as Windows is not yet activated" -ForegroundColor Red;
}

