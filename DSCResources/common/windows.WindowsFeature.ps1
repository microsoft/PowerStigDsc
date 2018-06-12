# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.

#region Header
$rules = Get-RuleClassData -StigData $StigData -Name WindowsFeatureRule
#endregion Header
#region Resource
Foreach( $rule in $rules )
{
    WindowsFeature (Get-ResourceTitle -Rule $rule)
    {
        Name = $rule.FeatureName
        Ensure = $rule.InstallState
    }
}
#endregion Resource
