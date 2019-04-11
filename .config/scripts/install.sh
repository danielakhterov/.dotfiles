#!/bin/sh

# Set this just in case otherwise nix might not install 
sysctl kernel.unprivileged_userns_clone=1

# Install Nix package manager
curl https://nixos.org/nix/install | sh
. $HOME/.nix-profile/etc/profile.d/nix.sh

# Exa
nix-env --install exa

# Yadm
nix-env --install yadm

# Initialize dotfiles
cd $HOME
yadm clone https://github.com/danielakhterov/.dotfiles.git
yadm submodule update --init

# Install ZPlug
curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
