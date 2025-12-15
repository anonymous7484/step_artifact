# STeP Artifact Evaluation

## Artifact Check-List

* Compilation:
* Data set:

* Run-time environment:

* Hardware: Any conventional x86 CPU with at least 32GB of RAM should work.

* Output: Terminal outputs, files, and graphs (PDF figures). Expected results are included in the submitted paper.
* Experiments: All steps are detailed in the `README.md` in

## Installation

To install, first clone the [step_artifact](https://github.com/anonymous7484/step_artifact) and [step-artifact-eval}](https://github.com/anonymous7484/step-artifact-eval) repository to the local machine. Then build the Docker image with the following commands (the build takes about 5 minutes):

```
git clone --recursive https://github.com/anonymous7484/step_artifact.git
git clone https://github.com/anonymous7484/step-artifact-eval.git
docker build -f step_artifact/Dockerfile -t step_artifact .
```

The Docker container can be started with the following command. This will print the container ID.

```
docker run -d -it step_artifact bash
```

The container can be attached to by running:

```
docker attach <CONTAINER_ID>
```

## Evaluation and Expected Results

All the experiments and figures can be run by the following commands. In total, it takes around 7 hours when tested on a machine with 8 vCPUs.

```
### In Docker Container ###
$ cd /root/step_artifact

# Figure 6,7,8,9,11
$ source ae_cmd.sh

# Figure 5
$ cp /root/step_artifact/hdl_validation/fig5.csv /root/step-artifact-eval/step_reference.csv
$ cd /root/step-artifact-eval
$ ./run_dse_and_figure.sh

# ctrl+p ctrl+q
```

Detach the container by pressing `ctrl+p` and `ctrl+q`. Move into the cloned `step_artifact` repository on the local machine and run the following command to copy the experiment results and figures from the container. The results and figures will be copied to `step_artifact/results`.

```
### In the local machine ###

$ cd step_artifact
$ mkdir -p results
$ python copy_from_docker.py --docker_id <CONTAINER_ID> --output_dir ./results
```

The expected results in the `step_artifact/results` are:

```
step_artifact/results
|_ step-artifact-eval
|_step_artifact
    |_dyn_tiling
    |_dynamic_par
    |_timeshare_mem_bound
```

* Figure 5: The reproduced figure and experiment results can be found in the `step-artifact-eval` folder. The `validation.pdf` should match `fig:step-vs-bluespec`. The values used to create the plot are in the other two CSV files in the `step-artifact-eval`}` folder.

* Figure 6: The reproduced figure and experiment results can be found in the `dyn_tiling` folder. The file `figure6.pdf`}` should match `fig:dyn-tile-64`. The values used for creating the plot can be found in`figure_6_mixtral_b64.csv`}` and `figure_6_qwen_b64.csv`.

* Figure 7: The reproduced figure and experiment results can be found in the `dyn_tiling` folder.  The file `figure7.pdf` should match Figure 7. The values used for creating the plot can be found in `figure_7_mixtral_b1024.csv` and `figure_7_qwen_b1024.csv`.

* Figure 8: The reproduced figure and experiment results can be found in the `timeshare_mem_bound` folder. `timeshare_mem_bound` folder. The file `figure8.pdf` should match Figure 8. The values used to create the plot are in `fig_8_a.csv` and `fig_8_b.csv`.

* Figure 9: The reproduced figure and experiment results can be found in the `timeshare_mem_bound` folder. The file `figure9.pdf` should match Figure 9. The values used to create the plot are in `fig_9_a.csv` and `fig_9_b.csv`.

* Figure 11: The reproduced figure and experiment results can be found in the `dynamic_par` folder. The file `figure11.pdf` should match Figure 11. The values used for creating the plot can be found in the other three CSV files in the `dynamic_par` folder.
