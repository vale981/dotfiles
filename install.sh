#!/bin/bash
source colors.sh
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
DOTDIR="dots"
SCHEME="light"
YES=false

source config.sh

function main {
    # extract options and their arguments into variables.
    while getopts ":s: :i :y :d: :c:" OPT; do
	case $OPT in
	    c)
		source $OPTARG
		;;
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
	    d)
		DOTDIR=$OPTARG
		;;
	    \?)
		echo "Usage $0 [-i -> Initialize] [-s -> Colorscheme] [-c -> config, default: config.sh] [-y] [-d -> dotfile dir, optional]"
		exit
		;;
	esac
    done
    
    mkdir -p $DOTFILES_TMP
    
    printHeading "Creating Color Themes."
    setColors $SCHEME
    generateGtk

    # Wallpaper
    printHeading "Install Wallpaper"
    ln -svf $DOTFILES_DIR/wallpaper/$SCHEME $HOME/.wallpaper
    
    # Install Stuff
    autolink
    
    # Reload
    printHeading "Reloading"
    xrdb -load ${HOME}/.Xresources >/dev/null 2>&1
    killall -s USR1 st >/dev/null 2>&1
    i3-msg restart >/dev/null 2>&1
    gtkrc-reload >/dev/null 2>&1
    $HOME/.scripts/wallp
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

    FILES=$(find $DOTFILES_DIR/$DIR ! -name '.link' ! -name '*~' ! -name '#*' -type f |  sed "s~$DOTFILES_DIR/*$DIR/*~~")

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

function autolink {
    for DIR in $DOTFILES_DIR/$DOTDIR/*/ ; do
	if [ ! -f $DIR/.link ]; then
	    continue
	fi

	source $DIR/.link
	printHeading "$TASKNAME"
	CLEANED_DIR=$(echo $DIR | sed "s~$DOTFILES_DIR/~~")
	linkall $CLEANED_DIR $LINKTO
    done
}

main "$@"
