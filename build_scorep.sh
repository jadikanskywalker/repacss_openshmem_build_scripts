#!/bin/bash

# SOS must be build with --enable-profiling to enable pshmem
# interface that allows SCOREP to profile OpenSHMEM functions

cd $TMPDIR

# rm scorep-9.4 -rf

# wget https://perftools.pages.jsc.fz-juelich.de/cicd/scorep/tags/scorep-9.4/scorep-9.4.tar.gz
# tar -xzf scorep-9.4.tar.gz

cd scorep-9.4

mkdir build_
cd build_

# Run configure with LDFLAGS explicitly pointing to the custom UCX
../configure --prefix=$SWHOME/scorep_9.4/ \
            --without-mpi \
            --with-shmem=openshmem \
            --with-libbfd=download \
            --with-libgotcha=download \
            SHMEMCC=/mnt/DISCL/home/jadhicks/sw/el9-x86_64/sos_1.5/bin/oshcc \
            SHMEMCXX=/mnt/DISCL/home/jadhicks/sw/el9-x86_64/sos_1.5/bin/oshc++ \
            SHMEM_LIBS="-lsma" \
            SHMEM_NAME="OpenSHMEM"

make -j $CORES
make install
