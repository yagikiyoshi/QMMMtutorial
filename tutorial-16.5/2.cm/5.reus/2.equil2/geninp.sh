#!/bin/bash

name=equil2
fc0=100.0

nimg=$(wc ../0.window/win_rr.dat |awk '{print $1}')
#echo $nimg

r1=($(cat ../0.window/win_rr.dat |awk '{print $2}'))
r2=($(cat ../0.window/win_rr.dat |awk '{print $3}'))
r3=($(cat ../0.window/win_rr.dat |awk '{print $4}'))
r4=($(cat ../0.window/win_rr.dat |awk '{print $5}'))
r5=($(cat ../0.window/win_rr.dat |awk '{print $6}'))

cr1=${r1[@]}
cr2=${r2[@]}
cr3=${r3[@]}
cr4=${r4[@]}
cr5=${r5[@]}

cfc=" "
for i in `seq 1 $nimg`; do
  cfc=$cfc$fc0"  "
done
#echo $cfc
#echo ${r1[@]}

sed "s/NREP/$nimg/" template.inp > aa
sed "s/R1/${cr1}/" aa  > a1
sed "s/R2/${cr2}/" a1  > a2
sed "s/R3/${cr3}/" a2  > a3
sed "s/R4/${cr4}/" a3  > a4
sed "s/R5/${cr5}/" a4  > a5
mv a5 aa
rm a1 a2 a3 a4
sed "s/FC1/${cfc}/" aa  > a1
sed "s/FC2/${cfc}/" a1  > a2
sed "s/FC3/${cfc}/" a2  > a3
sed "s/FC4/${cfc}/" a3  > a4
sed "s/FC5/${cfc}/" a4  > a5
mv a5 ${name}_reus.inp
rm aa a1 a2 a3 a4
exit 0

