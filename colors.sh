# Colort Palette

S_base3=#002b36
S_base2=#073642
S_base1=#586e75
S_base0=#657b83
S_base00=#839496
S_base01=#93a1a1
S_base02=#eee8d5
S_base03=#fdf6e3

S_yellow=#b58900
S_orange=#cb4b16
S_red=#dc322f
S_magenta=#d33682
S_violet=#6c71c4
S_blue=#268bd2
S_cyan=#2aa198
S_green=#859900

# Swap to Dark if you have to.
function setColors {
if [ $1 == "dark" ]; then
    S_base03=#002b36
    S_base02=#073642
    S_base01=#586e75
    S_base00=#657b83
    S_base0=#839496
    S_base1=#93a1a1
    S_base2=#eee8d5
    S_base3=#fdf6e3
fi
}

function generateGtk {
    OOMOXCONF="$DOTFILES_TMP/$SCHEME"

    if [ ! -f $OOMOXCONF ]; then
	grey "Generating...\nThis might take a while..."

    cat > $OOMOXCONF << EOF
NAME="hiroTheme"
NOGUI=True
BG=$S_base03
FG=$S_base0
TXT_BG=$S_base02
TXT_FG=$S_base0
SEL_BG=$S_base0
SEL_FG=$S_base3
MENU_BG=$S_base03
MENU_FG=$S_base0
BTN_BG=$S_base03
BTN_FG=$S_base0
HDR_BTN_BG=$S_base03
HDR_BTN_FG=$S_base0
ICONS_LIGHT_FOLDER=$S_base0
ICONS_LIGHT=$S_base1
ICONS_MEDIUM=$S_base0
ICONS_DARK=$S_base00
EOF
    
    sed -i -s 's/#//' $OOMOXCONF

    # make the theme
    tools/oomox-gtk-theme/change_color.sh $OOMOXCONF >/dev/null 2>&1
    tools/oomox-archdroid-icon-theme/change_color.sh $OOMOXCONF  >/dev/null 2>&1
    fi
    OOMOXTHEME="oomox-"$SCHEME
}
