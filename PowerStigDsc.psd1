@{
    # Version number of this module.
    ModuleVersion = '1.0.0.0'

    # ID used to uniquely identify this module
    GUID = '80479bf1-c535-49de-bd10-9a54a49eb4a1'

    # Author of this module
    Author = 'Adam Haynes'

    # Company or vendor of this module
    CompanyName = 'Microsoft Corporation'

    # Copyright statement for this module
    Copyright = '(c) 2017 Adam Haynes. All rights reserved.'

    # Description of the functionality provided by this module
    Description = 'Module for managing the DISA STIGs'

    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion = '5.1'

    # Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
    CLRVersion = '4.0'

    # Modules that must be imported into the global environment prior to importing this module
    RequiredModules  = @(
        @{ModuleName = 'PowerStig'; ModuleVersion = '1.0.0.0'},
        @{ModuleName = 'AuditPolicyDsc'; ModuleVersion = '1.1.0.0'},
        @{ModuleName = 'AccessControlDsc'; ModuleVersion = '1.1.0.0'},
        @{ModuleName = 'SecurityPolicyDsc'; ModuleVersion = '2.1.0.0'},
        @{ModuleName = 'xDnsServer'; ModuleVersion = '1.9.0.0'},
        @{ModuleName = 'xPSDesiredStateConfiguration'; ModuleVersion = '8.0.0.0'},
        @{ModuleName = 'xWinEventLog'; ModuleVersion = '1.1.0.0'}
        )

    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
    FunctionsToExport = @()

    # Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
    CmdletsToExport = @()

    # Variables to export from this module
    VariablesToExport = @()

    # Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
    AliasesToExport = @()

    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData = @{

        PSData = @{

            ExternalModuleDependencies = @('AuditPolicyDSC','AccessControlDsc',
            'SecurityPolicyDSC','xDnsServer','xPSDesiredStateConfiguration')

            # Tags applied to this module. These help with module discovery in online galleries.
            Tags = @('DSC','DesiredStateConfiguration','STIG','PowerStig')

            # A URL to the license for this module.
            LicenseUri = 'https://github.com/Microsoft/PowerStigDsc/blob/master/LICENSE'

            # A URL to the main website for this project.
            ProjectUri = 'https://github.com/Microsoft/PowerStigDsc'

            # A URL to an icon representing this module.
            # IconUri = ''

            # ReleaseNotes of this module
            ReleaseNotes = '
            Production release
            Fixed resource name formatting
            Added ForestName parameter to WindowsServer and WindowsDnsServer STIG to properly resolve forest account names.'

        } # End of PSData hashtable

    } # End of PrivateData hashtable

    # HelpInfo URI of this module
    # HelpInfoURI = ''

    # Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
    # DefaultCommandPrefix = ''

    }
