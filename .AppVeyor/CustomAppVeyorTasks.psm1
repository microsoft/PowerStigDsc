function Invoke-CustomAppveyorInstallTask
{
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param ()

    Write-Info -Message 'Custom Install Task Begin.'

    Write-Info -Message 'Custom Install Task Complete.'
}

function Start-CustomAppveyorTestTask
{
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param ()

    Write-Info -Message 'Custom Test Task Begin.'

    Write-Info -Message 'Custom Test Task Complete.'
}

function Start-CustomAppveyorAfterTestTask
{
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param ()

    Write-Info -Message 'Custom After Test Task Begin.'

    Write-Info -Message 'Custom After Test Task Complete.'
}

Export-ModuleMember -Function