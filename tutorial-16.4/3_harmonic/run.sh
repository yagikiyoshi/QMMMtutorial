#!/bin/bash

export PATH=/path/to/genesis/bin:$PATH

export OMP_NUM_THREADS=8
export QM_NUM_THREADS=8

# 1) Open MPI
#
mpirun -np 2 --map-by node:pe=${QM_NUM_THREADS} atdyn qmmm_min.inp > qmmm_min.out 2>&1

# 2) Intel MPI
#
#mpirun -np 2 -ppn 2 atdyn qmmm_harm.inp  > qmmm_harm.log  2>&1

. ../sindo/sindo-4.0/sindovars.sh
java HarmSpectrum qmmm_harm.minfo 5 300 1800 1 > harmonic.spectrum
gnuplot plotIR.gpi
