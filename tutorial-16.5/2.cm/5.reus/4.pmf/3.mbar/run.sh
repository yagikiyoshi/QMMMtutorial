#!/bin/bash

export PATH=$PATH:/path/to/genesis/bin

rm weight*
rm fene.dat

export OMP_NUM_THREADS=4
mbar_analysis mbar.inp >& mbar.out
