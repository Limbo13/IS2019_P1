Write-Host "This will enable Windows Features on this computer that are enabled on the target computer.  Multiple reboots and executions of this script may be required"
$TemplateMachineName = Read-Host -Prompt "Template machine name"
$TemplateMachine = Invoke-Command -ComputerName $TemplateMachineName -ScriptBlock{Get-WindowsOptionalFeature -Online | ? state -eq 'enabled'} | select FeatureName
$TargetMachine = Get-WindowsOptionalFeature -Online | ? state -eq 'enabled' | select FeatureName
$TemplateMachineList = $TemplateMachine.FeatureName
$TargetMachineList = $TargetMachine.FeatureName

$InstallCount = 0

foreach ($Component in $TemplateMachineList)
{
    If ($TargetMachineList -notcontains $Component)
    {
        Enable-WindowsOptionalFeature -FeatureName $Component -Online -All
        write-output "Enabling: $Component"
        $InstallCount++
    }
}

If ($InstallCount -eq 0)
{
    Write-Output "Computers match, no updates required"
}
