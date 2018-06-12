#region Header
[string] $sutRoot = $MyInvocation.MyCommand.Path -replace '\\tests\\', '\src\' `
                                                 -replace '\.tests\.ps1', '' `
                                                 -replace '\\unit\\', '\'

Import-Module "$PSScriptRoot\..\helper.psm1" -Force
#endregion
#region Test Setup
$manifestData = Import-PowerShellDataFile -Path "$sutRoot.psd1"
Write-Output 'Getting PowerStig module details from gallery.'
$powerStigModuleSpecification = Find-Module -Name PowerStig -Repository PSGallery
#endregion Test Setup
#region Tests
Describe 'Manifest' {
    [version] $manifestPowerStigVersion = $manifestData.RequiredModules.Where( 
                                                {$PSItem.ModuleName -eq 'PowerStig'} ).ModuleVersion
    [version] $galleryPowerStigVersion  = $powerStigModuleSpecification.Version

    It 'Should require the most recent PowerStig version' {
        $manifestPowerStigVersion | Should Be $galleryPowerStigVersion
    }
}
#endregion Tests
