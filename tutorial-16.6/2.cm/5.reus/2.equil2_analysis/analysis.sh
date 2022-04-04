#!/bin/bash

export PATH=${PATH}:/path/to/genesis/bin

NIMG=$(wc ../0.window/win_rr.dat |awk '{print $1}')

rm *.dis
rm *.rms
rm *.pdb
for i in `seq 1 ${NIMG}`; do
  echo ${i}

  # get rC1C8/rC5O2
  sed "s/NUM/${i}/g"  trj_analysis.inp >& trj_analysis${i}.inp
  trj_analysis trj_analysis${i}.inp >& trj_analysis${i}.out
  rm trj_analysis${i}.inp trj_analysis${i}.out

  # get RMSD
  sed "s/NUM/${i}/g"  rmsd_analysis.inp >& rmsd_analysis${i}.inp
  rmsd_analysis rmsd_analysis${i}.inp >& rmsd_analysis${i}.out
  rm rmsd_analysis${i}.inp rmsd_analysis${i}.out

  # get pdbfiles
  sed "s/NUM/${i}/g" rst_convert.inp  >& rst_convert${i}.inp
  rst_convert rst_convert${i}.inp >& rst_convert${i}.out
  rm rst_convert${i}.inp rst_convert${i}.out
done

rm *.pathcv
sed "s/NREP/${NIMG}/g" pathcv.inp   >& aa
pathcv_analysis aa >& pathcv.out
rm aa

for i in `seq 1 $NIMG`; do
  cat equil2_${i}.pathcv >> all.pathcv
done

