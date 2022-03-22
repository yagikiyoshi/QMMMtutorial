#!/bin/bash

gfortran make_window.f90  -o make_window

# change rpath_xx.dat to your final path
./make_window ../../4.mep/1.string16/rpath_xx.dat > win_rr.log
