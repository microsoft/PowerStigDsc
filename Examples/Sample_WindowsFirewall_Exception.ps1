<#
    Use embedded STIG data and inject exception data.
    In this example, the Windows Firewall V1 R6 STIG is processed by the composite
    resource and merges in the default values for any settings that have a valid range.
    Additionally, an exception is added inline to the configuration, so that the setting
    in STIG ID V-1000 would be over written with the value 1.
#>

configuration Sample_WindowsFirewall_Exception
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
        WindowsFirewall Sample_WindowsFirewall_Exception
        {
            StigVersion = '1.6'
            Exception   = @{'V-1000'='1'}
        }
    }
}

Sample_WindowsFirewall_Exception
