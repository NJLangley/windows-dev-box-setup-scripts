$ChocoCacheLocation = "$env:userprofile\AppData\Local\Temp\chocolatey\";
New-Item -Path $ChocoCacheLocation -ItemType directory -Force | Out-Null;
