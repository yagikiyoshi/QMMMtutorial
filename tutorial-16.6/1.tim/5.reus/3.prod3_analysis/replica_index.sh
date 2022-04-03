#!/bin/bash

grep "ParmIDtoRepID:" ../3.prod3/prod3_reus.out >  replica_index.log
grep "ParmIDtoRepID:" ../3.prod3/prod4_reus.out >> replica_index.log
