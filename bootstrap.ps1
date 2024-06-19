if (7 -le $PSVersionTable.PSVersion.Major) {
    if ($null -eq $Env:Dotfiles_Dir) {
        $Env:Dotfiles_Dir = (Get-Location)
    }
    . (Get-Item -Path (Join-Path -Path $Env:Dotfiles_Dir -ChildPath "pwsh\bootstrap.ps1"))
} else {
    throw "Seems that your PowerShell is NOT big enough. Get one over 7.x.x"
}
