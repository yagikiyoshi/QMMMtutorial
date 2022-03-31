#!/bin/bash

gfortran make_window.f90  -o make_window

# change rpath_xx.dat to your final path
./make_window -dat ../../4.mep/2.analysis/rpath_xx.dat -ds 0.1 -ndim 2 > win_rr.log
