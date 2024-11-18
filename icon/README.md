## Directions for Installing ICON
1. git clone https://gitlab.dkrz.de/icon/icon-model.git
2. Edit /config/dkrz/levante.gcc
  - from here, you will need to install the spack dependencies
  - use the exact versions they have in the dkrz file (you will have the most success this way)
  - when you install openmpi, you must specify `+legacy launchers` i.e. `spack install openmpi@4.1.2 %gcc@11.4.1 +legacylaunchers`
3. Run from the icon main directory `./config/dkrz/levante.gcc`
  - there can be an issue with cmake, just run `spack load cmake` then rerun config script. If it asks for the version, choose the `gcc@11.4.1` version i.e. `spack load cmake/vw4nu5g`
  - if you run into issues here with `Fortran compiler cannot build executables`, there is an issue with your Spack installs. Read the config.log, there will be an error explaining why the Fortran compiler cannot compile the code. For example, we ran into this issue and the solve was that we had to rerun the spack install for eccodes with `spack install eccodes %gcc@11.4.1 +fortran`
4. Run `make -j4 `
  - if there is no makefile, something has gone wrong in your config script. Review the errors.
  - if it has run successfully, then you should get `make[1]: Leaving directory '/path/to/icon'`
  - if there was a build failure, such as `eccrad solvers` or `yaxt`, once again there was an issue with the config. Review the installs.
5. Run `./make_runscripts --all`
  - if everything has gone successfully to this point, each script should have `... done.` at the end of it.
  - Yay!
6. Download the grid files from https://nextcloud.dkrz.de/index.php/s/sCJcn2Jo3WFYcm8
  - You will probably have to download them to your host machine and scp to the remote machine (there are many tutorials on how to scp online)
  - Once you have them, move them into your icon directory with the directory name `grids`
7. cd into the run directory (`cd run`)
8. Edit the `exp.nh_dcmip_tc_52_r2b4.run` file
  - This file has many issues we will need to fix before getting a run
  - First, you will need to edit the names of the grid files. You can either rename in the script to match the directory or vice versa. For each grid file, you will need to change the section where it specifies `atmo_dyn_grids` to change the grid.
  - Next, change `vertical/coord_tables` to `vertical_coord_tables`. Give the absolute path of the vct_filename so it can find it i.e. `/path/to/icon/vertical_coord_tables/atm_hyb_sz_30`.  
  - You will also need to turn off some things from the output_nml. Should be: <br/><br/>
`1 !&output_nml`  <br/><br/>
`2 ! output_filename = 'icon-mpi-dwd.52.medium.L30.tri.nonhydro' ! file name base`  <br/><br/>
`3 ! output_bounds = 0.,${dt_restart},${dt_data} ! start, end, increment`  <br/><br/>
`4 ! steps_per_file = ${steps_per_file}`  <br/><br/>
`5 ! remap = 0 ! 0 = no remapping`  <br/><br/>
`6 ! output_grid = .TRUE.`  <br/><br/>
`7 ! ml_varlist = ` <br/><br/>
`,→  'qv','u','v','w','temp','pres_sfc','pres','theta_v','rho','exner','tempv','omega_z','div','z_mc','SHFL_S','LHFL_S','qhfl_s','tot_prec','group:precip_vars','cosmu0','SOB_S','group:rad_vars'  `
`8 ! pl_varlist = 'u','v','w','temp' ` <br/><br/>
`9 ! p_levels = 20000.,50000.,85000. !` (Pa) from TOA to surface  <br/><br/>
`10 ! hl_varlist = 'u','v' ` <br/><br/>
`11 ! h_levels = 10000.,1000.,100. ! (m) from TOA to surface ` <br/><br/>
`12 !/ ` <br/><br/>
`13 &output_nml ` <br/><br/>
`14 output_filename = 'icon-mpi-dwd.52.medium.L30.latlon.nonhydro' ! file name base ` <br/><br/>
`15 output_bounds = 0.,${dt_restart},${dt_data} ! start, end, increment ` <br/><br/>
`16 steps_per_file = ${steps_per_file}`  <br/><br/>
`17 remap = 1 ! 1 = remap to regular lat-lon grid` <br/><br/> 
`18 reg_lat_def = -90.,1., 90. ! latitude grid`  <br/><br/>
`19 reg_lon_def = 0.,1.,360. ! longitude grid ` <br/><br/>
`20 output_grid = .TRUE.`  <br/><br/>
`21 ! ml_varlist = ` <br/><br/>
,→ 'qv','u','v','w','temp','pres_sfc','pres','z_mc','SHFL_S','LHFL_S','qhfl_s','tot_prec','group:precip_vars','cosmu0','SOB_S','group:rad_vars'  <br/><br/>
`22 pl_varlist = 'u','v','w','temp' ` <br/><br/>
`23 ! hl_varlist = 'u','v'` <br/><br/>
(for the varlists, you can turn of ml_varlist and hl_varlist)
9. Run the experiment (`./exp.nh_dcmip_tc_52_r2b4.run`). Simulation should start running!
10. If you want to run multinode: create a hostfile and change the mpiexec command.
    - First, to create a hostfile, make a new file with any name you want (i.e. hostfile.txt). In this file, put the IP addresses of the nodes you want to use along with the amount of mpi proccesses you want. For example:
      `10.0.0.2 slots=100
      10.0.0.3 slots=100`
    - Then you will need to edit `exp.nh_dcmip_tc_52_r2b4.run` again
    - This time, look for where `START=/path/to/openmpi/mpiexec -n $num_of_total_procs` in the file. You will edit it this to `START=/path/to/openmpi/mpiexec --hostfile hostfile.txt -n $num_of_total_procs`
    - You will also need to change `$num_of_total_procs` (line 31) to equal the amount of mpi processes you specified in the `hostfile.txt` (you will need to give the absolute path so it can find it). In our example, we specified a total of 200 proccesses.
11. Run the experiment (`./exp.nh_dcmip_tc_52_r2b4.run`). Simulation should start running **MULTINODE**!
12. Profit! Also, "Allowed changes e.g.: nproma, proc0_shift, START" (from Jannek). Try these for optimization. 
