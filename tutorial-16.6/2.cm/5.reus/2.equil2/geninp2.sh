#!/bin/bash

if [ $# -lt 2 ]; then
  echo "USAGE: geninp.sh newname oldname"
  echo "  newname: the name of new file (NEWNAME in template.inp)"
  echo "  newname: the name of old rstfile (OLDNAME in template.inp)"
  exit 0
fi

newname=$1
oldname=$2
fc0=100.0

nimg=$(wc ../0.window/win_rr.dat |awk '{print $1}')
#echo $nimg

r1=($(cat ../0.window/win_rr.dat |awk '{print $2}'))
r2=($(cat ../0.window/win_rr.dat |awk '{print $3}'))

cr1=${r1[@]}
cr2=${r2[@]}

cfc=" "
for i in `seq 1 $nimg`; do
  cfc=$cfc$fc0"  "
done
#echo $cfc
#echo ${r1[@]}

sed "s/NREP/$nimg/" template.inp > aa
sed "s/R1/${cr1}/" aa  > a1
sed "s/R2/${cr2}/" a1  > a2
mv a2 aa
rm a1 
sed "s/FC1/${cfc}/" aa  > a1
sed "s/FC2/${cfc}/" a1  > a2
sed "s#OLDNAME#$oldname#" a2 > a3
sed "s#NEWNAME#$newname#" a3 > a4
mv a4 ${newname}_reus.inp
rm aa a1 a2 a3
exit 0

