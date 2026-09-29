#!/bin/bash

cd $TMPDIR 

rm -rf ucx_$PLATFORM
if [ ! -d "./ucx_$PLATFORM" ]; then
  git clone -b v1.17.x https://github.com/openucx/ucx.git ucx_$PLATFORM
fi

cd ucx_$PLATFORM
git submodule update --init --recursive
rm -rf build
mkdir -p build
./autogen.sh

PREFIX="$SWHOME/ucx_1.17"
mkdir -p $PREFIX

# Internode communication enabled
./contrib/configure-release \
  CFLAGS="-Wno-error=unused-but-set-variable" \
  CXXFLAGS="-Wno-error=unused-but-set-variable" \
  --prefix=$PREFIX \
  --enable-mt \
  --with-verbs \
  --with-rc \
  --with-ud \
  --with-dc \
  --with-cm \
  --with-cma

make -j $CORES
make -j $CORES install

