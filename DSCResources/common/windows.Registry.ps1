# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.

#region Header
$rules = Get-RuleClassData -StigData $StigData -Name RegistryRule
#endregion Header
#region Resource
Foreach ( $rule in $rules )
{
    $valueData = $rule.ValueData.Split("{;}")

    Registry (Get-ResourceTitle -Rule $rule)
    {
        Key       = $rule.Key
        ValueName = $rule.ValueName
        ValueData = $valueData
        ValueType = $rule.ValueType
        Ensure    = $rule.Ensure
    }
}
#endregion Resource
