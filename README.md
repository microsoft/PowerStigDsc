# PowerStigDsc

|Branch|Status|
| ---- | ---- |
| master | [![Build status](https://ci.appveyor.com/api/projects/status/h9lcjalgdlneyd46/branch/master?svg=true)](https://ci.appveyor.com/api/projects/status/h9lcjalgdlneyd46/branch/master?svg=true) |
| dev | [![Build status](https://ci.appveyor.com/api/projects/status/h9lcjalgdlneyd46/branch/dev?svg=true)](https://ci.appveyor.com/api/projects/status/h9lcjalgdlneyd46/branch/dev?svg=true) |

**PowerStigDsc** is a Windows PowerShell Desired State Configuration (DSC) composite resource to manage the configurable items of the DISA STIG's.
This is accomplished by using OSS DSC Resources that are specialized to a specific area of the STIG from the PowerShell gallery. PowerStigDsc depends on an external module [PowerStig](https://github.com/Microsoft/PowerStig) for the STIG data and multiple DSC resources to apply the setting. All of the required dependencies are defined in the module manifest so they are automatically downloaded if you install PowerStigDsc from the [PowerShell Gallery](https://www.powershellgallery.com/packages/PowerStigDsc).

This project has adopted the [Microsoft Open Source Code of Conduct](
  https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](
  https://opensource.microsoft.com/codeofconduct/faq/)
or contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions
or comments.

## Contributing

Please check out common DSC Resources [contributing guidelines](
  https://github.com/PowerShell/DscResources/blob/master/CONTRIBUTING.md).
Thank you to everyone that has reviewed the project and provided feedback through issues.
We are especially thankful for those who have contributed pull requests to the code and documentation.

### Contributors

* [@athaynes](https://github.com/athaynes) (Adam Haynes)
* [@bgouldman](https://github.com/bgouldman) (Brian Gouldman)
* [@camusicjunkie](https://github.com/camusicjunkie)
* [@chasewilson](https://github.com/chasewilson) (Chase Wilson)
* [@jcwalker](https://github.com/jcwalker) (Jason Walker)
* [@mcollera](https://github.com/mcollera)
* [@regedit32](https://github.com/regedit32) (Reggie Gibson)

## Composite Resources

* [Browser](https://github.com/Microsoft/PowerStigDsc/wiki/Browser): Provides a mechanism to manage Browser STIG settings.

* [SqlServer](https://github.com/Microsoft/PowerStigDsc/wiki/SqlServer): Provides a mechanism to manage SqlServer STIG settings.

* [WindowsDnsServer](https://github.com/Microsoft/PowerStigDsc/wiki/WindowsDnsServer): Provides a mechanism to manage Windows DNS Server STIG settings.

* [WindowsFirewall](https://github.com/Microsoft/PowerStigDsc/wiki/WindowsFirewall): Provides a mechanism to manage the Windows Firewall STIG settings.

* [WindowsServer](https://github.com/Microsoft/PowerStigDsc/wiki/WindowsServer): Provides a mechanism to manage the Windows Server STIG settings.

## Versions

### Unreleased

* Replaced PowerStig Technology Class with Enumeration

### 1.1.0.0

* Added ModuleVersion parameter to each Import-DscResource for all composite resources
* Added support for Technology enumeration added to PowerStig 1.1.0.0

### 1.0.0.0

* Browser Composite
* Windows DNS Server Composite
* Windows Firewall Composite
* Windows Server Composite
