#!/bin/bash

export PATH=$PATH:../../bin

trj_analysis qmd_angle.inp > qmd_angle.out

awk -f 1dhist.awk output_qmd.ang > hist_qmd.ang

gnuplot plotHist.gpi
