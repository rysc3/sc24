# Instructions to make my script work

0. Obtain nvidia optimized benchmarks container from 
https://catalog.ngc.nvidia.com/orgs/nvidia/containers/hpc-benchmarks

1. Clone repo
```
git clone https://github.com/rysc3/sc24
cd sc24/HPCG
```

2. Follow the TODOs in `param.slurm`, updating the filepaths as necessary

3. You should have a directory, `full-job-output` in the same directory as your `param.slurm` file. Make this directory if it does not exist. 

4. You will next need to copy the `hpcg.sh` script from inside the singularity image into your run directory. You can do this by doing the following in your run dir (the dir with the param.slurm file)

```
module load singularity 
singularity shell -B .:/MY-COOL-MOUNTED-DIRECTORY hpc-benchmarks:24.03.sif /bin/bash
cd /workspace
cp hpcg.sh /MY-COOL-MOUNTED-DIRECTORY
exit
```

*in place of hpc-benchmarks:24.03.sif, you should put the full filepath to this .sif file. In this case, the .sif file was already in my current directory so I can just specify it by name, no different than using `./hpc-benchmarks:24.03.sif`*

You'll now have `hpcg.sh` in your run dir. From this point, you should tweak the `SBATCH` directives at the beginning of the script according to your needs, and run `sbatch param.slurm`.


## Default output

By default, the script will generate two types of output

### Verification Output
For every job, you will have a temp directory created, for example, `full-job-output/tmp.iU937hdfb` directory will be created. Inside of this directory, you will have 
1. The `HPCG.dat` file with the parameters you passed in through `PARAM_PARAMS.csv`
2. A file, `HPCG.out` which contains the complete job output


### Parsable results output
There are a number of examples for how you might save your output to individual files at the bottom of `param.slurm` that can be uncommented if you want to use, for example, you may uncomment the section to format your data in an easy way for you to graph the relationship between `N` and `GFLOPS` by uncommenting the appropriate line here. 

These are meant to make it more convenient to format your data at runtime as you're generating it, so you will then be able to just paste this data into matplotlib to graph it afterward. 

By Default, you will have the following files created/updated for every iteration (slurm array index) that is run 

1. `slurm-(job id).out`. This file will print out important information like where the tmp directory is for the corresponding job id. These will be generated in the directory that your `param.slurm` is in. 
2. `RESULTS_FULL.csv`. You can reference the file [here](https://github.com/rysc3/sc24/blob/main/HPCG/RESULTS_FULL.csv) to see the format. This will output the number of nodes, number of ntasks per node, parameters passed in, results, and start and finish time of the HPL/HPCG run itself
3. `RESULTS_SML.csv`. You can reference the file [here](https://github.com/rysc3/sc24/blob/main/HPCG/RESULTS_SML.csv) to see the format. Similar to the full results, but each result is a single line just giving the parameters you specify with the `echo $NX, $NY, $NZ, $RT, $GFLOPS >> $RESULTS_SML` line in `params.slurm`