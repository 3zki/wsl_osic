#!/bin/sh
# ========================================================================
# Initialization of IIC Open-Source EDA Environment for Ubuntu WSL2
# This script is for use with OpenRule1umPDK.
# ========================================================================

# Define setup environment
# ------------------------
export PDK_ROOT="$HOME/pdk"
export SRC_DIR="$HOME/src"
my_path=$(realpath "$0")
my_dir=$(dirname "$my_path")
export SCRIPT_DIR="$my_dir"


# --------
echo ""
echo ">>>> Initializing..."
echo ""

# Copy KLayout Configurations
# ----------------------------------
if [ ! -d "$HOME/.klayout" ]; then
	mkdir $HOME/.klayout
	mkdir $HOME/.klayout/salt
	# mkdir $home/.klayout/libraries
fi

# Install PDK
# -----------------------------------
cp -f or1pdk/klayoutrc $HOME/.klayout/klayoutrc
# cp -aR or1pdk/GDS/PTS06/* $HOME/.klayout/libraries



if [ ! -d "$HOME/.xschem" ]; then
  mkdir -p $HOME/.xschem
  cd $my_dir
  cp -f or1pdk/xschem/xschemrc_PTS06 $HOME/.xschem/xschemrc
  cp -f or1pdk/xschem/title_PTS06.sch $HOME/.xschem/title_PTS06.sch
  mkdir -p $HOME/.xschem/symbols
  cp -aR ./or1pdk/xschem/symbols/* $HOME/.xschem/symbols/
  mkdir -p $HOME/.xschem/lib
  cp -aR ./or1pdk/xschem/lib/* $HOME/.xschem/lib/
fi

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

# Install GDSfactory
# -----------------------------------
# pip install gdsfactory

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
