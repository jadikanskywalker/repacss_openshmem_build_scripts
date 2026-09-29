#!/bin/bash

# Set installation directory
PREFIX="$SWHOME/ompi_5.0.4"
rm -rf $PREFIX
mkdir -p $PREFIX

# Change to tmp dir
cd $TMPDIR
# rm -rf openmpi*

# Download Open MPI source if not already downloaded
if [ ! -f "openmpi-5.0.4.tar.gz" ]; then
  wget https://download.open-mpi.org/release/open-mpi/v5.0/openmpi-5.0.4.tar.gz 
fi

# Extract Open MPI source if not already extracted
if [ ! -d "openmpi-5.0.4" ]; then
  tar -xzf openmpi-5.0.4.tar.gz
fi

# Change to Open MPI source directory
cd openmpi-5.0.4

# Clean up any previous builds
rm -rf build
mkdir build
cd build

echo "UCX_DIR: $UCX_DIR"
echo "PMIX_DIR: $PMIX_DIR"
echo "PREFIX: $PREFIX"

#export CC=`which clang`
#export CXX=`which clang++` 
../configure \
    --prefix=$PREFIX \
    --with-ucx=/opt/apps/nfs/spack-v0.23/opt/spack/linux-rocky9-zen3/gcc-11.4.1/ucx-1.17.0-tyada4cd2qokbnz57jreh2d2iub3cefw \
    --with-pmix=/opt/apps/nfs/spack-v0.23/opt/spack/linux-rocky9-zen4/gcc-11.4.1/pmix-5.0.3-735lncs2efktvnkbxlwp7okfsbc3euhu \
    --with-zlib=/opt/apps/nfs/spack-v0.23/opt/spack/linux-rocky9-zen3/gcc-11.4.1/zlib-ng-2.2.1-xefdd3cjoqkqzrf44pw7sohpi2djmv6h \
    --with-libevent=/opt/apps/nfs/spack-v0.23/opt/spack/linux-rocky9-zen4/gcc-11.4.1/libevent-2.1.12-eevmddhh74gn65pon2uamdne2fda2c5j \
    --disable-static \
    --disable-silent-rules \
    --enable-shared \
    --without-hcoll \
    --without-xpmem \
    --without-psm \
    --without-mxm \
    --without-knem \
    --without-psm2 \
    --without-ucc \
    --without-fca \
    --without-cray-xpmem \
    --without-alps \
    --without-lsf \
    --without-sge \
    --without-loadleveler \
    --disable-memchecker \
    --disable-java \
    --disable-mpi-java \
    --disable-io-romio \
    --with-gpfs=no \
    --without-cuda \
    --enable-oshmem \
    --enable-wrapper-rpath \
    --disable-wrapper-runpath \
    CFLAGS=-DYY_BUF_SIZE=1048576 \
    --disable-debug


    # --with-ucx=/opt/apps/nfs/spack-v0.23/opt/spack/linux-rocky9-zen3/gcc-11.4.1/ucx-1.17.0-tyada4cd2qokbnz57jreh2d2iub3cefw \
    # --with-libevent=/opt/apps/nfs/spack-v0.23/opt/spack/linux-rocky9-zen4/gcc-11.4.1/libevent-2.1.12-eevmddhh74gn65pon2uamdne2fda2c5j \
    # --with-zlib=/opt/apps/nfs/spack-v0.23/opt/spack/linux-rocky9-zen3/gcc-11.4.1/zlib-ng-2.2.1-xefdd3cjoqkqzrf44pw7sohpi2djmv6h \
    # --with-hwloc=/opt/apps/nfs/spack-v0.23/opt/spack/linux-rocky9-zen4/gcc-11.4.1/hwloc-2.11.1-euhnwwgwuxnsyfbhstyvmbmwll2bbhwu \

# Build and install Open MPI
make -j $(( $(nproc) - 1 )) install


