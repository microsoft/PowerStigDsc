<#
    Provide an organizational range xml file to merge into the main STIG settings.
    In this example, the Windows Server 2012R2 V2 R8 domain controller STIG is processed
    by the composite resource. Instead of merging in the default values for any settings
    that have a valid range, the organization has provided the list of values to merge
    into the valid ranges.
#>

configuration Sample_WindowsServer_OrgSettings
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
            OsRole      = 'MS'
            StigVersion = '2.12'
            DomainName  = 'sample.test'
            ForestName  = 'sample.test'
            OrgSettings = 'C:\stigs\2012-MS-2.8.org.xml'
        }
    }
}

Sample_WindowsServer_OrgSettings
