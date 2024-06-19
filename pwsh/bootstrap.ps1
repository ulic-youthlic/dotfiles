$ProfileDir = (Get-Item -Path $profile).Directory
$CurrentDir = (Get-Item -Path (Join-Path -Path $Env:Dotfiles_Dir -ChildPath pwsh))
function Script:New-SubConfigDirectory {
    param(
        [String] $SubItem
    )
    process {
        $JunctionPath = Join-Path -Path $ProfileDir -ChildPath $SubItem
        $TargetPath = Join-Path -Path $CurrentDir -ChildPath $SubItem
        if (-not (Test-Path $TargetPath -PathType Container)) {
            throw ([String]::Format("Config Dir, ``{0}``, NOT Exists.", $TargetPath))
        } elseif (Test-Path $JunctionPath) {
            $ResolvedPath = (Get-Item -Path $JunctionPath).Target
            if ($null -eq $ResolvedPath) {
                throw ([String]::Format("Config Dir, ``{0}``, Is NOT A Junction.", $JunctionPath))
            }
            if ((Test-Path $JunctionPath -PathType Container) -and ($ResolvedPath -eq $TargetPath)) {
                Write-Host ([String]::Format("[Warn]: Config Dir, ``{0} -> {1}``, Already Exists.", $JunctionPath, $ResolvedPath))
                return
            } else {
                throw ([String]::Format("Config Dir, ``{0}``, Already Exists.", $JunctionPath))
            }
        } else {
            New-Item -Path $JunctionPath -ItemType Junction -Target $TargetPath
        }
    }
}
function Script:New-ConfigInitFile {
    begin {
        $SymlinkPath = (Join-Path -Path $ProfileDir -ChildPath init.ps1)
        $TargetPath = (Join-Path -Path $CurrentDir -ChildPath init.ps1)
    }
    process {
        if (-not (Test-Path -Path $TargetPath -PathType Leaf)) {
            throw ([String]::Format("Init file, ``{0}``, Is NOT Correct.", $TargetPath))
        } elseif (Test-Path -Path $SymlinkPath) {
            if ((Test-Path -Path $SymlinkPath -PathType Leaf) -and (((Get-Item -Path $SymlinkPath).Target) -eq $TargetPath)) {
                Write-Host ([String]::Format("[Warn]: Init File, ``{0} -> {1}``, Already Exists.", $SymlinkPath, $TargetPath))
                return
            } else {
                throw ([String]::Format("Init File, ``{0}``, Already Exists.", $SymlinkPath))
            }
        } else {
            New-Item -Path $SymlinkPath -ItemType SymbolicLink -Target $TargetPath
        }
    }
}
function Script:Add-ConfigInitLine {
    begin {
        $InitFilePath = Join-Path -Path $ProfileDir -ChildPath init.ps1
        $InitLine = [String]::Format(". {0}", ($InitFilePath.Split("\") -join "/"))
        $ProfileContent = Get-Content -Path $profile -Raw
    }
    process {
        if ($ProfileContent -match $InitLine) {
            Write-Host ([String]::Format("Init Line: `n`n{0}`n`nIs Already In ``{1}``.", $InitLine, $profile))
            return
        } else {
            Set-Content -Path $profile -Value ($InitLine + "`r`n" + $ProfileContent)
        }
    }
}

New-SubConfigDirectory config
New-SubConfigDirectory completion
New-SubConfigDirectory completion-template
New-ConfigInitFile
Add-ConfigInitLine
