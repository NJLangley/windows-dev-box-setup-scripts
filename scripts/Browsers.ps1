$ChocoCachePath = “C:\Temp”
New-Item -Path $ChocoCachePath -ItemType directory -Force

#--- Browsers ---
choco install -y googlechrome –cacheLocation $ChocoCachePath
#choco install -y firefox --cacheLocation "$env:userprofile\AppData\Local\Temp\chocolatey\";
