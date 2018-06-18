Configuration WindowsServer_config
{
    param
    (
        [Parameter(Mandatory = $true)]
        [string]
        $OsVersion,

        [Parameter(Mandatory = $true)]
        [string]
        $OsRole,

        [Parameter(Mandatory = $true)]
        [version]
        $StigVersion,

        [Parameter(Mandatory = $true)]
        [string]
        $ForestName,

        [Parameter(Mandatory = $true)]
        [string]
        $DomainName
    )

    Import-DscResource -ModuleName PowerStigDsc

    Node localhost
    {
        WindowsServer BaseLineSettings
        {
            OsVersion   = $OsVersion
            OsRole      = $OsRole
            StigVersion = $StigVersion
            ForestName  = $ForestName
            DomainName  = $DomainName
        }
    }
}
