# plate_interface_roughness_analytics
# 1 Introduciton
The Roughness-Length Method (Malinverno, 1990)  written using matlab to calculate 
the roughness indicator (e.g. the maximum residual, the root-mean-square residual,
the fractal amplitude parameter). 

# 2 Code support
The Roughness-Length Method code is developed using Matlab by Haobo Xu, 10/11/2024
South China Sea Institute of Oceanography,CAS
Email: xuhaobo23@mails.ucas.ac.cn

The method for determining the largest earthquake associated with a seismic profile calculates the rupture area of each earthquake and determine whether the seismic profile passes through the rupture. This code Which is written by Valerie Locher using Python
Imperial College London
Email:valerie.locher22@imperial.ac.uk
For more details please see https://github.com/gems-val22/subduction_data_analytics (binning.py and preprocessing.py)

# 3 Directory structure description

/src/  Contains the source file that supports both macOS and Windows.
    

    [acquire_list.bat]                   Generate a list of data
    [MR_2d_multiprofiles.m]              Calculate the maximum residual for a 2D seismic profile.
    [RMS_2d_multiprofiles.m]             Calculate the root-mean-square residual and the fractal amplitude parameter for 2-dimensional data
    

/data/  Contains the data file of the plate interface fault geometries interpreted from from 2D/3D seismic profiles

    e.g. [Alaska-C ALEUT-Line3.dat]      2D plate interface data       
    Distance  Depth
    2.17    5496.27 
    12.17   5500.63 
    22.17   5505.01 
    32.17   5509.41 
    42.17   5513.82 
    Distance is length landward from the trench (m)
    Depth is the plate interface depth below sea level (m)

   
README                                  Help file

LICENSE                                 License file

#   4  How to use the Roughness-Length Method code
        Choose your OS
        
        For Mac OS
        1. Copy [acquire_list.sh] file to /data/ catalog
        2. Open the terminal and enter follows to generate a [list] file
            chmod +x list_dat_absolute.sh
            ./list_dat_absolute.sh
        3. Put the [list] file and code file in the same directory
        4. Open the matlab script (e.g., [RMS_2d_multiprofiles.m])
        5. Set the appropriate parameters (filename,times,t1,te,fid) and click Run in matlab 
        
        For Win OS
        1. Copy [acquire_list.sh] file to /data/ catalog and click to generate a [list] file
        2. Put the [list] file and code file in the same directory
        3. Open the matlab script (e.g., [RMS_2d_multiprofiles.m])
        4. Set the appropriate parameters  (filename,times,t1,te,fid) and click Run in matlab 
    
   

#   5  Parameter description of the Roughness-Length Method code

    filename                            Importdata File name
   
    dis                                 Distance 

    dep                                 Depth of the plate interface fault

    times                               Iteration times
    t1                                  Window length in first interation
    te                                  Window length in last interation
    fid                                 Output file
