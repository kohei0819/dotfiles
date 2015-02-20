#!/bin/bash
set -e

DOTFILES_ROOT=$(cd -P `dirname $0`; pwd)

for FILE in $(ls -a $DOTFILES_ROOT); do
    for IGNORE in "." ".." ".git" ".gitignore" "setup.sh" "README.md"; do
        if [ "$FILE" = "$IGNORE" ]; then
            continue 2
        fi
    done

    FROM_PATH=$DOTFILES_ROOT/$FILE
    TO_PATH=$HOME/$FILE

    if [ -L "$TO_PATH" -a "$(readlink $TO_PATH)" = "$FROM_PATH" ]; then
        continue
    fi

    if [ -e "$TO_PATH" ]; then
        echo -n "replace $TO_PATH? [y/n](n):"
        read INPUT
        if [ "$INPUT" = "y" ]; then
            rm -rf $TO_PATH
        else
            continue
        fi
    fi

    ln -s $DOTFILES_ROOT/$FILE $HOME/$FILE
done

# install NeoBundle
NEOBUNDLE_PATH=$HOME/.vim/bundle/neobundle.vim
if [ ! -e $NEOBUNDLE_PATH ]; then
    git clone git://github.com/Shougo/neobundle.vim $NEOBUNDLE_PATH
fi
