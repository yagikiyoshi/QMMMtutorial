
#export PATH=${PATH}:/path/to/genesis/bin
export PATH=${PATH}:/home/yagi/devel/genesis/genesis.gat_beluga/bin

NIMG=21

for i in `seq 1 ${NIMG}`; do
  echo ${i}

  # get rOH/rCH
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

pathcv_analysis pathcv.inp >& pathcv.out

for i in `seq 1 $NIMG`; do
  cat equil3_${i}.pathcv >> all.pathcv
done

