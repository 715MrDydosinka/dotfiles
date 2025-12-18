#!/bin/sh
SCRIPT_DIR="$(dirname "$(realpath "$0")")"
echo "Script directory: $SCRIPT_DIR"
cd $SCRIPT_DIR

USERNAME="hlupa"
read -p "Enter your main user name: " $USERNAME
HOMEDIR=$(getent passwd hlupa | cut -d: -f6)

CFG_DIR="$HOMEDIR/.config"
SWAYCFG_DIR="$CFG_DIR/sway"

dpkg --add-architecture i386
apt update -y
if [ $? -ne 0 ]; then
    echo "Updating repositories failed.\nAre u sure u have an internet connection?"
    exit 1
fi

echo "Installing Sudo"
apt install sudo -y
if [ $? -eq 0 ]; then
    sed -i "\$a$USERNAME   ALL=(ALL:ALL) NOPASSWD:ALL" /etc/sudoers
else
    echo "Installing Sudo failed"
fi

echo "Installing Fish"
apt install fish -y
if [ $? -eq 0 ]; then
    usermod -s "/usr/bin/fish" "$USERNAME"
    mkdir -p "$CFG_DIR/fish"
    mv "$CFG_DIR/config.fish" "$CFG_DIR/config.fish.old"
    cp "$SCRIPT_DIR/fish_config" "$CFG_DIR/config.fish"
else
    echo "Installing Fish failed"
fi

echo "Installing Sway"
apt install sway swaylock xwayland mako-notifier libnotify-bin -y
if [ $? -eq 0 ]; then

    mv "$SWAYCFG_DIR" "$CFG_DIR/sway.old"
    mkdir -p "$SWAYCFG_DIR"
    cp "$SCRIPT_DIR/wallpaper.jpg" "$SWAYCFG_DIR"
    cp "$SCRIPT_DIR/sway_config" "$SWAYCFG_DIR/config"
    cp "$SCRIPT_DIR/swaybar" "$SWAYCFG_DIR/"
    chmod +x "$SCRIPT_DIR/swaybar"
    chown -R "$USERNAME":"$USERNAME" "$SWAYCFG_DIR"
else
    echo "Installing Sway failed"
fi

echo "Installing fetches"
apt install fastfetch hyfetch -y
if [ $? -eq 0 ]; then
    cp "$SCRIPT_DIR/hyfetch_config" "$CFG_DIR/hyfetch.json"
else
    echo "Installing Fetches failed"
fi

echo "Installing Curl n Wget"
apt install curl wget -y
if [ $? -eq 0 ]; then
    mkdir -p "$SCRIPT_DIR/tmp"

    echo "Installing Hiddify"
    wget -O "$SCRIPT_DIR/tmp/hiddify.deb" "https://github.com/hiddify/hiddify-next/releases/download/v2.3.1/Hiddify-Debian-x64.deb"
    dpkg -i "$SCRIPT_DIR/tmp/hiddify.deb"
    if [ $? -ne 0 ]; then
    	echo "Installing Hiddify failed"
    fi

    echo "Installing Telegram failed"
    wget -O "$SCRIPT_DIR/tmp/telegram.tar.xz" "https://telegram.org/dl/desktop/linux"
    if [ $? -eq 0 ]; then
        mkdir "/opt/telegram"
        tar xf "$SCRIPT_DIR/tmp/telegram.tar.xz" -C "/opt/telegram"
        ln -s "/opt/telegram/Telegram" "/usr/bin/telegram"
    else
	echo "Installing Telegram failder"
    fi

fi

# Installing sound
echo "Installing Pipewire"
apt install pipewire-audio pavucontrol -y
if [ $? -ne 0 ]; then
    echo "Installing Pipewire failed"
fi

echo "Installing Git"
apt install git -y
if [ $? -eq 0 ]; then
    echo "Git installed, zbs"
    git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
    if [ $? -ne 0 ]; then
	    echo "Failed git'ing Packer for neovim"
    fi
else
    echo "Installing Git failed"
fi

echo "Installing Neovim"
apt install neovim -y
if [ $? -eq 0 ]; then
    mv "$SCRIPT_DIR/nvim" "$CFG_DIR/nvim.old"
    cp -R "$SCRIPT_DIR/nvim" "$CFG_DIR"
fi

echo "Installing Rust Cargo"
#TODO

sed -i.bak 's/Debian/Lesbian/g' /etc/os-release

apt install alacritty firefox-esr darktable qbittorrent filezilla build-essential grim slurp wl-clipboard obs-studio vlc remmina vlc -y

echo ""
echo ""
echo "Hlupamination completed!"
echo "Enjoy!"
echo ""
echo ""
