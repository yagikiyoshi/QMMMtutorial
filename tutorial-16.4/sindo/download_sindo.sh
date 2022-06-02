#!/bin/bash

wget https://tms.riken.jp/wp-content/uploads/2022/03/sindo-4.0_220319.zip
unzip sindo-4.0_220319.zip
cd sindo-4.0_220319

dir=$(pwd)
mv sindovars.sh sindovars.sh.org
sed "s#path/to/sindo#$dir#g" sindovars.sh.org > sindovars.sh
