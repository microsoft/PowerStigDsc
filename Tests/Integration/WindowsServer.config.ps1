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
        $DomainName,

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
        & ([scriptblock]::Create("
            WindowsServer BaseLineSettings
            {
                OsVersion    = '$OsVersion'
                OsRole       = '$OsRole'
                StigVersion  = '$StigVersion'
                ForestName   = '$ForestName'
                DomainName   = '$DomainName'
                $(if($SkipRule)
                {
                    "SkipRule = '$SkipRule'`n"
                }
                if ($SkipRuleType)
                {
                    "SkipRuleType = '$SkipRuleType'`n"
                })
            }")
        )
    }
}
