#!/bin/bash
#
export LD_LIBRARY_PATH=/path/to/qsimulate/lib:$LD_LIBRARY_PATH
export PATH=$PATH:/path/to/genesis/bin

export OMP_NUM_THREADS=4
export BAGEL_NUM_THREADS=${OMP_NUM_THREADS}
export MKL_NUM_THREADS=${OMP_NUM_THREADS}
export I_MPI_PERHOST=4
export I_MPI_DEBUG=5

gfortran gen_input.f90 -o gen_input
./gen_input 

for i in `seq 1 21`; do
  mpiexec.hydra -n 8 atdyn equil2_${i}.inp >& equil2_${i}.out
done

exit 0

