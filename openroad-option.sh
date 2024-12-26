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
export KLAYOUT_VERSION=0.29.10
export UBUNTU_VERSION=22

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

# Install/update sby
# ------------------
if [ ! -d "$SRC_DIR/sby" ]; then
	echo ">>>> Installing sby"
	sudo apt -qq install -y build-essential clang bison flex \
	libreadline-dev gawk tcl-dev libffi-dev git \
	graphviz xdot pkg-config python3 zlib1g-dev
	python3 -m pip install click
	git clone https://github.com/YosysHQ/sby.git "$SRC_DIR/sby"
	cd "$SRC_DIR/sby" || exit
else
	echo ">>>> Updating sby"
	cd "$SRC_DIR/sby" || exit
	git pull
fi
sudo make install
make clean

# Install/update eqy
# ------------------
if [ ! -d "$SRC_DIR/eqy" ]; then
	echo ">>>> Installing eqy"
	git clone https://github.com/YosysHQ/eqy.git "$SRC_DIR/eqy"
	cd "$SRC_DIR/eqy" || exit
else
	echo ">>>> Updating eqy"
	cd "$SRC_DIR/eqy" || exit
	git pull
fi
make
sudo make install
make clean

# Install/Update KLayout
# ---------------------
echo ">>>> Installing KLayout-$KLAYOUT_VERSION"
wget https://www.klayout.org/downloads/Ubuntu-$UBUNTU_VERSION/klayout_$KLAYOUT_VERSION-1_amd64.deb
sudo apt -qq install -y ./klayout_$KLAYOUT_VERSION-1_amd64.deb
rm klayout_$KLAYOUT_VERSION-1_amd64.deb
pip install docopt pandas pip-autoremove

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
# -eqy option will install yosys, eqy and sby
# but NOT recommended!
# sudo ./etc/DependencyInstaller.sh -eqy
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
