<#
    Use the embedded STIG data with default range values.
    In this example, the Windows SQL Server 2012 V1 R17 STIG is processed by the
    composite resource and merges in the default values for any settings that have a valid range.
    Additionally, a skip is added inline to the configuration, so that the setting for all
    STIG ID's with the type 'SqlScriptQueryRule' would be marked to skip configuration when applied.
#>

configuration Example
{
    param
    (
        [parameter()]
        [string]
        $NodeName = 'localhost'
    )

    Import-DscResource -ModuleName PowerStigDsc

    Node localhost
    {
        SqlServer BaseLine 
        {
            SqlVersion     = '2012'
            SqlRole        = 'Instance'
            StigVersion    = '1.17'
            ServerInstance = 'ServerX\TestInstance'
            SkipRuleType   = 'SqlScriptQueryRule'
        }
    }
}

Example
