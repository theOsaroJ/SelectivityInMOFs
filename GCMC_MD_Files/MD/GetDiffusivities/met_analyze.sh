#!/bin/bash


##------------------------running PyLAT-----------------------------------##
sh compile.sh
python3 PyLAT.py -d -g --mol ch4 --nummol XXX -p ./ -f ch4.json -v 2 mol.log restart.data  mol.metmolecs.lammpstrj
