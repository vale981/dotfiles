#!/bin/bash
source colors.sh
source config.sh
source install_init.sh
source tools/mo

echo -e "
   ############################################
   # Welcome to Hiro98s Dotfile Installer     #
   # It's interactive, so sit back and enjoy. #
   ############################################"

DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DOTFILES_TMP=$DOTFILES_DIR/.tmp #TODO remove
FISH_DIR=$HOME/.config/fish
SCHEME="light"
YES=false

function main {
    # extract options and their arguments into variables.
    while getopts ":s: :i :y" OPT; do
	case $OPT in
	    s)
		SCHEME=$OPTARG
		grey "\n---------> Using color scheme: $SCHEME"
		;;
	    i)
		printHeading "Installing initial dependencies!"
		installInit
		exit
		;;
	    y)
		YES=true
		;;
	    \?)
		echo "Usage $0 [-i -> Initialize] [-s -> Colorscheme] [-y]"
		exit
		;;
	esac
    done
    
    mkdir -p $DOTFILES_TMP

    printHeading "Creating Color Themes."
    setColors $SCHEME
    generateGtk

    # Install Home files
    printHeading "Installing Home Directory files."
    linkall "home" ""
    grey "Reloading Xresources"

    # Configure Fish
    printHeading "Configuring Fish"

    ## Install Fish Config
    linkall "fish" ".config/fish"
    grey "Renaming fishd.Lobsang..."
    mv $FISH_DIR/fishd.Lobsang "$FISH_DIR/fishd.$(cat /etc/hostname)"

    # Configure Powerline
    printHeading "Configuring i3"

    ## Install Powerline Config
    linkall "i3" ".config/i3"
    linkall "i3status" ".config/i3status"

    # Install GTK stuff
    linkall "gtk" ".config/gtk-3.0/"

    # Install Useful Scripts
    printHeading "Installing Scripts"
    linkall "scripts" ".scripts"
    
    # Reload
    xrdb -load ${HOME}/.Xresources >/dev/null 2>&1
    killall -s USR1 st >/dev/null 2>&1
    i3-msg restart >/dev/null 2>&1
    gtkrc-reload >/dev/null 2>&1
}

## Helpers
SECTION[0]=0

function grey {
    echo -e "\e[249m$1"
}

function attention {
    printf "\e[36m$1\e[39m"
}

function printImportant {
    echo -e "\e[93m\e[4m$1\e[0m"
}

function printHeading {
    SECTION[0]=$(expr ${SECTION[0]} + 1)
    SECTION[1]=0

    echo
    printImportant "${SECTION[0]}: $1"
}

function printSubHeading {
    SECTION[1]=$(expr ${SECTION[1]} + 1)
    echo
    printImportant "${SECTION[0]}.${SECTION[1]}: $1"
}

# Re-Link All Function
function linkall {
    DIR=$1
    INSTALL_PREFIX=$2

    printSubHeading "Installing $DOTFILES_DIR/$DIR"

    # Create Dir-Struct
    DIRS=$(find $DOTFILES_DIR/$DIR -type d | sed -n "s|^${DOTFILES_DIR}/${DIR}/||p")

    # Create Base-Dir
    grey "Creating Directory: $HOME/$INSTALL_PREFIX/"
    mkdir -p $HOME/$INSTALL_PREFIX

    for d in $DIRS
    do
        grey "Creating Directory: $HOME/$INSTALL_PREFIX/$d"
        mkdir -p $HOME/$INSTALL_PREFIX/$d
    done

    FILES=$(find $DOTFILES_DIR/$DIR -type f | sed -n "s|^${DOTFILES_DIR}/${DIR}/||p")

    for f in $FILES
    do
        CDIR=$DOTFILES_DIR/$DIR/
        # Get Commands
        CMD=$(sed -n '/#\$/p' $CDIR/$f | sed -e 's/#\$//g')

        if [[  ${f: -9} == ".template" ]]; then
            mkdir -p $DOTFILES_TMP/$DIR
            cat $CDIR/$f | mo > $DOTFILES_TMP/$DIR/${f:0:-9}
            CDIR=$DOTFILES_TMP/$DIR/
            f=${f:0:-9}
        fi
        if ! $YES && [ -f $HOME/$INSTALL_PREFIX/$f ]; then
            attention "Overwrite File '$HOME/$INSTALL_PREFIX/$f' [Y/n] "
            read c
            case $c in
                   [Nn]* ) continue;;
            esac
        fi

        if ! [ -z "${CMD// }" ]; then
            grey "Running $CMD on $CDIR/$f $CDIR/$f | eval $CMD > $CDIR/$f"
            cat  $CDIR/$f | eval "$CMD" > $CDIR/$f.tmp
            mv $CDIR/$f.tmp $CDIR/$f
        fi

        ln -sfv $CDIR/$f $HOME/$INSTALL_PREFIX/$f
    done

}

main "$@"
