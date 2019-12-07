#!/bin/sh
cd src
echo "\e[32mMaking executables...\e[39m"
make
cd ..
echo Original Program
echo --------------------
cat ./$1
echo --------------------
echo "\e[32mRunning test '$1'...\e[39m"
./bin/cariocaScript $1
echo "\e[32mEnd of Build\e[39m"
