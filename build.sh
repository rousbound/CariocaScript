#!/bin/sh
cd src
echo -e "\e[32mMaking executable...\e[39m"
make
cd ..
if [ $# == 0 ]
then
  cd tests
  for file in *;
  do
    echo -e "\e[32mRunning test '$file'...\e[39m"
    ./../bin/provolone $file
  done
else
  echo -e "\e[32mRunning test '$1'...\e[39m"
  ./bin/provolone $1
fi
echo -e "\e[32mEnd of Build\e[39m"
