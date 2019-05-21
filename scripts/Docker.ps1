Enable-WindowsOptionalFeature -Online -FeatureName containers -All -NoRestart;
RefreshEnv;

# Check the computer model to work out the the hypervisor...
$computerModel = Get-WmiObject Win32_ComputerSystem | Select-Object -ExpandProperty Model;


# Running Doker for Windows seems to be problematic when running inside a VMWare VM, as detailed here https://github.com/docker/for-win/issues/2253
# I could not get the workarounds to work manually, so I hav resorted to manually setting up the dcoker environment. This means the updates are not
# automatic, but we use Chocolatey, so thats not too much of an issue...
if ( $computerModel -notlike "VMWare*" ){
    if ( ( choco list -localonly -exact docker-desktop | Select-Object -Last 1 ) -eq "0 packages installed."  ) {
        choco install -y docker-desktop;
        Invoke-Reboot;
    }

} else {
    # These are the key parts of docker on windows
    choco install -y docker-cli;
    choco install -y docker-machine;
    choco install -y docker-compose;

    # Add a HyperV switch so the Linux VM used for Linux Docker containers can talk to it's host, and pull images from the internet
    $hostNetAdapter = Get-NetAdapter -Physical | Select-Object -First 1 -ExpandProperty Name;
    $dockerSwitchName = "DockerNAT";
    $dockerVMName = "docker-vm";
    if ( $null -eq (Get-VMSwitch -Name $dockerSwitchName -ErrorAction SilentlyContinue) ){
        Write-Host "Adding Hyper-V switch '$dockerSwitchName'" -ForegroundColor Green;
        New-VMSwitch $dockerSwitchName -NetAdapterName $hostNetAdapter;
    }
    # Create the Docker Linux VM, and set it to start automatically
    if ( $null -eq (docker-machine ls --filter name=$dockerVMName | ConvertFrom-String)[1] ){
        Write-Host "Adding Docker linux VM to Hyper-V" -ForegroundColor Green;
        docker-machine create -d hyperv --hyperv-virtual-switch $dockerSwitchName --hyperv-memory 4096 $dockerVMName;
        Get-VM -Name $dockerVMName | Set-VM -AutomaticStartAction Start;
    
        # For the dcoker command tow work correctly, we need a few environment variables set. docker-machine cn provide the PowerShell to set these up
        Write-Host "Configuring Docker environment variables with VM details" -ForegroundColor Green;
        & docker-machine env $dockerVMName | Invoke-Expression;
    
        # The line above only sets the environment variables at the session level. We need then to be for the current user, or aftr a reboot we won't be able
        # to use docker commands
        Get-ChildItem -Path env: | Where-Object -Property Name -Like docker* | ForEach-Object { [System.Environment]::SetEnvironmentVariable($_.Name, $_.Value, [System.EnvironmentVariableTarget]::User) }

        # Finally add the docker IP to the hosts file as docker.local
        $IPsql2017 = docker-machine ip $dockerVMName;
        $hostsEntry = "$IPsql2017`t`tdocker.local"
        if ( $null -ne (Get-Content C:\Windows\System32\drivers\etc\hosts).Split("`n") | Where-Object { $_ -eq $hostsEntry } ){
            $hostsEntry | Out-File -Append -Encoding utf8 -FilePath C:\Windows\System32\drivers\etc\hosts
        }
    }
}

# Finally, install the docker plugin for VSCode
choco install -y vscode-docker
