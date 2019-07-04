#!/bin/sh
cd src
echo -e "\e[32mMaking executable...\e[39m"
make
cd ..
echo -e "\e[32mRunning test...\e[39m"
if [ $# == 0 ]
then
  ./bin/provolone ./tests/simple.p1
else
  ./bin/provolone $1
fi
echo -e "\e[32mEnd of Build\e[39m"
