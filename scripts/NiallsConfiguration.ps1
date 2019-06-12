Update-SessionEnvironment

# Carbon is a module to help in setting up machines, has some useful commandlets for setting reg keys etc
Install-Module dbatools;
Install-Module Carbon;
Install-Module PPoShTools; # Has a useful CmdLet for adding fonts

# Add my fav programming font's with ligatures so that they are in place ready for the settings for my code editors
$fontsTempDirectory = "$Env:Temp\fonts"
if ( -Not (Test-Path $fontsTempDirectory) ) { New-Item -Path $fontsTempDirectory -Type Directory -Force | Out-Null };
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/tonsky/FiraCode/master/distr/ttf/FiraCode-Bold.ttf" -OutFile "$fontsTempDirectory\FiraCode-Bold.ttf";
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/tonsky/FiraCode/master/distr/ttf/FiraCode-Light.ttf" -OutFile "$fontsTempDirectory\FiraCode-Light.ttf";
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/tonsky/FiraCode/master/distr/ttf/FiraCode-Medium.ttf" -OutFile "$fontsTempDirectory\FiraCode-Medium.ttf";
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/tonsky/FiraCode/master/distr/ttf/FiraCode-Regular.ttf" -OutFile "$fontsTempDirectory\FiraCode-Regular.ttf";
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/tonsky/FiraCode/master/distr/ttf/FiraCode-Retina.ttf" -OutFile "$fontsTempDirectory\FiraCode-Retina.ttf";
Import-Module PPoShTools -NoClobber;
Add-Font -Path $fontsTempDirectory

# I Like Chrome to be my default browser
choco install -y SetDefaultBrowser;
SetDefaultBrowser.exe chrome;

# A few more useful apps
choco install -y paint.net;
choco install -y sourcetree;

# Install the poshgit PowerShell module, and add my profile for all hosts. We want version 1 whcih is still pre-release...
$currentUserProfile = [System.IO.Path]::Combine([Environment]::GetFolderPath("MyDocuments"), "WindowsPowerShell", "profile.ps1");
Write-Host "Writing PowerShell Profile to: $currentUserProfile";
Install-Module posh-git -AllowPrerelease -Force;
(new-object net.webclient).DownloadString("https://gist.githubusercontent.com/NJLangley/9dc9ef0b83aba75d603e45e69f7fb54c/raw/profile.ps1") |
    New-Item -Path $currentUserProfile -Force |
    Out-Null;

# Grab my VSCode settings from the gist that the sync tool uses
Write-Host "Writing VSCode settings to: $env:APPDATA\Code\User\settings.json";
(new-object net.webclient).DownloadString("https://gist.githubusercontent.com/NJLangley/17a245eb13a733f94fc306b093c2d326/raw/settings.json") |
    New-Item -Path "$env:APPDATA\Code\User\settings.json" -Force |
    Out-Null;

# Also grab the extensions list, as the sync is not setup to be two way yet, and we can get the extensions list from it
$vsCodeExtensionsInstalled = code --list-extensions
$requiredExtensions = (new-object net.webclient).DownloadString("https://gist.githubusercontent.com/NJLangley/17a245eb13a733f94fc306b093c2d326/raw/extensions.json") |
    ConvertFrom-Json |
    ForEach-Object { $_.metadata.publisherId }
$requiredExtensions | 
    Where-Object { $_ -notin $vsCodeExtensionsInstalled } |
    ForEach-Object { code --install-extension $_; };


# TODO: Add SSMS plugins, config file etc...
$SecondsToSleep = 20
$ssmsSettingsTempFile = "$Env:Temp\ssms_settings.xml";
Write-Host "Writing SSMS settings to: $ssmsSettingsTempFile";
(new-object net.webclient).DownloadString("https://gist.githubusercontent.com/NJLangley/e994a57c178c9960c66aa4d27cc7f9d6/raw/ssms_colours_only.vssettings") |
    New-Item -Path $ssmsSettingsTempFile -Force |
    Out-Null;
$ssmsExe = Get-ChildItem -Path 'C:\Program Files (x86)\Microsoft*' -Include 'ssms.exe' -Recurse |
    Select-Object -ExpandProperty FullName -First 1;
$args = "/ResetSettings `"$ssmsSettingsTempFile`""
Write-Host "Setting SSMS Options, will take $SecondsToSleep seconds"
$Process = Start-Process -FilePath $ssmsExe -ArgumentList $Args -Passthru
Start-Sleep -Seconds $SecondsToSleep #hack: Couldn't find a way to exit when done
$Process.Kill()

choco install -y sqltoolbelt --params "/products:'SQL Prompt, SQL Search'" --force;

# TODO: Add Visual Studio plugins, config file etc...
choco install resharper-ultimate-all --params "'/NoCpp /NoTeamCityAddin'";

