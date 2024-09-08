#!/bin/bash
#$ -N met_E
#$ -q hpc@@colon
#$ -pe smp 16

#if [[ -f AllResults.csv ]]; then
#rm AllResults.csv
#fi

echo "Mols,Temp,Diff_msd,Diff_plot,Diff_fit" > Met_AllResults.csv

ls | grep 'met' > list.txt
for i in $(cat list.txt)
do
cd $i
cd Simulations

## ------------------------extracting the diffusivity--------------------------##

##------------------------running PyLAT-----------------------------------##
cp ../../met_analyze.sh .
rep=$(head -n 4 mol.metmolecs.lammpstrj | tail -n 1)
tempp=$(grep 'mytemp' simulation.input | head -n 1 | awk -F' ' '{print $4}')

sed -i 's/XXX/'$rep'/' met_analyze.sh
cp -r ../../PyLATStuff/* .
sh met_analyze.sh

grep 'ch4' ch4.json | head -n 1 | awk -F ' ' '{print $2}' | sed 's/.$//' > ch4values.txt

aa=$(head -n 1 ch4values.txt)


echo "$i,$tempp,$aa" >> ../../Met_AllResults.csv

#rm ch4values.txt met_values.txt
cd ../../
done
