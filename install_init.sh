#!/bin/bash
function installInit {
    printHeading "Install OMF"

    curl -L https://get.oh-my.fish | fish

    printSubHeading "Install OMF Theme"
    fish -c "omf install bobthefish"
    curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish
    fisher add jethrokuan/z
}
