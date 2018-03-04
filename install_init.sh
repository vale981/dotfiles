#!/bin/bash
function installInit {
    printHeading "Install OMF"

    OMF_TMP=$(mktemp)
    curl -L https://get.oh-my.fish > $OMF_TMP
    fish $OMF_TMP

    printSubHeading "Install OMF Theme"
    fish -c "omf install bobthefish"
}
