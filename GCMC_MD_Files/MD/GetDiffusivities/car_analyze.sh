#!/bin/bash


##------------------------running PyLAT-----------------------------------##
sh compile.sh
python3 PyLAT.py -d -g --mol co2 --nummol XXX -p ./ -f co2.json -v 2 mol.log restart.data  co2.lammpstrj
