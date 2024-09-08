#!/bin/bash
#$ -q hpc@@colon
#$ -pe smp 2
#$ -N DIRR

# amount of co2 in system
ccc=$(expr XXX \* 3)
cccc=$(expr $ccc + 9)

if [[ -f saved.csv ]]; then
rm saved.csv
fi

cp mol.co2molecs.lammpstrj test.lammpstrj

for ((i=1; i<=2000; i++)); do
head -n $cccc test.lammpstrj > first.csv
head -n 9 first.csv >> co2.lammpstrj

sed -i '1,9d' first.csv

cut -d' ' -f 1-5 first.csv > third.csv

awk -F' ' '{print $6}' first.csv > fourth.csv

python3 edit.py

paste third.csv fifth.csv -d' ' > sixth.csv
cat sixth.csv >> co2.lammpstrj

sed -i '1,'$cccc'd' test.lammpstrj
done
