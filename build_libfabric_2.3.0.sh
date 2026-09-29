#!/bin/bash

# build libfabric
#  - 

HLINE="--------------------------------------------"

# Set installation directory
PREFIX="$SWHOME/libfabric-2.3.1"
rm -rf $PREFIX
mkdir -p $PREFIX

# Change to tmp dir
cd $TMPDIR
rm -rf libfabric-2.3.1

# Download Open MPI source if not already downloaded
if [ ! -d "libfabric-2.3.1" ]; then
  wget https://github.com/ofiwg/libfabric/archive/refs/tags/v2.3.1.tar.gz
fi

tar -xzf v2.3.1.tar.gz

cd libfabric-2.3.1

echo $HLINE
echo "            RUNNING AUTOGEN"
echo $HLINE
./autogen.sh
echo ; echo

echo $HLINE
echo "            CONFIGURING"
echo $HLINE

./configure               \
  --prefix=$LIBFABRIC_DIR        \
  --enable-verbs \
  --enable-rxm \
  --disable-psm2 \
  --disable-sockets \
  --disable-usnic \
  --disable-udp \
  --disable-rxd
# disables other providers to prioritize verbs+ofi_rxm
# psm3, psm2, and opx don't work on REPACSS

echo $HLINE
echo "            COMPILING"
echo $HLINE
make -j $CORES
make install

