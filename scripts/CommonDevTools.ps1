
# tools we expect devs across many scenarios will want
choco install -y vscode --cacheLocation $ChocoCacheLocation;
choco install -y git --package-parameters="'/GitAndUnixToolsOnPath'" --cacheLocation $ChocoCacheLocation;
choco install -y python --cacheLocation $ChocoCacheLocation;
choco install -y 7zip.install --cacheLocation $ChocoCacheLocation;
choco install -y sysinternals --cacheLocation $ChocoCacheLocation;
