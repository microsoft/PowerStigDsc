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
        $StigVersion
    )

    Import-DscResource -ModuleName PowerStigDsc

    Node localhost
    {
        WindowsServer BaseLineSettings
        {
            OsVersion   = $OsVersion
            OsRole      = $OsRole
            StigVersion = $StigVersion
        } 
    }
}
