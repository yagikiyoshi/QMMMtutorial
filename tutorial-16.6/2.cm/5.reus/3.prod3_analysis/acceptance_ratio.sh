#!/bin/bash

if [ $# -lt 1 ]; then
  echo "USAGE: acceptance_ratio.sh output"
  echo "  output: the GENESIS output file of REUS"
  exit 0
fi

out=$1
NIMG=$(wc ../0.window/win_rr.dat |awk '{print $1}')

if [ -e log ]; then
  rm log
fi
touch log

for i in `seq 1 $(($NIMG-1))`; do
  j=$(($i+1))

  key=""
  if [ $i -lt 10 ]; then
    key=" $i"
  else
    key="$i"
  fi
  if [ $j -lt 10 ]; then
    key=$key" >     $j"
  else
    key=$key" >    $j"
  fi
  #echo "$key"

  grep "$key" $out | tail -1 >> log
done

awk '{print $2,$3,$4,$6/$8}' log
rm log
