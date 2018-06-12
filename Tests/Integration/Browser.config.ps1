Configuration Browser_config
{
    param 
    (
        [Parameter(Mandatory = $true)]
        [string]
        $BrowserVersion,

        [Parameter(Mandatory = $false)]
        [string]
        $StigVersion
    )

    Import-DscResource -ModuleName PowerStigDsc

    Node localhost
    {
        Browser InternetExplorer
        {
            BrowserVersion = $BrowserVersion
            Stigversion = $StigVersion
        } 
    }
}
