$script:DSCModuleName            = 'PowerStigDsc'
$script:DSCCompositeResourceName = 'DotNetFramework'

#region HEADER
# Integration Test Template Version: 1.1.1
[String] $script:moduleRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
if ( (-not (Test-Path -Path (Join-Path -Path $script:moduleRoot -ChildPath 'DSCResource.Tests'))) -or `
     (-not (Test-Path -Path (Join-Path -Path $script:moduleRoot -ChildPath 'DSCResource.Tests\TestHelper.psm1'))) )
{
    & git @('clone','https://github.com/PowerShell/DscResource.Tests.git',(Join-Path -Path $script:moduleRoot -ChildPath '\DSCResource.Tests\'))
}

Import-Module (Join-Path -Path $script:moduleRoot -ChildPath 'Tests\helper.psm1' ) -Force
Import-Module (Join-Path -Path $script:moduleRoot -ChildPath 'DSCResource.Tests\TestHelper.psm1') -Force
$TestEnvironment = Initialize-TestEnvironment `
    -DSCModuleName $script:DSCModuleName `
    -DSCResourceName $script:DSCCompositeResourceName `
    -TestType Integration
#endregion

# Using try/finally to always cleanup even if something awful happens.
try
{
    #region Integration Tests
    $ConfigFile = Join-Path -Path $PSScriptRoot -ChildPath "$($script:DSCCompositeResourceName).config.ps1"
    . $ConfigFile

    $stigList = Get-StigVersionTable -CompositeResourceName $script:DSCCompositeResourceName

    #region Integration Tests
    Foreach ($stig in $stigList)
    {

        Describe "Framework $($stig.TechnologyRole) $($stig.StigVersion) mof output" {

        It 'Should compile the MOF without throwing' {
            {
                & "$($script:DSCCompositeResourceName)_config" `
                -FrameworkVersion $stig.TechnologyRole `
                -StigVersion $stig.stigVersion `
            -OutputPath $TestDrive
            } | Should Not throw
        }

        [xml] $dscXml = Get-Content -Path $stig.Path

        $ConfigurationDocumentPath = "$TestDrive\localhost.mof"

        $instances = [Microsoft.PowerShell.DesiredStateConfiguration.Internal.DscClassCache]::ImportInstances($ConfigurationDocumentPath, 4)

        Context 'Registry' {
            $hasAllSettings = $true
            $dscXml = $dscXml.DISASTIG.RegistryRule.Rule
            $dscMof = $instances | 
                Where-Object {$PSItem.ResourceID -match "\[Registry\]"}

            Foreach ($setting in $dscXml)
            {
                If (-not ($dscMof.ResourceID -match $setting.Id) )
                {
                    Write-Warning -Message "Missing registry Setting $($setting.Id)"
                    $hasAllSettings = $false
                }
            }

            It "Should have $($dscXml.Count) Registry settings" {
                $hasAllSettings | Should Be $true
            }
        }
    }
}
#endregion Tests
}
finally
{
#region FOOTER
Restore-TestEnvironment -TestEnvironment $TestEnvironment
#endregion
}

