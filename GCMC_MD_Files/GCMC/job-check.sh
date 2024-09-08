#!/bin/bash

if [[ -f jobstatus.txt ]]; then
rm jobstatus.txt
fi

for p in $(cat pressures.csv)
do
cd $p

for t in $(cat temp.csv)
do
cd $t

for m in $(cat mols.csv)
do
cd $m
cd Output/System_0/
FLAG="Simulation finished,"

if [ -f output* ]; then
STATUS=$(grep 'Simulation finished' output* | head -n 1 | awk -F' ' '{print $1,$2}')
fi

if [[ $STATUS == $FLAG ]];then
echo "$p,$t,$m" >> ../../../../../jobstatus.txt
fi

cd ../../

cd ../
done

cd ../
done

cd ../
done
