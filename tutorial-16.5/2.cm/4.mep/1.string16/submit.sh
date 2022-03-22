#!/bin/bash
#------ pjsub option --------#
#PJM -L rscunit=bwmpc
#PJM -L vnode=32
#PJM -L vnode-core=40
#PJM -L elapse=2:00:00
#PJM -g Q21535
#PJM -N cm4_mep1a
#PJM -j
#------- Program execution -------#
#
module load intel/19.5.281
module load gcc/7.2.0

. /bwfefs/opt/x86_64/intel/parallel_studio_xe_2019.5.075/compilers_and_libraries_2019/linux/mkl/bin/mklvars.sh intel64
export LD_LIBRARY_PATH=/home/kyagi/local/lib:$LD_LIBRARY_PATH

GENESIS=/home/kyagi/devel/genesis/genesis.gat_qmmm_qs/bin/atdyn

export OMP_NUM_THREADS=5
export BAGEL_NUM_THREADS=${OMP_NUM_THREADS}
export MKL_NUM_THREADS=${OMP_NUM_THREADS}
export I_MPI_PERHOST=8
export I_MPI_DEBUG=5

mpiexec.hydra -n 256 -print-rank-map $GENESIS qmmm_mep.inp >& qmmm_mep.out

exit 0

