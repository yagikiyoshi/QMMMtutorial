#!/bin/bash

if [ -e log ]; then
  rm log
fi

grep " 1 >     2" ../3.prod3/prod4_reus.out | tail -1 >  log
grep " 2 >     3" ../3.prod3/prod4_reus.out | tail -1 >> log
grep " 3 >     4" ../3.prod3/prod4_reus.out | tail -1 >> log
grep " 4 >     5" ../3.prod3/prod4_reus.out | tail -1 >> log
grep " 5 >     6" ../3.prod3/prod4_reus.out | tail -1 >> log
grep " 6 >     7" ../3.prod3/prod4_reus.out | tail -1 >> log
grep " 7 >     8" ../3.prod3/prod4_reus.out | tail -1 >> log
grep " 8 >     9" ../3.prod3/prod4_reus.out | tail -1 >> log
grep " 9 >    10" ../3.prod3/prod4_reus.out | tail -1 >> log
grep "10 >    11" ../3.prod3/prod4_reus.out | tail -1 >> log
grep "11 >    12" ../3.prod3/prod4_reus.out | tail -1 >> log
grep "12 >    13" ../3.prod3/prod4_reus.out | tail -1 >> log
grep "13 >    14" ../3.prod3/prod4_reus.out | tail -1 >> log
grep "14 >    15" ../3.prod3/prod4_reus.out | tail -1 >> log
grep "15 >    16" ../3.prod3/prod4_reus.out | tail -1 >> log
grep "16 >    17" ../3.prod3/prod4_reus.out | tail -1 >> log
grep "17 >    18" ../3.prod3/prod4_reus.out | tail -1 >> log
grep "18 >    19" ../3.prod3/prod4_reus.out | tail -1 >> log
grep "19 >    20" ../3.prod3/prod4_reus.out | tail -1 >> log
grep "20 >    21" ../3.prod3/prod4_reus.out | tail -1 >> log

awk '{print $2,$3,$4,$6/$8}' log > acceptance_ratio.log
rm log
