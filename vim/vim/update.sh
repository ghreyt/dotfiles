#!/usr/bin/env bash

cd $(dirname $0)

START_DIR=pack/plugins/start
OPT_DIR=pack/plugins/opt

mkdir -p $START_DIR
mkdir -p $OPT_DIR

PLUGINS=( \
    https://github.com/scrooloose/nerdtree \
    https://github.com/jistr/vim-nerdtree-tabs \
    https://github.com/bling/vim-airline \
    https://github.com/vim-airline/vim-airline-themes \
    https://github.com/kien/ctrlp.vim \
    https://github.com/airblade/vim-gitgutter \
    https://github.com/jmcantrell/vim-virtualenv \
    )

cd $START_DIR
for url in "${PLUGINS[@]}"; do
    name=$(echo $url | cut -d'/' -f5)

    if [[ -d $name ]]; then
        echo "*** update $name"
        git pull
    else
        echo "*** initialize $name"
        git clone $url
    fi

    echo ""
done
cd -
