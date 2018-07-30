Configuration Browser_config
{
    param
    (
        [Parameter(Mandatory = $true)]
        [string]
        $BrowserVersion,

        [Parameter(Mandatory = $true)]
        [string]
        $StigVersion
    )

    Import-DscResource -ModuleName PowerStigDsc -ModuleVersion 1.0.0.0
    Node localhost
    {
        Browser InternetExplorer
        {
            BrowserVersion = $BrowserVersion
            Stigversion    = $StigVersion
        }
    }
}
