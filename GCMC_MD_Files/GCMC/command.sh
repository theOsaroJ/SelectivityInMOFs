#!/bin/bash

for p in $(cat pressures.csv)
do
mkdir $p
cd $p
cp ../Essentials/temp.csv .

for t in $(cat temp.csv)
do
mkdir $t
cd $t
cp ../../Essentials/mols.csv .

for m in $(cat mols.csv)
do
mkdir $m
cd $m

cp ../../../Essentials/simulation.input .
cp ../../../Essentials/condor-sh .
cp ../../../Essentials/raspa.sh .

sed -i 's/PPP/'$p'/' simulation.input
sed -i 's/TTT/'$t'/' simulation.input
sed -i 's/MMM/'$m'/' simulation.input

sed -i 's/PPP/'$p'/' raspa.sh
sed -i 's/TTT/'$t'/' raspa.sh
sed -i 's/MMM/'$m'/' raspa.sh

sed -i 's/PPP/'$p'/' condor-sh
sed -i 's/TTT/'$t'/' condor-sh
sed -i 's/MMM/'$m'/' condor-sh

total=1
rep=$(echo "$total - $m" | bc)

sed -i 's/CCC/'$rep'/' simulation.input

condor_submit condor-sh

cd ../
done

cd ../
done

cd ../
done
