#!/bin/bash

export LD_LIBRARY_PATH=/path/to/qsimulate/lib:$LD_LIBRARY_PATH
export PATH=$PATH:/path/to/genesis/bin

qmmm_generator qmmm_generator.inp >& qmmm_generator.out

export OMP_NUM_THREADS=4
export BAGEL_NUM_THREADS=${OMP_NUM_THREADS}
export MKL_NUM_THREADS=${OMP_NUM_THREADS}
export I_MPI_PERHOST=4
export I_MPI_DEBUG=5

mpiexec.hydra -n 8 atdyn step4.1_nvt.inp >& step4.1_nvt.out
mpiexec.hydra -n 8 atdyn step4.2_nvt.inp >& step4.2_nvt.out
mpiexec.hydra -n 8 atdyn step4.3_nvt.inp >& step4.3_nvt.out
mpiexec.hydra -n 8 atdyn step4.4_nvt.inp >& step4.4_nvt.out
mpiexec.hydra -n 8 atdyn step4.5_nvt.inp >& step4.5_nvt.out
mpiexec.hydra -n 8 atdyn step4.6_nvt.inp >& step4.6_nvt.out
mpiexec.hydra -n 8 atdyn step4.7_nvt.inp >& step4.7_nvt.out
mpiexec.hydra -n 8 atdyn step4.8_nvt.inp >& step4.8_nvt.out


exit 0

