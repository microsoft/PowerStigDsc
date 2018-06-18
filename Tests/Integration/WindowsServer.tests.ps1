#region Header
Import-Module "$PSScriptRoot\..\helper.psm1" -Force

# Build the path to the config file.
$compositeResourceName = $MyInvocation.MyCommand.Name -replace "\.tests\.ps1",""
$configFilePath = Join-Path -Path $PSScriptRoot -ChildPath "$compositeResourceName.config.ps1"
# load the config into memory
. $configFilePath

$stigList = Get-StigVersionTable -CompositeResourceName 'WindowsServer'
#endregion Header
#region Test Setup
#endregionTest Setup
#region Tests
Foreach ($stig in $stigList)
{
    Describe "Windows $($stig.TechnologyVersion) $($stig.TechnologyRole) $($stig.StigVersion) mof output" {

        It 'Should compile the MOF without throwing' {
            {
                & "$($compositeResourceName)_config" `
                    -OsVersion $stig.TechnologyVersion  `
                    -OsRole $stig.TechnologyRole `
                    -StigVersion $stig.StigVersion `
                    -ForestName 'integration.test' `
                    -DomainName 'integration.test' `
                    -OutputPath $TestDrive
            } | Should not throw
        }

        [xml] $dscXml = Get-Content -Path $stig.Path

        $ConfigurationDocumentPath = "$TestDrive\localhost.mof"

        $instances = [Microsoft.PowerShell.DesiredStateConfiguration.Internal.DscClassCache]::ImportInstances($ConfigurationDocumentPath, 4)

        Context 'AuditPolicy' {
            $hasAllSettings = $true
            $dscXml         = $dscXml.DISASTIG.AuditPolicyRule.Rule
            $dscMof         = $instances |
                Where-Object {$PSItem.ResourceID -match "\[AuditPolicySubcategory\]"}

            Foreach ( $setting in $dscXml )
            {
                If (-not ($dscMof.ResourceID -match $setting.Id) )
                {
                    Write-Warning -Message "Missing Audit Policy Setting $($setting.Id)"
                    $hasAllSettings = $false
                }
            }

            It "Should have $($dscXml.Count) Audit Policy settings" {
                $hasAllSettings | Should Be $true
            }
        }

        Context 'Permissions' {
            $hasAllSettings = $true
            $dscXmlPermissionPolicy = $dscXml.DISASTIG.PermissionRule.Rule |
                Where-Object {$PSItem.conversionstatus -eq "pass"}
            $dscMofPermissionPolicy = $instances |
                Where-Object {$PSItem.ResourceID -match "\[NTFSAccessEntry\]|\[RegistryAccessEntry\]"}

            Foreach ($setting in $dscXmlPermissionPolicy)
            {
                If (-not ($dscMofPermissionPolicy.ResourceID -match $setting.Id) )
                {
                    Write-Warning -Message "Missing permission setting $($setting.Id)"
                    $hasAllSettings = $false
                }
            }

            It "Should have $($dscXmlPermissionPolicy.Count) permission settings" {
                $hasAllSettings | Should Be $true
            }
        }

        Context 'Registry' {
            $hasAllSettings = $true
            $dscXml   = $dscXml.DISASTIG.RegistryRule.Rule
            $dscMof   = $instances |
                Where-Object {$PSItem.ResourceID -match "\[Registry\]"}

            Foreach ( $setting in $dscXml )
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

        Context 'WMI' {
            $hasAllSettings = $true
            $dscXml    = $dscXml.DISASTIG.WmiRule.Rule
            $dscMof   = $instances |
                Where-Object {$PSItem.ResourceID -match "\[script\]"}

            Foreach ( $setting in $dscXml )
            {
                If (-not ($dscMof.ResourceID -match $setting.Id) )
                {
                    Write-Warning -Message "Missing wmi setting $($setting.Id)"
                    $hasAllSettings = $false
                }
            }

            It "Should have $($dscXml.Count) wmi settings" {
                $hasAllSettings | Should Be $true
            }
        }

        Context 'Services' {
            $hasAllSettings = $true
            $dscXml = $dscXml.DISASTIG.ServiceRule.Rule
            $dscMof = $instances |
                Where-Object {$PSItem.ResourceID -match "\[xService\]"}

            Foreach ( $setting in $dscXml )
            {
                If (-not ($dscMof.ResourceID -match $setting.Id) )
                {
                    Write-Warning -Message "Missing service setting $($setting.Id)"
                    $hasAllSettings = $false
                }
            }

            It "Should have $($dscXml.Count) service settings" {
                $hasAllSettings | Should Be $true
            }
        }

        Context 'AccountPolicy' {
            $hasAllSettings = $true
            $dscXml = $dscXml.DISASTIG.AccountPolicyRule.Rule
            $dscMof = $instances |
                Where-Object {$PSItem.ResourceID -match "\[AccountPolicy\]"}

            Foreach ( $setting in $dscXml )
            {
                If (-not ($dscMof.ResourceID -match $setting.Id) )
                {
                    Write-Warning -Message "Missing security setting $($setting.Id)"
                    $hasAllSettings = $false
                }
            }

            It "Should have $($dscXml.Count) security settings" {
                $hasAllSettings | Should Be $true
            }
        }

        Context 'UserRightsAssignment' {
            $hasAllSettings = $true
            $dscXml = $dscXml.DISASTIG.UserRightRule.Rule
            $dscMof = $instances |
                Where-Object {$PSItem.ResourceID -match "\[UserRightsAssignment\]"}

            Foreach ( $setting in $dscXml )
            {
                If (-not ($dscMof.ResourceID -match $setting.Id) )
                {
                    Write-Warning -Message "Missing user right $($setting.Id)"
                    $hasAllSettings = $false
                }
            }

            It "Should have $($dscXml.Count) user rights settings" {
                $hasAllSettings | Should Be $true
            }
        }

        Context 'SecurityOption' {
            $hasAllSettings = $true
            $dscXml = $dscXml.DISASTIG.SecurityOptionRule.Rule
            $dscMof = $instances |
                Where-Object {$PSItem.ResourceID -match "\[SecurityOption\]"}

            Foreach ( $setting in $dscXml )
            {
                If (-not ($dscMof.ResourceID -match $setting.Id) )
                {
                    Write-Warning -Message "Missing security setting $($setting.Id)"
                    $hasAllSettings = $false
                }
            }

            It "Should have $($dscXml.Count) security settings" {
                $hasAllSettings | Should Be $true
            }
        }

        Context 'Windows Feature' {
            $hasAllSettings = $true
            $dscXml = $dscXml.DISASTIG.WindowsFeatureRule.Rule
            $dscMof = $instances |
                Where-Object {$PSItem.ResourceID -match "\[WindowsFeature\]"}

            Foreach ($setting in $dscXml)
            {
                If (-not ($dscMof.ResourceID -match $setting.Id) )
                {
                    Write-Warning -Message "Missing windows feature $($setting.Id)"
                    $hasAllSettings = $false
                }
            }

            It "Should have $($dscXml.Count) windows feature settings" {
                $hasAllSettings | Should Be $true
            }
        }
    }
}
#endregion Tests
