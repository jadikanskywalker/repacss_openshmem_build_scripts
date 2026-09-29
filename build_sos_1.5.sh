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

# NOTE: we could patch src/transport_ofi.c so support libfabric2.3.0 mr_, redownload at your own risk
# git checkout src/transport_ofi.c

# Patch transport_ofi.c to include FI_MR_LOCAL required by Libfabric 2.x "verbs;ofi_rxm"
# sed -i '/#ifdef ENABLE_MR_ENDPOINT/i #ifdef FI_MR_LOCAL\n    domain_attr.mr_mode |= FI_MR_LOCAL;\n#endif\n' src/transport_ofi.c
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
  --with-cma
  # --enable-shr-atomics    # does not work on REPACSS
  #--with-pmix=/opt/apps/nfs/spack-v0.23/opt/spack/linux-rocky9-zen4/gcc-11.4.1/pmix-5.0.3-735lncs2efktvnkbxlwp7okfsbc3euhu      built manually with gcc 15 \
  #--enable-pmi-simple      # did not work for me      \
  #--enable-ofi-mr=basic          \
  #--with-ucx=$UCX_DIR            \

echo $HLINE
echo "            COMPILING"
echo $HLINE
# export SHMEM_OFI_PROVIDER="verbs;ofi_rxm"
# make -j $CORES check
# make -j $CORES install

