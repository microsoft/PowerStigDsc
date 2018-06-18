
$script:DSCModuleName            = 'PowerStigDsc'
$script:DSCCompositeResourceName = 'WindowsDnsServer'

#region HEADER
[String] $script:moduleRoot = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $script:MyInvocation.MyCommand.Path))
if ( (-not (Test-Path -Path (Join-Path -Path $moduleRoot -ChildPath 'DSCResource.Tests'))) -or `
     (-not (Test-Path -Path (Join-Path -Path $moduleRoot -ChildPath 'DSCResource.Tests\TestHelper.psm1'))) )
{
    & git @('clone','https://github.com/PowerShell/DscResource.Tests.git',(Join-Path -Path $moduleRoot -ChildPath '\DSCResource.Tests\'))
}
else
{
    & git @('-C',(Join-Path -Path $moduleRoot -ChildPath '\DSCResource.Tests\'),'pull')
}

Import-Module (Join-Path -Path $moduleRoot -ChildPath 'Tests\helper.psm1') -Force
Import-Module (Join-Path -Path $moduleRoot -ChildPath 'DSCResource.Tests\TestHelper.psm1') -Force
# $TestEnvironment = Initialize-TestEnvironment `
#     -DSCModuleName $script:DSCModuleName `
#     -DSCResourceName $script:DSCCompositeResourceName `
#     -TestType Unit

$compositeManifestPath = "$($script:moduleRoot)\DscResources\$script:DSCCompositeResourceName\$script:DSCCompositeResourceName.psd1"
$compositeSchemaPath   = "$($script:moduleRoot)\DscResources\$script:DSCCompositeResourceName\$script:DSCCompositeResourceName.schema.psm1"
#endregion

    # Begin Testing
    try
    {
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
}
finally
{
    #region FOOTER
    #Restore-TestEnvironment -TestEnvironment $TestEnvironment
    #endregion
}
