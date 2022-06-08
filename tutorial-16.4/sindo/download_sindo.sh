#!/bin/bash

wget https://tms.riken.jp/wp-content/uploads/2022/06/sindo-4.0_220603.zip
unzip sindo-4.0_220603.zip

cd sindo-4.0_220603
dir=$(pwd)
mv sindovars.sh sindovars.sh.org
sed "s#path/to/sindo#$dir#g" sindovars.sh.org > sindovars.sh
cd ..

ln -s sindo-4.0_220603 sindo-4.0
