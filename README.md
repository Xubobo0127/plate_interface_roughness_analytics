# Fractal-rl-method

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

/src/  Contains the source file
    
    [acquire_list.bat]                   Generate a list of data
    [MR_2d_multiprofiles.m]              Calculate the maximum residual for a 2D seismic profile.
    [RMS_2d_multiprofiles.m]             Calculate the root-mean-square residual and the fractal amplitude parameter for 2-dimensional data
    [RLS_3Ddata.m]                       Calculate maximum residual, root-mean-square residual and fractal amplitude parameter for 3-dimensional data


/data/  Contains the data file of the plate interface fault geometries interpreted from from 2D/3D seismic profiles

    e.g. [Alask]                         2D plate interface data       
    Distance  Depth
    2.17    5496.27 
    12.17   5500.63 
    22.17   5505.01 
    32.17   5509.41 
    42.17   5513.82 
    Distance is length landward from the trench (m)
    Depth is the plate interface depth below sea level (m)

    e.g. [Barbados-3D.pro]                 3D plate boundary fault data 
    Inline, Crossline, Distance, Depth
    620,245,1.501137e,5.946952e+03 

/example/                               Contains two cases to calculate the roughness indicator
    
    /example/2d/                        Example of 2d data
    /example/3d/                        Example of 3d data

README                                  Help file

LICENSE                                 License file

#   4  How to use the Roughness-Length Method code
    
    2d data    1. Use [acquire_list.bat] file to generate a list file at /data/ catalog
               2. Put the list file and code file in the same directory
               3. Set the appropriate parameters  (filename,times,t1,te,fid) and click Run
    
    3d data    1. Put the data file and code file in the same directory
               2. Set the appropriate parameters (filename,par,times,t1,te,fid) and click Run

#   5  Parameter description of the Roughness-Length Method code

    filename                            Importdata File name
    
    par                                 Select the parameters for calculation
                                        par = 1,maximum residual; 
                                        par = 2,root mean square residual; 
                                        par = 3,fractal amplitude parameter;

    dis                                 Distance 

    dep                                 Depth of the plate interface fault

    times                               Iteration times
    t1                                  Window length in first interation
    te                                  Window length in last interation
    fid                                 Output file
