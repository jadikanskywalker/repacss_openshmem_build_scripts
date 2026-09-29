os=$(uname -s)
arch=$(uname -m)
if [ -d /etc/susehelp.d ]; then
  os='sles'
elif [ '1' = "$(uname -r |cut -f 6 -d '.' |grep -c chaos)" ]; then
  os='toss'
elif [ 'Linux' = "$os" ]; then
  os=$(uname -r |grep -o -E '[a-z]+.' |head -n 1)
elif [ 'Darwin' = "$os" ]; then
  os='osx'
fi
export PLATFORM=${os}-${arch}

# --- Number of cores for building
export CORES=$(( $(nproc) -1 ))

# --- Set binary locations
# export TMPDIR=$SCRATCH
export SWHOME=$HOME/sw/$PLATFORM
if [ ! -d $SWHOME ]; then
  mkdir -p $SWHOME
fi

source ~/.bashrc

# --- s command for invoking printf x number of times
s() { for ((i=1; i<=$1; i++)); do printf '\n'; done; }

# ---------------------------------------------------------
#             Built-from-source sw paths
# ---------------------------------------------------------
export LLVM_DIR="$SWHOME/llvm_21.x"
export LLVM_BIN="$LLVM_DIR/bin"
export LLVM_LIB="$LLVM_DIR/lib"
export LLVM_INCLUDE="$LLVM_DIR/include"

# export HWLOC_DIR="$SWHOME/hwloc_2.12"
# export HWLOC_BIN="$HWLOC_DIR/bin"
# export HWLOC_INCLUDE="$HWLOC_DIR/include"
# export HWLOC_LIB="$HWLOC_DIR/lib"

# export LIBEV_DIR="$SWHOME/libev_4.33"
# export LIBEV_BIN="$LIBEV_DIR/bin"
# export LIBEV_LIB="$LIBEV_DIR/lib"
# export LIBEV_INCLUDE="$LIBEV_DIR/include"

# export LIBEVENT_DIR="$SWHOME/libevent_2.1.12"
# export LIBEVENT_BIN="$LIBEVENT_DIR/bin"
# export LIBEVENT_LIB="$LIBEVENT_DIR/lib"
# export LIBEVENT_INCLUDE="$LIBEVENT_DIR/include"

export LIBFABRIC_DIR="$SWHOME/libfabric-2.3.1"
export LIBFABRIC_BIN="$LIBFABRIC_DIR/bin"
export LIBFABRIC_LIB="$LIBFABRIC_DIR/lib"
export LIBFABRIC_INCLUDE="$LIBFABRIC_DIR/include"

# export PMIX_DIR="$SWHOME/pmix_6.0.0".    # Incompatible with PRRTE v3 (embedded in OMPI v5)
export PMIX_DIR="$SWHOME/pmix_5.0.3"
export PMIX_BIN="$PMIX_DIR/bin"
export PMIX_LIB="$PMIX_DIR/lib"
export PMIX_INCLUDE="$PMIX_DIR/include"

export UCX_DIR="$SWHOME/ucx_1.17"
# export UCX_DIR="/mnt/DISCL/home/jadhicks/ucx_cxi/ucx/build/build/usr"
export UCX_BIN="$UCX_DIR/bin"
export UCX_LIB="$UCX_DIR/lib64"
export UCX_INCLUDE="$UCX_DIR/include"
export UCX_WARN_UNUSED_ENV_VARS=n

export OMPI_DIR="$SWHOME/ompi_5.0.4"
export OMPI_BIN="$OMPI_DIR/bin"
export OMPI_LIB="$OMPI_DIR/lib"
export OMPI_INCLUDE="$OMPI_DIR/include"

# export MPICH_DIR="$SWHOME/mpich_4.3.0"
# export MPICH_BIN="$MPICH_DIR/bin"
# export MPICH_LIB="$MPICH_DIR/lib"
# export MPICH_INCLUDE="$MPICH_DIR/include"

export SOS_DIR="$SWHOME/sos_1.5"
export SOS_BIN="$SOS_DIR/bin"
export SOS_LIB="$SOS_DIR/lib"
export SOS_INCLUDE="$SOS_DIR/include"

export OSSS_DIR="$SWHOME/osss-ucx_1.5"
export OSSS_BIN="$OSSS_DIR/bin"
export OSSS_LIB="$OSSS_DIR/lib"
export OSSS_INCLUDE="$OSSS_DIR/include"

# export OSSS_TESTING_DIR="$HOME/lanl/shmem/osss/osss-ucx_v1.5/build/install"
# export OSSS_TESTING_BIN="$OSSS_TESTING_DIR/bin"
# export OSSS_TESTING_LIB="$OSSS_TESTING_DIR/lib"
# export OSSS_TESTING_INCLUDE="$OSSS_TESTING_DIR/include"

export SCOREP_DIR="$SWHOME/scorep_9.4"
export SCOREP_BIN="$SCOREP_DIR/bin"
export SCOREP_LIB="$SCOREP_DIR/lib"
export SCOREP_INCLUDE="$SCOREP_DIR/include"

export CTAGS_BIN="$SWHOME/ctags/bin"
export CSCOPE_BIN="$SWHOME/cscope-15.9/src"
# export GCC14_BIN="/opt/apps/nfs/spack-v0.23/opt/spack/linux-rocky9-zen4/gcc-11.4.1/gcc-14.2.0-3tfk3jkagydeiwcl2jsyw75usqwaccuk/bin"

export CUDAQ_BIN="/mnt/DISCL/home/jadhicks/.cudaq/bin"

export CPATH="$SCOREP_INCLUDE:$CPATH"

export DEFAULT_PATH="/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:$HOME/.local/bin:$HOME/miniforge3/bin"
export PATH="$UCX_BIN:$DEFAULT_PATH:$LIBFABRIC_BIN:$OSSS_BIN:$OMPI_BIN:$CTAGS_BIN:$CSCOPE_BIN:$SCOREP_BIN"
export PATH="$PATH:/mnt/DISCL/home/jadhicks/sw/el9-x86_64/intel/oneapi/vtune/2025.6/bin64"
. "$HOME/.cargo/env"

# module load gcc/15.2.0
# export LD_LIBRARY_PATH="$(dirname $(gcc --print-file-name=libatomic.so.1))"
