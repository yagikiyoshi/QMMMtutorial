#!/bin/bash

export PATH=${PATH}:/path/to/genesis/bin

NIMG=$(wc ../../0.window/win_rr.dat |awk '{print $1}')

rm *.dis
for i in `seq 1 ${NIMG}`; do
  echo ${i}

  # get rOH/rCH
  sed "s/NUM/${i}/g"  trj_analysis.inp >& trj_analysis${i}.inp
  trj_analysis trj_analysis${i}.inp >& trj_analysis${i}.out
  rm trj_analysis${i}.inp trj_analysis${i}.out

done

