#!/bin/bash
#$ -N met_E
#$ -q hpc@@colon
#$ -pe smp 16

#if [[ -f AllResults.csv ]]; then
#rm AllResults.csv
#fi

echo "Mols,Temp,Diff_msd,Diff_plot,Diff_fit" > Met_AllResults.csv

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
cp ../../met_plot.py .

sed -i 's/AAA/'$rep'/' met_plot.py
sed -i 's/BBB/'$tempp'/' met_plot.py

##-----------------running the python file-----------------------------##
python3 met_plot.py > met_values.txt

cat met_values.txt >> ch4values.txt

aa=$(head -n 1 ch4values.txt)
bb=$(head -n 2 ch4values.txt | tail -n 1)
cc=$(tail -n 1 ch4values.txt)

echo "$i,$tempp,$aa,$bb,$cc" >> ../../Met_AllResults.csv

#rm ch4values.txt met_values.txt
cd ../../
done
