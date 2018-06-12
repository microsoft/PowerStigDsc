#region Header
Import-Module "$PSScriptRoot\..\helper.psm1" -Force

# Build the path to the config file.
$compositeResourceName = $MyInvocation.MyCommand.Name -replace "\.tests\.ps1",""
$configFilePath = Join-Path -Path $PSScriptRoot -ChildPath "$compositeResourceName.config.ps1"
# load the config into memory
. $configFilePath

$stigList = Get-StigVersionTable -CompositeResourceName 'Browser'
#endregion Header
#region Test Setup
#endregionTest Setup
#region Tests
Foreach ($stig in $stigList.GetEnumerator())
{
    $stigDetails = $stig.Key -Split "-"
    $BrowserVersion = $stigDetails[2]
    $StigVersion = $stigDetails[3]

    Describe "Browser $BrowserName $BrowserVersion mof output" {
    
        It 'Should compile the MOF without throwing' {
            {
                & "$($compositeResourceName)_config" `
                    -BrowserVersion $BrowserVersion `
                    -StigVersion $StigVersion `
                -OutputPath $TestDrive
            } | Should not throw
        }

        [xml] $dscXml = Get-Content -Path $stig.Value

        $ConfigurationDocumentPath = "$TestDrive\localhost.mof"

        $instances = [Microsoft.PowerShell.DesiredStateConfiguration.Internal.DscClassCache]::ImportInstances($ConfigurationDocumentPath, 4)
        Context 'Registry' {
            $hasAllSettings = $true
            $dscXml   = $dscXml.DISASTIG.RegistryRule.Rule
            $dscMof   = $instances | 
                Where-Object {$PSItem.ResourceID -match "\[Registry\]"}
#Make Rule Key Filter here.
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
 
    }
}
#endregion Tests
