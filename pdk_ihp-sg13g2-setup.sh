#!/bin/bash
# ========================================================================
# Initialization of IIC Open-Source EDA Environment for Ubuntu WSL2
# This script is for use with SG13G2.
# ========================================================================

# Define setup environment
# ------------------------
export PDK_ROOT="$HOME/pdk"
export MY_STDCELL=sg13g2_stdcells
export SRC_DIR="$HOME/src"
my_path=$(realpath "$0")
my_dir=$(dirname "$my_path")
export SCRIPT_DIR="$my_dir"
export PDK_GIT_NAME="IHP-Open-PDK"
export PDK_NAME="ihp-sg13g2"
export PDK="$PDK_GIT_NAME/$PDK_NAME"
export OPENVAF_VERSION="_23_5_0_"

# --------
echo ""
echo ">>>> Initializing..."
echo ""

if [ "$(uname)" == 'Darwin' ]; then
	OS='Mac'
	echo "Your platform ($(uname -a)) is not supported."
	exit 1
elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
	OS='Linux'
elif [ "$(expr substr $(uname -s) 1 10)" == 'MINGW32_NT' ]; then
	OS='Cygwin'
	echo "Your platform ($(uname -a)) is not supported."
	exit 1
else
	echo "Your platform ($(uname -a)) is not supported."
	exit 1
fi

# for Mac
if [ "$(uname)" == 'Darwin' ]; then
  VER=`sw_vers -productVersion | awk -F. '{ print $1 }'`
  case $VER in
    "14")
      export MAC_OS_NAME=Sonoma
      ;;
    "15")
      export MAC_OS_NAME=Sequoia
      ;;
    *)
      echo "Your Mac OS Version ($VER) is not supported."
      exit 1
      ;;
  esac
  export MAC_ARCH_NAME=`uname -m`
fi
export TCL_VERSION=8.6.14
export TK_VERSION=8.6.14
export GTK_VERSION=3.24.42
export CC_VERSION=-14
export CXX_VERSION=-14


# Delete previous PDK
# ---------------------------------------------
if [ -d "$PDK_ROOT" ]; then
	echo ">>>> Delete previous PDK"
	rm -rf "$PDK_ROOT"
fi
mkdir "$PDK_ROOT"

# Install OpenVAF
# -----------------------------------
cd $HOME
mkdir bin
cd bin
wget https://openva.fra1.cdn.digitaloceanspaces.com/openvaf$OPENVAF_VERSIONlinux_amd64.tar.gz
tar zxf openvaf$OPENVAF_VERSIONlinux_amd64.tar.gz
rm openvaf$OPENVAF_VERSIONlinux_amd64.tar.gz
export PATH=$HOME/bin:$PATH

# Install PDK
# -----------------------------------
cd $PDK_ROOT
git clone --recursive https://github.com/IHP-GmbH/IHP-Open-PDK.git

cd $PDK_GIT_NAME
pip install -r requirements.txt
cd $PDK_NAME/libs.tech/xschem/
export PDK_ROOT="$HOME/pdk/$PDK_GIT_NAME"
python3 install.py
export PDK_ROOT="$HOME/pdk"
export PYTHONPYCACHEPREFIX=/tmp

# Copy KLayout Configurations
# ----------------------------------
if [ ! -d "$HOME/.klayout" ]; then
	mkdir $HOME/.klayout
fi
if [ ! -d "$HOME/.klayout/tech" ]; then
	mkdir -p $HOME/.klayout/tech/
fi
if [ ! -d "$HOME/.klayout/libraries" ]; then
	mkdir -p $HOME/.klayout/libraries
fi
cp -f $PDK_ROOT/$PDK/libs.tech/klayout/tech/sg13g2.lyp $HOME/.klayout/tech/
cp -f $PDK_ROOT/$PDK/libs.tech/klayout/tech/sg13g2.lyt $HOME/.klayout/tech/

cp -rf $PDK_ROOT/$PDK/libs.tech/klayout/tech/drc $HOME/.klayout/drc
cp -rf $PDK_ROOT/$PDK/libs.tech/klayout/tech/lvs $HOME/.klayout/lvs
cp -rf $PDK_ROOT/$PDK/libs.tech/klayout/tech/macros $HOME/.klayout/macros
cp -rf $PDK_ROOT/$PDK/libs.tech/klayout/tech/pymacros $HOME/.klayout/pymacros
cp -rf $PDK_ROOT/$PDK/libs.tech/klayout/python $HOME/.klayout/python
ln -s $HOME/.klayout/python/pycell4klayout-api/source/python/cni/ $HOME/.klayout/python/cni


# Install OpenEMS
# -----------------------------------
sudo apt-get install -y build-essential cmake git libhdf5-dev libvtk7-dev libboost-all-dev libcgal-dev libtinyxml-dev qtbase5-dev libvtk7-qt-dev octave liboctave-dev gengetopt help2man groff pod2pdf bison flex libhpdf-dev libtool 
sudo pip install numpy matplotlib cython h5py

cd $SRC_DIR
if [ ! -d "$SRC_DIR/openEMS-Project" ]; then
	git clone --recursive https://github.com/thliebig/openEMS-Project.git
	cd openEMS-Project
else
	cd openEMS-Project
	git pull --recurse-submodules
fi
./update_openEMS.sh ~/opt/openEMS --with-hyp2mat --with-CTB --python


# Create .spiceinit
# -----------------
rm $HOME/.spiceinit
cp -f $PDK_ROOT/$PDK/libs.tech/ngspice/.spiceinit $HOME/
{
	echo "set num_threads=$(nproc)"
} >> "$HOME/.spiceinit"

# Create iic-init.sh
# ------------------
if [ ! -d "$HOME/.xschem" ]; then
	mkdir "$HOME/.xschem"
fi
{
	echo "export PDK_ROOT=$PDK_ROOT"
	echo "export PDK=$PDK"
	echo "export STD_CELL_LIBRARY=$MY_STDCELL"
	echo "export PYTHONPYCACHEPREFIX=/tmp"
	echo "export PATH=\"$HOME/bin:$PATH\""
} >> "$HOME/.bashrc"

# Copy various things
# -------------------
rm $HOME/.xschem/xschemrc
cp -f $PDK_ROOT/$PDK/libs.tech/xschem/xschemrc $HOME/.xschem/

# Fix paths in xschemrc to point to correct PDK directory
# -------------------------------------------------------

# Finished
# --------
echo ""
echo ">>>> All done. Please restart or re-read .bashrc"
echo ""
