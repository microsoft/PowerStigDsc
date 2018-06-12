# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.

#region Header
$rules = Get-RuleClassData -StigData $StigData -Name SecurityOptionRule
#endregion Header
#region Resource
Foreach ( $rule in $rules )
{
    $policy = $rule.OptionName -replace "(\/)|(:)*\s", "_"

    $sb = [scriptblock]::Create("
        SecurityOption  '$(Get-ResourceTitle -Rule $rule)'
        {
            Name = '$policy'
            $policy = '$($rule.OptionValue)'
        }"
    )

    & $sb
}
#endregion Resource
