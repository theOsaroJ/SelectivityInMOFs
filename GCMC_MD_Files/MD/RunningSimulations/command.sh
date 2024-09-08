#!/bin/bash

ls | grep 'met' > tmp.txt

for i in $(cat tmp.txt)
do
cd $i

rm -rf Simulations

if [[ ! -d Simulations ]];
then
mkdir Simulations
cd Simulations

cp ../combine.* .
cp ../in_nvt .
cp ../simulation.input .

cp ../edit.* .

#cp ../../run.sh .
#sed -i 's/DIRR/'$i'/' run.sh

cp ../../lammps.sh .
cp ../../condor-sh .

sed -i 's/XXX/'$i'/' lammps.sh
sed -i 's/XXX/'$i'/' condor-sh

condor_submit condor-sh

cd ../../

fi

done
