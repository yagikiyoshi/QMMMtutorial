#!/bin/bash

export PATH=$PATH:/path/to/genesis/bin

NIMG=$(wc ../../0.window/win_rr.dat |awk '{print $1}')

for i in `seq 1 $NIMG`; do
  awk '{print $1, $3}' ../4.calc_pathcv/prod3_${i}.pathcv > ${i}.pathdist
done

rm *.dat
pmf_analysis pmf_bw15.inp > pmf_bw15.out
pmf_analysis pmf_bw20.inp > pmf_bw20.out

rm *.pathdist

