#!/bin/bash

export PATH=$PATH:/path/to/genesis/bin
export OMP_NUM_THREADS=4

mpirun -np 16 -npernode 4 spdyn step3.1_minimization.inp >& step3.1_minimization.out
mpirun -np 16 -npernode 4 spdyn step3.2_heating.inp      >& step3.2_heating.out
mpirun -np 16 -npernode 4 spdyn step3.3_npt.inp          >& step3.3_npt.out
mpirun -np 16 -npernode 4 spdyn step3.4_nvt.inp          >& step3.4_nvt.out
crd_convert crd_convert.inp > crd_convert.out

exit 0

