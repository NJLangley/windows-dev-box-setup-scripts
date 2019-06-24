# visualstudio2017community recomends being up to date on .Net framework first, and rebooting after that's installed
if ( ( choco list -localonly -exact dotnetfx | Select-Object -Last 1 ) -eq "0 packages installed." ){
    choco install -y dotnetfx;
    Invoke-Reboot;
}

# visualstudio2017community recomends rebooting before and after install
if ( ( choco list -localonly -exact visualstudio2019community | Select-Object -Last 1 ) -eq "0 packages installed." ){
    choco install -y visualstudio2019community --cacheLocation $ChocoCacheLocation;
    Invoke-Reboot;
}

choco install -y visualstudio2019-workload-data --cacheLocation $ChocoCacheLocation;
choco install -y visualstudio2019-workload-azure --cacheLocation $ChocoCacheLocation;
choco install -y visualstudio2019-workload-manageddesktop --cacheLocation $ChocoCacheLocation;

# Install the Microsoft OLE DB Driver for SQL Server 18 driver as it's not included with VisualStudio any more
choco install -y msoledbsql --cacheLocation $ChocoCacheLocation;

# SSIS Install
choco install ssis-vs2019 --cacheLocation $ChocoCacheLocation;

# SSMS Install
choco install -y sql-server-management-studio --cacheLocation $ChocoCacheLocation;
Update-SessionEnvironment;



