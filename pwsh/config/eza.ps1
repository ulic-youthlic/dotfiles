Remove-Alias ls

function Script:Invoke-Eza {
    eza $args --icons=auto
}
New-Alias -Name ls Invoke-Eza

function Script:Invoke-EzaAll {
    eza $args --icons=auto -a
}
New-Alias -Name l Invoke-EzaAll

function Script:Invoke-EzaHG {
    eza $args --icons=auto -hlG --smart-group
}
New-Alias -Name ll Invoke-EzaHG

function Script:Invoke-EzaAllHG {
    eza $args --icons=auto -hlGA --smart-group
}
New-Alias -Name lll Invoke-EzaAllHG

function Script:Invoke-EzaAllHGWithGit {
    eza $args --icons=auto -hlA --smart-group --git
}
New-Alias -Name lls Invoke-EzaAllHGWithGit

function Script:Invoke-EzaTree {
    eza $args --icons=auto -Tlh -L 2 --git --git-ignore
}
New-Alias -Name lt Invoke-EzaTree

function Script:Invoke-EzaTreeAll {
    eza $args --icons=auto -Tlh -L 2 --git --git-ignore -A
}
New-Alias -Name llt Invoke-EzaTreeAll

