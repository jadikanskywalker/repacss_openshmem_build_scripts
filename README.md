These scripts install libraries into `~/sw/$PLATFORM/`. They rely on
environment variables to be exported from `~/.bash_profile`. To
configure this, copy `bash_profile` into your `~/.bash_profile`.

Note: this `bash_profile` sources `~/.bashrc`, so the latter
shouldn't source the former.

In general, all MPI/SHMEM librariers first require PMIX. Then, OSSS
can be built over UCX, or SOS can be built over libfabric. I have
observed slightly better performance with OSSS.

libev + pmix
================
PMIX is a library that configures distributed memory runtimes, used 
by many MPI and OpenSHMEM libraries. REPACSS does not have slurm
plugins for "pmi-simple" builds. Therefore, OpenMPI, SOS, and OSSS
all must be built with PMIX linked.

A pmix installation exists at:
`/opt/apps/nfs/spack-v0.23/opt/spack/linux-rocky9-zen4/gcc-11.4.1/pmix-5.0.3-735lncs2efktvnkbxlwp7okfsbc3euhu`.
If you use this, change PMIX_DIR in `~/.bash_profile`.

Alternatively, to build PMIX from source, build libev then pmix.

libfabric + SOS
================
SOS is built over libfabric; it also supports UCX but that is
experimental per their wiki page.

REPACSS is an IB cluster, so the libfabric verbs+ofi_rxm providers
should be configured and used for performant multi-node runtimes.
See the SOS wiki page on building for verbs providers for reference:
`https://github.com/Sandia-OpenSHMEM/SOS/wiki/Verbs-Build-Instructions`.

Note on runtime variables: setting the following environmental
variables helps improve performance and avoid errors.
  - `SHMEM_OFI_PROVIDER=verbs;ofi_rxm` helps libfabric choose
    the berst providers
  - `FI_VERBS_DEVICE_NAME=mlx5_2` (or alternative device) avoids
    initialization hang from different PEs choosing different devices
    on different nodes
  - `FI_MR_CACHE_MAX_COUNT=0` avoids memory registration cache issues

Run `make -j$CORES check TEST_RUNNER="srun -n 2 -ppn 1"` to run the
SOS test suite.

Note on ScoreP: ScoreP is a profiling library for profiling MPI
and OpenSHMEM application. The scorep build script is for linking
ScoreP to SOS for profiling; note this requires SOS to be built with
the `--enable_profiling` flag that enables its pshmem interface. Even
with that, I can not been able to successfully profile OpenSHMEM
functions with ScoreP yet. I have also not tried building ScoreP over
OSSS or any MPI installation yet.

UCX + OpenMPI + OSSS
=====================
OSSS is built over UCX, which in general has better verbs support
than libfabric. I have found OSSS to be more slighty more performant
than SOS on REPACSS. Moreover, REPACSS has become the primary
contributor to OSSS, and we have a fork that is 1.6 compliant,
whereas SOS is only 1.5 compliant.

OSSS does not build its own launcher, but expects to use OpenMPI's
launcher. Therefore, build UCX and OpenMPI first, then OSSS.

Note on OpenMPI: the build script manually links to a spack PMIX,
libevent, UCX, and zlip install. I remember having linking trouble
installing with custom built libraries. You can try though.

Note on OSSS launcher: the OSSS `oshrun` launcher requires Python
3.12. Any other python version will fail. Ensure that Python
3.12 is available in your environment when using the launcher.

Note on runtime variables:
  - If you do fancy things with memory, setting `UCX_MEM_EVENTS=no`
    prevents the verbs transport from reacting to memory events and
    invalidating rkeys your application still wants to use. However,
    this stops UCX from freeing symmetric-heap memory that has been
    freed.
