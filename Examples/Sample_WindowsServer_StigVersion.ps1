<#
    Use the embedded STIG data with default range values.
    In this example, the Windows Server 2012R2 V2 R8 member server STIG is
    processed by the composite resource and merges in the default values for
    any settings that have a valid range.
#>

configuration ServerX
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
            StigVersion = '2.8'
        }
    }
}
```

### Example 3: Use embedded STIG data and inject exception data.
In this example, the Windows Server 2012R2 V2 R8 domain controller STIG is processed by the composite resource and merges in the default values for any settings that have a valid range.
Additionally, an exception is added inline to the configuration, so that the setting in STIG ID V-1000 would be over written with the value 1.

```powershell
configuration ServerX
{
    Import-DscResource -ModuleName PowerStigDsc

    Node localhost
    {
        WindowsServer BaseLine
        {
            OsVersion   = '2012R2'
            OsRole      = 'DomainController'
            StigVersion = '2.8'
            Exception   = @{'V-1000'='1'}
        }
    }
}
```

### Example 4: Provide an organizational range xml file to merge into the main STIG settings.
In this example, the Windows Server 2012R2 V2 R8 domain controller STIG is processed by the composite resource.
Instead of merging in the default values for any settings that have a valid range, the organization
has provided the list of values to merge into the valid ranges.

```powershell
configuration ServerX
{
    Import-DscResource -ModuleName PowerStigDsc

    Node localhost
    {
        WindowsServer BaseLine
        {
            OsVersion   = '2012R2'
            OsRole      = 'DomainController'
            StigVersion = '2.8'
            OrgSetting  = 'C:\stigs\2012-MS-2.8.org.xml'
        }
    }
}
```

### Example 5: Use embedded STIG data and inject a skipped rule.
In this example, the Windows Server 2012R2 V2 R8 domain controller STIG is processed by the composite resource and merges in the default values for any settings that have a valid range.
Additionally, a skip is added inline to the configuration, so that the setting in STIG ID V-1000 would be marked to skip configuration when applied.

```powershell
configuration ServerX
{
    Import-DscResource -ModuleName PowerStigDsc

    Node localhost
    {
        WindowsServer BaseLine
        {
            OsVersion   = '2012R2'
            OsRole      = 'DomainController'
            StigVersion = '2.8'
            SkipRule    = 'V-1000'
        }
    }
}
```

### Example 6: Use embedded STIG data and skip an entire rule set.
In this example, the Windows Server 2012R2 V2 R8 domain controller STIG is processed by the composite resource and merges in the default values for any settings that have a valid range.
Additionally, a skip is added inline to the configuration, so that the setting for all STIG ID's with the type 'AuditPolicyRule' would be marked to skip configuration when applied.

```powershell
configuration ServerX
{
    Import-DscResource -ModuleName PowerStigDsc

    Node localhost
    {
        WindowsServer BaseLine
        {
            OsVersion    = '2012R2'
            OsRole       = 'DomainController'
            StigVersion  = '2.8'
            SkipRuleType = 'AuditPolicyRule'
        }
    }
}
```
