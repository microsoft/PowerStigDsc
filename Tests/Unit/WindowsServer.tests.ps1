<#
    The common unit tests will discover all of the resources using Get-ChildItem on the DscResources
    directory and loop through all of the discovered compsite resources to test and validate the
    core resource functionality. Individual test files are needed to verify that specifc resources
    exist and contain any testing that is specific to that resoruce.
#>

$compositeRoot = ( Split-Path -Path $MyInvocation.MyCommand.Path -Parent) -replace '\\tests\\unit\\','\src\'
$compositeName = ($MyInvocation.MyCommand.Name -split "\.")[0]

$compositeManifestPath = "$compositeRoot\$compositeName\$compositeName.psd1"
$compositeSchemaPath = "$compositeRoot\$compositeName\$compositeName.schema.psm1"

##########################################     Header     ##########################################

Describe "$compositeName Composite resource" {

}
