#!/bin/bash

export PATH=$PATH:../../bin

export OMP_NUM_THREADS=16
export QM_NUM_THREADS=16
mpirun -np 1 atdyn qmmm_min.inp  > qmmm_min.out  2>&1

