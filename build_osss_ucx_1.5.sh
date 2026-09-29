#!/bin/bash

HLINE="--------------------------------------------"

# Set installation directory
PREFIX="$SWHOME/osss-ucx_1.5"
rm -rf $PREFIX
mkdir -p $PREFIX

# Change to tmp dir
cd $TMPDIR
rm -rf osss-ucx

# Download Open MPI source if not already downloaded
if [ ! -d "osss-ucx" ]; then
  git clone -b v1.5 git@github.com:michael-beebe/osss-ucx.git
fi

cd osss-ucx


echo $HLINE
echo "            RUNNING AUTOGEN"
echo $HLINE
mkdir build
./autogen.sh
cd build
echo ; echo


echo $HLINE
echo "            CONFIGURING"
echo $HLINE
export SHMEM_LAUNCHER="$OMPI_BIN/mpiexec"
export CC=`which gcc`
../configure              \
  --prefix=$PREFIX        \
  --with-pmix=$PMIX_DIR   \
  --enable-mt \
  --with-heap-size=128M

echo $HLINE
echo "            COMPILING"
echo $HLINE
make -j $CORES install

