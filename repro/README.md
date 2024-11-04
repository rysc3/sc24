
## Building flow monitor tool
- cd into `datalife/flow-monitor`.
- Replace the code on line 501 in `src/Lib.cpp` with the following

```C++
template <typename T>
struct always_false : std::false_type {};

template <typename T>
int monitorStat(std::string name, std::string metaName, MonitorFile::Type type, int version, const char *filename, T *buf) {
  /*auto ret = stat(metaName.c_str(), buf);*/
  int ret;
  if constexpr (std::is_same<T, struct stat>::value) {
    ret = stat(metaName.c_str(), buf);
  } else if constexpr (std::is_same<T, struct stat64>::value) {
    ret = stat64(metaName.c_str(), buf);
  } else {
    static_assert(always_false<T>::value, "Unsupported stat structure type");
  }
```
- Follow the rest of the instructions in the `flow-monitor` directory.


## Running the flow-monitor tool
- Run the script `datalife-run` and pass an application. For example, to run a python script, use `/path/to/datalife-run my_file.py`.
- Make sure the install directory looks like the following or the script won't work.

```
├── install
│   ├── bin
│   │   └── datalife-run
│   └── lib
│       └── libmonitor.so
```


## Running 1000 genomes
- Add the data from (https://github.com/pegasus-isi/1000genome-workflow/tree/master/data/20130502) to the working directory.
- Run `./prepare_input.sh` to download the rest of the data to the working directory.
- Run `sbatch genomes.sbatch` to run 1000 genomes and `sbatch genomes-monitor.sbatch` to run 1000 genomes with the flow monitor tool.