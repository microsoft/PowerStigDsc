# SqlServer

## Syntax

```powershell
SqlServer [string] #ResourceName
{
    SqlVersion     = [string] { 2012 }
    SqlRole        = [string] { Database, Instance }
  [ ServerInstance = [array]
  [ Database       = [array]
  [ StigVersion    = [version] ]
  [ Exception      = [hashtable] ]
  [ OrgSetting     = [xml] ]
  [ SkipRule       = [psobject] ]
  [ SkipRuleType   = [psobject] ]
}
```

## Properties

| Property | Description |
| -------- | ----------- |
| SqlVersion     | The version of the SQL Server Version that the configuration is applying to. |
| SqlRole        | The scope that the STIG will cover. |
| ServerInstance | The SQL Server Instance Name. If you want the default Instance, Only use the hosting computer name. |
| Database       | The name of the database that the configuration is applying to. |
| StigVersion    | The version of the STIG you want to apply. If no value is provided, the most recent version of the STIG is applied. |
| Exception      | A hash table of the exceptions to be applied to the server. The hashtable must be in the format StigId = Exception |
| OrgSetting     | This is an xml file that overrides the default settings of allowable ranges in the STIG. |
| SkipRule       | Rule Id/s that you do not want applied to the server. |
| SkipRuleType   | Rule type/s that you do not want applied to the server. |

## Example usage

There are several different ways that you can take advantage of the composite resource.

### Example 1: Use the embedded STIG data with default range values

In this example, the Windows SQL Server 2012 Instance V1 R16 STIG is processed by the composite resource and merges in the default values for any settings that have a valid range.
The server instance is only the hosting computername, which makes it the default SQL Instance.

```powershell
configuration ServerX
{
    Import-DscResource -ModuleName PowerStigDsc

    Node localhost
    {
        SqlServer SqlSettings
        {
            SqlVersion     = '2012'
            ServerInstance = 'ServerX'
            SqlRole        = 'Instance'
            OsVersion      = '2012R2'
            StigVersion    = '1.16'
        }
    }
}
```

### Example 2: Use embedded STIG data and inject exception data

In this example, the Windows SQL Server 2012 Instance V1 R16 STIG is processed by the composite resource and merges in the default values for any settings that have a valid range.
Additionally, an exception is added inline to the configuration, so that the setting in STIG ID V-1000 would be over written with the value 1.

```powershell
configuration ServerX
{
    Import-DscResource -ModuleName PowerStigDsc

    Node localhost
    {
        SqlServer SqlSettings
        {
            SqlVersion     = '2012'
            ServerInstance = 'ServerX'
            SqlRole        = 'Instance'
            StigVersion    = '1.16'
            Exception      = @{"V-1000"='1'}
        }
    }
}
```

### Example 3: Use embedded STIG data and inject a skipped rule

In this example, the Windows SQL Server 2012 Instance V1 R16 STIG is processed by the composite resource and merges in the default values for any settings that have a valid range.
Additionally, a skip is added inline to the configuration, so that the setting in STIG ID V-1000 would be marked to skip configuration when applied.

```powershell
configuration ServerX
{
    Import-DscResource -ModuleName PowerStigDsc

    Node localhost
    {
        SqlServer SqlSettings
        {
            SqlVersion     = '2012'
            ServerInstance = 'ServerX'
            SqlRole        = 'Instance'
            StigVersion    = '1.16'
            SkipRule       = "V-1000"
        }
    }
}
```
