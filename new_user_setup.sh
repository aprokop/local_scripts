#!/bin/bash

# Edit ssh configuration (manual)
mkdir -p "$HOME/.ssh/tmp"

# Setup ssh keys
if [[ -f $HOME/.ssh/id_rsa ]]; then
    echo "Found existing ssh key"
else
    ssh-keygen -t rsa -b 2048
    eval `ssh-agent -s`
fi
ssh-add -l || ssh-add

# Create .personal
P=$HOME/.personal
mkdir -p $P

# Clone repos
echo -n "Have you uploaded ssh key to GitHub? [yes/no] "
read github
if [ "$github" != "yes" ]; then
    exit 1
fi

GIT_ADDRESS="git@github.com:"
# GIT_ADDRESS="ssh://git@ssh.github.com:443/"
[ -d $P/configs ]          || git clone ${GIT_ADDRESS}aprokop/dotfiles         $P/configs
[ -d $P/scripts ]          || git clone ${GIT_ADDRESS}aprokop/local_scripts    $P/scripts

# Initialize submodule
cd $P/configs
git submodule init
GIT_ALLOW_PROTOCOL="git:http:https:ssh" git submodule update
cd ~

# Link to ~/bin
mkdir -p $HOME/bin
cd $HOME/bin
ln -s $P/scripts/be_quiet .
ln -s $P/scripts/ninjac .
ln -s $P/scripts/split_path .
ln -s $P/scripts/updatedb_user .
ln -s $P/scripts/latexmk.pl .
if [[ -f /usr/bin/ccache ]]; then
    for compiler in cc clang clang++ gcc g++; do
        ln -s /usr/bin/ccache $compiler
    done
fi
cd -

# Create symlinks
cd $HOME
[[ -f $HOME/.bashrc ]] && [[ ! -f $HOME/.bashrc.orig ]] && mv $HOME/.bashrc $HOME/.bashrc.orig
ln -s $P/configs/.bashrc .
ln -s $P/configs/.bash_profile .
ln -s $P/configs/.dir_colors .
ln -s $P/configs/.emacs .
ln -s $P/configs/.emacs.d .
ln -s $P/configs/.gdbinit .
# Linking of .gitconfig happens at the end of the script
ln -s $P/configs/.git_templates .
ln -s $P/configs/.inputrc .
ln -s $P/configs/.latexmkrc .
ln -s $P/configs/.mime.types .
ln -s $P/configs/.screenrc .
ln -s $P/configs/.tigrc .
ln -s $P/configs/.tmux.conf .
ln -s $P/configs/.tmux .
ln -s $P/configs/.vim .
ln -s $P/configs/.vimrc .

mkdir -p $HOME/local/share/git
cd $HOME/local/share/git
ln -s $HOME/.personal/scripts/git-prompt.sh .
cd $HOME

mkdir -p $HOME/local/share/bash-completion/completions
cd $HOME/local/share/bash-completion/completions
ln -s $HOME/.personal/scripts/bash_completions/tmux
ln -s $HOME/.personal/scripts/bash_completions/git
cd $HOME

mkdir -p $HOME/local/share/cdargs
cd $HOME/local/share/cdargs
ln -s $HOME/.personal/scripts/cdargs-bash.sh
cd $HOME

mkdir -p $HOME/.ccopy
mkdir -p $HOME/tmp

# Helper
chkcmd="command -v &>/dev/null"

# Setup VIM
mkdir -p $HOME/.vim/undo
mkdir -p $HOME/.vim/bundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/vundle.vim
$chkcmd vim
if [ $? -eq 0 ]; then
    vim +PluginInstall +qall

    $chkcmd cmake
    if [ $? -eq 0 ]; then
        cd $HOME/.vim/bundle/youcompleteme
        ./install.py --clang-completer
    fi
else
    echo "vim is missing"
fi
cd $HOME

# Setup Emacs
$chkcmd emacs
if [ $? -eq 0 ]; then
    cd $P/configs/.emacs.d/org-mode
    make autoloads
else
    echo "emacs is missing"
fi
cd $HOME

# Create .gitconfig symlink last as it may have problems with push.simple
ln -s $P/configs/.gitconfig

echo "Do not forget to set crontab for:"
echo "  * updatedb_user"
