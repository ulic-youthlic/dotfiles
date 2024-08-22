# starship
$ENV:STARSHIP_CONFIG = "$HOME\.config\starship\config.toml"
Invoke-Expression (& starship init powershell --print-full-init | Out-String)
