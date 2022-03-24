#!/bin/bash
#PJM -L "rscgrp=small"
#PJM -L "rscunit=rscunit_ft01"
#PJM -L "node=1"
#PJM --mpi "proc=4"
#PJM -L "elapse=08:00:00"
#PJM -j
#PJM -S

## RUN
export LD_LIBRARY_PATH=/home/hp210101/u01237/local_trad/lib:$LD_LIBRARY_PATH

export PATH=${PATH}:/home/hp210101/u01237/devel/genesis/genesis.gat_qmmm_qs/bin

export PLE_MPI_STD_EMPTYFILE=off

omp=12
export  QM_NUM_THREADS=${omp}
export OMP_NUM_THREADS=${omp}
export BAGEL_NUM_THREADS=${omp}

for i in `seq 1 28`; do
  mpiexec -n 4 -stdout equil1_${i}.out atdyn equil1_${i}.inp
done

exit 0
