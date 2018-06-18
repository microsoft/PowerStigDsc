<#
    In this example, the Internet Explorer 11 STIG is processed by the composite resource.
#>

Configuration Sample_Browser
{
    param
    (
        [parameter()]
        [string]
        $NodeName = 'localhost'
    )

    Import-DscResource -ModuleName PowerStigDsc

    Node $NodeName
    {
        Browser InternetExplorerSettings
        {
            BrowserVersion = 'IE11'
            Stigversion    = '1.15'
        }
    }
}

Sample_Browser
