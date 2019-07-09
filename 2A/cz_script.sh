#!/bin/bash

#SBATCH --nodes=1
#SBATCH --ntasks=12
#SBATCH --time=06-23
#SBATCH --partition=shas
#SBATCH --qos=long
#SBATCH --output=sample-%j.out
#SBATCH --mail-type=ALL
#SBATCH --mail-user=mast4878


module purge

module load gcc
module load python
module load R/3.5.0
python main.py

module unload python

module load python/3.5.1
export LD_LIBRARY_PATH=:/curc/sw/R/3.5.0/lib64/R/lib

python main_supplement.py
        
    
