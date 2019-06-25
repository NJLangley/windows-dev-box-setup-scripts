$ChocoCachePath = “C:\Temp”
New-Item -Path $ChocoCachePath -ItemType directory -Force

# tools we expect devs across many scenarios will want
choco install -y vscode –cacheLocation $ChocoCachePath
choco install -y git --package-parameters="'/GitAndUnixToolsOnPath'" –cacheLocation $ChocoCachePath
choco install -y python –cacheLocation $ChocoCachePath
choco install -y 7zip.install –cacheLocation $ChocoCachePath
choco install -y sysinternals –cacheLocation $ChocoCachePath
