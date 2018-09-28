#!/bin/bash
function installInit {
    printHeading "Install OMF"

    curl -L https://get.oh-my.fish | fish

    printSubHeading "Install OMF Theme"
    fish -c "omf install bobthefish"
}
