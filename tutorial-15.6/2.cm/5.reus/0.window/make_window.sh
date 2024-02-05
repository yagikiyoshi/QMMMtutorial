#!/bin/bash

gfortran make_window.f90  -o make_window

./make_window -dat ../../4.mep/2.analysis/rpath_200.dat -ds 0.1 -ndim 2 > win_rr.log
