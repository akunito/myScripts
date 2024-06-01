#!/bin/bash
cd ~/Downloads
rm -rf ~/Downloads/karabiner
git clone https://github.com/mxstbr/karabiner
cd karabiner
yarn install
yarn run build

# remove the files that we do NOT want to overwrite
rm karabiner.json rules.ts types.ts utils.ts

# UWAGA!!! copy and overwrite
cp -R . ~/syncthing/git_repos/myProjects/KeyboardProjects/spinachShortcuts/karabiner

# go to see results
cd ~/syncthing/git_repos/myProjects/KeyboardProjects/spinachShortcuts/karabiner