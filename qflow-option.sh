#!/bin/sh
# ========================================================================
# QFlow options
# ========================================================================

# Define setup environment
# ------------------------
export PDK_ROOT="$HOME/pdk"
export SRC_DIR="$HOME/src"
my_path=$(realpath "$0")
my_dir=$(dirname "$my_path")
export SCRIPT_DIR="$my_dir"


# Install/update qrouter
# --------------------
if [ ! -d "$SRC_DIR/qrouter" ]; then
	echo ">>>> Installing qrouter"
	git clone https://github.com/RTimothyEdwards/qrouter.git "$SRC_DIR/qrouter"
	cd "$SRC_DIR/qrouter" || exit
else
	echo ">>>> Updating qrouter"
	cd "$SRC_DIR/qrouter" || exit
	git pull
fi
git checkout qrouter-1.4
./configure
git checkout
make && sudo make install
make clean

# Install/update graywolf
# --------------------
if [ ! -d "$SRC_DIR/graywolf" ]; then
	echo ">>>> Installing graywolf"
	sudo apt -qq install -y libgsl-dev cmake
	git clone https://github.com/RTimothyEdwards/graywolf.git "$SRC_DIR/graywolf"
	cd "$SRC_DIR/graywolf" || exit
	./configure
else
	echo ">>>> Updating graywolf"
	cd "$SRC_DIR/graywolf" || exit
	git pull
fi
mkdir build
cd build
cmake ..
make  
sudo make install  

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
	./configure
else
	echo ">>>> Updating yosys"
	cd "$SRC_DIR/yosys" || exit
	git pull
fi
make config-clang
make -j"$(nproc)" && sudo make install
make clean

# Install/update qflow
# --------------------
if [ ! -d "$SRC_DIR/qflow" ]; then
	echo ">>>> Installing qflow"
	sudio apt -qq install -y python-tk
	git clone https://github.com/RTimothyEdwards/qflow.git "$SRC_DIR/qflow"
	cd "$SRC_DIR/qflow" || exit
else
	echo ">>>> Updating yosys"
	cd "$SRC_DIR/qflow" || exit
	git pull
fi
git checkout qflow-1.3
./configure
make && sudo make install
make clean
