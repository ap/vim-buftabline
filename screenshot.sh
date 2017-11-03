#!/bin/sh
set -e
rm -rf .vim
cp -a vim .vim
GIT_INDEX_FILE=git-index GIT_WORK_TREE=.vim git checkout master -- .
HOME=$PWD MYVIMRC= VIMINIT= mvim -S screenshot.vim
screencapture -W screenshot.png
open -a ImageOptim screenshot.png
rm -rf .vim
