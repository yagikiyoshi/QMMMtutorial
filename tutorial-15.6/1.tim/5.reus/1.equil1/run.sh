#!/bin/bash
#
export LD_LIBRARY_PATH=/path/to/qsimulate/lib:$LD_LIBRARY_PATH
export PATH=$PATH:/path/to/genesis/bin

export OMP_NUM_THREADS=4
export BAGEL_NUM_THREADS=${OMP_NUM_THREADS}
export MKL_NUM_THREADS=${OMP_NUM_THREADS}
export I_MPI_PERHOST=4
export I_MPI_DEBUG=5

nimg=$(wc ../0.window/win_rr.dat |awk '{print $1}')
for i in `seq 1 $nimg`; do
  mpiexec.hydra -n 2 atdyn equil1_${i}.inp >& equil1_${i}.out
done

exit 0

