#!/bin/bash
#$ -q CLUSTER
#$ -pe smp 16
#$ -N making

# Read the values from another file into an array
readarray -t co2_values < co2_mols.csv
readarray -t temp_values < temp.csv

i=1  # Initialize index variable

for m in $(cat methane_mols.csv); do
folder="met_${m}_${i}"  # Create a unique folder name
mkdir "$folder"
cd "$folder"

cp ../Essentials/* .

cc="${co2_values[0]}"  # Get the first value from the array
sav="${co2_values[0]}"  # Get the first value from the array

tt="${temp_values[0]}"  # Get the first values from the temp array

sed -i 's/methane_mols/'"$m"'/' mixture.inp
sed -i 's/co2_mols/'"$cc"'/' mixture.inp

# Remove the first value from the array
co2_values=("${co2_values[@]:1}")

# Remove the first value from the array
temp_values=("${temp_values[@]:1}")

## ---------------------------- packmol to generate multiple methane ---------------------------------##
./packmol.sh < mixture.inp

## ---------------------------- creating the data file using VMD ------------------------------------##

module load vmd
vmd -dispdev text -eofexit < input.tcl > output.log
cp molecules.data copymolecules.data

## --------------------------- editing the file appropraitely ---------------------------------------##
sed -n '/Atoms # full/,/Bonds/p' molecules.data > first.txt

#-------------------------Remove the first two lines-----------------------------#
sed -i '1 d' first.txt
sed -i '1 d' first.txt

#-----------------------Remove the last two lines--------------------------------#
sed -i '$d' first.txt
sed -i '$d' first.txt

#----------------------Sorting the methane coordinates--------------------------#
head -n $m first.txt > second.txt

#-----------Editing the atom second column numbers---------#
echo 'Atoms # full' > third.txt
echo ' ' >> third.txt
awk -F ' ' '{print $1, $1, $3, $4, $5 , $6 , $7}' second.txt >> third.txt
cp third.txt fin_methane.txt

mul=$(expr $cc \* 3)
jul=$(expr $cc + $m)
tail -n $mul first.txt > fourth.txt

#---------------------fixing the molecule tag------------------------#
#mul=$(expr $cc \* 3)
sed -i 's/XXX/'$m'/' num.py
sed -i 's/YYY/'$jul'/' num.py
python3 num.py > fifth.txt

#---------------------adding the charges of co2------------------------#
awk -F' ' '{print $3}' fourth.txt > six.txt
sed -i 's/2/-0.35/g' six.txt
sed -i 's/1/0.7/g' six.txt

paste fourth.txt fifth.txt six.txt -d' ' > edit.txt
awk -F ' ' '{print $1, $10, $3, $11, $5 , $6 , $7}' edit.txt >> tedit.txt

cat tedit.txt >> fin_methane.txt
echo ' ' >> fin_methane.txt

#-----------------Getting the bonds and angles-----------#
sed -n '/Bonds/,$p' molecules.data > bondangle.txt

#-------------Cat'ing (lol) the first 14 lines-------------#
head -n 14 molecules.data > check.data
echo ' ' >> check.data
cat coefficients.txt >> check.data
cat fin_methane.txt >> check.data
cat bondangle.txt >> check.data
mv check.data molecules.data

rm tedit.txt edit.txt first.txt second.txt third.txt bondangle.txt fourth.txt fifth.txt six.txt fin_methane.txt

##----------------------------------------moltemplate stuff------------------------------------------##
ltemplify.py -name mof CuBTC.data > CuBTC.lt
ltemplify.py -name mol molecules.data > molecules.lt
moltemplate.sh -overlay-angles combine.lt

##--------------------------------------------simulation datafile-------------------------------------##
sed -i 's/SSS/'"$tt"'/' simulation.input
sed -i 's/SSS/'"$tt"'/' in_nvt

##----------------------------for the purpose of adjusting co2 lammpstrj file--------------------------##
sed -i 's/XXX/'"$cc"'/' edit.sh
sed -i 's/chg/'"$m"'/' edit.py

##---------------------------------------next mol---------------------------------------------------##
cd ..

# Increment the index variable
i=$((i+1))
done
