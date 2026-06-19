#!/bin/bash

self=`readlink -f $0`
pushd `dirname $self`

cp -a ./CheckSum_Generator ./images/
cp -a ./lib* ./images/
cd ./images/
./CheckSum_Generator
cd ../
rm -rf ./images/CheckSum_Generator
rm -rf ./images/lib*

popd

