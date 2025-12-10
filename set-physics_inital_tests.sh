# Copyright (C) 2009-2016, 2025  PISM authors

#################################################################################
# This is the physics file for Ethan Lee's PISM glacial model. This is for the  #
# Delete and Retreat NERC funded project under the direction of the PI Dr       #
# Jeremy Ely. The modelling aspect was conducted by Dr Ethan Lee at the         #
# Universiy of Sheffield, also under the direction of Dr Jeremy Ely. This is    #
# file is taken and edited from the set-physics.sh file from the PISM Authors   #
# 'antartic-spin' example.                                                      #
#################################################################################

# grids - dictates resolution
## Region 1 - Cordillera Blanca
export R1_100m="-Mx 1600 -My 2800 -Lz 2000 -Lbz 1000 -Mz 51 -Mbz 10 -z_spacing quadratic -bed_smoother_range 50"

## Region 2 - 
export R2_100m="-Mx 3400 -My 1600 -Lz 1000 -Lbz 1000 -Mz 51 -Mbz 10 -z_spacing quadratic -bed_smoother_range 50"

##Region 3 -
export R3_100m="-Mx 1600 -My 1600 -Lz 1000 -Lbz 1000 -Mz 51 -Mbz 10 -z_spacing quadratic -bed_smoother_range 50"

##Region 4 -
export R4_100m="-Mx 600 -My 800 -Lz 1000 -Lbz 1000 -Mz 51 -Mbz 10 -z_spacing quadratic -bed_smoother_range 50"

##Region 5 -
export R5_100m="-Mx 1200 -My 3600 -Lz 1000 -Lbz 1000 -Mz 51 -Mbz 10 -z_spacing quadratic -bed_smoother_range 50"

# skips
export SKIP100m=50

#################################################################################

### PIK-stuff; notes:

# read climate from delta T and delta precip files 
export COUPLING="-atmosphere given,delta_T,frac_P -atmosphere_given_file $PISM_INDATANAME -surface pdd -atmosphere_delta_T_file DeltaT_0.nc -atmosphere_frac_P_file FracP_1.nc -temp_lapse_rate 6.5"

# dynamics related options
export SIA_ENHANCEMENT=""

export PARAMS="-regularized_coulomb -yield_stress mohr_coulomb"

export PHYS="-stress_balance ssa+sia $PARAMS"

export SIADIFFUS="-limit_sia_diffusivity yes"


# use these if KSP "diverged" errors occur
export STRONGKSP="-ssafd_ksp_type gmres -ssafd_ksp_norm_type unpreconditioned -ssafd_ksp_pc_side right -ssafd_pc_type asm -ssafd_sub_pc_type lu"

# below are the sections used for sensitivity testing modern day min/max runs
#################################################################################
### DEFAULT
export FLOW="-sia_e 1 -ssa_e 1 -sia_n 3 -ssa_n 3"
### min
export FLOWMIN="-sia_e 0.2 -ssa_e 0.2 -sia_n 3 -ssa_n 3"
### max
export FLOWMAX="-sia_e 20 -ssa_e 20.0 -sia_n 3 -ssa_n 3"

### DEFAULT
export SLIDE="-pseudo_plastic_q 0.25 -pseudo_plastic_uthreshold 100.0"
### min
export SLIDEMIN="-pseudo_plastic_q 0.05 -pseudo_plastic_uthreshold 20.0"
### max
export SLIDEMAX="-pseudo_plastic_q 0.95 -pseudo_plastic_uthreshold 200.0"

### DEFAULT
export TILL="-plastic_phi 30.0 -hydrology_tillwat_max 2.0 -hydrology_tillwat_decay_rate 1.0"
### min
export TILLMIN="-plastic_phi 5.0 -hydrology_tillwat_max 0.1 -hydrology_tillwat_decay_rate 0.1"
### max
export TILLMAX="-plastic_phi 45.0 -hydrology_tillwat_max 10.0  -hydrology_tillwat_decay_rate 12.0"
#################################################################################