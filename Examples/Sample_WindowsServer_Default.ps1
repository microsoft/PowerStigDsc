<#
    Use the embedded STIG data with default range values to apply the most recent STIG settings.
    In this example, the composite resource gets the highest 2012 R2 member server STIG version
    file it can find locally and applies it to the server. The composite resource merges in the
    default values for any settings that have a valid range.
#>

configuration Sample_WindowsServer_Default
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
        WindowsServer BaseLine
        {
            OsVersion   = '2012R2'
            OsRole      = 'MemberServer'
        }
    }
}

Sample_WindowsServer_Default
