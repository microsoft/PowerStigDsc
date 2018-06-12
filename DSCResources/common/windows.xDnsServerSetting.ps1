# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.

#region Header
$rules = Get-RuleClassData -StigData $StigData -Name DnsServerSettingRule
#endregion Header
#region Resource
Foreach ( $rule in $rules )
{
    $sb = [scriptblock]::Create("
        xDnsServerSetting  '$(Get-ResourceTitle -Rule $rule)'
        {
            Name = '$($rule.PropertyName)'
            $($rule.PropertyName)  = $($rule.PropertyValue)
        }"
    )

    & $sb
}
#endregion Resource
