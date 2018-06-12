# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.

#region Header
$rules = Get-RuleClassData -StigData $StigData -Name WmiRule
#endregion Header
#region Resource
Foreach ( $rule in $rules )
{
    Script (Get-ResourceTitle -Rule $rule)
    {
        # Must return a hashtable with at least one key named 'Result' of type String
        GetScript = {
            Return @{
                'Result' = [string] $( ( Get-WmiObject -Class $Using:rule.Class ).$( $Using:rule.Property ) )
            }
        }

        # Must return a boolean: $true or $false
        TestScript = {
            $valueToTest = ( ( Get-WmiObject -Class $Using:rule.Class ).$( $Using:rule.Property ) )

            ForEach ( $value in $valueToTest )
            {
                $wmiTest = [scriptBlock]::create("""$value"" $($Using:rule.Operator) ""$($Using:rule.Value)""")

                if ( -not ( & $wmiTest ) )
                {
                    Write-Verbose "$($Using:rule.Property) -not $($Using:rule.Operator) $($Using:rule.Value)"
                    return $false
                }
            }

            Write-Verbose "$($Using:rule.Property) $($Using:rule.Operator) $($Using:rule.Value)"
            return $true
        }

        <#
            This is left blank because we are only using the script resource as an audit tool for
            STIG items that should be part of an orchestration function and not configuration.
        #>
        SetScript = { }
    }
}
#endregion Resource
