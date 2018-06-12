# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.

#region Header
$rules = Get-RuleClassData -StigData $StigData -Name AccountPolicyRule
#endregion Header
#region Resource

Foreach ( $rule in $rules )
{
    $policy = $rule.PolicyName -replace "(:)*\s","_"

    $sb = [scriptblock]::Create("
        AccountPolicy '$(Get-ResourceTitle -Rule $rule)'
        {
            Name = '$policy'
            $policy = '$($rule.PolicyValue)'
        }"
    )

    & $sb
}
#endregion Resource
