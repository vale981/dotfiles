set fish_greeting ""
set -gx PATH $HOME/.scripts $PATH
set -gx PATH $HOME/.roswell/bin $PATH
set -gx PATH /usr/lib/ccache/bin/ $PATH
set -g theme_display_date no
set -g fish_key_bindings fish_default_key_bindings
set -g FZF_PREVIEW_FILE_CMD "bat --color=always"
set -g FZF_CD_CMD "fd --type d . \$dir"
set -g FZF_FIND_FILE_CMD "fd --type f . \$dir"
set -g FZF_OPEN_COMMAND "fd . \$dir"

set -g FZF_LEGACY_KEYBINDINGS 1
set -g FZF_COMPLETE 1

set -U FZF_FIND_FILE_OPTS '--preview "$FZF_PREVIEW_FILE_CMD {}"'

alias mktargz "tar -zcvf"
alias frem "sudo pacman -R (pacman -Q | fzf -m --preview=\"echo {} | cut -d' ' -f1 | pacman -Si -\" | cut -d' ' -f1 )"
alias fyay "yay -Pc x | fzf -m | cut -f1 | yay -S -"
alias ftmux "tmux a -t (tmux ls | fzf --height=5 | cut -d ' ' -f 1)"
alias please sudo

function cmus
    set cmus_sess "cmus"
    tmux new-session -A -s $cmus_sess "bash -c cmus"
end

eval (direnv hook fish)
