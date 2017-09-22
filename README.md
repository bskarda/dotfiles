```bash
    git init --bare $HOME/.dotfiles
    alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
    config config status.showUntrackedFiles no
# Add files
    config status
    config add .vimrc
    config commit -m "Add vimrc"
    config add .config/redshift.conf
    config commit -m "Add redshift config"
    config push
# Clone
    git clone --separate-git-dir=$HOME/.dotfiles /path/to/repo $HOME/dotfiles-tmp
    cp ~/dotfiles-tmp/.gitmodules ~  # If you use Git submodules
    rm -r ~/dotfiles-tmp/
    alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
```
