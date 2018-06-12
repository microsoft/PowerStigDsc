Configuration WindowsDnsServer_config
{
    param 
    (
        [Parameter(Mandatory = $true)]
        [string]
        $OsVersion,

        [Parameter(Mandatory = $true)]
        [version]
        $StigVersion
    )

    Import-DscResource -ModuleName PowerStigDsc

    Node localhost
    {
        WindowsDnsServer BaseLineSettings
        {
            OsVersion   = $OsVersion
            StigVersion = $StigVersion
        } 
    }
}
