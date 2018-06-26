
$script:DSCModuleName            = 'PowerStigDsc'
$script:DSCCompositeResourceName = 'Browser'

#region HEADER
$script:moduleRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
Import-Module (Join-Path -Path $moduleRoot -ChildPath 'Tests\helper.psm1') -Force

$compositeManifestPath = "$($script:moduleRoot)\DscResources\$script:DSCCompositeResourceName\$script:DSCCompositeResourceName.psd1"
$compositeSchemaPath   = "$($script:moduleRoot)\DscResources\$script:DSCCompositeResourceName\$script:DSCCompositeResourceName.schema.psm1"
#endregion

Describe "$($script:DSCCompositeResourceName) Composite resource" {

    It 'Should be a valid manifest' {
        {Test-ModuleManifest -Path $compositeManifestPath} | Should Not Throw
    }

    It 'Should contain a schema module' {
        Test-Path -Path $compositeSchemaPath | Should Be $true
    }

    It 'Should contain a correctly named configuration' {
        $configurationName = Get-ConfigurationName -FilePath $compositeSchemaPath
        $configurationName | Should Be $script:DSCCompositeResourceName
    }

    It "Should match ValidateSet from PowerStig" {
        $validateSet = Get-StigVersionParameterValidateSet -FilePath $compositeSchemaPath
        $powerStigVersion = Get-PowerStigVersionFromManifest -ManifestPath "$($script:moduleRoot)\$($script:DSCModuleName).psd1"
        $availableStigVersions = Get-ValidStigVersionNumbers -CompositeResourceName $script:DSCCompositeResourceName -ModuleVersion $powerStigVersion

        $validateSet | Should BeIn $availableStigVersions
    }
}
