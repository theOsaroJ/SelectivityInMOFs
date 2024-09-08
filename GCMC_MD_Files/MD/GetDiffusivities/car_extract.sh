#!/bin/bash
#$ -N car_E
#$ -q hpc@@colon
#$ -pe smp 16

echo "Mols,Temp,Diff_msd,Diff_plot,Diff_fit" > Car_AllResults.csv

for i in $(cat list.txt)
do
cd $i
cd Simulations

## ------------------------extracting the diffusivity--------------------------##

##------------------------running PyLAT-----------------------------------##
cp ../../car_analyze.sh .
num=$(head -n 4 co2.lammpstrj | tail -n 1)
rep=$(expr $num / 3)
tempp=$(grep 'mytemp' simulation.input | head -n 1 | awk -F' ' '{print $4}')

sed -i 's/XXX/'$rep'/' car_analyze.sh
cp -r ../../PyLATStuff/* .
sh car_analyze.sh

grep 'co2' co2.json | head -n 1 | awk -F ' ' '{print $2}' | sed 's/.$//' > co2values.txt

aa=$(head -n 1 co2values.txt)
echo "$i,$tempp,$aa" >> ../../Car_AllResults.csv

cd ../../
done
