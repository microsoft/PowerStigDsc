
$compositeRoot = ( Split-Path -Path $MyInvocation.MyCommand.Path -Parent) -replace '\\tests\\unit\\','\src\'

$resourceList = (Get-childItem -Path $compositeRoot -Exclude 'common' -Directory).Name
$Manifest = Import-PowerShellDataFile -Path "$srcRootDir\$moduleName.psd1"
$powerStigVersion = $Manifest.requiredModules.Where({$PSItem.ModuleName -eq 'PowerStig'}).ModuleVersion

if ( -not (Get-Module -FullyQualifiedName @{ModuleName='PowerStig';ModuleVersion=$powerStigVersion} -ListAvailable))
{
    "Installing the requireds PowerStig module."
    Install-Module PowerStig -Scope CurrentUser -Force -Repository 'PsGallery'
}

Import-Module ( Resolve-path -Path "$PSScriptRoot\..\..\helper.psm1" ) -Force

##########################################     Header     ##########################################

foreach ($compositeName in $resourceList)
{
    $compositeManifestPath = "$compositeRoot\$compositeName\$compositeName.psd1"
    $compositeSchemaPath = "$compositeRoot\$compositeName\$compositeName.schema.psm1"

    Describe "$compositeName Composite Manifest" {
    
        It 'Should be a valid manifest' {
            {Test-ModuleManifest -Path $compositeManifestPath} | Should Not Throw
        }
    }
    
    Describe "$compositeName Composite Schema" {
    
        It 'Should contain a schema module' {
            Test-Path -Path $compositeSchemaPath | Should Be $true
        }
    
        It 'Should contain a correctly named configuration' {
            $configurationName = Get-ConfigurationName -FilePath $compositeSchemaPath
            $configurationName | Should Be $compositeName
        }
    
        It "Should match ValidateSet from PowerStig $powerStigVersion" {
            $validateSet = Get-StigVersionParameterValidateSet -FilePath $compositeSchemaPath
            $availableStigVersions = Get-ValidStigVersionNumbers -CompositeResourceName $compositeName -ModuleVersion $powerStigVersion
            $validateSet | Should Be $availableStigVersions
        }
    }
}
