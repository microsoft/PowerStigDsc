<#
    Use embedded STIG data and inject a skipped rule.
    In this example, the Windows Firewall V1 R6 STIG is processed by the composite
    resource and merges in the default values for any settings that have a valid range.
    Additionally, a skip is added inline to the configuration, so that the setting in
    STIG ID V-1000 would be marked to skip configuration when applied.
#>

configuration Sample_WindowsFirewall_SkipRule
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
        WindowsFirewall EnterpriseFirewallPolicy
        {
            StigVersion = '1.6'
            SkipRule    = 'V-1000'
        }
    }
}

Sample_WindowsFirewall_SkipRule
