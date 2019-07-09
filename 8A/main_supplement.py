import os
import csv
import numpy as np

pathway = os.getcwd()
os.chdir(os.path.join(pathway,'SensAnal'))
import analyzeNonpara as an
os.chdir(pathway)

an.sensiAnal('energy_data_np_1')
        
    
