## Initial setup for this repo
```bash
    git init --bare $HOME/.dotfiles
    alias config='/usr/local/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
    config config status.showUntrackedFiles no
```

## Add files
```bash
    config status
    config add .vimrc
    config commit -m "Add vimrc"
    config add .config/redshift.conf
    config commit -m "Add redshift config"
    config push
```

## Clone onto a new box
```bash
    git clone --separate-git-dir=$HOME/.dotfiles git@github.com:bskarda/dotfiles.git $HOME/dotfiles-tmp
    rm -r ~/dotfiles-tmp/
    alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
```
