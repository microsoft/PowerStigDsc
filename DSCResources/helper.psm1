# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.

#region Variables
[string] $resourcePath = (Resolve-Path -Path $PSScriptRoot\common).Path
#endregion

#region Functions
function Get-ResourceTitle
{
    param
    (
        [Parameter(Mandatory=$true)]
        [System.Xml.XmlElement]
        $Rule
    )

    return "[$($rule.Id)][$($rule.severity)][$($rule.title)]"
}

function Get-RuleClassData
{
    param
    (
        [Parameter(Mandatory=$true)]
        [string]
        $Name,

        [Parameter(Mandatory=$true)]
        [xml]
        $StigData
    )

    return $StigData.DISASTIG.$Name.Rule | Where-Object { $_.conversionstatus -eq 'pass' }
}
#endregion

Export-ModuleMember -Function 'Get-ResourceTitle','Get-RuleClassData' `
                    -Variable 'resourcePath'
