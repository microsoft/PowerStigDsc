#region Header
[string] $script:moduleRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$moduleName = 'PowerStigDsc'
Import-Module "$script:moduleRoot\tests\helper.psm1" -Force

#region Tests

Describe 'Common Tests - Configuration Module Requirements' {

    $Files = Get-ChildItem -Path $script:moduleRoot
    $Manifest = Import-PowerShellDataFile -Path "$script:moduleRoot\$moduleName.psd1"

    Context "$moduleName module manifest properties" {

        It 'Should be a valid Manifest' {
            {Microsoft.PowerShell.Core\Test-ModuleManifest -Path "$script:moduleRoot\$moduleName.psd1" } |
            Should Not Throw
        }

        It 'Contains a module manifest that aligns to the folder and module names' {
            $Files.Name.Contains("$moduleName.psd1") | Should Be True
        }
        It 'Contains a readme' {
            Test-Path "$($script:moduleRoot)\README.md" | Should Be True
        }
        It "Manifest $moduleName.psd1 should import as a data file" {
            $Manifest | Should BeOfType 'Hashtable'
        }
        It 'Should have a GUID in the manifest' {
            $Manifest.GUID | Should Match '[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}'
        }
        It 'Should list requirements in the manifest' {
            $Manifest.RequiredModules | Should Not BeNullOrEmpty
        }
        It 'Should list a module version in the manifest' {
            $Manifest.ModuleVersion | Should BeGreaterThan 0.0.0.0
        }
        It 'Should list an author in the manifest' {
            $Manifest.Author | Should Not BeNullOrEmpty
        }
        It 'Should provide a description in the manifest' {
            $Manifest.Description | Should Not BeNullOrEmpty
        }
        It 'Should require PowerShell version 5.0 or later in the manifest' {
            $Manifest.PowerShellVersion | Should BeGreaterThan 5.0
        }
        It 'Should require CLR version 4 or later in the manifest' {
            $Manifest.CLRVersion | Should BeGreaterThan 4.0
        }
        It 'Should export DscResources in the manifest' {
            $Manifest.DscResourcesToExport | Should Not BeNullOrEmpty
        }
        It 'Should include tags in the manifest' {
            $Manifest.PrivateData.PSData.Tags | Should Not BeNullOrEmpty
        }
        It 'Should include a project URI in the manifest' {
            $Manifest.PrivateData.PSData.ProjectURI | Should Not BeNullOrEmpty
        }
    }

    if ($Manifest.RequiredModules)
    {
        Context "$moduleName required modules" {

            ForEach ($RequiredModule in $Manifest.RequiredModules)
            {
                if ($RequiredModule.GetType().Name -eq 'Hashtable')
                {
                    It "$($RequiredModule.ModuleName) version $($RequiredModule.ModuleVersion) should be found in the PowerShell public gallery" {
                        {Find-Module -Name $RequiredModule.ModuleName -RequiredVersion $RequiredModule.ModuleVersion -Repository 'PsGallery' } | Should Not BeNullOrEmpty
                    }
                    # It "$($RequiredModule.ModuleName) version $($RequiredModule.ModuleVersion) should install locally without error" {
                    #     {Install-Module -Name $RequiredModule.ModuleName -RequiredVersion $RequiredModule.ModuleVersion -Scope CurrentUser -Force -Repository 'PsGallery' } | Should Not Throw
                    # }
                }
                else
                {
                    It "$RequiredModule should be found in the PowerShell public gallery" {
                        {Find-Module -Name $RequiredModule -Repository 'PsGallery' } | Should Not BeNullOrEmpty
                    }
                    # It "$RequiredModule should install locally without error" {
                    #     {Install-Module -Name $RequiredModule -Scope CurrentUser -Force -Repository 'PsGallery' } | Should Not Throw
                    # }
                }
            }
        }
    }
}

#endregion Tests
