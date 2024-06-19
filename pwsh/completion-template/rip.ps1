$Script:Name = "rip"
$Script:File = Join-Path -Path $env:PowerShell_Completion_Dir -ChildPath "$Name.ps1"
if ($null -eq (Get-Command $Name -ErrorAction SilentlyContinue)) {
    Write-Host ([String]::Format("[Warn]: Unable to find {0} in your PATH", $Name))
} else {
    rip completions powershell > $File
}
