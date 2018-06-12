# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.

#region Header
$rules = Get-RuleClassData -StigData $StigData -Name AuditPolicyRule
#endregion Header
#region Resource
Foreach ( $rule in $rules )
{
    AuditPolicySubcategory (Get-ResourceTitle -Rule $rule)
    {
        Name      = $rule.Subcategory
        AuditFlag = $rule.AuditFlag
        Ensure    = $rule.Ensure
    }
}
#endregion Resource
