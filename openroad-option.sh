#!/bin/sh
# ========================================================================
# openROAD options
# ========================================================================

# Define setup environment
# ------------------------
export PDK_ROOT="$HOME/pdk"
export SRC_DIR="$HOME/src"
my_path=$(realpath "$0")
my_dir=$(dirname "$my_path")
export SCRIPT_DIR="$my_dir"

# Update Ubuntu/Xubuntu installation
# ----------------------------------
# the sed is needed for xschem build
echo ">>>> Update packages"
sudo sed -i 's/# deb-src/deb-src/g' /etc/apt/sources.list
sudo apt -qq update -y
sudo apt -qq upgrade -y

# Optional removal of unneeded packages to free up space, important for VirtualBox
# --------------------------------------------------------------------------------
#echo ">>>> Removing packages to free up space"
# FIXME could improve this list
#sudo apt -qq remove -y libreoffice-* pidgin* thunderbird* transmission* xfburn* \
#	gnome-mines gnome-sudoku sgt-puzzles parole gimp*
#sudo apt -qq autoremove -y


# Install basic tools via apt
# ---------------------------
echo ">>>> Installing required packages via APT"
# sudo add-apt-repository -y ppa:deadsnakes/ppa
sudo apt -qq install -y build-essential python3-pip

# unnecessary packages iic-osic will install:
# octave octave-signal octave-communications octave-control
# htop mc gedit vim vim-gtk3 kdiff3

# setup gnome-terminal (with PATCH for Ubuntu 22 WSL2)
# --------
sudo apt -qq install -y gnome-terminal
systemctl --user start gnome-terminal-server

# Install/update openroad
# -----------------------
if [ ! -d "$SRC_DIR/openROAD" ]; then
       echo ">>>> Installing openROAD"
       git clone https://github.com/The-OpenROAD-Project/OpenROAD.git "$SRC_DIR/openROAD"
       cd "$SRC_DIR/openROAD" || exit
       git submodule update --init
else
       echo ">>>> Updating openROAD"
       cd "$SRC_DIR/openROAD" || exit
       git pull
       git submodule update
fi
sudo ./etc/DependencyInstaller.sh
mkdir build && cd build
cmake ..
make
# -j option is not recommended 
sudo make install
make clean

# Create .bashrc
# --------------
sed -i -e '/export OPENROAD_EXE=/d' $HOME/.bashrc
sed -i -e '/export YOSYS_EXE=/d' $HOME/.bashrc

{
	echo "export OPENROAD_EXE=$(command -v openroad)"
	echo "export YOSYS_EXE=$(command -v yosys)"
} >> "$HOME/.bashrc"

# Finished
# --------
echo ""
echo ">>>> All done. Please restart or re-read .bashrc"
echo ""
