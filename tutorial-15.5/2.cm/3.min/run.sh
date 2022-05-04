#!/bin/bash

export LD_LIBRARY_PATH=/path/to/qsimulate/lib:$LD_LIBRARY_PATH
export PATH=$PATH:/path/to/genesis/bin

export OMP_NUM_THREADS=4
export BAGEL_NUM_THREADS=${OMP_NUM_THREADS}
export MKL_NUM_THREADS=${OMP_NUM_THREADS}
export I_MPI_PERHOST=4
export I_MPI_DEBUG=5

mpiexec.hydra -n 8 atdyn qmmm_min1.inp  >& qmmm_min1.out
sed "s/MIN/min1/" rst_convert.inp  > aa
rst_convert aa > /dev/null
rm aa

mpiexec.hydra -n 8 atdyn qmmm_min2a.inp >& qmmm_min2a.out
mpiexec.hydra -n 8 atdyn qmmm_min2b.inp >& qmmm_min2b.out
sed "s/MIN/min2b/" rst_convert.inp  > aa
rst_convert aa > /dev/null
rm aa

exit 0

