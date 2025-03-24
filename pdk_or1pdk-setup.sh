#!/bin/bash
# ========================================================================
# Initialization of IIC Open-Source EDA Environment for Ubuntu WSL2 and macOS.
# This script is for use with OpenRule1umPDK.
# ========================================================================

# Define setup environment
# ------------------------
export PDK_ROOT="$HOME/pdk"
export SRC_DIR="$HOME/src"
my_path=$(realpath "$0")
my_dir=$(dirname "$my_path")
export SCRIPT_DIR="$my_dir"

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


# --------
echo ""
echo ">>>> Initializing..."
echo ""

# Delete previous PDK
# ---------------------------------------------
if [ -d "$PDK_ROOT" ]; then
	echo ">>>> Delete previous PDK"
	sudo rm -rf "$PDK_ROOT"
	sudo mkdir "$PDK_ROOT"
	sudo chown "$USER:staff" "$PDK_ROOT"
fi

# Copy xschem Configurations
# ----------------------------------
if [ ! -d "$HOME/.xschem/symbols" ]; then
  mkdir -p $HOME/.xschem/symbols
  mkdir -p $HOME/.xschem/lib
fi
cd $my_dir
cp -f or1pdk/xschem/xschemrc_PTS06 $HOME/.xschem/xschemrc
cp -f or1pdk/xschem/title_PTS06.sch $HOME/.xschem/title_PTS06.sch
cp -aR ./or1pdk/xschem/symbols/* $HOME/.xschem/symbols/
cp -aR ./or1pdk/xschem/lib/* $HOME/.xschem/lib/


# Copy KLayout Configurations
# ----------------------------------
if [ ! -d "$HOME/.klayout" ]; then
	# cp -rf klayout $HOME/.klayout
	mkdir $HOME/.klayout
	mkdir $HOME/.klayout/salt
fi
cd $my_dir
cp -f or1pdk/klayoutrc $HOME/.klayout/klayoutrc


if [ ! -d "$SRC_DIR/OpenRule1um" ]; then
	cd $SRC_DIR
	git clone  https://github.com/mineda-support/OpenRule1um.git
	cp -aR OpenRule1um $HOME/.klayout/salt/
else
	echo ">>>> Updating OpenRule1um"
	cd $SRC_DIR/OpenRule1um || exit
	git pull
	cd ..
	cp -aR OpenRule1um $HOME/.klayout/salt/
fi
if [ ! -d "$SRC_DIR/AnagixLoader" ]; then
	cd $SRC_DIR
	git clone  https://github.com/mineda-support/AnagixLoader.git
	cp -aR AnagixLoader $HOME/.klayout/salt/
else
	echo ">>>> Updating AnagixLoader"
	cd $SRC_DIR/AnagixLoader || exit
	git pull
	cd ..
	cp -aR AnagixLoader $HOME/.klayout/salt/
fi


# Create .spiceinit
# -----------------
{
	echo "set num_threads=$(nproc)"
	echo "set ngbehavior=hsa"
	echo "set ng_nomodcheck"
} > "$HOME/.spiceinit"

# Finished
# --------
echo ""
echo ">>>> All done."
echo ""
