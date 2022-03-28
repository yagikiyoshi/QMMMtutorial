#!/bin/bash

export PATH=$PATH:/path/to/genesis/bin

rm pmf2.dat 
pmf_analysis pmf.in > pmf.log
sed -i -e "s/Infinity/500.0/g" pmf2.dat
gnuplot 2dsurf_mix.gpi

