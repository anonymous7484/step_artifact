# STeP Artifact Evaluation

This is a repository for STeP artifact generation.

## Overview

* [Getting Started (5 human-minutes + 10 compute-minutes)](#getting-started-5-human-minutes--10-compute-minutes)
* [Run Experiments (5 human-minutes + 7 compute-hour)](#run-experiments-5-human-minutes--7-compute-hour)
* [Validate All Results](#validate-all-resultsvalidate)
* [[Optional] Detailed Explanation of What the Top-Level Script Does](#optional-detailed-explanation-of-what-the-top-level-script-does)

## Getting Started (5 human-minutes + 10 compute-minutes)

This guide assumes the user has a working installation of Docker, git, and some version of Python 3 installed.

* Run the following commands to clone this repository and the [step-artifact-eval](https://github.com/anonymous7484/step-artifact-eval) repository to the local machine.

    ```bash
    git clone --recursive https://github.com/anonymous7484/step_artifact.git
    git clone https://github.com/anonymous7484/step-artifact-eval.git
    ```

* Build the Docker image with the following commands (the build can take upto 5 minutes)

    ```
    docker build -f step_artifact/Dockerfile -t step_artifact .
    ```

* The Docker container can be started with the following command. This will print the `CONTAINER_ID`.

    ```
    docker run -dit step_artifact bash
    ```

* The container can be attached to by running the command below using the `CONTAINER_ID` the previous step.

    ```
    docker attach <CONTAINER_ID>
    ```

* IMPORTANT: Do not type `exit` in the docker terminal as this will stop the container. The proper way to detach the docker is the pressing sequence `CTRL+p`, `CTRL+q`.

## Run Experiments (5 human-minutes + 7 compute-hour)

All the experiments and figures can be run by the following commands. In total, it takes around 7 hours when tested on a machine with 8 vCPUs.

```bash
### In Docker Container ###
$ cd /root/step_artifact
# Figure 6,7,8,9,11, and half of Figure 5 (5hr 30mins)
$ source ae_cmd.sh
# Figure 5 (1hr 30mins)
$ cp /root/step_artifact/hdl_validation/fig5.csv /root/step-artifact-eval/step_reference.csv
$ cd /root/step-artifact-eval
$ ./run_dse_and_figure.sh
```

Once all the experiments complete, detach the container by pressing `CTRL+p` and then `CTRL+q`. You can extract the tables/figures from the Docker container by following the instructions in the section [Validate All Results](#validate-all-results) in this README.

## Validate All Results

1. Exit the docker (CTRL+p, CTRL+q)
2. Move into the cloned `step_artifact` repository on the local machine and run the following command. This will copy the experiment results and figures from the container. The results and figures will be copied to `step_artifact/<OUTPUT_DIRECTORY>`.

    ```bash
    ### In the local machine ###
    $ cd step_artifact
    $ mkdir -p <OUTPUT_DIRECTORY>  # This will be the argument for the --output_dir in the following line
    $ python copy_from_docker.py --docker_id <CONTAINER_ID> --output_dir <OUTPUT_DIRECTORY>
    ```

    * `copy_from_docker.py` runs a series of docker cp commands to pull the figures from the container.
    * `--output_dir` is used to specify an output directory on the local machine for the figures to be stored in. The `mkdir -p <OUTPUT_DIRECTORY>` command will create the directory if it doesn't exist. The files referenced in the next few steps will be found at this directory.
    * `--docker_id` is used to identify the docker container ID. This should have printed when the docker was created and is the same ID used to attach to the container. You may also retrieve the CONTAINER_ID again by running `docker ps` in your terminal.
3. The expected results in the `step_artifact/<OUTPUT_DIRECTORY>` are:

    ```
    step_artifact/<OUTPUT_DIRECTORY>
    |_ step-artifact-eval
    |_step_artifact
        |_dyn_tiling
        |_dynamic_par
        |_timeshare_mem_bound
    ```

    * Figure 5: The reproduced figure and experiment results can be found in the `step-artifact-eval` folder. The `validation.pdf` should match Figure 5 in the paper. The values used to create the plot are in the other two CSV files in the `step-artifact-eval` folder.

    * Figure 6: The reproduced figure and experiment results can be found in the `dyn_tiling` folder. The file `figure6.pdf` should match Figure 6 in the paper. The values used for creating the plot can be found in`figure_6_mixtral_b64.csv` and `figure_6_qwen_b64.csv`.

    * Figure 7: The reproduced figure and experiment results can be found in the `dyn_tiling` folder.  The file `figure7.pdf` should match Figure 7 in the paper. The values used for creating the plot can be found in `figure_7_mixtral_b1024.csv` and `figure_7_qwen_b1024.csv`.

    * Figure 8: The reproduced figure and experiment results can be found in the `timeshare_mem_bound` folder. The file `figure8.pdf` should match Figure 8 in the paper. The values used to create the plot are in `fig_8_a.csv` and `fig_8_b.csv`.

    * Figure 9: The reproduced figure and experiment results can be found in the `timeshare_mem_bound` folder. The file `figure9.pdf` should match Figure 9 in the paper. The values used to create the plot are in `fig_9_a.csv` and `fig_9_b.csv`.

    * Figure 11: The reproduced figure and experiment results can be found in the `dynamic_par` folder. The file `figure11.pdf` should match Figure 11 in the paper. The values used for creating the plot can be found in the other three CSV files in the `dynamic_par` folder.

## [Optional] Detailed Explanation of What the Top-Level Script Does

### Run and Validate Figure 5 (10 human-minutes + 2 compute-hours)

* Run the following commands:
    1. Generates the STeP Simulator numbers (organe dots) in Figure 5. The numbers will be stored in `/root/step_artifact/hdl_validation/fig5.csv`.

        ```bash
        ### In the docker container ###
        $ cd /root/step_artifact/
        $ source ./hdl_validation/figure5_step.sh    
        ```

    2. Run the HDL simulation, copy the results from STeP simulator to the designated location, and generate figure 5.

        ```bash
        # Copy the simulation resuls for the STeP simulator (fig5.csv) to the designated location to generate the graph
        $ cp /root/step_artifact/hdl_validation/fig5.csv /root/step-artifact-eval/step_reference.csv
        # Run the HDL simulation and generate the figure
        $ cd /root/step-artifact-eval
        $ ./run_dse_and_figure.sh
        ```

* To validate the results:
    1. Exit the docker (CTRL+p, CTRL+q) and move into the cloned `step_artifact` repository on the local machine.

        ```bash
        # Exit the docker (CTRL+p, CTRL+q)
        
        ### In the local machine ###
        $ cd step_artifact
        ```

    2. As there will only be results related to figure 5 generated, modify the `FILES_TO_COPY` list in the `step_artifact/copy_from_docker.py` file to only include the files related to figure 5 as follows:

        ```python
        FILES_TO_COPY = [
            "step-artifact-eval/dse_results.csv",
            "step-artifact-eval/step_reference.csv",
            "step-artifact-eval/validation.pdf",
        ]
        ```

    3. Run the following command. This will copy the experiment results and figures from the container. The results and figures will be copied to `step_artifact/<OUTPUT_DIRECTORY>`.

        ```bash
        ### In the local machine (step_artifact repository) ###
        $ mkdir -p <OUTPUT_DIRECTORY>  # This will be the argument for the --output_dir in the following line
        $ python copy_from_docker.py --docker_id <CONTAINER_ID> --output_dir <OUTPUT_DIRECTORY>
        ```

    4. The reproduced figure and experiment results can be found in the `step-artifact-eval` folder. The `validation.pdf` should match Figure 5 in the paper. The values used to create the plot are in the other two CSV files in the `step-artifact-eval` folder.

        ```
        step_artifact/<OUTPUT_DIRECTORY>
        |_ step-artifact-eval
            |_ dse_results.csv
            |_ step_reference.csv
            |_ validation.pdf

        ```

### Run and Validate Figure 6 (5 human-minutes + 80 compute-minutes)

* Run the following commands

    ```bash
    ### In the docker container ###
    cd /root/step_artifact/
    pytest dyn_tiling/test_mixtral_sweep.py::test_mixtral_b64
    # Produced file: step_artifact/dyn_tiling/figure_6_mixtral_b64.csv

    pytest dyn_tiling/test_qwen_sweep.py::test_qwen_b64
    # Produced file: step_artifact/dyn_tiling/figure_6_qwen_b64.csv

    python dyn_tiling/generate_fig6.py
    # Produced file: step_artifact/dyn_tiling/figure6.pdf
    # Produced file: step_artifact/dyn_tiling/figure6.png

    echo "figure 6 done"
    ```

  * The `test_mixtral_b64` will run the left portion of figure 6 (Mixtral8x7B) and produce `step_artifact/dyn_tiling/figure_6_mixtral_b64.csv`.
  * The `test_qwen_b64` will run the right portion of figure 6 (Qwen3-30B-A3B) and produce `step_artifact/dyn_tiling/figure_6_qwen_b64.csv`.

* To validate the results:
    1. Exit the docker (CTRL+p, CTRL+q) and move into the cloned `step_artifact` repository on the local machine.

        ```bash
        # Exit the docker (CTRL+p, CTRL+q)
        
        ### In the local machine ###
        $ cd step_artifact
        ```

    2. modify the `FILES_TO_COPY` list in the `step_artifact/copy_from_docker.py` file to only include the files related to figure 6 as follows:

        ```python
        FILES_TO_COPY = [
            "step_artifact/dyn_tiling/figure_6_mixtral_b64.csv",
            "step_artifact/dyn_tiling/figure_6_qwen_b64.csv",
            "step_artifact/dyn_tiling/figure6.pdf",
        ]
        ```

    3. Run the following command. This will copy the experiment results and figures from the container. The results and figures will be copied to `step_artifact/<OUTPUT_DIRECTORY>`.

        ```bash
        ### In the local machine ###
        $ mkdir -p <OUTPUT_DIRECTORY>  # This will be the argument for the --output_dir in the following line
        $ python copy_from_docker.py --docker_id <CONTAINER_ID> --output_dir <OUTPUT_DIRECTORY>
        ```

    4. The reproduced figure and experiment results can be found in the `dyn_tiling` folder. The file `figure6.pdf` should match Figure 6 in the paper. The values used for creating the plot can be found in`figure_6_mixtral_b64.csv` and `figure_6_qwen_b64.csv`.

        ```
        step_artifact/<OUTPUT_DIRECTORY>
        |_step_artifact
            |_dyn_tiling
                |_ figure_6_mixtral_b64.csv
                |_ figure_6_qwen_b64.csv
                |_ figure6.pdf
        ```

### Run and Validate Figure 7 (5 human-minutes + 150 compute-minutes)

* Run the following commands

    ```bash
    ### In the docker container ###
    cd /root/step_artifact/
    pytest dyn_tiling/test_mixtral_sweep_prefill.py::test_mixtral_b1024
    # Produced file: step_artifact/dyn_tiling/figure_7_mixtral_b1024.csv

    pytest dyn_tiling/test_qwen_sweep_prefill.py::test_qwen_b1024
    # Produced file: step_artifact/dyn_tiling/figure_7_qwen_b1024.csv

    python dyn_tiling/generate_fig7.py
    # Produced file: step_artifact/dyn_tiling/figure7.pdf
    # Produced file: step_artifact/dyn_tiling/figure7.png

    echo "figure 7 done"
    ```

  * The `test_mixtral_b1024` will run the left portion of figure 7 (Mixtral8x7B) and produce `step_artifact/dyn_tiling/figure_7_mixtral_b1024.csv`.
  * The `test_qwen_b1024` will run the right portion of figure 7 (Qwen3-30B-A3B) and produce `step_artifact/dyn_tiling/figure_7_qwen_b1024.csv`.

* To validate the results:
    1. Exit the docker (CTRL+p, CTRL+q) and move into the cloned `step_artifact` repository on the local machine.

        ```bash
        # Exit the docker (CTRL+p, CTRL+q)
        
        ### In the local machine ###
        $ cd step_artifact
        ```

    2. modify the `FILES_TO_COPY` list in the `step_artifact/copy_from_docker.py` file to only include the files related to figure 7 as follows:

        ```python
        FILES_TO_COPY = [
            "step_artifact/dyn_tiling/figure_7_mixtral_b1024.csv",
            "step_artifact/dyn_tiling/figure_7_qwen_b1024.csv",
            "step_artifact/dyn_tiling/figure7.pdf",
        ]
        ```

    3. Run the following command. This will copy the experiment results and figures from the container. The results and figures will be copied to `step_artifact/<OUTPUT_DIRECTORY>`.

        ```bash
        ### In the local machine ###
        $ mkdir -p <OUTPUT_DIRECTORY>  # This will be the argument for the --output_dir in the following line
        $ python copy_from_docker.py --docker_id <CONTAINER_ID> --output_dir <OUTPUT_DIRECTORY>
        ```

    4. The reproduced figure and experiment results can be found in the `dyn_tiling` folder.  The file `figure7.pdf` should match Figure 7 in the paper. The values used for creating the plot can be found in `figure_7_mixtral_b1024.csv` and `figure_7_qwen_b1024.csv`.

        ```
        step_artifact/<OUTPUT_DIRECTORY>
        |_step_artifact
            |_dyn_tiling
                |_ figure_7_mixtral_b1024.csv
                |_ figure_7_qwen_b1024.csv
                |_ figure7.pdf
        ```

### Run and Validate Figure 8 (5 human-minutes + 100 compute-minutes)

* Run the following commands

    ```bash
    ### In the docker container ###
    cd /root/step_artifact/
    pytest timeshare_mem_bound/test_membound_qwen_sweep_revet.py::test_static_tile
    # Produced files: step_artifact/timeshare_mem_bound/fig_8_a.csv, 

    pytest timeshare_mem_bound/test_membound_qwen_sweep_dyn_tile.py::test_dyn_tile
    # Produced files: step_artifact/timeshare_mem_bound/fig_8_b.csv

    python timeshare_mem_bound/generate_fig8.py 
    # Produced file: step_artifact/timeshare_mem_bound/figure8.pdf
    ```

  * The `test_static_tile` will run experiments for figure 8(a) and produce `step_artifact/timeshare_mem_bound/fig_8_a.csv`.
  * The `test_dyn_tile` will run experiments for figure 8(b) and produce `step_artifact/timeshare_mem_bound/fig_8_b.csv`.

* To validate the results:
    1. Exit the docker (CTRL+p, CTRL+q) and move into the cloned `step_artifact` repository on the local machine.

        ```bash
        # Exit the docker (CTRL+p, CTRL+q)
        
        ### In the local machine ###
        $ cd step_artifact
        ```

    2. modify the `FILES_TO_COPY` list in the `step_artifact/copy_from_docker.py` file to only include the files related to figure 8 as follows:

        ```python
        FILES_TO_COPY = [
            "step_artifact/timeshare_mem_bound/fig_8_a.csv",
            "step_artifact/timeshare_mem_bound/fig_8_b.csv",
            "step_artifact/timeshare_mem_bound/figure8.pdf",
        ]
        ```

    3. Run the following command. This will copy the experiment results and figures from the container. The results and figures will be copied to `step_artifact/<OUTPUT_DIRECTORY>`.

        ```bash
        ### In the local machine ###
        $ mkdir -p <OUTPUT_DIRECTORY>  # This will be the argument for the --output_dir in the following line
        $ python copy_from_docker.py --docker_id <CONTAINER_ID> --output_dir <OUTPUT_DIRECTORY>
        ```

    4. The reproduced figure and experiment results can be found in the `timeshare_mem_bound` folder. The file `figure8.pdf` should match Figure 8 in the paper. The values used to create the plot are in `fig_8_a.csv` and `fig_8_b.csv`.

        ```
        step_artifact/<OUTPUT_DIRECTORY>
        |_step_artifact
            |timeshare_mem_bound
                |_ fig_8_a.csv
                |_ fig_8_b.csv
                |_ figure8.pdf
        ```

### Run and Validate Figure 9 (5 human-minutes + 50 compute-minutes)

* Run the following commands

    ```bash
    ### In the docker container ###
    cd /root/step_artifact/
    pytest timeshare_mem_bound/test_membound_qwen_sweep_revet.py::test_static_tile
    # Produced files: step_artifact/timeshare_mem_bound/fig_9_a.csv,
    #                 step_artifact/timeshare_mem_bound/fig_9_b.csv

    python timeshare_mem_bound/generate_fig9.py 
    # Produced file: step_artifact/timeshare_mem_bound/figure9.pdf

    ```

  * The `test_static_tile` will run experiments for figure 9 and produce `step_artifact/timeshare_mem_bound/fig_9_a.csv` and `step_artifact/timeshare_mem_bound/fig_9_b.csv`.

* To validate the results:
    1. Exit the docker (CTRL+p, CTRL+q) and move into the cloned `step_artifact` repository on the local machine.

        ```bash
        # Exit the docker (CTRL+p, CTRL+q)
        
        ### In the local machine ###
        $ cd step_artifact
        ```

    2. modify the `FILES_TO_COPY` list in the `step_artifact/copy_from_docker.py` file to only include the files related to figure 9 as follows:

        ```python
        FILES_TO_COPY = [
            "step_artifact/timeshare_mem_bound/fig_9_a.csv",
            "step_artifact/timeshare_mem_bound/fig_9_b.csv",
            "step_artifact/timeshare_mem_bound/figure9.pdf",
        ]
        ```

    3. Run the following command. This will copy the experiment results and figures from the container. The results and figures will be copied to `step_artifact/<OUTPUT_DIRECTORY>`.

        ```bash
        ### In the local machine ###
        $ mkdir -p <OUTPUT_DIRECTORY>  # This will be the argument for the --output_dir in the following line
        $ python copy_from_docker.py --docker_id <CONTAINER_ID> --output_dir <OUTPUT_DIRECTORY>
        ```

    4. The reproduced figure and experiment results can be found in the `timeshare_mem_bound` folder. The file `figure9.pdf` should match Figure 9 in the paper. The values used to create the plot are in `fig_9_a.csv` and `fig_9_b.csv`.

        ```
        step_artifact/<OUTPUT_DIRECTORY>
        |_step_artifact
            |timeshare_mem_bound
                |_ fig_9_a.csv
                |_ fig_9_b.csv
                |_ figure9.pdf
        ```

### Run and Validate Figure 11 (5 human-minutes + 15 compute-minutes)

* Run the following commands

    ```bash
    ### In the docker container ###
    cd /root/step_artifact/
    pytest dynamic_par/sweep_ae.py::test_b16_sweep
    # Produced file: step_artifact/dynamic_par/batch16_sweep_ae.csv

    pytest dynamic_par/sweep_ae.py::test_b64_sweep
    # Produced file: step_artifact/dynamic_par/batch64_sweep_ae.csv

    pytest dynamic_par/sweep_ae.py::test_b64_b16_sweep
    # Produced file: step_artifact/dynamic_par/batch80_sweep_ae.csv

    python dynamic_par/fig11.py
    # Produced file: step_artifact/dynamic_par/figure11.pdf
    echo "figure 11 done"

    ```

  * The `test_b16_sweep` will run experiments for `B = 16` (left) in figure 11 and produce `step_artifact/dynamic_par/batch16_sweep_ae.csv`.
  * The `test_b64_sweep` will run experiments for `B = 64` (middle) in figure 11 and produce `step_artifact/dynamic_par/batch64_sweep_ae.csv`.
  * The `test_b16_sweep` will run experiments for `B = 64+16` (right) in figure 11 and produce `step_artifact/dynamic_par/batch80_sweep_ae.csv`.

* To validate the results:
    1. Exit the docker (CTRL+p, CTRL+q) and move into the cloned `step_artifact` repository on the local machine.

        ```bash
        # Exit the docker (CTRL+p, CTRL+q)
        
        ### In the local machine ###
        $ cd step_artifact
        ```

    2. modify the `FILES_TO_COPY` list in the `step_artifact/copy_from_docker.py` file to only include the files related to figure 11 as follows:

        ```python
        FILES_TO_COPY = [
            "step_artifact/dynamic_par/batch16_sweep_ae.csv",
            "step_artifact/dynamic_par/batch64_sweep_ae.csv",
            "step_artifact/dynamic_par/batch80_sweep_ae.csv",
            "step_artifact/dynamic_par/figure11.pdf",
        ]
        ```

    3. Run the following command. This will copy the experiment results and figures from the container. The results and figures will be copied to `step_artifact/<OUTPUT_DIRECTORY>`.

        ```bash
        ### In the local machine ###
        $ mkdir -p <OUTPUT_DIRECTORY>  # This will be the argument for the --output_dir in the following line
        $ python copy_from_docker.py --docker_id <CONTAINER_ID> --output_dir <OUTPUT_DIRECTORY>
        ```

    4. The reproduced figure and experiment results can be found in the `timeshare_mem_bound` folder. The file `figure11.pdf` should match Figure 11 in the paper. The values used to create the plot are in the other three CSV files.

        ```
        step_artifact/<OUTPUT_DIRECTORY>
        |_step_artifact
            |_dynamic_par
                |_ batch16_sweep_ae.csv
                |_ batch64_sweep_ae.csv
                |_ batch80_sweep_ae.csv
                |_ figure11.pdf
        ```
