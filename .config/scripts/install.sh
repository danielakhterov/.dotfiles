#!/bin/sh

# curl https://raw.githubusercontent.com/danielakhterov/.dotfiles/master/.config/scripts/install.sh | sh

UPDATE_VARIABLES=false

if sysctl kernel.unprivileged_userns_clone 2>&1 | grep "0" > /dev/null 2>&1; then
    echo "Changing kernel.unprivileged_userns_clone to 1 requires sudo permissions"
    echo "command: sudo sysctl kernel.unprivileged_userns_clone=1"
    sudo sysctl kernel.unprivileged_userns_clone=1
fi

if ! command -v nix-env > /dev/null 2>&1; then
    echo "Installing nix package manager..."
    curl https://nixos.org/nix/install | sh
    . $HOME/.nix-profile/etc/profile.d/nix.sh
fi

if ! nix-channel --list | awk '{print $1;}' | grep "nixos" > /dev/null; then
    echo "Adding nixos channel..."
    nix-channel --add https://releases.nixos.org/nixos/19.03/nixos-19.03.172764.50d5d73e22b > /dev/null 2>&1
    UPDATE_VARIABLES=true
fi

if ! nix-channel --list | awk '{print $1;}' | grep "nixpkgs" > /dev/null; then
    echo "Adding nixpkgs-unstable channel..."
    nix-channel --add https://nixos.org/channels/nixpkgs-unstable > /dev/null 2>&1
    UPDATE_VARIABLES=true
fi

if ! nix-channel --list | awk '{print $1;}' | grep "home-manager" > /dev/null; then
    echo "Adding home-manager channel..."
    nix-channel --add https://github.com/rycee/home-manager/archive/master.tar.gz home-manager > /dev/null 2>&1
    UPDATE_VARIABLES=true
fi

if [ "$UPDATE_VARIABLES" = true ]; then
    echo "Updating channels..."
    nix-channel --update > /dev/null 2>&1
fi

# Sometimes required by home-manager especially on non NixOS machines
echo "Setting NIX_PATH env to " $HOME/.nix-defexpr/channels${NIX_PATH:+:}$NIX_PATH
export NIX_PATH=$HOME/.nix-defexpr/channels${NIX_PATH:+:}$NIX_PATH

if ! command -v home-manager > /dev/null 2>&1; then
    echo "Installing home-manager..."
    nix-shell '<home-manager>' -A install > /dev/null 2>&1
fi

if command -v home-manager > /dev/null 2>&1 && cat /etc/os-release | grep "^ID=" | cut -d '=' -f 2 | grep "nixos" > /dev/null 2>&1; then
    echo "Insatlling packages using home-manager..."
    echo "Uninstalling packages that home-manager installs. This is required otherwise home-manager will fail to install..."
    nix-env --uninstall alacritty > /dev/null 2>&1
    nix-env --uninstall alsamixer > /dev/null 2>&1
    nix-env --uninstall android-studio-canary > /dev/null 2>&1
    nix-env --uninstall bat > /dev/null 2>&1
    nix-env --uninstall binutils > /dev/null 2>&1
    nix-env --uninstall cargo-edit > /dev/null 2>&1
    nix-env --uninstall diff-so-fancy > /dev/null 2>&1
    nix-env --uninstall discord > /dev/null 2>&1
    nix-env --uninstall exa > /dev/null 2>&1
    nix-env --uninstall feh > /dev/null 2>&1
    nix-env --uninstall firefox > /dev/null 2>&1
    nix-env --uninstall fish > /dev/null 2>&1
    nix-env --uninstall fzf > /dev/null 2>&1
    nix-env --uninstall gcc > /dev/null 2>&1
    nix-env --uninstall ghq > /dev/null 2>&1
    nix-env --uninstall git > /dev/null 2>&1
    nix-env --uninstall go > /dev/null 2>&1
    nix-env --uninstall hack-font > /dev/null 2>&1
    nix-env --uninstall htop > /dev/null 2>&1
    nix-env --uninstall i3 > /dev/null 2>&1
    nix-env --uninstall i3lock-fancy-unstable > /dev/null 2>&1
    nix-env --uninstall idea-community > /dev/null 2>&1
    nix-env --uninstall openjdk8 > /dev/null 2>&1
    nix-env --uninstall pulseaudio > /dev/null 2>&1
    nix-env --uninstall polybar > /dev/null 2>&1
    nix-env --uninstall rofi-unwrapped > /dev/null 2>&1
    nix-env --uninstall rustup > /dev/null 2>&1
    nix-env --uninstall steam > /dev/null 2>&1
    nix-env --uninstall vim > /dev/null 2>&1
    nix-env --uninstall xautolock > /dev/null 2>&1
    nix-env --uninstall yadm > /dev/null 2>&1
    nix-env --uninstall youtube-dl > /dev/null 2>&1

    echo "Creating $HOME/.config/nixpkgs..."
    mkdir -p $HOME/.config/nixpkgs
    echo "Downloading home.nix from github..."
    curl -o $HOME/.config/nixpkgs/home.nix https://raw.githubusercontent.com/danielakhterov/.dotfiles/master/.config/nixpkgs/home.nix > /dev/null 2>&1

    echo "Running home-manager..."
    home-manager switch > /dev/null 2>&1
elif command -v nix-env > /dev/null 2>&1; then
    echo "Installing packages using nix-env..."
    nix-env --install alacritty > /dev/null 2>&1
    nix-env --install alsamixer > /dev/null 2>&1
    nix-env --install android-studio-canary > /dev/null 2>&1
    nix-env --install bat > /dev/null 2>&1
    nix-env --install binutils > /dev/null 2>&1
    nix-env --install cargo-edit > /dev/null 2>&1
    nix-env --install diff-so-fancy > /dev/null 2>&1
    nix-env --install discord > /dev/null 2>&1
    nix-env --install exa > /dev/null 2>&1
    nix-env --install feh > /dev/null 2>&1
    nix-env --install firefox > /dev/null 2>&1
    nix-env --install fish > /dev/null 2>&1
    nix-env --install fzf > /dev/null 2>&1
    nix-env --install gcc > /dev/null 2>&1
    nix-env --install ghq > /dev/null 2>&1
    nix-env --install git > /dev/null 2>&1
    nix-env --install go > /dev/null 2>&1
    nix-env --install hack-font > /dev/null 2>&1
    nix-env --install htop > /dev/null 2>&1
    nix-env --install i3 > /dev/null 2>&1
    nix-env --install i3lock-fancy-unstable > /dev/null 2>&1
    nix-env --install idea-community > /dev/null 2>&1
    nix-env --install openjdk8 > /dev/null 2>&1
    nix-env --install pulseaudio > /dev/null 2>&1
    nix-env --install polybar --arg i3Support true --arg pulseSupport true --arg mpdSupport true > /dev/null 2>&1
    nix-env --install rofi-unwrapped > /dev/null 2>&1
    nix-env --install rustup > /dev/null 2>&1
    nix-env --install steam > /dev/null 2>&1
    nix-env --install vim > /dev/null 2>&1
    nix-env --install xautolock > /dev/null 2>&1
    nix-env --install yadm > /dev/null 2>&1
    nix-env --install youtube-dl > /dev/null 2>&1
else
    echo "Failed to install packages because nix-env and home-manager failed to install"
    exit 1
fi

if command -v rustup > /dev/null 2>&1; then
    echo "Setting default toolchain for rustup to nightly..."
    rustup default nightly > /dev/null 2>&1

    echo "Downloading rust-src using rustup..."
    rustup component add rust-src > /dev/null 2>&1
fi

if command -v cargo > /dev/null 2>&1; then
    echo "Insatlling rusty-tags using cargo..."
    cargo install rusty-tags > /dev/null 2>&1
fi

if command -v diff-so-fancy > /dev/null 2>&1 && ! git config --list | grep "core.pager" > /dev/null 2>&1; then
    echo "Updating git pager to use diff-so-fancy..."
    git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX" > /dev/null 2>&1
fi

if command -v yadm > /dev/null 2>&1 && ! yadm remote show origin | grep "Fetch URL:" > /dev/null 2>&1; then
    echo "Initializing dotfiles using yadm..."
    yadm clone https://github.com/danielakhterov/.dotfiles.git > /dev/null 2>&1
fi

if command -v zsh > /dev/null 2>&1 && ! zsh -c "command -v zsh > /dev/null 2>&1 || exit 1;" > /dev/null 2>&1; then
    echo "Installing zplugin..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zplugin/master/doc/install.sh > /dev/null 2>&1)" > /dev/null 2>&1
fi

if command -v fish > /dev/null 2>&1 && ! fish -c "fisher --help > /dev/null 2>&1; or exit 1" > /dev/null 2>&1; then
    echo "Installing fisher..."
    curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish > /dev/null 2>&1
    echo "Running fisher..."
    fish -c fisher > /dev/null 2>&1
fi

if command -v vim > /dev/null 2>&1; then
    echo "Installing vim plugins..."
    vim +PlugInstall +qal\! > /dev/null 2>&1
fi

echo "Restart your display manager or restart your computer to apply changes"
echo "Done!"
