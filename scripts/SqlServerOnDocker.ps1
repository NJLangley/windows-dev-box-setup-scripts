Update-SessionEnvironment;

if ( $null -eq (docker ps --filter name=sql2017 | ConvertFrom-String)[1] ){
    docker run --name sql2017 `
            --restart always `
            -p 1433:1433 `
            -e "ACCEPT_EULA=Y" `
            -e "SA_PASSWORD=ChocoSQL123!" `
            -d `
            mcr.microsoft.com/mssql/server:2017-latest;
}
