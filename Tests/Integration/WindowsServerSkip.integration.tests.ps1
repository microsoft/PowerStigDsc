$script:DSCModuleName            = 'PowerStigDsc'
$script:DSCCompositeResourceName = 'WindowsServer'

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
        Describe "Windows $($stig.TechnologyVersion) $($stig.TechnologyRole) $($stig.StigVersion) Single SkipRule/RuleType mof output" {

            [xml] $dscXml = Get-Content -Path $stig.Path
            $RegistryIds  = $dscXml.DISASTIG.RegistryRule.Rule.id
            $SkipRule     = Get-Random -InputObject $RegistryIds
            $skipRuleType = "AuditPolicyRule"

            It 'Should compile the MOF without throwing' {
                {
                    & "$($script:DSCCompositeResourceName)_config" `
                        -OsVersion $stig.TechnologyVersion  `
                        -OsRole $stig.TechnologyRole `
                        -StigVersion $stig.StigVersion `
                        -ForestName 'integration.test' `
                        -DomainName 'integration.test' `
                        -SkipRule $skipRule `
                        -SkipRuleType $skipRuleType `
                        -OutputPath $TestDrive
                } | Should not throw
            }

            #region Gets the mof content
            $ConfigurationDocumentPath = "$TestDrive\localhost.mof"
            $instances = [Microsoft.PowerShell.DesiredStateConfiguration.Internal.DscClassCache]::ImportInstances($ConfigurationDocumentPath, 4)
            #endregion

            Context 'Skip check' {

                #region counts how many Skips there are and how many there should be.
                $dscXml = $dscXml.DISASTIG.AuditPolicyRule.Rule | Where-Object {$_.ConversionStatus -eq "pass"}
                $dscXml = ($($dscXml.Count) + $($SkipRule.Count))

                $dscMof = $instances | Where-Object {$PSItem.ResourceID -match "\[Skip\]"}
                #endregion

                It "Should have $dscXml Skipped settings" {
                    $dscMof.count | Should Be $dscXml
                }
            }
        }

        Describe "Windows $($stig.TechnologyVersion) $($stig.TechnologyRole) $($stig.StigVersion) Multiple SkipRule/RuleType mof output" {

            [xml] $dscXml = Get-Content -Path $stig.Path
            $RegistryIds = $dscXml.DISASTIG.RegistryRule.Rule.id
            $skipRule = @()
            $skipCount = 2

            # Gets a set of random rule Id's
            while ($skipRule.Count -le $skipCount)
            {
                $skipToAdd = Get-Random -InputObject $RegistryIds

                if ($skipToAdd -contains $skiprule)
                {
                    $null
                }
                else
                {
                    $skiprule += $skipToAdd
                }
            }

            $skipRuleType = @("AuditPolicyRule", "AccountPolicyRule")

            It 'Should compile the MOF without throwing' {
                {
                    & "$($script:DSCCompositeResourceName)_config" `
                        -OsVersion $stig.TechnologyVersion  `
                        -OsRole $stig.TechnologyRole `
                        -StigVersion $stig.StigVersion `
                        -ForestName 'integration.test' `
                        -DomainName 'integration.test' `
                        -SkipRule $skipRule `
                        -SkipRuleType $skipRuleType `
                        -OutputPath $TestDrive
                } | Should not throw
            }

            #region Gets the mof content
            $ConfigurationDocumentPath = "$TestDrive\localhost.mof"
            $instances = [Microsoft.PowerShell.DesiredStateConfiguration.Internal.DscClassCache]::ImportInstances($ConfigurationDocumentPath, 4)
            #endregion

            Context 'Skip check' {

                #region counts how many Skips there are and how many there should be.
                $dscAuditXml = $dscXml.DISASTIG.AuditPolicyRule.Rule | Where-Object {$_.ConversionStatus -eq "Pass"}
                $dscPermissionXml = $dscXml.DISASTIG.AccountPolicyRule.Rule | Where-Object {$_.ConversionStatus -eq "Pass"}

                $dscXml = ($($dscAuditXml.Count) + $($dscPermissionXml.count) + $($skipRule.Count))

                $dscMof = $instances | Where-Object {$PSItem.ResourceID -match "\[Skip\]"}
                #endregion

                It "Should have $dscXml Skipped settings" {
                    $dscMof.count | Should Be $dscXml
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
