#!/bin/bash

export PATH=$PATH:../bin
. ../sindo/sindo-4.0/sindovars.sh

java RunMakePES -f makePES.xml >& makePES.out1

export OMP_NUM_THREADS=8
export QM_NUM_THREADS=8
mpirun -np 2 atdyn qmmm_grid.inp  > qmmm_grid.out  2>&1

java RunMakePES -f makePES.xml >& makePES.out2

