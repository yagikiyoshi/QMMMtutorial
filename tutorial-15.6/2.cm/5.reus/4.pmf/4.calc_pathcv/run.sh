#!/bin/bash

export PATH=${PATH}:/path/to/genesis/bin

NIMG=$(wc ../../0.window/win_rr.dat |awk '{print $1}')

rm *.pathcv
sed "s/NREP/${NIMG}/g" pathcv.inp   >& aa
pathcv_analysis aa >& pathcv.out
rm aa
for i in `seq 1 $NIMG`; do
  cat prod3_${i}.pathcv >> all.pathcv
done

