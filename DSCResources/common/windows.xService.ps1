# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.

#region Header
$rules = Get-RuleClassData -StigData $StigData -Name ServiceRule
#endregion Header
#region Resource
Foreach( $rule in $rules )
{
    xService (Get-ResourceTitle -Rule $rule)
    {
        Name        = $rule.ServiceName
        State       = $rule.ServiceState
        StartupType = $rule.StartupType
    }
}
#endregion Resource
