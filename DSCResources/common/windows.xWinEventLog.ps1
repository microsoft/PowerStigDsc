# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.

#region Header
$rules = Get-RuleClassData -StigData $StigData -Name WinEventLogRule
#endregion Header
#region Resource
Foreach( $rule in $rules )
{
    xWinEventLog (Get-ResourceTitle -Rule $rule)
    {
        LogName     = $rule.LogName
        IsEnabled   = [boolean]$($rule.IsEnabled)
    }
}
#endregion Resource
