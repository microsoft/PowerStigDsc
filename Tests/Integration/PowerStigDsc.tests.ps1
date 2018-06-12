#########################################   Begin Header   #########################################
$projectRoot = (Resolve-Path -Path $PSScriptRoot\..\..).Path
Import-Module "$projectRoot\tests\helper.psm1" -Force

# Build the path to the config file.
$ModuleName = $MyInvocation.MyCommand.Name -replace "\.tests\.ps1",""
#########################################   Begin Header   #########################################

Describe "$ModuleName module" {

    Context 'Root Module' {
        
        It "Should import without throwing an error" {
            {Import-Module -Name $ModuleName } | Should Not Throw
        }
    }
    
    $dscResourceList = Get-DscResource -Module $ModuleName
    
    $dscResources = @('WindowsServer', 'WindowsFirewall', 'WindowsDnsServer')
    
    Foreach ($resource in $dscResources)
    {
        Context "$resource Composite Resource" {
    
            It "Should have a $resource Composite Resource" {
                $dscResourceList.Where( {$PSItem.Name -eq $resource})  | Should Not BeNullOrEmpty
            }
        }
    }   
}
