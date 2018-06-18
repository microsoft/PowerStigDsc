#region Header
Import-Module "$PSScriptRoot\..\helper.psm1" -Force

# Build the path to the config file.
$compositeResourceName = $MyInvocation.MyCommand.Name -replace "\.tests\.ps1",""
$configFilePath = Join-Path -Path $PSScriptRoot -ChildPath "$compositeResourceName.config.ps1"
# load the config into memory
. $configFilePath

$stigList = Get-StigVersionTable -CompositeResourceName 'WindowsServer'
#endregion Header

#region Tests
Foreach ($stig in $stigList)
{
    Describe "Windows $($stig.TechnologyVersion) $($stig.TechnologyRole) $($stig.StigVersion) Single SkipRule/RuleType mof output" {

        [xml] $dscXml = Get-Content -Path $stig.Path
        $RegistryIds = $dscXml.DISASTIG.RegistryRule.Rule.id
        $SkipRule     = Get-Random -InputObject $RegistryIds
        $skipRuleType = "AuditPolicyRule"

        It 'Should compile the MOF without throwing' {
            {
                & "$($compositeResourceName)_config" `
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
                & "$($compositeResourceName)_config" `
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
