#!/bin/bash

if  [[ -f Loadings.csv ]];
then
rm Loadings.csv
fi

echo "Pressure, Temperature, X_ch4, ch4_uptake, co2_uptake" > Loadings.csv

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

if [ -f output* ]; then
met=$(grep 'Average loading absolute [molecules/unit cell]' output_* | awk -F ' ' '{print $4}' | head -n 1)
car=$(grep 'Average loading absolute [molecules/unit cell]' output_* | awk -F ' ' '{print $4}' | tail -n 1)
fi

echo "$p,$t,$m,$met,$car" >> ../../../../../Loadings.csv

cd ../../

cd ../
done

cd ../
done

cd ../
done
