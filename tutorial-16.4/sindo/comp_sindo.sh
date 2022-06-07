#!/bin/bash

cd FSindo
./configure

cd src
make

cd ../../..

ln -s sindo-4.0_220603 sindo-4.0
