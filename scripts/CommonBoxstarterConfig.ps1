#$ChocoCacheLocation = "$env:userprofile\AppData\Local\Temp\chocolatey\";
#New-Item -Path $ChocoCacheLocation -ItemType directory -Force | Out-Null;

New-Item -Path "c:\Temp\chocolatey\" -ItemType directory -Force | Out-Null;

# Make sure Chocolatey is installed for debugging errors
choco install choco;
