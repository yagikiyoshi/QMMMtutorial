#!/bin/bash

export PATH=$PATH:/path/to/genesis/bin

for i in `seq 1 21`; do
  awk '{print $1, $3}' ../../5.prod3/prod3_${i}.pathcv >${i}.pathdist
done

rm *.dat
pmf_analysis pmf_bw15.in > pmf_bw15.log
pmf_analysis pmf_bw20.in > pmf_bw20.log
pmf_analysis pmf_bw25.in > pmf_bw25.log

gnuplot pmf.gpi
