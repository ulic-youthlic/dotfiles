using namespace System.IO

$ProfileDir = (Get-Item -Path $profile).Directory
function Script:Get-SubConfigDirectory {
    [OutputType([DirectoryInfo])]
    param(
        [String] $SubItem
    )
    begin {
        $TextInfo = (Get-Culture).TextInfo
    }
    process {
        $Path =  Join-Path -Path $ProfileDir -ChildPath $SubItem
        if (-not (Test-Path $Path -PathType Container) ) {
            throw ([String]::Format("{0} Directory Path, ``{1}``, Is NOT A Valid Dir.", $TextInfo.ToTitleCase($SubItem), $Path))
        }
        return (Get-Item $Path)
    }
}
$Env:PowerShell_Config_Dir = $ProfileDir
$Env:PowerShell_Completion_Dir = Join-Path -Path $ProfileDir -ChildPath completion
$Script:TemplateDir = (Get-SubConfigDirectory -SubItem completion-template)
. (Get-Item -Path (Join-Path -Path $TemplateDir -ChildPath "init.ps1"))
$Script:TemplateFiles = Split-Path -Path (Join-Path -Path $TemplateDir -ChildPath "*.ps1") -Leaf -Resolve
foreach($File in $Script:TemplateFiles) {
    $Script:TempFile = Join-Path -Path $Env:PowerShell_Completion_Dir -ChildPath $File
    if (-not (Test-Path $Script:TempFile -PathType Leaf)) {
        . (Get-Item -Path (Join-Path -Path $Script:TemplateDir -ChildPath $File))
    }
}
$Script:ConfigDirectories = (Get-SubConfigDirectory -SubItem config), (Get-SubConfigDirectory -SubItem completion)
$Script:ConfigFiles = Get-ChildItem -Path $ConfigDirectories -Filter "*.ps1"
foreach($File in $ConfigFiles) {
    . $File
}
