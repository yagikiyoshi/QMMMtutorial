#!/bin/bash

export PATH=$PATH:/path/to/genesis/bin

rm pmf2.dat 
pmf_analysis pmf.inp > pmf.out
sed "s/Infinity/500.0/g" pmf2.dat > aa
mv aa pmf2.dat

