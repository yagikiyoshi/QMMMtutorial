#!/bin/bash

export PATH=${PATH}:/path/to/genesis/bin

NIMG=$(wc ../0.window/win_rr.dat |awk '{print $1}')

rm *.rms
for i in `seq 1 ${NIMG}`; do
  echo ${i}

  # get RMSD
  sed "s/NUM/${i}/g"  rmsd_analysis.inp >& rmsd_analysis${i}.inp
  rmsd_analysis rmsd_analysis${i}.inp >& rmsd_analysis${i}.out
  rm rmsd_analysis${i}.inp rmsd_analysis${i}.out

done

