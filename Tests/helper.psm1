
####################################    Common test Helpers    #$###################################
<#
    .SYNOPSIS
        Retrieves the parse errors for the given file.

    .PARAMETER FilePath
        The path to the file to get parse errors for.
#>
function Get-FileParseErrors
{
    [OutputType([System.Management.Automation.Language.ParseError[]])]
    [CmdletBinding()]
    param
    (
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        [String]
        $FilePath
    )

    $parseErrors = $null

    $null = [System.Management.Automation.Language.Parser]::ParseFile(
            $FilePath, 
            [ref] $null, 
            [ref] $parseErrors
    )
    return $parseErrors
}

<#
    .SYNOPSIS
        Retrieves all text files under the given root file path.

    .PARAMETER Root
        The root file path under which to retrieve all text files.

    .NOTES
        Retrieves all files with the '.gitignore', '.gitattributes', '.ps1', '.psm1', '.psd1',
        '.json', '.xml', '.cmd', or '.mof' file extensions.
#>
function Get-TextFilesList
{
    [OutputType([System.IO.FileInfo[]])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $FilePath
    )

    $textFileExtensions = @('.gitignore', '.gitattributes', '.ps1', '.psm1', '.psd1', '.json', 
    '.xml', '.cmd', '.mof')

    return Get-ChildItem -Path $FilePath -File -Recurse | Where-Object { $textFileExtensions `
    -contains $_.Extension }
}
function Test-FileInUnicode
{
    [OutputType([Boolean])]
    [CmdletBinding()]
    param
    (
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        [System.IO.FileInfo]
        $FileInfo
    )

    $filePath = $FileInfo.FullName

    $fileBytes = [System.IO.File]::ReadAllBytes($filePath)

    $zeroBytes = @( $fileBytes -eq 0 )

    return ($zeroBytes.Length -ne 0)
}

####################################    Common test Helpers    #####################################

function Get-PowerStigVersionFromManifest
{
    [OutputType([version])]
    [CmdletBinding()]
    param( )

    Import-PowerShelldata  $releaseDir\$ModuleName.psd1
}



function Get-RequiredStigDataVersion
{
    [cmdletbinding()]
    param()

    $Manifest = Import-PowerShellDataFile -Path "$relDirectory\$moduleName.psd1"

    return $Manifest.RequiredModules.Where({$PSItem.ModuleName -eq 'PowerStig'}).ModuleVersion
}

function Get-StigDataRootPath
{
    [cmdletbinding()]
    param
    (
        [parameter(Mandatory=$true)]
        [version]
        $ModuleVersion
    )

    return "$((Get-Module -Name PowerStig -ListAvailable | 
        Where-Object {$PSItem.Version -eq $ModuleVersion}).ModuleBase)\StigData"
}

<#
    .SYNOPSIS
    Get all of the version files to test 

    .PARAMETER CompositeResourceName
    The name of the composite resource used to filter the results
#>
function Get-StigFileList
{
    [cmdletbinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [string]
        $CompositeResourceName
    )

    # 
    $stigFilePath     = Resolve-Path -Path $PSScriptRoot\..\..\src\stigData
    $stigVersionFiles = Get-ChildItem -Path $stigFilePath -Exclude "*.org*"

    $stigVersionFiles
}

<#
    .SYNOPSIS
    Returns a list of stigs for a given resource. This is used in integration testign by looping 
    through every valide STIG found in the StigData directory.

    .PARAMETER CompositeResourceName
    The resource to filter the results

    .PARAMETER Filter
    Parameter description

#>
function Get-StigVersionTable
{
    [outputtype([psobject])]
    [cmdletbinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [string]
        $CompositeResourceName,

        [Parameter()]
        [string]
        $Filter
    )

    $include = Import-PowerShellDataFile -Path $PSScriptRoot\CompositeResourceFilter.psd1
    
    $path = "$((((Get-Module -Name PowerStig -ListAvailable) | 
        Sort-Object Version)[-1]).ModuleBase)\StigData"

    $versions = Get-ChildItem -Path $path -Exclude "*.org.*", "*.xsd" -Include $include.$CompositeResourceName -File -Recurse

    $versionTable = @{} 
    foreach ($version in $versions)
    {
        if ($version.Basename -match $Filter)
        {
            $versionTable.Add($version.Basename, $version.FullName)
        }
    }

    return $versionTable
}

<#
    .SYNOPSIS
    Using an AST, it returns the name of a configuration in the composite resource schema file.
    
    .PARAMETER FilePath
    The full path to the resource schema module file
#> 
function Get-ConfigurationName
{
    [cmdletbinding()]
    [outputtype([string[]])]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $FilePath
    )
    
    $AST = [System.Management.Automation.Language.Parser]::ParseFile(
        $FilePath, [ref] $null, [ref] $Null 
    )

    # Get the Export-ModuleMember details from the module file
    $ModuleMember = $AST.Find( {
            $args[0] -is [System.Management.Automation.Language.ConfigurationDefinitionAst]}, $true) 

    return $ModuleMember.InstanceName.Value
}

<#
    .SYNOPSIS
    Returns the list of StigVersion nunmbers that are defined in the ValidateSet parameter attribute

    .PARAMETER FilePath
    THe full path to the resource to read from
#> 
function Get-StigVersionParameterValidateSet
{
    [outputtype([string[]])]
    [cmdletbinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [string]
        $FilePath
    )

    $compositeResource = Get-Content -Path $FilePath -Raw

    $AbstractSyntaxTree = [System.Management.Automation.Language.Parser]::ParseInput(
        $compositeResource, [ref]$null, [ref]$null)

    $params = $AbstractSyntaxTree.FindAll(
        {$args[0] -is [System.Management.Automation.Language.ParameterAst]}, $true)

    # Filter the specifc ParameterAst
    $paramToUpdate = $params | 
        Where-Object {$PSItem.Name.VariablePath.UserPath -eq 'StigVersion'}

    # Get the specifc parameter attribute to update
    $validate = $paramToUpdate.Attributes.Where(
        {$PSItem.TypeName.Name -eq 'ValidateSet'})

    return $validate.PositionalArguments.Value 
}

<#
    .SYNOPSIS
    Get a unique list of valid STIG versions from the StigData 

    .PARAMETER CompositeResourceName
    The resource to filter the results
#>

function Get-ValidStigVersionNumbers
{
    [cmdletbinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [string]
        $CompositeResourceName,

        [parameter(Mandatory = $true)]
        [version]
        $ModuleVersion
    )

    $include = Import-PowerShellDataFile -Path $PSScriptRoot\CompositeResourceFilter.psd1
    
    $path = "$(Get-StigDataRootPath -ModuleVersion $ModuleVersion)"

    [string[]] $ValidStigVersionNumbers = Get-ChildItem -Path $path -Exclude "*.org.*", "*.xsd" -Include $include.$CompositeResourceName -File -Recurse | 
        ForEach-Object { ($PSItem.baseName -split "-")[-1] } |
        Select-Object -Unique

    return $ValidStigVersionNumbers
}

Export-ModuleMember -Function @(
    'Get-FileParseErrors',
    'Get-TextFilesList',
    'Test-FileInUnicode',
    'Get-StigVersionTable',
    'Get-ConfigurationName',
    'Get-StigVersionParameterValidateSet',
    'Get-ValidStigVersionNumbers'
)
