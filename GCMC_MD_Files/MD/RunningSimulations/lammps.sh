#!/bin/bash
if [ -r /opt/crc/Modules/current/init/bash ]; then
        source /opt/crc/Modules/current/init/bash
fi
# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

cd /scratch365/eosaro/Research/Diffusivities/Mixtures/PXT/CuBTC/Diffusivities/DataFiles/XXX/Simulations

##------------------------------loading lammps---------------------------##
module load lammps

##-------------------------running the first nvt job---------------------------##
mpirun -np 8 lmp_mpi -in simulation.input


##--------------------------running the last nvt job----------------------------##
mpirun -np 8 lmp_mpi -in in_nvt
