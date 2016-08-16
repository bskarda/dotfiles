!#/bin/bash

# parts taken from https://gist.github.com/andsens/2913223

# Check to see if git is available
git --version 2>&1 >/dev/null 
GIT_IS_AVAILABLE=$?

if [ $GIT_IS_AVAILABLE -eq 0 ]; then
    ### Install homeshick ###
    git clone git://github.com/andsens/homeshick.git $HOME/.homesick/repos/homeshick
    source $HOME/.homesick/repos/homeshick/homeshick.sh
    homeshick --batch clone 'https://github.com/bskarda/osx-dotfiles.git'
    homeshick link osx-dotfiles --force
fi
