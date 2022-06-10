#!/bin/bash

export PATH=/path/to/genesis/bin:$PATH

export OMP_NUM_THREADS=16
export QM_NUM_THREADS=16

# 1) Open MPI
#
mpirun -np 1 --map-by node:pe=${QM_NUM_THREADS} atdyn qmmm_min.inp > qmmm_min.out 2>&1

# 2) Intel MPI
#
#mpirun -np 1 atdyn qmmm_min.inp  > qmmm_min.out  2>&1

