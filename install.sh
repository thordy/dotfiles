#!/bin/bash

# Get full path of the dotfiles directory
DOTFILES_DIR="$(dirname "$(realpath "$0")")"

ln -sv "$DOTFILES_DIR/gitconfig" $HOME/.gitconfig
ln -sv "$DOTFILES_DIR/tmux.conf" $HOME/.tmux.conf
if [ "$(uname -s)" = "Linux" ]; then
  ln -sv "$DOTFILES_DIR/albertignore" $HOME/.albertignore
fi

# Setup vim prerequisites
if [ ! -d "$HOME/.vim/bundle/Vundle.vim" ]; then
  printf "Installing Vundle\n"
  git clone --quiet https://github.com/VundleVim/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim

  if [ $? -ne 0 ]; then
    printf "Vundle install failed\n"
    exit 1  
  fi
fi
ln -sv "$DOTFILES_DIR/vimrc" $HOME/.vimrc
vim -u $HOME/.vimrc -N -es +PluginInstall +qall

# Backup zshrc so we don't do anything stupid
if [ -f "$HOME/.zshrc.bak" ]; then
  printf ".zshrc.bak already exists, exiting\n"
  exit 1
else
  mv $HOME/.zshrc $HOME/.zshrc.bak
  ln -sv "$DOTFILES_DIR/zshrc" $HOME/.zshrc
fi

## Install Powerline-fonts (https://github.com/powerline/fonts)
git clone https://github.com/powerline/fonts.git --depth=1
cd fonts
./install.sh
cd ..
rm -rf fonts

## Clone iTerm2 Color Schemes
if [[ "$(uname -s)" != "Darwin" ]]; then
  git clone https://github.com/mbadolato/iTerm2-Color-Schemes.git
  cd iTerm2-Color-Schemes
  tools/import-scheme.sh schemes/*
  cd ..
  # Currently using "Monokai Vivid"
fi

if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
  printf "Installing zsh-autosuggestions\n"
  git clone --quiet https://github.com/zsh-users/zsh-autosuggestions $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions

  if [ $? -ne 0 ]; then
    printf "zsh-autosuggestions install failed\n"
    exit 1  
  fi
fi
