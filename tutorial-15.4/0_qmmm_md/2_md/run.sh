#!/bin/bash

export PATH=$PATH:../../bin

export OMP_NUM_THREADS=4
mpirun -np 4 spdyn min.inp   > min.out  2>&1
mpirun -np 4 spdyn equil.inp > equil.out 2>&1
mpirun -np 4 spdyn prod.inp  > prod.out  2>&1

