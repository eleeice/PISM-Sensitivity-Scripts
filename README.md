# PISM Sensitivity Scripts (Lee et al., 2026)
Within this github repository there are scripts that were used to run the PSIM sensivitiy modelling for Lee et al. (2026).
These themselves were taken from the PISM Authors example from 'antartica' or 'antartic-spin'.
These scripts were modified by Dr Ethan Lee for their use within our model simulations.

The set-physics file is used to parameterise the model. These can be formated into variables which hold the parameters so they can be group together. They are called by the script below.

The spin file is the script that runs the PISM model. This requires the set-physics script to be present as it calls and takes the paramters from this file by calling the varible names. This script is set up to run in the University of Sheffield's Stanage HPC compunting envrionment. Set up may differ for different HPC envrionments.
