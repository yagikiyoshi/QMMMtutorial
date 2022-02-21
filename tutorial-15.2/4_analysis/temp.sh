grep INFO ../3_qmmm/qmmm_nvt.out | tail -n +2 > temp.log
gnuplot temp.gpi
