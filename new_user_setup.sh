#!/bin/bash

# Setup ssh keys
if [[ -f $HOME/.ssh/id_rsa ]]; then
    echo "Found existing ssh key"
else
    ssh-keygen -t rsa -b 2048
    eval `ssh-agent -s`
fi
ssh-add

# Clone repos
P=$HOME/.personal
mkdir -p $P
echo -n "Have you uploaded ssh key to GitHub? [yes/no] "
read github
if [ "$github" != "yes" ]; then
    exit 1
fi
git clone ssh://git@ssh.github.com:443/aprokop/dotfiles         $P/configs
git clone ssh://git@ssh.github.com:443/aprokop/local_scripts    $P/scripts
git clone ssh://git@ssh.github.com:443/aprokop/package_configs  $P/trilinos_configs

# Create symlinks
cd $HOME
[[ -f $HOME/.bashrc ]] && mv $HOME/.bashrc $HOME/.bashrc.orig
ln -s $P/configs/.bashrc .
ln -s $P/configs/.gitconfig .
ln -s $P/configs/.tmux.conf .
ln -s $P/configs/.vimrc .
ln -s $P/configs/.vim .
mkdir -p $HOME/.vim/bundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall

mkdir -p $HOME/local/share/git
cd $HOME/local/share/git
ln -s $HOME/.personal/scripts/git-prompt.sh .

mkdir -p $HOME/local/share/bash-completion/completions
ln -s $HOME/.personal/scripts/bash_completions/tmux
