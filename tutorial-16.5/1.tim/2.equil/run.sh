#!/bin/bash

export PATH=$PATH:/path/to/genesis/bin
export OMP_NUM_THREADS=4

qmmm_generator qmmm_generator.inp > qmmm_generator.out
mpirun -np 16 -npernode 4 atdyn step4.1_nvt.inp >& step4.1_nvt.out
mpirun -np 16 -npernode 4 atdyn step4.2_nvt.inp >& step4.2_nvt.out
mpirun -np 16 -npernode 4 atdyn step4.3_nvt.inp >& step4.3_nvt.out
mpirun -np 16 -npernode 4 atdyn step4.4_nvt.inp >& step4.4_nvt.out
mpirun -np 16 -npernode 4 atdyn step4.5_nvt.inp >& step4.5_nvt.out
mpirun -np 16 -npernode 4 atdyn step4.6_nvt.inp >& step4.6_nvt.out
mpirun -np 16 -npernode 4 atdyn step4.7_nvt.inp >& step4.7_nvt.out
mpirun -np 16 -npernode 4 atdyn step4.8_nvt.inp >& step4.8_nvt.out
mpirun -np 16 -npernode 4 atdyn step4.9_qmmm_nvt.inp  >& step4.9_qmmm_nvt.out
mpirun -np 16 -npernode 4 atdyn step4.10_qmmm_nvt.inp >& step4.10_qmmm_nvt.out
mpirun -np 16 -npernode 4 atdyn step4.11_qmmm_nvt.inp >& step4.11_qmmm_nvt.out

exit 0

