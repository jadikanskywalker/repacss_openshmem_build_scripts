#!/bin/bash
# Set installation directory
PREFIX="$SWHOME/pmix_5.0.3"
rm -rf $PREFIX
mkdir -p $PREFIX

# Set temporary working directory
cd $TMPDIR
rm -rf pmix-5.0.3

# Download PMIx source if not already downloaded
if [ ! -f "pmix-5.0.3.tar.bz2" ]; then
  wget https://github.com/openpmix/openpmix/releases/download/v5.0.3/pmix-5.0.3.tar.bz2
fi

# Extract PMIx source if not already extracted
if [ ! -d "pmix-5.0.3" ]; then
  tar -xjf pmix-5.0.3.tar.bz2
fi

# Change to PMIx source directory
cd pmix-5.0.3

# Clean up any previous builds
rm -rf build
mkdir build
cd build

# Configure the build
export CC=`which gcc`
export CXX=`which g++`
../configure \
  --prefix=$PREFIX \
  --with-libev=$LIBEV_DIR

# Build and install PMIx
make -j $(( $(nproc) - 1 ))
make install

