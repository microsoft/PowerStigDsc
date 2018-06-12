# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.

#region Header
$rules = Get-RuleClassData -StigData $StigData -Name FirewallRule
#endregion Header
#region Resource
Foreach( $rule in $rules )
{
    ## TO DO - Make this work
    xFirewall (Get-ResourceTitle -Rule $rule)
    {

    }
}
#endregion Resource
