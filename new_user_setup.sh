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

GIT_ADDRESS="git@github.com:"
# GIT_ADDRESS="ssh://git@ssh.github.com:443/"
git clone ${GIT_ADDRESS}aprokop/dotfiles         $P/configs
git clone ${GIT_ADDRESS}aprokop/local_scripts    $P/scripts
git clone ${GIT_ADDRESS}aprokop/package_configs  $P/trilinos_configs

# Initialize submodule
cd $P/configs
git submodule init
GIT_ALLOW_PROTOCOL="hg:git:https:ssh" git submodule update
cd -

# Link to ~/bin
cd $HOME/bin
ln -s $P/scripts/ninjac .
cd -

cd $P/configs/.emacs.d/org-mode
make autoloads
cd -

# Create symlinks
cd $HOME
[[ -f $HOME/.bashrc ]] && [[ ! -f $HOME/.bashrc.orig ]] && mv $HOME/.bashrc $HOME/.bashrc.orig
ln -s $P/configs/.bashrc .
ln -s $P/configs/.gitconfig .
ln -s $P/configs/.git_templates .
ln -s $P/configs/.tmux.conf .
ln -s $P/configs/.vimrc .
ln -s $P/configs/.vim .
ln -s $P/configs/.emacs .
ln -s $P/configs/.emacs.d .


# Setup VIM
mkdir -p $HOME/.vim/bundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/vundle.vim
vim +PluginInstall +qall
cd $HOME/.vim/bundle/youcompleteme
cd ./install.py --clang-completer
cd $HOME

mkdir -p $HOME/local/share/git
cd $HOME/local/share/git
ln -s $HOME/.personal/scripts/git-prompt.sh .
cd $HOME

mkdir -p $HOME/local/share/bash-completion/completions
cd $HOME/local/share/bash-completion/completions
ln -s $HOME/.personal/scripts/bash_completions/tmux
cd $HOME
