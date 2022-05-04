#!/bin/bash

name=equil1
nimg=$(wc ../0.window/win_rr.dat |awk '{print $1}')

r1=($(cat ../0.window/win_rr.dat |awk '{print $2}'))
r2=($(cat ../0.window/win_rr.dat |awk '{print $3}'))

#echo ${#r1[@]}
#for e in ${r1[@]}; do
#    echo "${e}"
#    let i++
#done

rst0=$(grep rstfile template.inp |head -1 |awk '{print $3}')

for id in `seq 1 $nimg`; do
  sed "s/ID/$id/" template.inp > aa

  if [ $id -gt 1 ]; then
    sed "s#$rst0#$oldrst#" aa  > bb
    mv bb aa
  fi
  oldrst=$(grep rstfile aa |tail -1 |awk '{print $3}')

  idx=$(( $id-1 ))
  sed "s/R1/${r1[$idx]}/" aa  > a1
  sed "s/R2/${r2[$idx]}/" a1  > a2
  mv a2 ${name}_${id}.inp
  rm aa a1
done

