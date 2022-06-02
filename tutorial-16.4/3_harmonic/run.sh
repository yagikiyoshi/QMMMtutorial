#!/bin/bash

export PATH=$PATH:../bin

export OMP_NUM_THREADS=8
export QM_NUM_THREADS=8
mpirun -np 2 atdyn qmmm_harm.inp  > qmmm_harm.log  2>&1

. ../sindo/sindo-4.0_220319/sindovars.sh
java HarmSpectrum qmmm_harm.minfo 5 300 1800 1 > harmonic.spectrum
gnuplot plotIR.gpi
