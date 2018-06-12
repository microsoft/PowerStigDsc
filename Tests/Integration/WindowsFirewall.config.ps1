Configuration WindowsFirewall_config
{
    param 
    (
        [Parameter(Mandatory = $true)]
        [version]
        $StigVersion
    )

    Import-DscResource -ModuleName PowerStigDsc
    
    Node localhost
    {
        WindowsFirewall BaseLineSettings
        {
            StigVersion = $StigVersion
        } 
    }
}
