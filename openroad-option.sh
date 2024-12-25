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
export openROAD_VERSION="2.0-17198-g8396d0866"


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

# Install/update yosys
# --------------------
if [ ! -d "$SRC_DIR/yosys" ]; then
	echo ">>>> Installing yosys"
	sudo apt -qq install -y clang bison flex \
	libreadline-dev gawk tcl-dev libffi-dev git \
	graphviz xdot pkg-config python3 libboost-system-dev \
	libboost-python-dev libboost-filesystem-dev zlib1g-dev
	git clone https://github.com/YosysHQ/yosys.git "$SRC_DIR/yosys"
	cd "$SRC_DIR/yosys" || exit
 	git submodule update --init
else
	echo ">>>> Updating yosys"
	cd "$SRC_DIR/yosys" || exit
	git pull
 	git submodule update
fi
make config-clang
make -j"$(nproc)" && sudo make install
make clean

# Install/update openroad
# -----------------------
# if [ ! -d "$SRC_DIR/openROAD" ]; then
#	echo ">>>> Installing qrouter"
#	git clone https://github.com/The-OpenROAD-Project/OpenROAD.git "$SRC_DIR/openROAD"
#	cd "$SRC_DIR/openROAD" || exit
#else
#	echo ">>>> Updating openROAD"
#	cd "$SRC_DIR/openROAD" || exit
#	git pull
#fi
#sudo ./etc/DependencyInstaller.sh
#mkdir build && cd build
#cmake ..
#make -j"$(nproc)"
#sudo make install 
#make clean

wget "https://github.com/Precision-Innovations/OpenROAD/releases/download/$openROAD_VERSION/openroad_"$openROAD_VERSION"_amd64-ubuntu-22.04.deb"

# Ubuntu 22 WSL patch for openROAD package
sudo dpkg -i --force-overwrite "./openroad_"$openROAD_VERSION"_amd64-ubuntu-22.04.deb"
# Patch end

sudo apt -f -qq install -y "./openroad_"$openROAD_VERSION"_amd64-ubuntu-22.04.deb"
rm "./openroad_"$openROAD_VERSION"_amd64-ubuntu-22.04.deb"

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
