#!/bin/bash

. ../sindo/sindo-4.0/sindovars.sh
java HarmSpectrum qmmm_harm.minfo 5 300 1800 1 > harmonic.spectrum
gnuplot plotIR.gpi

