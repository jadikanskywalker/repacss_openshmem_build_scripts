#!/bin/bash

HLINE="--------------------------------------------"

# Set installation directory
# PREFIX="$SWHOME/sos_1.5"
# rm -rf $PREFIX
mkdir -p $SOS_DIR

# Change to tmp dir
cd $TMPDIR
rm -rf SOS

# Download SOS source if not already downloaded
if [ ! -d "SOS" ]; then
  git clone https://github.com/Sandia-OpenSHMEM/SOS.git
fi

cd SOS

git submodule update --init

echo $HLINE
echo "            RUNNING AUTOGEN"
echo $HLINE
./autogen.sh
echo ; echo


echo $HLINE
echo "            CONFIGURING"
echo $HLINE
echo
echo PMIX_DIR=$PMIX_DIR
echo LIBFABRIC_DIR=$LIBFABRIC_DIR
export CPPFLAGS="-I$LIBFABRIC_DIR/include -I$PMIX_DIR/include $CPPFLAGS"
export LDFLAGS="-L$LIBFABRIC_DIR/lib -L$PMIX_DIR/lib $LDFLAGS"
echo CPPFLAGS=$CPPFLAGS
echo LDFLAGS=$LDFLAGS
echo 
echo
./configure                       \
  --prefix=$SOS_DIR      \
  --with-pmix=$PMIX_DIR \
  --enable-hard-polling \
  --enable-ofi-mr=basic \
  --with-ofi=$LIBFABRIC_DIR \
  --with-cma #             --> more efficient intra-node transport
  # --enable-hard-polling  --> signficantly improves performance for SOS + OFI verbs
  # --enable-ofi-mr=basic  --> required for OFI verbs to work
  # --enable-shr-atomics     X   does not work on REPACSS
  # --enable-pmi-simple      X   does not work on REPACSS (slurm has no simple pmi plugin)
  # --with-xpmem             X   does not work on REPACSS (library not fully installed)
  # --with-pmix=/opt/apps/nfs/spack-v0.23/opt/spack/linux-rocky9-zen4/gcc-11.4.1/pmix-5.0.3-735lncs2efktvnkbxlwp7okfsbc3euhu
  #                       could be tried instead of $PMIX_DIR, to avoid building PMIX from source
  # --enable-profiling    adds pshmem interface for scorep to profile openshmem functions
  # --with-ucx=$UCX_DIR   experimental, see the SOS build with UCX wiki page

echo $HLINE
echo "            COMPILING"
echo $HLINE
export SHMEM_OFI_PROVIDER="verbs;ofi_rxm"
make -j $CORES  # you may need to designate the launcher for the check tests, see SOS building instructions
make -j $CORES install

