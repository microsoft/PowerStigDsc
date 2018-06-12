Configuration WindowsServerSkip_config
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

        [Parameter(Mandatory = $false)]
        [psobject]
        $SkipRule,

        [Parameter(Mandatory = $false)]
        [psobject]
        $SkipRuleType
    )

    Import-DscResource -ModuleName PowerStigDsc

    Node localhost
    {
        WindowsServer BaseLineSettings
        {
            OsVersion    = $OsVersion
            OsRole       = $OsRole
            StigVersion  = $StigVersion
            SkipRule     = $SkipRule
            SkipRuleType = $SkipRuleType
        } 
    }
}
