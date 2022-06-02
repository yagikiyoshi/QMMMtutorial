#!/bin/bash

export PATH=$PATH:../../bin
qmmm_generator qmmm_generator.inp > qmmm_generator.out 2>&1

export OMP_NUM_THREADS=16
export QM_NUM_THREADS=16
mpirun -np 1 atdyn qmmm_min.inp   > qmmm_min.out   2>&1
mpirun -np 1 atdyn qmmm_equil.inp > qmmm_equil.out 2>&1
mpirun -np 1 atdyn qmmm_prod.inp  > qmmm_prod.out  2>&1

