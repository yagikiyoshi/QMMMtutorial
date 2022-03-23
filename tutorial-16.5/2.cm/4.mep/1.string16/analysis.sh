
export PATH=${PATH}:/path/to/genesis/bin

NIMG=16
NAME=mep

rm ${NAME}_*dis
rm ${NAME}_*.pdb
for i in `seq 1 ${NIMG}`; do
  echo ${i}

  # get rOH/rCH
  sed "s/NAME/${NAME}/g" ../analysis.files/trj_analysis_all.inp  >& aa
  sed "s/NUM/${i}/g" aa  >& trj_analysis${i}.inp
  trj_analysis trj_analysis${i}.inp >& trj_analysis${i}.out
  rm trj_analysis${i}.inp trj_analysis${i}.out aa

  # get pdbfiles
  sed "s/NAME/${NAME}/g" ../analysis.files/rst_convert.inp  >& aa
  sed "s/NUM/${i}/g" aa  >& rst_convert${i}.inp
  rst_convert rst_convert${i}.inp >& rst_convert${i}.out
  rm rst_convert${i}.inp rst_convert${i}.out aa
done

# get dat files
if [ ! -e ../analysis.files/makedat ]; then
  cd ../analysis.files
  gfortran makedat.f90 -o makedat
  cd ../1.string16
fi
../analysis.files/makedat -output qmmm_mep.out -disout mep_{}.dis -interval 10 -basename rpath_ >& makedat.out

