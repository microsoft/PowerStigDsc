$script:DSCModuleName = 'PowerStigDsc'

#region HEADER
[String] $script:moduleRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)

Import-Module (Join-Path -Path $script:moduleRoot -ChildPath 'Tests\helper.psm1' ) -Force
#endregion

Describe "$($script:DSCModuleName) module" {

    Context 'Root Module' {

        It "Should import without throwing an error" {
            {Import-Module -Name $script:DSCModuleName } | Should Not Throw
        }

        It 'Should require the most recent PowerStig version' {

            [version] $manifestPowerStigVersion = Get-PowerStigVersionFromManifest -ManifestPath "$($script:moduleRoot)\$($script:DSCModuleName).psd1"
            [version] $galleryPowerStigVersion  = (Find-Module -Name PowerStig -Repository PSGallery).Version

            $manifestPowerStigVersion | Should Be $galleryPowerStigVersion
        }
    }

    $dscResourceList = Get-DscResource -Module $ModuleName

    $dscResources = Get-ChildItem -Path "$($script:moduleRoot)\DscResources" -Directory -Exclude 'common' |
                        Select-Object -Property BaseName -ExpandProperty BaseName

    Foreach ($resource in $dscResources)
    {
        Context "$resource Composite Resource" {

            It "Should have a $resource Composite Resource" {
                $dscResourceList.Where( {$PSItem.Name -eq $resource}) | Should Not BeNullOrEmpty
            }
        }
    }
}
