
#export PATH=${PATH}:~/devel/genesis/genesis.gat_qmmm_beluga/bin

module load intel/19.5.281
module load gcc/7.2.0

. /bwfefs/opt/x86_64/intel/parallel_studio_xe_2019.5.075/compilers_and_libraries_2019/linux/mkl/bin/mklvars.sh intel64
export LD_LIBRARY_PATH=/home/kyagi/local/lib:$LD_LIBRARY_PATH

export PATH=${PATH}:~/devel/genesis/genesis.gat_qmmm_qs/bin


NIMG=16
NAME=mep
NSTEP=200

rm mep_*dis
rm mep_*.pdb
for i in `seq 1 ${NIMG}`; do
  echo ${i}

  # get rOH/rCH
  sed "s/NAME/${NAME}/g" ../analysis.files/trj_analysis_all.inp  >& aa
  sed "s/NSTEP/${NSTEP}/g" aa >& bb
  sed "s/NUM/${i}/g"  bb >& trj_analysis${i}.inp
  trj_analysis trj_analysis${i}.inp >& trj_analysis${i}.out
  rm trj_analysis${i}.inp trj_analysis${i}.out

  # get pdbfiles
  sed "s/NAME/${NAME}/g" ../analysis.files/rst_convert.inp  >& aa
  sed "s/NUM/${i}/g" aa  >& rst_convert${i}.inp
  rst_convert rst_convert${i}.inp >& rst_convert${i}.out
  rm rst_convert${i}.inp rst_convert${i}.out aa bb
done

# get dat files
../analysis.files/makedat -output qmmm_mep.out -disout mep_{}.dis -interval 10 -basename rpath_ >& makedat.out

