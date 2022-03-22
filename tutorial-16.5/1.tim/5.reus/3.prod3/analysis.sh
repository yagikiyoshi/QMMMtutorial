
export PATH=${PATH}:/path/to/genesis/bin

NIMG=21
NAME=prod3
NSTEP=1000  # 100000 / 100

rm ${NAME}_*dis
rm ${NAME}_*.pdb
rm ${NAME}_*.rms
for i in `seq 1 ${NIMG}`; do
  echo ${i}

  # get rOH/rCH
  sed "s/NAME/${NAME}/g" ../analysis.files/trj_analysis_cv.inp  >& aa
  sed "s/NSTEP/${NAME}/g" aa >& bb
  sed "s/NUM/${i}/g"  bb >& trj_analysis${i}.inp
  trj_analysis trj_analysis${i}.inp >& trj_analysis${i}.out
  rm trj_analysis${i}.inp trj_analysis${i}.out aa bb

  # get RMSD
  sed "s/NAME/${NAME}/g" ../analysis.files/rmsd_analysis.inp    >& aa
  sed "s/NSTEP/${NSTEP}/g" aa >& bb
  sed "s/NUM/${i}/g"  bb >& rmsd_analysis${i}.inp
  rmsd_analysis rmsd_analysis${i}.inp >& rmsd_analysis${i}.out
  rm rmsd_analysis${i}.inp rmsd_analysis${i}.out aa bb

  # get pdbfiles
  sed "s/NAME/${NAME}/g" ../analysis.files/rst_convert.inp  >& aa
  sed "s/NUM/${i}/g" aa  >& rst_convert${i}.inp
  rst_convert rst_convert${i}.inp >& rst_convert${i}.out
  rm rst_convert${i}.inp rst_convert${i}.out aa
done

rm ${NAME}_*pathcv
sed "s/NAME/${NAME}/g" ../analysis.files/pathcv.inp  >& pathcv.inp
pathcv_analysis pathcv.inp >& pathcv.out

rm all.pathcv
for i in `seq 1 $NIMG`; do
  cat ${NAME}_${i}.pathcv >> all.pathcv
done
