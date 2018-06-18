### Example 1: Use the embedded STIG data with default range values.
In this example, the Windows Firewall V1 R6 STIG is processed by the composite resource and merges in the default values for any settings that have a valid range.

configuration Sample_WindowsFirewall_Default
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
        }
    }
}

Sample_WindowsFirewall_Default
