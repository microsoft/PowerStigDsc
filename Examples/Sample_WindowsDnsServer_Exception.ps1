<#
    Use embedded STIG data and inject exception data. In this example,
    the Windows DNS Server 2012 R2 V1 R7 STIG is processed by the
    composite resource and merges in the default values for any settings
    that have a valid range. Additionally, an exception is added inline
    to the configuration, so that the setting in STIG ID V-1000 would be
    over written with the value 1.
#>

configuration Sample_WindowsDnsServer_Exception
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
        WindowsDnsServer DnsSettings
        {
            OsVersion   = '2012R2'
            StigVersion = '1.7'
            Exception   = @{"V-1000"='1'}
        }
    }
}

Sample_WindowsDnsServer_Exception
