#!/bin/bash
#SBATCH --job-name=VS_2010
#SBATCH -p sheffield
#SBATCH --nodes=2
#SBATCH --ntasks=64
#SBATCH --mem-per-cpu=4G
#SBATCH --mail-user=ethan.lee@sheffield.ac.uk
#SBATCH --mail-type=ALL
#SBATCH --time=48:00:00
module restore pism_intel
export PATH=/users/gg1ele/pism/bin:$PATH

# Copyright (C) 2009-2016, 2025  PISM authors
#################################################################################
# This is the physics file for Ethan Lee's PISM glacial model. This is for the  #
# Delete and Retreat NERC funded project under the direction of the PI Dr       #
# Jeremy Ely. The modelling aspect was conducted by Dr Ethan Lee at the         #
# Universiy of Sheffield, also under the direction of Dr Jeremy Ely. This is    #
# file is taken and edited from the antspin-coarse file from the PISM Authors   #
# 'antartic-spin' example.                                                      #
#################################################################################

echo "Running on $(hostname)"
echo "Node list: $SLURM_JOB_NODELIST"

SCRIPTNAME="#(spin_vilca_debm_test.sh)"

echo "$SCRIPTNAME"

set -e  # exit on error

echo "$SCRIPTNAME   Constant-climate spinup script to test parameters"
echo "$SCRIPTNAME   uses the hybrid stress balance (-stress_balance ssa+sia)"

# naming files, directories, executables
RESDIR="/mnt/parscratch/users/gg1ele/debm_vilca_tests/"
BOOTDIR="/users/gg1ele/pism_input_files/Vilca_SMB_tests/"
PHYSFILES="/users/gg1ele/physics_files/"
PISM_EXEC=${PISM_EXEC:=pismr}
PISM_MPIDO="mpirun"

echo "Checking /mnt/parscratch visibility:"
ls $RESDIR || echo "Directory NOT visible from compute node!"

# input data:
export PISM_INDATANAME=${BOOTDIR}vilca_PISM_dd_new.nc

# import the parameterisation file
source ${PHYSFILES}set-physics_inital_tests.sh

# I think these lines can go, since mpiexec will pick up the number specified in #SBATCH -ntasks <number>
#NN=16  # default number of processors
#if [ $# -gt 0 ] ; then  # if user says "antspinCC.sh 8" then NN = 8
#  NN="$1"
#fi
echo "$SCRIPTNAME              MPI tasks = $SLURM_NTASKS"
set -e  # exit on error

# check if env var PISM_DO was set (i.e. PISM_DO=echo for a 'dry' run)
if [ -n "${PISM_DO:+1}" ] ; then  # check if env var is already set
  echo "$SCRIPTNAME         PISM_DO = $PISM_DO  (already set)"
else
  PISM_DO=""
fi
DO=$PISM_DO

# These allow you to change the resolution and skips
# These are imported from the parameterisation file imported ealier

GRID=$R2_100m
SKIP=$SKIP100m
GRIDNAME=100m

# These place at the top of the output what was used to run PISM (i.e., the physics used etc)
echo "$SCRIPTNAME             PISM = $PISM_EXEC"
echo "$SCRIPTNAME             PHYS = $PHYS"
echo "$SCRIPTNAME         COUPLING = $COUPLING"
echo "$SCRIPTNAME PIKPHYS_COUPLING = $PIKPHYS_COUPLING"

# ################################################### #
# run into steady state with constant climate forcing #
# ################################################### #

stage=Vilca_inital_param_minmax_DEFAULT
INNAME=$PISM_INDATANAME
RESNAME=${RESDIR}${stage}_${GRIDNAME}.nc
TSNAME=${RESDIR}ts_${stage}_${GRIDNAME}.nc
RUNTIME=1500
EXTRANAME=${RESDIR}extra_${stage}_${GRIDNAME}.nc
exvars="thk,usurf,velbase_mag,velsurf_mag,mask,bmelt,topg,effective_precipitation,ice_mass,velbar,tempicethk"
expackage="-extra_times 0:100:$RUNTIME -extra_vars $exvars"

# If need to test the climate model without computing ice flow then add:
# -test_climate_models -no_mass before the -i flag.
# Using modern time for test runs, us palaeotime for actual runs
echo
echo "$SCRIPTNAME  run into steady state with constant climate forcing for $RUNTIME a"
cmd="$PISM_MPIDO $PISM_EXEC -skip -skip_max $SKIP -i $PISM_INDATANAME -bootstrap $GRID \
    $SIA_ENHANCEMENT $COUPLING $PHYS $STRONGKSP \
    $FLOW $SLIDE $TILL \
    -ys 0 -ye $RUNTIME \
    -ts_file $TSNAME -ts_times 0:1:$RUNTIME \
    -extra_file $EXTRANAME $expackage \
    -o $RESNAME -o_size big"
$DO $cmd

echo
echo "$SCRIPTNAME $GRIDNAME simulation complete"
