# visualstudio2017community recomends being up to date on .Net framework first, and rebooting after that's installed
if ( ( choco list -localonly -exact dotnetfx | Select-Object -Last 1 ) -eq "0 packages installed." ){
    choco install -y dotnetfx;
    Invoke-Reboot;
}

# visualstudio2017community recomends rebooting before and after install
if ( ( choco list -localonly -exact visualstudio2019community | Select-Object -Last 1 ) -eq "0 packages installed." ){
    choco install -y visualstudio2019community;
    Invoke-Reboot;
}

choco install -y visualstudio2019-workload-data;
choco install -y visualstudio2019-workload-azure;
choco install -y visualstudio2019-workload-manageddesktop;

choco install -y sql-server-management-studio;
Update-SessionEnvironment;



