#region Header
Import-Module "$PSScriptRoot\..\helper.psm1" -Force

# Build the path to the config file.
$compositeResourceName = $MyInvocation.MyCommand.Name -replace "\.tests\.ps1",""
$configFilePath = Join-Path -Path $PSScriptRoot -ChildPath "$compositeResourceName.config.ps1"
# load the config into memory
. $configFilePath

$stigList = Get-StigVersionTable -CompositeResourceName 'WindowsFirewall'
#endregion Header
#region Test Setup
#endregion Test Setup
#region Tests
Foreach ($stig in $stigList)
{
    Describe "Windows Firewall $($stig.stigVersion) mof output" {

        It 'Should compile the MOF without throwing' {
            {
                & "$($compositeResourceName)_config" `
                    -StigVersion $stig.StigVersion `
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
