
# tools we expect devs across many scenarios will want
choco install -y vscode --cacheLocation "$env:userprofile\AppData\Local\Temp\chocolatey\";
choco install -y git --package-parameters="'/GitAndUnixToolsOnPath'" --cacheLocation "$env:userprofile\AppData\Local\Temp\chocolatey\";
choco install -y python --cacheLocation "$env:userprofile\AppData\Local\Temp\chocolatey\";
choco install -y 7zip.install --cacheLocation "$env:userprofile\AppData\Local\Temp\chocolatey\";
choco install -y sysinternals --cacheLocation "$env:userprofile\AppData\Local\Temp\chocolatey\";
