    #!/bin/bash

    # comments out a line in a file.
    comment () {
        sed -i "/^$1/s/^/#/" $2

    }
    # checking if the correct directory structure exists.
    DIRECTORY=$1
    META=$1/Meta
    RESULTS=$1/results
    RUN_MODEL=$1/runModel
    SENSANALY=$1/SensAnal
    SOURCE_FR=$1/sourceFolder
    NUM=$#
    if [ "$NUM" -ne 1 ]; then
        echo 'Incorrect number of arguments provided.'
        exit 0
    fi

    if [ ! -d "$DIRECTORY" ]; then
    # Control will enter here if $DIRECTORY exists.
        echo 'Directory does not exist!'
        exit 0

    fi

    if [ ! -d "$META" ]; then
    # Control will enter here if $DIRECTORY exists.
        echo 'Meta Model folder does not exist!'
        exit 0

    fi

    if [ ! -d "$RESULTS" ]; then
    # Control will enter here if $DIRECTORY exists.
        echo 'Results folder does not exist!'
        exit 0

    fi


    if [ ! -d "$RUN_MODEL" ]; then
    # Control will enter here if $DIRECTORY exists.
        echo 'Run Model folder does not exist!'
        exit 0

    fi

    if [ ! -d "$SENSANALY" ]; then
    # Control will enter here if $DIRECTORY exists.
        echo 'Sensitivity Analysis folder does not exist!'
        exit 0

    fi

    if [ ! -d "$SOURCE_FR" ]; then
    # Control will enter here if $DIRECTORY exists.
        echo 'Source folder does not exist!'
        exit 0

    fi
    # fix the path
    sed -i "/'\/usr\/bin\/openstudio'/s//openstudio/" $1/runModel/parallelSimuMeta.py    
    # directories are made later, no worry for that
    # switch to R/3.5.0
    sed -i "/3.3/s//3.5/" $1/SensAnal/analyzeNonpara.py
    # create directories
    mkdir $1/results/samples
    mkdir $1/results/sensitive

    sed -i "/,grid_jump=[0-9]*/s///" $1/SensAnal/analyzeMORRIS.py
    # create the main_supplement.py file
    touch $1/main_supplement.py

    echo "import os
import csv
import numpy as np

pathway = os.getcwd()
os.chdir(os.path.join(pathway,'SensAnal'))
import analyzeNonpara as an
os.chdir(pathway)

an.sensiAnal('energy_data_np_1')
        
    " >> $1/main_supplement.py

    # create the script to submit to the supercomputer
    # 1 climate zone = 1 node = 12 cores, up to 6 days, 23 hours (unlikely to be that long)
    touch $1/cz_script.sh


    echo "#!/bin/bash

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
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/curc/sw/R/3.5.0/lib64/R/lib

python main_supplement.py
        
    " >> $1/cz_script.sh


    comment "import analyzeNonpara as an" $1/main.py


    comment "an.sensiAnal('energy_data_np_1')" $1/main.py
    # rename the directories and create all of the copies for the climate zones
    mv $1 1A
    mkdir 2A
    mkdir 2B
    mkdir 3A
    mkdir 3B
    mkdir 3C
    mkdir 4A
    mkdir 4B
    mkdir 4C
    mkdir 5A
    mkdir 5B
    mkdir 6A
    mkdir 6B
    mkdir 7A
    mkdir 8A
    cd 1A
    cp -r * ../2A
    cp -r * ../2B
    cp -r * ../3A
    cp -r * ../3B
    cp -r * ../3C
    cp -r * ../4A
    cp -r * ../4B
    cp -r * ../4C
    cp -r * ../5A
    cp -r * ../5B
    cp -r * ../6A
    cp -r * ../6B
    cp -r * ../7A
    cp -r * ../8A
    cd ..
    # change main.py in the files.
    # since we are only running one job per climate zone..
    # change the climate and climate_lib lists to only have the 
    # corresponding climate zone

    sed -i "/^climate = .*/s//climate = ['1A']/" 1A/main.py
    sed -i "/^climate_lib = .*/s//climate_lib = ['1A']/" 1A/main.py

    sed -i "/^climate = .*/s//climate = ['2A']/" 2A/main.py
    sed -i "/^climate_lib = .*/s//climate_lib = ['2A']/" 2A/main.py

    sed -i "/^climate = .*/s//climate = ['2B']/" 2B/main.py
    sed -i "/^climate_lib = .*/s//climate_lib = ['2B']/" 2B/main.py

    sed -i "/^climate = .*/s//climate = ['3A']/" 3A/main.py
    sed -i "/^climate_lib = .*/s//climate_lib = ['3A']/" 3A/main.py

    sed -i "/^climate = .*/s//climate = ['3B']/" 3B/main.py
    sed -i "/^climate_lib = .*/s//climate_lib = ['3B']/" 3B/main.py

    sed -i "/^climate = .*/s//climate = ['3C']/" 3C/main.py
    sed -i "/^climate_lib = .*/s//climate_lib = ['3C']/" 3C/main.py

    sed -i "/^climate = .*/s//climate = ['4A']/" 4A/main.py
    sed -i "/^climate_lib = .*/s//climate_lib = ['4A']/" 4A/main.py

    sed -i "/^climate = .*/s//climate = ['4B']/" 4B/main.py
    sed -i "/^climate_lib = .*/s//climate_lib = ['4B']/" 4B/main.py

    sed -i "/^climate = .*/s//climate = ['4C']/" 4C/main.py
    sed -i "/^climate_lib = .*/s//climate_lib = ['4C']/" 4C/main.py

    sed -i "/^climate = .*/s//climate = ['5A']/" 5A/main.py
    sed -i "/^climate_lib = .*/s//climate_lib = ['5A']/" 5A/main.py

    sed -i "/^climate = .*/s//climate = ['5B']/" 5B/main.py
    sed -i "/^climate_lib = .*/s//climate_lib = ['5B']/" 5B/main.py

    sed -i "/^climate = .*/s//climate = ['6A']/" 6A/main.py
    sed -i "/^climate_lib = .*/s//climate_lib = ['6A']/" 6A/main.py

    sed -i "/^climate = .*/s//climate = ['6B']/" 6B/main.py
    sed -i "/^climate_lib = .*/s//climate_lib = ['6B']/" 6B/main.py

    sed -i "/^climate = .*/s//climate = ['7A']/" 7A/main.py
    sed -i "/^climate_lib = .*/s//climate_lib = ['7A']/" 7A/main.py

    sed -i "/^climate = .*/s//climate = ['8A']/" 8A/main.py
    sed -i "/^climate_lib = .*/s//climate_lib = ['8A']/" 8A/main.py


    # run the scripts here

    cd 1A/ && sbatch cz_script.sh && cd ..
    cd 2A/ && sbatch cz_script.sh && cd ..
    cd 2B/ && sbatch cz_script.sh && cd ..
    cd 3A/ && sbatch cz_script.sh && cd ..
    cd 3B/ && sbatch cz_script.sh && cd ..
    cd 3C/ && sbatch cz_script.sh && cd ..
    cd 4A/ && sbatch cz_script.sh && cd ..
    cd 4B/ && sbatch cz_script.sh && cd ..
    cd 4C/ && sbatch cz_script.sh && cd ..
    cd 5A/ && sbatch cz_script.sh && cd ..
    cd 5B/ && sbatch cz_script.sh && cd ..
    cd 6A/ && sbatch cz_script.sh && cd ..
    cd 6B/ && sbatch cz_script.sh && cd ..
    cd 7A/ && sbatch cz_script.sh && cd ..
    cd 8A/ && sbatch cz_script.sh && cd ..

