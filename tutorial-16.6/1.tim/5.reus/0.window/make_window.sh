#!/bin/bash

gfortran make_window.f90  -o make_window

./make_window -dat ../../4.mep/2.analysis/rpath_93.dat -ds 0.1 -ndim 5 -idx 1,2,3,4,6 > win_rr.log
