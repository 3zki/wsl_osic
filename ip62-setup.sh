#!/bin/sh
# ========================================================================
# Initialization of IIC Open-Source EDA Environment for Ubuntu WSL2
# This script is for use with OpenIP62PDK.
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

if [ ! -d "$HOME/.xschem" ]; then
  mkdir -p $HOME/.xschem
  cp -f $my_dir/ip62/xschemrc_IP62 $HOME/.xschem/xschemrc
  cp -aR $my_dir/ip62/models $HOME/.xschem
fi

if [ ! -d "$SRC_DIR/OpenIP62" ]; then
        cd $SRC_DIR
  git clone  https://github.com/ishi-kai/OpenIP62.git
  cp -aR OpenIP62 $HOME/.klayout/salt
else
  echo ">>>> Updating OpenRule1um"
  cd $SRC_DIR/OpenIP62 || exit
  git pull
  cp -aR IP62 $HOME/.klayout/salt
  cp -aR AnagixLoader $HOME/.klayout/salt

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
