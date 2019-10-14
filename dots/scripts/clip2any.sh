#!/bin/bash

TMP=`mktemp`
RST=`mktemp`
xclip -o > $TMP
echo $TMP
pandoc "$@" $TMP > $RST
echo $RST
xclip -i < $RST
